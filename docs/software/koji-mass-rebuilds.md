Mass RPM Rebuilds for a new Build Target in Koji
================================================

Whenever we move to a new OSG series (OSG 3.3) and/or a new RHEL version (EL7), we want to make new builds for all of our packages in the new koji build target (osg-3.3-el7). Due to tricky build dependencies and unexpected build failures, this can be a messy task; and in the past we have gone about it in an ad-hoc manner.

This document will discuss some of the aspects of the task and issues involved, some possible approaches, and ultimately a proposal for a general tool or procedure for doing our mass rebuilds.


New RHEL version vs new OSG series
----------------------------------

### New RHEL version

For a new RHEL version, we start with no osg packages to build against, so we are forced to build things in dependency order. Figuring out the dependency order is possibly the most difficult (or interesting) part of doing mass rebuilds -- more on that later.

### New OSG series

For a new OSG series within an existing RHEL version, we have more options. While it's possible to "start from scratch" the same way we would with a new RHEL version and build everything in dependency order, this is not really necessary if we take advantage of existing builds from the previous series.

A prior step is to determine the package list for the new series -- this will be some combination of Upcoming and the current release series, minus any packages pruned for the new series. This should also be reflected in the new trunk packaging area. All the current builds for packages in that list (from upcoming + current series) can be tagged into the new \*-development (or \*-build) repos. This should make all of the build dependencies available for mass rebuilding the new series all at once (osg-build koji \*).

After some consideration, I wholeheartedly endorse this approach for new OSG series -- for all but academic exercises. Rebuilding in dependency order when all the dependencies are already built just seems like wasted effort.

Doing scratch builds of everything first
----------------------------------------

Before doing the mass rebuilds in a new build target, it seems to be a good idea to do scratch builds of all the packages in the current series first. (Or, at least the ones we intend to bring into the new build target.) This will give us a chance to see any build failures that have crept in (possibly due to upstream changes in the OS or EPEL), and fix them first if desired, but in any case avoid the confusion of seeing the failures for the first time in the new build target.

Doing mass scratch rebuilds for an existing series is easy, as they can all be done at once.

Relatedly, doing a round of scratch builds **after** successfully building all packages into a new build target can also be useful, because it can reveal dependency issues only present in the new set of builds. Doing developer test installs or a round of VMU tests may also uncover any runtime dependency issues.

Options for calculating build dependencies
------------------------------------------

We can get dependency information from a number of places:

- scraping .spec files for Requires/BuildRequires/Provides and `%package` names
- querying existing rpms directly on koji-hub and our OS/EPEL mirrors (`rpm -q`)
- querying srpms from `osg-build prebuild` directly for build requirements
- inspecting previous buildroots to determine resolved build dependencies
- use `repoquery` to determine whatrequires/whatprovides for packages
- use `yum-builddep` to find packages with all build requirements available
- using the repodata (primary+filelists) from rpm repositories, including:
- upcoming + 3.X development + external repos (Centos/EPEL/JPackage), OR
- osg-upcoming-elX-build, which includes them all

One important aspect is that the runtime requirements are also relevant for determining build requirements, since a build will require installing all of the runtime requirements of the packages required for the build.

That is, `(A BuildRequires B) and (B Requires C)` implies `A BuildRequires C`.

Combined with the fact that runtime requirements are transitive, that is, `(A Requires B) and (B Requires C)` implies `A Requires C`, computing build requirements is a recursive operation, which can be many levels deep.

Another question to keep in mind is whether to use versioned requires/provides (i.e., BuildRequires xyz >= 1.2-3) or to only pay attention to the package/capability names. Similarly, whether to pay any attention to conflicts/obsoletes. These would add complexity to anything except the standard tools (repoquery, yum-builddep) which already take these things into account. (And we may get pretty far even without paying attention to versions.)

Note also that the dependencies/capabilities for a given package often varies between different rhel versions.

Pre-computing (predictive) vs just-in-time
------------------------------------------

Two different approaches to determining dependency order for building are:

- pre compute all dependencies based on an existing series/rhel version, OR
- compute which remaining packages have all build reqs satisfied now

The first approach has the benefit of being able to determine the packages that need to be built in order to accomplish a smaller subset goal first -- for example, to be able to install osg-wn-client. (And, if there are problems with resolving certain dependencies (say with osg-wn-client again), it will become apparent earlier, as opposed to not until all possible-to-build packages have been built.) The limitation of this approach is that the predicted set of files/capabilities that a binary package will provide may differ between osg series/rhel versions, and as a result may be inaccurate for the new build target.

The second approach provides somewhat more confidence about being able to correctly determine which packages should be buildable at any point in time, but (as mentioned above) it is a bit more in the dark about seeing the bigger picture of the dependency graph or being able to build subsets of targets.

It may be useful to have both options available -- building from the list in the second approach, but using the first mechanism to have a better picture of where things are at, or perhaps to steer toward finishing a certain subset of packages first.

Package list closure, pruning
-----------------------------

At some point (either in the planning stage or after building packages into the new build target), we need to ensure that the new osg series/rhel version contains all of its install requirements for all of its packages. It would probably suffice to do a VMU run that installs each package (perhaps individually, to avoid conflicts).

But if we go about it more analytically, we may also get, as a result, a list of packages which we previously only maintained for the purpose of building our other packages (ie, that were never required at runtime for any use cases that we cared about), which now, in the new target, are no longer build requirements (directly or indirectly) for any packages that we care about installing. Packages in this category could be reviewed to also be dropped from the new build target.

Proposal / Recommendations
--------------------------

As mentioned earlier, my recommendation is that we treat a new OSG series differently than a new RHEL version.

### For a new OSG series:

- update native/redhat packaging area to reflect packages for new series, including upcoming + trunk - removed packages

- tag existing builds of packages in new list into the new development tag (eg, for osg-3.3-el6, tag the .osgup.el6 and .osg32.el6 builds into osg-3.3-el6-development)

- build all packages in new packaging area into new build target at once

- for all successful builds, remove corresponding old builds (eg, .osgup/.osg32) from the new tag (osg-3.3-el6-development)

### For a new RHEL version:

- pull the repodata from the relevant `*-build` repo from koji:

for pre-computing, use a build repo from an existing rhel version:  
https://koji.chtc.wisc.edu/mnt/koji/repos/osg-3.2-el6-build/latest/x86_64/repodata/

for just-in-time, use the new build repo:  
https://koji.chtc.wisc.edu/mnt/koji/repos/osg-3.2-el8-build/latest/x86_64/repodata/

the primary and filelists (sqlite) files can be used to get runtime requires and provides. (Note that this includes packages from the relevant external repos, also.)

- generate srpms repodata for the current set of packages to build, with osg-build prebuild and createrepo.

the primary (sqlite) file can be used to get build-requires.

- use sql to resolve direct dependencies at the package name level:
    - src-pkg: bin-pkg (BuildRequires)
    - bin-pkg: bin-pkg (Requires)
    - bin-pkg: src-pkg (bin-pkg comes from which src-pkg? only needed for pre-computing dependencies)
- resolve this list into a full list of recursive build dependencies.

Since this is recursive, there is no way to do it in a fixed number of sql queries. However the above input list is already directly consumable by Make, which is designed to handle recursive dependencies just like this. Or we can write a new tool to do it in python.

- build ready-to-be-built packages
- update our copy of the repodata from the regen'ed `*-build` repo, as often as new versions become available
- update our dependency lists
- repeat until all packages are built


