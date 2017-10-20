OSG Software Flexible Release Model
===================================

Introduction
------------

Before November 2017, the OSG software stack was released on the second Tuesday of each month, except in the case of urgent releases, which were infrequent. This schedule had been in place since early 2013. Since then, conditions within and outside of the Software team have changed, and we have adjusted the release schedule and associated processes.

The previous release model had the recurring problem of a "release crunch," where it was difficult to find the effort required to test large changes before their deadline had passed. Sometimes the lack of timely effort led to software being pushed to the next release (a month later), because there was insufficient testing time.

Based on software support tickets, we noticed that many sites follow a local update schedule that is independent of the OSG Release team schedule; some sites upgrade every few months, skipping interim releases, other sites upgrade individual packages as needed. In addition, upstream software developers do not follow our release schedule either, releasing software on their own development timelines. As a result, some site administrators would prefer to have OSG software updates more often, closer to when they become available, rather than tied to a monthly cycle.

For these reasons, we created a new release model.

Release Model
-------------

The OSG Release team will release batches of integrated, tested software on an ad hoc basis, with the process outlined below (changes from the old process are highlighted):

1.  Software and Release Team members develop packages and mark them for testing

2.  Software and Release Team members test the packages, possibly with help from the community

3.  Once adequate testing is complete and successful, the Release Manager approves packages for release

4.  **Weekly, the Release Manager evaluates packages that are ready for release; when a sufficient number of important packages are ready**[1]**, the Release Manager schedules a release date and announces it. For urgent changes, the Release Manager evaluates the packages as soon as they are tested**

5.  The Software and Release Team perform pre-release testing, release the packages, and announce the release

Note: The release dates of parallel release series (e.g., 3.3 and 3.4) will not have to coincide, as they have in the past.

[1] The threshold for “sufficient number of important packages” will be determined by the Release Manager, with input from the other Technology Area leaders.
