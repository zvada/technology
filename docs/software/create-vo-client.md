Creating the VO Client Package
==============================

Overview
--------

This document will explain the step-by-step procedures for creating and releasing the VO Client Package.

The VO Client Package sources can be found here:
<https://github.com/opensciencegrid/osg-vo-config>

When upstream changes have been made and are ready for a new VO Client Package release, these sources will be used to
prepare a release tarball, which will in turn be used for the RPMs.

In order to build the RPM, one needs:

-   The tarball containing the:
    -   `edg-mkgridmap.conf` file
    -   `gums.config.template` file
    -   `grid-vorolemap` file (generated)
    -   `voms-mapfile-default` file (generated)
    -   `vomses` file
    -   `vomsdir` directory tree, containing the .lsc files.
-   The RPM spec file, [maintained](#rpm-spec-file-maintenance) in the OSG packaging area.


JIRA Ticket for the Release
---------------------------

There should be an associated JIRA ticket with a summary line of the form "Release VO Package 85".
(Throughout this document, this release number will be referred to as `<NN>`.)

The JIRA ticket should contain the details of the changes expected in the new VO Client Package release, which you
should verify before proceeding.
You can verify this with your favorite git tool (eg, `git diff` or `gitk`), or just view the changes directly on GitHub:

-   <https://github.com/opensciencegrid/osg-vo-config/compare/release-84...master>

Here, `release-84` is the _previous_ release tag, which you are comparing to the latest changes in `master`.
To use GitHub to view the comparison, you need to specify whatever is the most recent _previous_ release tag.

Alternatively, you can proceed to [make the tarball](#making-the-tarball), and compare the result to the previous
`vo-client` tarball (from the upstream source cache) before [publishing the new release](#publishing-the-new-release).

However you choose to do it, the point is to verify that the changes going into the release match what is expected in
the JIRA ticket before publishing a new release.

Making the tarball
------------------

To make the tarball:

-   start with a clean directory
-   copy in the `vomses`, `gums.template`, and `edg-mkgridmap.conf` files and rename the edg-mkgridmap file:

<!-- -->

          wget http://repo.opensciencgrid.org/pacman/tarballs/vo-package/vomses
          wget http://repo.opensciencegrid.org/pacman/tarballs/vo-package/edg-mkgridmap.osg
          mv edg-mkgridmap.osg edg-mkgridmap.conf
          wget http://repo.opensciencegrid.org/pacman/tarballs/vo-package/gums.template # TODO UNSURE

-   Create the vomsdir directory by downloading the .lsc files

<!-- -->

         wget --recursive --no-host-directories --cut-dirs=3 -A "*.lsc" http://repo.opensciencegrid.org/pacman/tarballs/vo-package/vomsdir

-   In a separate directory, unpack the *old* vo-client tarball (from the upstream source cache)
-   diff the two directories, and compare the changes to the expected changes listed in the JIRA ticket for this VO Client package release

<!-- -->

-   Follow the instructions in the attached [gums-template-conversion.txt](gums-template-conversion.txt) file to convert it from GUMS 1.1 (1.2?) format to GUMS 1.3 format. Name the result `gums.config.template`. See also the [Automated GUMS Conversion](#automated-gums-conversion) section below for a scripted version of this step.
-   Move the files into a subdirectory to include in the tarball:

<!-- -->

          VERSION=44  # set appropriately
          mkdir vo-client-$VERSION
          mv vomses gums.config.template edg-mkgridmap.conf vomsdir vo-client-$VERSION/
          tar -czf vo-client-$VERSION-osg.tar.gz vo-client-$VERSION/

Upload the tarball into the [upstream source cache](/software/rpm-development-guide#upstream-source-cache), in the `vo-client/VERSION/` directory.

Automated GUMS Conversion
-------------------------

The above [instructions](gums-template-conversion.txt) outline a procedure for converting the osg gums.config template from GUMS 1.1 format to 1.3 format. Because setting up a GUMS instance for this can be time consuming and tricky to get right, a script was written to automate the procedure on a Fermi VM. The script lives in svn under: `$SVN/software/tools/convert-osg-gums-template-for-vo-client.sh` .

To use it:

-   Create a new Fermi VM (el5 or el6)
-   Copy the script and the new `gums.template` to be converted to the /root homedir on the VM.
-   Log into the VM as root, make sure the script is executable, and run against the gums template:

<!-- -->

          $ ssh root@el6-vo-client
          # wget https://vdt.cs.wisc.edu/svn/software/tools/convert-osg-gums-template-for-vo-client.sh
          # chmod +x convert-osg-gums-template-for-vo-client.sh
          # ./convert-osg-gums-template-for-vo-client.sh gums.template

-   It takes a little while to install and set up gums and related packages, but if it succeeds, you should see a message that says "User group has been saved.", and a file `gums.config.template` should be written in the current directory.
-   The newly converted `gums.config.template` should be compared to the old version of that file (from the previous vo-client package) to ensure that the only the differences are the changes for this release. (I have had to manually strip the extra test account stuff.) The 'meld' program is a nice graphical diff tool that I use for comparing them.

RPM spec file maintenance
-------------------------

The OSG RPM spec file is [maintained in Subversion](/software/rpm-development-guide#revision-control-system).

The VO Client package is located in `native/redhat/trunk/vo-client`

There are two files that need to be maintained:

-   `osg/vo-client.spec` - This is the RPM spec file proper. One needs to update the version (and/or the release number) every time a new RPM is created.
-   `upstream/release_tarball.source` - This file contains the relative path of the tarball within the [upstream source cache](/software/rpm-development-guide#upstream-source-cache). Since the tarball file name will change with every new RPM version, this file has to be changed accordingly.

RPM building
------------

After installing the [osg-build tools](/software/osg-build-tools), check out a clean copy from svn, then:

-   `osg-build prebuild .`
-   Once there are no errors, run `osg-build koji . --scratch` This can be done without making any permanent change.
-   Once that builds successfully, run `osg-build koji .` This is permanent, unlike when you ran with `--scratch`. You cannot rebuild this version of the RPM again - you must bump the release number and edit the changelog.

This will push the RPMs into the OSG development repository. Koji requires additional setup compared to rpmbuild; [see the documentation here](/software/koji-workflow).

Promotion to testing and release:
---------------------------------

### Policies

Read [Release Policy](/release/release-policy).

These should be synchronized internally with other GOC update activities.

