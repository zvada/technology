!!! note
    If you are performing a data release, please follow the instructions [here](cut-data-release)

How to Cut a Software Release
=============================

This document details the process for releasing new OSG Release version(s). This document does NOT discuss the policy for deciding what goes into a release, which can be found [here](/release/release-policy.md).

Due to the length of time that this process takes, it is recommended to do the release over three or more days to allow for errors to be corrected and tests to be run.

Requirements
------------

-   User certificate registered with OSG's koji with build and release team privileges
-   An account on UW CS machines (e.g. `library`, `ingwe`) to access UW's AFS
-   `release-tools` scripts in your `PATH` ([GitHub](https://github.com/opensciencegrid/release-tools))
-   `osg-build` scripts in your `PATH` (installed via OSG yum repos or [source](https://github.com/opensciencegrid/osg-build))

Pick the Version Number
-----------------------

The rest of this document makes references to `<VERSION(S)>` and `<NON-UPCOMING VERSIONS(S)>`, which refer to a space-delimited list of OSG version(s) and that same list minus `upcoming` (e.g. `3.3.28 3.4.3 upcoming` and `3.3.28 3.4.3`). If you are unsure about either the version or revision, please consult the release manager.

Day 0: Generate Preliminary Release List
----------------------------------------

The release manager often needs a tentative list of packages to be released. This is done by finding the package differences between osg-testing and the current release.

### Step 1: Update the osg-version RPM

For each release (excluding upcoming), update the version number in the osg-version RPM's spec file and build it in koji:

```bash
# If building for the latest release out of trunk
osg-build koji osg-version
# If building for an older release out of a branch:
MAJOR_VERSION=<MAJOR VERSION>
osg-build koji --repo=$MAJOR_VERSION osg-version
```

Where `<MAJOR VERSION>` is of the format `x.y` (e.g. `3.2`).

### Step 2: Promote osg-version and generate the release list

Run `0-generate-pkg-list` from a machine that has your koji-registered user certificate:

```bash
VERSIONS="<VERSION(S)>"
```
```bash
git clone https://github.com/opensciencegrid/release-tools.git
cd release-tools
0-generate-pkg-list $VERSIONS
```

Day 1: Verify Pre-Release and Generate Tarballs
-----------------------------------------------

This section is to be performed 1-2 days before the release (as designated by the release manager) to perform last checks of the release and create the client tarballs.

### Step 1: Verify Pre-Release

Compare the list of packages already in pre-release to the final list for the release put together by the OSG Release Coordinator (who should have updated `release-list` in git). To do this, run the `1-verify-prerelease` script from git:

```bash
VERSIONS="<VERSION(S)>"
```
```bash
1-verify-prerelease $VERSIONS
```

If there are any discrepancies consult the release manager. You may have to tag or untag packages with the `osg-koji` tool.

!!! note
    Please verify that the `osg-version` RPM is in your set of packages for the release! Also verify that if there is a new version of the `osg-tested-internal` RPM, then it is included in the release as well!

### Step 2: Test Pre-Release in VM Universe

To test pre-release, you will be kicking off a manual VM universe test run from `osghost.chtc.wisc.edu`.

1.  Ensure that you meet the [pre-requisites](https://github.com/opensciencegrid/vm-test-runs) for submitting VM universe test runs
2.  Prepare the test suite by running:

        osg-run-tests 'Testing OSG pre-release'

3.  `cd` into the directory specified in the output of the previous command
4.  `cd` into `parameters.d` and remove all files within it except for `osg33.yaml` and `osg34.yaml`
5.  Edit `osg33.yaml` so that it reads:

        platforms:
          - centos_6_x86_64
          - rhel_6_x86_64
          - sl_6_x86_64
          - centos_7_x86_64
          - rhel_7_x86_64
          - sl_7_x86_64
        
        sources:
          - opensciencegrid:master; 3.3; osg-prerelease
          - opensciencegrid:master; 3.3; osg > osg-prerelease
        
        package_sets:
          - label: All (java)
            selinux: True
            osg_java: True
            rng: True
            packages:
              - osg-tested-internal
              
6.  Edit `osg34.yaml` so that it reads:

        platforms:
          - centos_6_x86_64
          - rhel_6_x86_64
          - sl_6_x86_64
          - centos_7_x86_64
          - rhel_7_x86_64
          - sl_7_x86_64
        
        sources:
          - opensciencegrid:master; 3.4; osg-prerelease
          - opensciencegrid:master; 3.4; osg > osg-prerelease
          - opensciencegrid:master; 3.3; osg > 3.4/osg-prerelease
          - opensciencegrid:master; 3.4; osg-prerelease, osg-upcoming-prerelease, osg-upcoming
          - opensciencegrid:master; 3.4; osg > osg-prerelease, osg-upcoming-prerelease, osg-upcoming

        package_sets:
          - label: All
            selinux: True
            osg_java: False
            packages:
              - osg-tested-internal
              
    If you are not releasing packages into `upcoming`, delete the `upcoming`-related lines in the `sources` section.

7.  `cd` back into the root directory of the test run (e.g. `cd ..`)
8.  Submit the DAG:

        condor_submit_dag master-run.dag

!!! note
    If there are failures, consult the release-manager before proceeding.

### Step 3: Test Pre-Release on the Madison ITB site

Test the pre-release on the Madison ITB by following the [ITB pre-release testing instructions](itb-testing/).

### Step 4: Regenerate the build repositories

To avoid 404 errors when retrieving packages, it's necessary to regenerate the build repositories. Run the following script from a machine with your koji-registered user certificate:

```bash
NON_UPCOMING_VERSIONS="<NON-UPCOMING VERSION(S)>"
```
```bash
1-regen-repos $NON_UPCOMING_VERSIONS
```

### Step 5: Create the client tarballs

Create the client tarballs as root on an EL7 fermicloud machine using the relevant script from git:

```bash
NON_UPCOMING_VERSIONS="<NON-UPCOMING VERSION(S)>"
```
```bash
git clone https://github.com/opensciencegrid/release-tools.git
cd release-tools
./1-client-tarballs $NON_UPCOMING_VERSIONS
```

### Step 6: Briefly test the client tarballs

As an **unprivileged user**, extract each tarball into a separate directory. Make sure osg-post-install works. Make sure `osgrun osg-version` works by running the following tests, replacing `<NON-UPCOMING VERSION(S)` with the appropriate version numbers:

```bash
NON_UPCOMING_VERSIONS="<NON-UPCOMING VERSION(S)>"
```
```bash
dotest () {
    file=$dir/$client-$ver-1.$rhel.$arch.tar.gz
    if [ -e $file ]; then
        echo "Testing $client-$ver-1.$rhel.$arch..."
        size=$(du -m "$file" | cut -f 1)
        if [ $size -gt $max_size ]; then
            echo -e "\e[1;33mWARNING: $client-$ver-1.$rhel.$arch is too big. Check with release manager.\e[0m"
        fi
        mkdir -p $rhel-$arch
        pushd $rhel-$arch
        tar xzf ../$file
        $client/osg/osg-post-install
        $client/osgrun osg-version
        popd
        rm -rf $rhel-$arch
    else
        echo -e "\e[1;31mERROR: $client-$ver-1.$rhel.$arch tarball is missing.\e[0m"
    fi
}

pushd /tmp

for ver in $NON_UPCOMING_VERSIONS; do
    major_version="${ver%.*}"
    clients="osg-wn-client"
    if [ "$major_version" = "3.4" ]; then
        clients="$clients osg-afs-client"
    fi
    for client in $clients; do
        rhels="el6 el7"
        for rhel in $rhels; do
            max_size=24
            if [ $rhel = "el7" ]; then
                max_size=32
            fi
            archs="x86_64"
            if [ "$major_version" = "3.3" -a $rhel = "el6" ]; then
                archs="i386 $archs"
            fi
            for arch in $archs; do
                dir=tarballs/$major_version/$arch
                dotest
            done
        done
    done
done

popd
```

If you have time, try some of the binaries, such as grid-proxy-init.

!!! todo
    We need to automate this and have it run on the proper architectures and version of RHEL.

### Step 7: Update the UW AFS installation of the tarball client

The UW keeps an install of the tarball client in `/p/vdt/workspace/tarball-client` on the UW's AFS. To update it, run the following commands:

```bash
NON_UPCOMING_VERSIONS="<NON-UPCOMING VERSION(S)>"
```
```bash
for ver in $NON_UPCOMING_VERSIONS; do
    /p/vdt/workspace/tarball-client/afs-install-tarball-client $ver
done
```

### Step 8: Wait

Wait for clearance. The OSG Release Coordinator (in consultation with the Software Team and any testers) need to sign off on the update before it is released. If you are releasing things over two days, this is a good place to stop for the day.

Day 2: Pushing the Release
--------------------------

!!! warning
    Operations would like to send out the release announcement prior to 3 PM Eastern time.
    Do not start this process after 2 PM Eastern time unless you check with Operations (specifically Kyle Gross) first.

### Step 1: Push from pre-release to release

This script moves the packages into release, clones releases into new version-specific release repos, locks the repos and regenerates them. Afterward, it produces `*release-note*` files that should be used to update the release note pages. Clone it from the github repo and run the script:

```bash
VERSIONS="<VERSION(S)>"
```
```bash
2-create-release $VERSIONS
```

1.  `*.txt` files are also created and it should be verified that they've been moved to /p/vdt/public/html/release-info/ on UW's AFS.
2.  For each release version, use the `*release-note*` files to update the relevant sections of the release note pages.

### Step 2: Upload the client tarballs

Ask Tim Theisen, Brian Lin, or someone with privileges on the `opensciencegrid.org` repo servers to upload the tarballs with the following procedure:

#### On a CS machine

```bash
NON_UPCOMING_VERSIONS="<NON-UPCOMING VERSION(S)>"
```
```bash
for ver in $NON_UPCOMING_VERSIONS; do
    major_ver=`sed 's/.[0-9]*$//' <<< $ver`
    cd /p/vdt/public/html/tarball-client
    ssh jump.grid.iu.edu mkdir /tmp/$ver/
    scp -p $major_ver/*/osg-wn-client-$ver*gz jump.grid.iu.edu:/tmp/$ver/
done
```

#### On jump.grid.iu.edu

```bash
NON_UPCOMING_VERSIONS="<NON-UPCOMING VERSION(S)>"
```
```bash
for ver in $NON_UPCOMING_VERSIONS; do
    scp -pr /tmp/$ver repo1:/tmp/
    scp -pr /tmp/$ver repo2:/tmp/
    rm -rf /tmp/$ver
done
```

#### On repo1/repo2 (as root)

You can ssh to repo1 and repo2 from jump.grid.iu.edu; you will need to do this procedure on both systems.

```bash
sudo su -
```

```bash
NON_UPCOMING_VERSIONS="<NON-UPCOMING VERSION(S)>"
```
```bash
for ver in $NON_UPCOMING_VERSIONS; do
    major_ver=`sed 's/.[0-9]*$//' <<< $ver`
    mv /tmp/$ver /usr/local/repo/tarball-install/$major_ver/
    rm -f /usr/local/repo/tarball-install/$major_ver/*latest*
done
/root/mk-sims.sh
for ver in $NON_UPCOMING_VERSIONS; do
    major_ver=`sed 's/.[0-9]*$//' <<< $ver`
    ls -l /usr/local/repo/tarball-install/$major_ver/*latest* # verify the symlinks are correct
done
```

### Step 3: Install the tarballs into OASIS

!!! note
    You must be an OASIS manager of the `mis` VO to do these steps. Known managers as of 2014-07-22: Mat, Tim C, Tim T, Brian L. 

Get the uploader script from Git and run it with `osgrun` from the UW AFS install of the tarball client you made earlier. On a UW CSL machine:

```bash
NON_UPCOMING_VERSIONS="<NON-UPCOMING VERSION(S)>"
```
```bash
cd /tmp
git clone --depth 1 file:///p/vdt/workspace/git/repo/tarball-client.git
for ver in $NON_UPCOMING_VERSIONS; do
    /p/vdt/workspace/tarball-client/current/sys/osgrun /tmp/tarball-client/upload-tarballs-to-oasis $ver
done
```

The script will automatically ssh you to oasis-login.opensciencegrid.org and give you instructions to complete the process.

### Step 4: Remove old UW AFS installations of the tarball client

To keep space usage down, remove tarball client installations and symlinks under `/p/vdt/workspace/tarball-client` on UW's AFS that are more than 2 months old. The following command will remove them:

```bash
find /p/vdt/workspace/tarball-client -maxdepth 1 -mtime +60 -name 3\* -ls -exec rm -rf {} \;
```

### Step 5: Update the Docker WN client

Update the GitHub repo at [opensciencegrid/docker-osg-wn](https://github.com/opensciencegrid/docker-osg-wn) using the `update-all` script found in [opensciencegrid/docker-osg-wn-scripts](https://github.com/opensciencegrid/docker-osg-wn-scripts). This requires push access to the `opensciencegrid/docker-osg-wn` repo.

Instructions for using the script:

```bash
git clone git@github.com:opensciencegrid/docker-osg-wn-scripts.git
git clone git@github.com:opensciencegrid/docker-osg-wn.git
docker-osg-wn-scripts/update-all docker-osg-wn
cd docker-osg-wn
# Verify everything looks fine and run the 'git push' command
# that 'update-all' should have printed
```

### Step 6: Announce the release

The following instructions are meant for the release manager (or interim release manager). If you are not the release manager, let the release manager know that they can announce the release.

1.  The release manager writes the a release announcement for each version and sends it out.
    The announcement should mention a handful of the most important updates.
    Due to downstream formatting issues, each major change should end at column 76 or earlier.
    Here is a sample, replace `<BRACKETED TEXT>` with the appropriate values:

        Subject: Announcing OSG Software version <VERSION>

        We are pleased to announce OSG Software version <VERSION>!

        Changes to OSG <VERSION> include:
        - Major Change 1
        - Major Change 2
        - Major Change 3

        Release notes and pointers to more documentation can be found at:

        http://opensciencegrid.github.io/docs/release/<SERIES.VERSION>/release-<RELEASE-VERSION>/

        Need help? Let us know:

        http://opensciencegrid.github.io/docs/common/help/

        We welcome feedback on this release!

2.  The release manager emails the announcement to `vdt-discuss@opensciencegrid.org`
3.  The release manager asks the GOC to distribute the announcement by [opening a ticket](https://ticket.opensciencegrid.org/goc/other)
4.  The release manager closes the tickets marked 'Ready for Release' in the release's JIRA filter using the 'bulk change' function.
    Also set the Fix Versions field to the appropriate value(s) and uncheck the box that reads "Send mail for this update"

Day 3: Update the ITB
---------------------

Now that the release has had a chance to propogate to all the mirrors, update the Madison ITB site by following
the [yum update section](../infrastructure/madison-itb/#doing-yum-updates) of the Madison ITB document.
Remember, it may be advisable to stop the HTCondor daemons according to the [HTCondor pre-release testing instructions](itb-testing/#installing-htcondor-prerelease).
