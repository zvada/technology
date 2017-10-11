How to Prepare a New Release Series
===================================

!!! warning
    This document was specifically written for OSG 3.4 and will need to be
    adapted to work for 3.5, 3.6, etc.

    The information was taken from
    [SOFTWARE-2622](https://jira.opensciencegrid.org/browse/SOFTWARE-2622)
    and
    [Matyas's notes for the OSG 3.4 release](http://pages.cs.wisc.edu/~matyas/notes/main/closed-2016/osg34.html).

Do first, anytime before the month of the release
-------------------------------------------------

-   Add 3.4 koji tags and targets

    -   Modify this script as appropriate and run: <https://github.com/opensciencegrid/osg-next-tools/blob/osg34/koji/create-new-koji-osg34-tags-etc>
    -   At first, upcoming-build should continue to inherit from 3.3-devel
    -   Create osg-3.4-elX-bootstrap and have the build tag inherit from it

-   Add Koji package signing

    -   Edit /etc/koji-hub/plugins/sign.conf; copy and modify one of the other osg entries
    -   Ensure the permissions are 0600 apache:apache
    -   Save the result with `etckeeper commit`

-   Update `osg-build` to use the new koji tags and targets (not by default of course)
    -   See the Git commits on opensciencegrid/osg-build for SOFTWARE-2693 for details on how to do this
    -   **You will be using this version of `osg-build` for some tasks, even if it hasn't been released**


Do afterward, anytime before the month of the release
-----------------------------------------------------

-   Create a blank `osg-3.4` SVN branch and add `buildsys-macros` package

    1.  svn copy `buildsys-macros` from trunk and hand-edit it to hardcode all the new values

        For EL 6:

        1.  Edit the spec file and set `dver` to 6
        2.  Run the following commands (adjust the NVR as necessary):

                :::console
                $ osg-build rpmbuild --el6
                $ osg-koji import _build_results/buildsys-macros-*.el6.src.rpm
                $ osg-koji import _build_results/buildsys-macros-*.el6.noarch.rpm
                $ osg-koji tag-pkg osg-3.4-el6-development buildsys-macros-7-5.osg34.el6

        Then do the same for EL 7:

        1.  Edit the spec file and set `dver` to 7
        2.  Run the following commands (adjust the NVR as necessary):

                :::console
                $ osg-build rpmbuild --el7
                $ osg-koji import _build_results/buildsys-macros-*.el7.src.rpm
                $ osg-koji import _build_results/buildsys-macros-*.el7.noarch.rpm
                $ osg-koji tag-pkg osg-3.4-el7-development buildsys-macros-7-5.osg34.el7

    2.  Do a 'real' build of `buildsys-macros`

        1.  Bump the revision in the `buildsys-macros` spec file and edit the `%changelog`.
            **Again, you will need a version of osg-build with 3.4 support.**

        2.  Set `dver` to 6. Commit

                :::console
                $ osg-build koji --repo=3.4 --el6

        3.  Set `dver` to 7. Commit

                :::console
                $ osg-build koji --repo=3.4 --el7

- Update `tarball-client` scripts
    - `bundles.ini`
    - `patches/`
    - `upload-tarballs-to-oasis` (for 3.4, `foreach_dver_arch` will need to be updated because we're dropping i386 support)

-   Populate the `bootstrap` tags

    Need to have them inherit from the 3.3 development tags, but only packages, not builds (hence the `--noconfig`; yes, the name is weird)

        :::console
        $ for el in el6 el7; do \
            for repo in 3.3 upcoming; do \
                osg-koji add-tag-inheritance --noconfig --priority=2 \
                    osg-3.4-$el-bootstrap osg-$repo-$el-development; \
            done; \
        done

-   Get the actual NVRs to tag

    -   I put Brian's spreadsheet into Excel and used its filtering feature to separate out:
        -   the packages going into 3.4.0
        -   the el6 versus el7 packages
    -   and copied the column containing the NVRs into Vim, and did a search&replace of the dver to the appropriate version
    -   saved two text files (pkgtotag-el6.txt and pkgtotag-el7.txt)
    -   Tagging:

            :::console
            $ for el in el6 el7; do \
                xargs -a pkgtotag-$el osg-koji tag-pkg osg-3.4-$el-bootstrap; \
            done

        (btw, xargs -a doesn't work on a Mac)


Do on the month of the 3.4.0 release
------------------------------------

-   Populate SVN branch and tags (as in fill it with the packages we're going to release for 3.4)
-   Mass rebuild
    -   Don't forget to update the `empty` and `contrib` tags with the appropriate packages;
        **remove the `empty*` packages from the development tags after they've been tagged into the `empty` tags**
- Update mash (coordinate with steige)
    - On repo-itb
    - On repo1/repo2
- Update documentation at
    <https://opensciencegrid.github.io/technology/software/development-process/>
- Update osg-test / vmu-test-runs
    -   They're only going to test from minefield (and eventurally testing) until the release


Do immediately after the 3.4.0 release
--------------------------------------

- Update tag inheritance on the `upcoming-build` tags to inherit from `3.4-devel` instead of `3.3-devel`
- Drop the `osg-3.4-elX-bootstrap` koji tags

Do sometime after the 3.4.0 release
-----------------------------------

- Do these three at the same time:
    - Move the SVN `trunk` to `branches/osg-3.3` and move `branches/osg-3.4` to `trunk`
    - Update the koji `osg-elX` build targets to build from and to 3.4 instead of 3.3
    - Notify the software list of this change
- Update osg-test / vmu-test-runs again to add release and release -> testing tests
- Update the docker-osg-wn-client scripts to build from 3.4 (need direct push access)
    1.  Update the constants in the `genbranches` script in the `docker-osg-wn-scripts` repo
    2.  Update the branches in `docker-osg-wn-client`; a script like this ought to work:

            :::shell
            git clone git@github.com:opensciencegrid/docker-osg-wn-scripts.git
            git clone git@github.com:opensciencegrid/docker-osg-wn.git
            cd docker-osg-wn-scripts
            ./genbranches
            cd ../docker-osg-wn
            for bpath in ../docker-osg-wn-scripts/branches/*; do
                b=${bpath##*/}
                git checkout -b $b master && \
                    mv $bpath Dockerfile.in && \
                    git add Dockerfile.in && \
                    git commit -m "Add branch $b"
            done

        and then run a similar script to update the existing branches
        Check the results before pushing, and then run `git push --all`

    3.  Update the arrays in `update-all` and `osg-wn-nightly-build` in `docker-osg-wn-scripts`

-   Update the default promotion route aliases in `osg-promote`

-   Update documentation again to reflect that 3.4 is now the _main_ branch and 3.3 is the _maintenance_ branch:
    <https://opensciencegrid.github.io/technology/software/development-process/>

