Resurrecting EPEL RPMs
======================

You will need to be a Koji admin to do these steps. 

    :::console
    [user@client ~] $ osg-koji --list-permissions --mine

Will tell you if you're an admin or not. Current Koji admins are the Madison team and Brian Bockelman.

| EPEL version | EPEL Koji tag | Our Koji tag   |
|:-------------|:------------- |:---------------|
| 5            | dist-5E-epel  | epelrescue-el5 |
| 6            | dist-6E-epel  | epelrescue-el6 |
| 7            | epel7         | epelrescue-el7 |

1. Determine the NVR of the build containing the RPM of the package you want.

    Use the Fedora/EPEL Koji web interface (<https://koji.fedoraproject.org>) to search for it.

    You can use the search box in the upper right to look for packages, builds, or RPMs; it accepts shell wildcards.

    EPEL builds have .el5, .el6, or .el7 in the dist tag.

2. Download *all* RPMs for *all* architectures we care about (i386, i486, i586, i686, x86\_64, noarch), including the .src.rpm and the debuginfo rpms.

    You have three options for the downloads:

    1. Use the links in the web interface
    2. Use the koji command-line interface against the Fedora koji:
        1.  Download `fedora-koji.conf`, attached to this page
        2.  Run `koji --noauth -c fedora-koji.conf download-build --debuginfo %RED%<BUILD_NVR>%ENDCOLOR%`
        3.  Delete RPMs for architectures we do not care about (see list above)
    3. Dig around in <https://kojipkgs.fedoraproject.org/packages/>

On your development machine:

1. **Important:** Verify that all of the RPMs are signed:
       
        :::console
        [root@client ~] # rpm -K *.rpm | grep -iv gpg

    should be empty

    If not, %RED%STOP%ENDCOLOR% and sign them using the OSG RPM key -- talk to Mat

2. Import the RPMs themselves into the Koji system


        :::console
        [user@client ~] $ osg-koji import %RED%<RPM_DIRECTORY>%ENDCOLOR%/*.rpm

    They will not be in any tags at this point

3. Add the package to the whitelist for our koji tag:

        :::console      
        [user@client ~] $ osg-koji add-pkg %RED%<OUR_KOJI_TAG>%ENDCOLOR% %RED%<PACKAGE>%ENDCOLOR% --owner="%RED%<YOUR_KOJI_USERNAME>%ENDCOLOR%"

4. Actually tag the builds:

        :::console 
        [user@client ~] $ osg-koji tag-pkg %RED%<OUR_KOJI_TAG> <BUILD>%ENDCOLOR%

5. Check the Tasks tab in Koji to see if kojira has started regening the repos -- it might take a few minutes to kick in.
     
    If it doesn't, do it manually (if you're doing multiple packages, save this step until you're done with all of them):
       
        :::code
        for repo in osg-{3.1,3.2,3.3,upcoming}-el5-{build,development,testing,release,prerelease,release-build}; do
           osg-koji regen-repo --nowait $repo
        done

6. Make a test VM and install the package from minefield to test that it is actually present.
7. Update the epelrescue RPMs table below

Removing resurrected RPMs
-------------------------

In case the RPM appeared back in EPEL, or we no longer need it, here's how to remove it from the epelrescue tags so we're not overriding the EPEL version:

1. Find out the NVR of the build:

        :::console
        [user@client ~] $ osg-koji list-tagged %RED%<OUR_KOJI_TAG> <PACKAGE>%ENDCOLOR%

2.  Untag the packages:
    
        :::console
        [user@client ~] $ osg-koji untag-pkg %RED%<OUR_KOJI_TAG> <BUILD>%ENDCOLOR%

### Why you should not use block-pkg

EPEL removes their packages by using 'koji block-pkg', which leaves the package and the builds in the tag, but prevents it from appearing in the repos. We cannot do that, because blocks are inherited and this will mess up our build repos. This is what happened in one case:

1. EPEL removed rpmdevtools, which is a necessary package for all builds. I resurrected it into epelrescue-el5.
2. Later, EPEL put rpmdevtools back into their repos, so it no longer needed to be in epelrescue-el5.
3. I used block-pkg on rpmdevtools in epelrescue-el5, thinking that the package could remain tagged, but will stay out of our repos, and the EPEL package would be used instead.
4. The block not only hid our rpmdevtools, it hid EPEL's rpmdevtools as well, preventing us from being able to build.
5. I unblocked the rpmdevtools, and just untagged the build instead, regenerated our build repos, and we could build again.

Policy for epelrescue tags
--------------------------

<https://jira.opensciencegrid.org/browse/SOFTWARE-2046>

Table of epelrescue RPMs
------------------------

| Package                                             | Distro version | Date added | Reason added                     | Date removed |
|:----------------------------------------------------|:---------------|:-----------|:---------------------------------|:-------------|
| python-six-1.7.3-1.el6                              | 6              | 2015-08-12 | Dep of osg-build (via mock)      | 2015-10-14   |
| python-argparse-1.2.1-2.el6                         | 6              | 2015-09-23 | Dep of osg-wn-client (via gfal2) | 2015-10-14   |
| python-backports-ssl\_match\_hostname-3.4.0.2-4.el6 | 6              | 2015-09-23 | Dep of osg-build (via mock)      | 2015-10-14   |
| python-requests-1.1.0-4.el6                         | 6              | 2015-09-23 | Dep of osg-build (via mock)      | 2015-10-14   |
| python-urllib3-1.5-7.el6                            | 6              | 2015-09-23 | Dep of osg-build (via mock)      | 2015-10-14   |

### Finding out if a package is still needed in epelrescue

Set `$pkg` to the name of a package to test (e.g. `python-six`), and `$rhel` set to the RHEL version you're testing for (e.g. `5`, `6`, or `7`).

Using Carl's `centos-srpms`, `scientific-srpms`, `slf-srpms` scripts:

``` code
for script in centos-srpms scientific-srpms slf-srpms; do
       echo -n $script ": "
       $script -$rhel $pkg | grep . || echo none
done
```

A dry run of removing the package:

``` code
osg-koji untag-pkg -n --all epelrescue-el$rhel $pkg
```

Remove the `-n` when the output of that looks fine.
