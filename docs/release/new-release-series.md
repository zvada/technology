How to Prepare a New Release Series
===================================

!!! note
    Notes taken from [SOFTWARE-2622](https://jira.opensciencegrid.org/browse/SOFTWARE-2622) for the OSG 3.4 release:

This ticket serves as a checklist for all the preparation that is required to release OSG 3.4. 

The following can be done at any time:

- Create a blank `osg-3.4` SVN branch and add `buildsys-macros` package
- Add 3.4 koji tags and targets; update `osg-build` to use them (not by default of course)
- Set up package signing for the 3.4 build tags
- Update `tarball-client` scripts
    - `bundles.ini`
    - `patches/`
    - `upload-tarballs-to-oasis` (`foreach_dver_arch` will need to be updated because we're dropping i386 support)

The following must wait until the month of the 3.4.0 release:

- Populate SVN branch and tags (as in fill it with the packages we're going to release for 3.4)
- Mass rebuild
- Update mash
    - On repo-itb
    - On repo1/repo2
- Update documentation
- Update osg-test / vmu-test-runs

The following must be done immediately after the 3.4.0 release:

- Update tag inheritance on the `upcoming-build` tags to inherit from `3.4-devel` instead of `3.3-devel`
- Drop the `osg-3.4-elX-bootstrap` koji tags

The following should be done sometime after the 3.4.0 release:

- Do these three at the same time:
    - Move the SVN `trunk` to `branches/osg-3.3` and move `branches/osg-3.4` to `trunk`
    - Update the koji `osg-elX` build targets to build from and to 3.4 instead of 3.3
    - Notify the software list of this change
- Update the docker-osg-wn-client scripts to build from 3.4
- Update the default promotion route aliases in `osg-promote`
