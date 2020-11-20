The OSG and NSF Campus Cyberinfrastructure
==========================================

The NSF Campus Cyberinfrastructure (CC\*) program invests in coordinated campus-level networking and cyberinfrastructure
improvements, innovation, integration, and engineering for science applications and distributed research projects.

In the most recent call for proposals ([NSF 21-528](https://www.nsf.gov/pubs/2021/nsf21528/nsf21528.htm)), joining the
[Open Science Grid](https://www.opensciencegrid.org) (OSG) is mentioned as a potential path to sharing resources with
the wider research community:

> Proposals are required to commit to a minimum of 20% shared time on the cluster and describe their approach to making 
> the cluster available as a shared resource external to the campus, [...]
> **One possible approach to implementing such a federated distributed computing solution is joining a multi-campus or 
> national federated system such as the Open Science Grid.**

Contributing to the OSG
-----------------------

The OSG consortium provides standard services and support for computational resource providers (i.e., "sites") using a
[distributed fabric](https://map.opensciencegrid.org) of high throughput computating (HTC) technologies.
These distributed-HTC (dHTC) services communicate with the site's local resource management (e.g. "queueing") systems to provision
resources for OSG users.
The OSG itself does not own resources, but provides software and services that enable the sharing of resources by many sites, 
and enable users to take advantage of these from submission points (whether via an OSG-0perated submission point, like 
[OSG Connect](https://www.osgconnect.net/), or via a 'local' one).

To contribute computational resources to the OSG, the following will be needed:

- An existing compute cluster running on a [supported operating system](https://opensciencegrid.org/docs/release/supported_platforms/)
  with a supported resource management system:
  [Grid Engine](http://www.univa.com/products/),
  [HTCondor](https://research.cs.wisc.edu/htcondor/),
  [LSF](https://www.ibm.com/us-en/marketplace/hpc-workload-management),
  [PBS Pro](https://www.pbsworks.com/PBSProduct.aspx?n=Altair-PBS-Professional&c=Overview-and-Capabilities)/[Torque](https://adaptivecomputing.com/cherry-services/torque-resource-manager/),
  or [Slurm](https://slurm.schedmd.com/).
- Outbound network connectivity from the cluster's worker nodes
- [Temporary scratch space](https://opensciencegrid.org/docs/worker-node/using-wn/#the-worker-node-environment) on each
  worker node
- SSH access to your local cluster's submit node from a known IP address
- Shared home directories on each cluster node
- Installation of some additional packages on the local cluster, IF the site would like to maximize it's ability to support
  users, including those with large per-job data, containerized software, and/or GPU jobs.

!!!success "Next steps"
    If you are interested in OSG-offered services, please [contact us](mailto:support@opensciencegrid.org) for a
    consultation, even if your site does not meet all the conditions as outlined above!

Additional Materials
--------------------

If you are interested in learning more about the OSG and what it means to share resources via the OSG services, consider
reviewing the following presentations from our [October 2020 workshop on dHTC and OSG services for campuses](https://indico.fnal.gov/event/45998/timetable/#20201022) ([YouTube Playlist](https://www.youtube.com/playlist?list=PLBWb4iScSWcPGfjvJztz_IeHCKS7f3u1k)):

- Intro to dHTC and PATh Services for Campuses ([slides](https://indico.fnal.gov/event/45998/contributions/199894/attachments/136489/169747/20201022OSGCampusWorkshop_dHTCServiceOverview_LMichael.pdf),[YouTube](https://www.youtube.com/watch?v=hYc6RaWL33g&list=PLBWb4iScSWcPGfjvJztz_IeHCKS7f3u1k&index=2&t=5s))
- How OSG Works ([slides](https://indico.fnal.gov/event/45998/contributions/199896/attachments/136496/169757/ccstarOctober2020-whatisosg.pdf), [YouTube](https://www.youtube.com/watch?v=kwIs7oa56t8&list=PLBWb4iScSWcPGfjvJztz_IeHCKS7f3u1k&index=4)
- Intro to OSG Resource Sharing ([slides](https://indico.fnal.gov/event/45998/contributions/199898/attachments/136497/169758/ccstarOctober2020-resourcesharing.pdf), [YouTube](https://www.youtube.com/watch?v=GuR8gxrVRew&list=PLBWb4iScSWcPGfjvJztz_IeHCKS7f3u1k&index=5))
- Resource Sharing Technology, Security, System Requirements, Setup Process ([slides](https://indico.fnal.gov/event/45998/contributions/199903/attachments/136555/169835/OSG-Sharing-Resources-CCStar-2020.pdf), [YouTube](https://www.youtube.com/watch?v=t5YtIIs7bqg&list=PLBWb4iScSWcPGfjvJztz_IeHCKS7f3u1k&index=7))
