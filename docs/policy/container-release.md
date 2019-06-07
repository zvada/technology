Container Release Policy
========================

17 April 2019

Container images are an increasingly popular tool for shortening the software development life cycle, allowing for speedy
deployment of new software versions or additional instances of a service.
Select services in the OSG Software Stack will be distributed as container images to support VOs and sites that are
interested in this model.

This document contains policy information for container images distributed by the OSG Software Team.

Contents and Sources
--------------------

Similar to our existing RPM infrastructure, container image sources, build logs, and artifacts will be stored in
publicly available repositories (e.g. GitHub, Docker Hub) for collaboration and traceability.
Additionally, container images distributed by the OSG Software team will be based off of the latest version of a 
[supported platform](https://opensciencegrid.org/docs/release/supported_platforms/) with software installed from OS,
EPEL, and [OSG release](/policy/software-release.md#yum-repositories) Yum repositories with select packages
installed from `osg-development`.

Tags
----

OSG Software container images will be tagged with at least one of the following tags:

| Tag       | Description                                                                                                                                                       |
|-----------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `fresh`   | Images that build successfully and pass automated tests. Intended for users that need the latest fixes and features.                                              |
| timestamp | Each `fresh` image  is also tagged with a timestamp reflecting their build date and time. Intended for rollback in case of issues with the current `fresh` image. |
| `stable`  | `fresh` images that pass acceptance testing; approved by the Release Manager. Intended for stable production use.                                                 |

### Cleanup  ###

Images with only a timestamp tag will be untagged according to the following policy:

- Weekly timestamped image tags will be kept for at least three months
- After three months, monthly timestamped image tags will be kept for at least one year

Announcements
-------------

Container images that have been tagged as **stable** will be noted in the OSG release notes and announcements.
