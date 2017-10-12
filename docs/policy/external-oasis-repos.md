
Policy for OSG Mirroring of External CVMFS repositories
=====================================================

This document provides an overview of the policies and security understanding with regards to OSG mirroring of CVMFS
repositories of external organizations.  This is not a service-level agreement but rather a statement of responsibilities.

!!! note:
    To actually understand the technical procedure for mirroring a repository, [see the following page](https://twiki.grid.iu.edu/bin/view/Documentation/Release3/OasisExternalRepositories).  This document solely covers the policy aspects.

Introduction
------------

The OSG provides a network of CVMFS Stratum-1 servers for mirroring content of externally-managed repositories.  These repositories are often
hosted by large HEP or physics VOs for the purpose of distributing software for high-throughput computing jobs.  Additionally, OSG provides a
repository (<oasis.opensciencegrid.org>) for smaller VOs; this is not covered here.

OSG will include additional repositories into the content distribution network (CDN) at the request of an OSG-affiliated VO.  These repositories
are meant to help the OSG-affiliated VO accomplish their domain science.

The goal of this mirroring provides an improved quality-of-service for the VO end-users running at OSG sites.  OSG does not provide support
for use of the software in external repositories, but will help end-users contact the VO for help as necessary.

OSG Responsibilities
---------------------

* OSG will provide the Stratum-1 server network according to [the OASIS SLA](https://opensciencegrid.github.io/operations/SLA/oasis-replica/)
* OSG will provide a best-effort mirror of the full contents of the external repo.  We will attempt to provide best-effort integrity of the
  object contents, but assume users of the Stratum-1 will do further integrity checking.  No SLA is provided covering potential data corruptions.
* OSG will provide best-effort notification to the mirrored repository in case OSG detects a service outage of the external repo.
* In the event of a reported security incident, OSG will replace the repository contents with an empty directory, signed by an OSG-managed key.
* Once the external repository is approved, OSG will distribute the corresponding repository signing keys in a valid whitelist.  The whitelist
  will be signed by the OSG Stratum-0.  This whitelist attests to the authenticity of the key, but not a statement about repository contents.

VO Responsibilities
-------------------
* The requesting VO should only include targeted repositories they need to support their science.
* The VO should understand that in the event of a reported security incident, the contents of this repository may be replaced with an
  empty directory and signed by the OSG repository key.  This will be done after attempting to contact the VO first; the amount of time OSG
  will wait on an unresponsive VO will be based on the evaluation of the situation of the OSG Security officer. 
* The VO is ultimately responsible for the contents of the repository.  OSG provides a mirror.
* If the external repository is *not* operated by the VO, OSG may work directly with the external repository maintainers.  This is done for
  ease of operations and may be limited to day-to-day, non-security-related support.

