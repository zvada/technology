Promoting Packages from Upcoming to Main
========================================

Sometimes we move packages from Upcoming to the Main repositories in the middle of a release series. Once the Release Manager has given tentative approval for such a move:

If needed, move the software from upcoming to trunk and release using the usual process:

1. Merge changes to the package in SVN from branches/upcoming to trunk.
2. Build the package from trunk.
3. Follow the normal process to prepare a build for release (including development testing, promotion, etc.).

On release day, when the package has been released in the Main production repository, clean up the package from the upcoming repos:

1. Untag from **all upcoming repos** the version of the package corresponding to the version that was released in main. (Do **NOT** untag from the osg-upcoming-elN-release-X.Y.Z tags)

Also, untag all equal or lesser NVRs (minus the dist tag) from all upcoming repos.

If you do not have the privileges to untag from upcoming-release, someone on the Release Team can help.

(These steps are necessary to make sure Koji builds can't mistakenly use an older build from the upcoming repos).


2. Unless there's a newer build in branches/upcoming than what was released, remove the package directory from branches/upcoming.

