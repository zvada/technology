Container Release Policy
========================

12 March 2019

Container images are an increasingly popular tool for shortening the software development lifecycle, allowing for speedy
deployment of new software versions or additional instances of a service.
Select services in the OSG Software Stack will be distrbuted as container images to support VOs and sites that are
interested in this model.

This document contains policy information for container images distributed by the OSG Software Team.

Contents and Sources
--------------------

Similar to our existing RPM infrastructure, container image sources, build logs, and artifacts will be stored in
publicly available repositories (e.g. GitHub, DockerHub) for collaboration and traceability.
Additionally, container images distributed by the OSG Software team will be based off of the latest version of a 
[supported platform](https://opensciencegrid.org/docs/release/supported_platforms/) with software installed from OS,
EPEL, and [OSG release](/docs/policy/software-release.md#yum-repositories) Yum repositories with select packages
installed from `osg-development`.

Tags
----

OSG Software container images will be automatically tagged with the timestamp of their build to provide rollback options
in case of issues.
Additionally, container images may have the following tags describing their suitability for production:

| Tag Name | Description                                                                 |
|----------|-----------------------------------------------------------------------------|
| `fast`   | Images that build successfully and pass automated tests                     |
| `slow`   | `fast` images that pass acceptance testing; approved by the Release Manager |


### Cleanup  ###

Weekly timestamped image tags will be kept for three months.
After three months, monthly timestamped image tags will be kept up to one year.

Announcements
-------------

Container images that have been tagged as **slow** will be noted in the OSG release notes and announcements.
