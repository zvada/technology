!!! note
    If you are performing a software release, please follow the instructions [here](cut-sw-release)

How to Cut a Data Release
=========================

This document details the process for releasing new OSG Data Release version(s). This document does NOT discuss the policy for deciding what goes into a release, which can be found [here](/release/release-policy.md).

Due to the length of time that this process takes, it is recommended to do the release over three or more days to allow for errors to be corrected and tests to be run.

Requirements
------------

-   User certificate registered with OSG's koji with build and release team privileges
-   An account on UW CS machines (e.g. `library`, `ingwe`) to access UW's AFS
-   `release-tools` scripts in your `PATH` ([GitHub](https://github.com/opensciencegrid/release-tools))
-   `osg-build` scripts in your `PATH` (installed via OSG yum repos or [source](https://github.com/opensciencegrid/osg-build))

Pick the Version and Revision Numbers
-------------------------------------

The rest of this document makes references to `<REVISION>` and `<VERSION(S)>` , which refer to the space-delimited list of OSG version(s) and data revision, respectively (e.g. `3.3.28 3.4.3` and `2`, respectively). If you are unsure about either the version or revision, please consult the release manager.

Day 0: Generate Preliminary Release List
----------------------------------------

The release manager often needs a tentative list of packages to be released. This is done by finding the package differences between osg-testing and the current release. Run `0-generate-pkg-list` from a machine that has your koji-registered user certificate:

```bash
VERSIONS='<VERSION(S)>'
REVISION=<REVISION>
```
```bash
git clone https://github.com/opensciencegrid/release-tools.git
cd release-tools
0-generate-pkg-list -d $REVISION $VERSIONS
```

Day 1: Verify Pre-Release
-------------------------

This section is to be performed 1-2 days before the release (as designated by the release manager) to perform last checks of the release.

### Step 1: Generate the release list

Compare the list of packages already in pre-release to the final list for the release put together by the OSG Release Coordinator (who should have updated `release-list` in git). To do this, run the `1-verify-prerelease` script from git:

```bash
VERSIONS='<VERSION(S)>'
```
```bash
1-verify-prerelease $VERSIONS
```

If there are any discrepancies consult the release manager. You may have to tag packages with the `osg-koji` tool.

### Step 2: Test the Pre-Release on the Madison ITB site

Test the pre-release on the Madison IRB by following the [ITB pre-release testing instructions](itb-testing/).

Day 2: Pushing the Release
--------------------------

!!! warning
    Operations would like to send out the release announcement prior to 3 PM Eastern time.
    Do not start this process after 2 PM Eastern time unless you check with Operations (specifically Kyle Gross) first.

### Step 1: Push from pre-release to release

This script moves the packages into release, clones releases into new version-specific release repos, locks the repos and regenerates them. Afterwards, it produces `*release-note*` files that should be used to update the release note pages. Clone it from the github repo and run the script:

```bash
VERSIONS='VERSION(S)>'
REVISION=<REVISION>
```
```bash
2-create-release -d $REVISION $VERSIONS
```

1.  `*.txt` files are also created and it should be verified that they've been moved to `/p/vdt/public/html/release-info/` on UW's AFS.
2.  For each release version, use the `*release-note*` files to update the relevant sections of the release note pages.

### Step 2: Update the Docker WN client

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

### Step 3: Verify the VO Package and/or CA certificates

Wait for the [CA certificates](https://repo.opensciencegrid.org/cadist/) to be updated.
It may take a while for the updates to reach the mirror used to update the web site.
The repository is checked every 10 minutes for updated CA certificates.
Once the web page is updated, run the following command to update the VO Package and/or CA certificates in the tarball installations and
verify that the version of the VO Package and/or CA certificates match the version that was promoted to release.

```bash
/p/vdt/workspace/tarball-client/current/amd64_rhel6/osgrun osg-update-data
/p/vdt/workspace/tarball-client/current/amd64_rhel7/osgrun osg-update-data
```

### Step 4: Announce the release

The following instructions are meant for the release manager (or interim release manager). If you are not the release manager, let the release manager know that they can announce the release.

1.  The release manager writes the a release announcement for each version and sends it out.
    The announcement should mention a handful of the most important updates.
    Due to downstream formatting issues, each major change should end at column 76 or ealier.
    Here is a sample, replace `<BRACKETED TEXT>` with the appropriate values:
    If you are only updating certificates or only updated the VO package, delete the corresponding text:

        Subject: Announcing OSG CA Certificate and VO Package Updates
        Subject: Announcing OSG CA Certificate Update
        Subject: Announcing VO Package Update

        We are pleased to announce a data release for the OSG Software Stack.
        Data releases do not contain any software changes.

        This release contains updated CA Certificates based on IGTF <VERSION>:
        - <Change 1 from IGTF changelog>
        - <Change 2 from IGTF changelog>

        This release contains VO Package v<VERSION>:
        This release also contains VO Package v<VERSION>:
        - <Change 1 from VO changelog>
        - <Change 2 from VO changelog>

        Release notes and pointers to more documentation can be found at:

        http://opensciencegrid.github.io/docs/release/<SERIES.VERSION>/release-<RELEASE-VERSION>/

        Need help? Let us know:

        http://opensciencegrid.github.io/docs/common/help/

        We welcome feedback on this release!

2.  The release manager emails the announcement to `vdt-discuss@opensciencegrid.org`
3.  The release manager asks the GOC to distribute the announcement by [opening a ticket](https://ticket.opensciencegrid.org/goc/other)
4.  The release manager closes the tickets marked 'Ready for Release' in the release's JIRA filter using the 'bulk change' function. Uncheck the box that reads "Send mail for this update"

Day 3: Update the ITB
---------------------

Now that the release has had a chance to proprogate to all the mirrors, update the Madison ITB site by following
the [yum update section](../infrastructure/madison-itb/#doing-yum-updates) of the Madison ITB document.
Remember, it may be advisable to stop the HTCondor daemons according to the [HTCondor pre-release testing instructions](itb-testing/#installing-htcondor-prerelease).

