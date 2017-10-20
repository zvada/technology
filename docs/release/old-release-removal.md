Old Release Series Removal Plan
===============================

In order to reduce clutter and disk usage on our repositories and build system,
we will remove older OSG Software release series.  This will result in packages
from those series becoming unavailable, so we will remove a release series when
its packages are no longer needed.

We will remove a release series when the _following_ series is completely out
of support.  For example, OSG 3.1 will be removed when OSG 3.2 is out of
support, and OSG 3.2 will be removed when OSG 3.3 is out of support.


Tasks
-----

Removing a release series requires work from both Operations and Software &
Release.  The first step is to create a JIRA ticket in the SOFTWARE project to
track the work.  Second, Software & Release will enumerate the directories for
Operations to remove.

Operations tasks should be completed before Software & Release tasks.


### Operations

These tasks should be completed in order.

1.  Two weeks in advance, notify sites (including mirror sites) that the
    release series is going away.  See the [template email](#template-email)
    below.

2.  Remove the series from the mash configs on the repo.grid.iu.edu machines.

3.  Remove the appropriate mirrorlist directories from `/usr/local/mirror/osg`.

4.  Remove the appropriate repo directories from `/usr/local/repo/osg`.

5.  Wait for mash to run and verify that the repos are no longer getting
    updated:

    -  Look at the mash logs in `/var/log/repo`.
    -  Verify that mash did not recreate the repo directory under
       `/usr/local/repo/osg` corresponding to the old release series.

### Software & Release

These tasks can be completed in any order.

- Tag and remove the SVN branch corresponding to the release series.

- Edit `vm-test-runs` and remove any "long tail" tests that reference the
  series.

- Edit `tarball-client`:

    - Remove bundles from `bundles.ini`.
    - Remove patch and other files that were used only by those bundles.
    - Test that the current bundles didn't get broken by your changes.

- Edit `osg-build`:

    - Remove the promotion routes from `promoter.ini`.
    - Remove references in `constants.py`.
    - Test your changes; also run the unit tests.

- Remove things from Koji:

    - All targets referencing the series.
    - All tags referencing the series.

- Remove references to the series from `opensciencegrid/docker-osg-wn-scripts`
  on GitHub, including the `genbranches` and `update-all` scripts.

- Remove branches from `opensciencegrid/docker-osg-wn` on GitHub.

- Move files in `/p/vdt/public/html/release-info` to its `attic` subdirectory.


Undoing
-------

If we really need RPMs from a removed release series, we can look at the text
files in `/p/vdt/public/html/release-info/attic` to determine the exact NVRs we
need, and download them from Koji.



Template Email
--------------

>   On <DAYNAME, MONTH DAY>, the OSG will be removing the OSG <3.X> release
>   series from our repositories.  This includes both RPMs and tarballs hosted
>   on repo.opensciencegrid.org.
>
>   All support for OSG <3.X> had been discontinued at the end of <MONTH YEAR>.
>
>   Any sites running OSG <3.X> should upgrade to the current release series,
>   OSG <3.Y>.  If you need assistance upgrading, please contact us at
>   goc@opensciencegrid.org.

If we're dropping support for a distro (e.g. EL 5 when we drop OSG 3.2), add
the following after the first paragraph:

>   Note that OSG <3.X> was the last release to support Enterprise Linux <Z>
>   distributions.
