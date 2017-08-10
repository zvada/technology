!!! note
    If you are performing a software release, please follow the instructions [here](cut-sw-release)

How to Cut a Data Release
=========================

This document details the process for releasing new OSG Data Release version(s). This document does NOT discuss the policy for deciding what goes into a release, which can be found [here](https://twiki.opensciencegrid.org/bin/view/SoftwareTeam/ReleasePolicy).

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

```console
[user@client ~] $ git clone https://github.com/opensciencegrid/release-tools.git
[user@client ~] $ cd release-tools
[user@client ~] $ 0-generate-pkg-list -d <REVISION> <VERSION(S)>
```

Day 1: Verify Pre-Release
-------------------------

This section is to be performed 1-2 days before the release (as designated by the release manager) to perform last checks of the release.

Compare the list of packages already in pre-release to the final list for the release put together by the OSG Release Coordinator (who should have updated `release-list` in git). To do this, run the `1-verify-prerelease` script from git:

```console
[user@client ~] $ 1-verify-prerelease <VERSION(S)>
```

If there are any discrepancies consult the release manager. You may have to tag packages with the `osg-koji` tool.

Day 2: Pushing the Release
--------------------------

For the second phase of the release, try to complete it earlier in the day rather than later. The GOC would like to send out the release announcement prior to 3 p.m. Eastern time.

### Step 1: Push from pre-release to release

This script moves the packages into release, clones releases into new version-specific release repos, locks the repos and regenerates them. Afterwards, it produces `*release-note*` files that should be used to update the release note pages. Clone it from the github repo and run the script:

```console
[user@client ~] $ 2-create-release -d <REVISION> <VERSION(S)>
```

1.  `*.txt` files are also created and it should be verified that they've been moved to `/p/vdt/public/html/release-info/` on UW's AFS.
2.  For each release version, use the `*release-note*` files to update the relevant sections of the release note pages.

### Step 2: Update the Docker WN client

Update the GitHub repo at [opensciencegrid/docker-osg-wn](https://github.com/opensciencegrid/docker-osg-wn) using the `update-all` script found in [opensciencegrid/docker-osg-wn-scripts](https://github.com/opensciencegrid/docker-osg-wn-scripts). This requires push access to the `opensciencegrid/docker-osg-wn` repo.

Instructions for using the script:

```console
[user@client ~] $ git clone git@github.com:opensciencegrid/docker-osg-wn-scripts.git
[user@client ~] $ git clone git@github.com:opensciencegrid/docker-osg-wn.git
[user@client ~] $ docker-osg-wn-scripts/update-all docker-osg-wn
[user@client ~] $ cd docker-osg-wn
# Verify everything looks fine and run the 'git push' command
# that 'update-all' should have printed
```

### Step 3: Verify the VO Package and/or CA certificates

Wait for the CA certificates to be propagated to the web server on `repo.grid.iu.edu`. The repository is checked every 10 minutes for update CA certificates. Then, run the following command to update the VO Package and/or CA certificates in the tarball installations and verify that the version of the VO Package and/or CA certificates match the version that was promoted to release.

```console
[user@client ~] $ /p/vdt/workspace/tarball-client/current/amd64_rhel6/osgrun osg-update-data
[user@client ~] $ /p/vdt/workspace/tarball-client/current/amd64_rhel7/osgrun osg-update-data
```

### Step 4: Announce the release

The following instructions are meant for the release manager (or interim release manager). If you are not the release manager, let the release manager know that they can announce the release.

1.  The release manager writes the release announcement and send it out. Here is a sample, replace `<HIGHLIGHTED TEXT>` with the appropriate values:

         Subject: Announcing OSG Software version <VERSION(S)>
         
         We are pleased to announce OSG Software version <VERSION(S)>!
         
         This is the new OSG Software distributed via RPMs for:
         
         * Scientific Linux 6 and 7
         * CentOS 6 and 7
         * Red Hat Enterprise Linux 6 and 7
         
         This release affects the <SET OF METAPACKAGES (client, compute element, etc...)>. Changes include:
         
         * Major change 1
         * Major change 2
         * Major change 3
         
         Release notes and pointers to more documentation can be found at:
         
         <LINK TO RELEASE NOTES>
         
         Need help? Let us know:
         
         https://www.opensciencegrid.org/bin/view/Documentation/Release3/HelpProcedure
         
         We welcome feedback on this release

2.  The release manager emails the announcement to `vdt-discuss@opensciencegrid.org`
3.  The release manager asks the GOC to distribute the announcement by [opening a ticket](https://ticket.grid.iu.edu/goc/other)
4.  The release manager closes the tickets marked 'Ready for Release' in the release's JIRA filter using the 'bulk change' function. Uncheck the box that reads "Send mail for this update"
5.  The release manager updates the recent/scheduled release tables on the Software/Release [homepage](https://twiki.opensciencegrid.org/bin/view/SoftwareTeam/WebHome)

