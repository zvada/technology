The OSG and NSF Campus Cyberinfrastructure
==========================================

The NSF Campus Cyberinfrastructure (CC\*) program invests in coordinated campus-level networking and cyberinfrastructure
improvements, innovation, integration, and engineering for science applications and distributed research projects.

In the most recent call for proposals ([NSF 20-507](https://www.nsf.gov/pubs/2020/nsf20507/nsf20507.htm)), joining the
[Open Science Grid](https://www.opensciencegrid.org) (OSG) is mentioned as a potential path to sharing resources with
the wider research community:

> Proposals should commit to a minimum of 20% shared time on the cluster and describe their approach to making the
> cluster available as a shared resource external to the campus. [...]
> **One possible approach to implementing such a federated distributed computing solution is joining the Open Science
> Grid.**

Contributing to the OSG
-----------------------

The OSG provides common services and support for computational resource providers (i.e., "sites") using a
[distributed fabric](https://map.opensciencegrid.org) of high throughput computational (HTC) services.
These HTC services communicate with a site's resource management systems at a site to provision resources for OSG users.
The OSG itself does not own resources but provides software and services to users and resource providers alike to enable
the opportunistic usage and sharing of resources.

To contribute computational resources to the OSG, the following will be needed:

- An existing compute cluster running on a [supported operating system](https://opensciencegrid.org/docs/release/supported_platforms/)
  with a supported resource management system:
  [Grid Engine](http://www.univa.com/products/),
  [HTCondor](https://research.cs.wisc.edu/htcondor/),
  [LSF](https://www.ibm.com/us-en/marketplace/hpc-workload-management),
  [PBS Pro](https://www.pbsworks.com/PBSProduct.aspx?n=Altair-PBS-Professional&c=Overview-and-Capabilities)/[Torque](http://www.adaptivecomputing.com/products/torque/),
  or [Slurm](https://slurm.schedmd.com/).
- Outbound network connectivity from your cluster's worker nodes
- [Temporary scratch space](https://opensciencegrid.org/docs/worker-node/using-wn/#the-worker-node-environment) on each
  worker node
- Allow SSH access to your local cluster's submit node from a known IP address
- Shared home directories on each cluster node

!!!success "Next steps"
    If you are interested in OSG-hosted services, please [contact us](mailto:help@opensciencegrid.org) for a
    consultation, even if your site does not meet the conditions as outlined above!

Additional Materials
--------------------

If you are interested in learning more about the OSG and what it means to contribute or use resources, consider
reviewing the following slides that were presented to the 2019 CC\* awardees:

- [Introduction to OSG and OSG Participants](https://drive.google.com/file/d/12SvIOxXjlo4f2oJx9V9Oqbbu-oGXuJfa/view?usp=sharing)
- [How Resources are Shared and Used via OSG](https://drive.google.com/open?id=1_1N2LrsJr8A8wICk3FMVimOdUPbHhXLz)
- [Hosted CE options/process and implementation](https://docs.google.com/presentation/d/1YPdkslUT0r50W5dYqUm4Wlhv_nhhxIEhINhOwdSol1I/edit?usp=sharing)
- [Using and Facilitating the Use of OSG Resources](https://drive.google.com/file/d/19AatZvqa_gss-lPtagK3lqSA85GrqFMJ/view?usp=sharing)
