OSG Support of the Globus Toolkit
=================================

!!! note "Gridftp and GSI Migration Plan"
    In December 2019, the OSG developed a plan for migrating the OSG Software stack away from GridFTP and GSI that can
    be found [here](gridftp-gsi-migration.md).

6 June 2017

Many in the OSG community have heard the news about the end of support for the open-source Globus Toolkit (formerly
available from https://github.com/globus/globus-toolkit/blob/globus_6_branch/support-changes).

What does this imply for the OSG Software stack?
Not much: OSG support for the Globus Toolkit (e.g., GridFTP and GSI) will continue for as long as stakeholders need it.
Period.

Note the OSG Software team provides a support guarantee for all the software in its stack.
When a software component reaches end-of-life, the OSG assists its stakeholders in managing the transition to new
software to replace or extend those capabilities.
This assistance comes in many forms, such as finding an equivalent replacement, adapting code to avoid the dependency,
or helping research and develop a transition to new technology.
During such transition periods, OSG takes on traditional maintenance duties (i.e., patching, bug fixes and support) of
the end-of-life software.
The OSG is committed to keep the software secure until its stakeholders have successfully transitioned to new software. 

This model has been successfully demonstrated throughout the lifetime of OSG, including for example the five year
transition period for the BestMan storage resource manager.
The Globus Toolkit will not be an exception.  Indeed, OSG has accumulated more than a decade of experience with this
software and has often provided patches back to Globus.

Over the next weeks and months, we will be in contact with our stakeholder VOs, sites, and software providers to discuss
their requirements and timelines with regard to GridFTP and GSI.

Please reach out to [goc@opensciencegrid.org](mailto:goc@opensciencegrid.org) with your questions, comments, and
concerns.

Change Log
----------

**8 October 2020** Add note linking to the GridFTP and GSI migration plan
