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
EPEL, and [osg-development](/policy/software-releases#yum-repositories) Yum repositories.

Tags
----

OSG Software container images will be automatically tagged with the timestamp of their build.
Additionally, container images will have the following tags describing their suitability for production:

| Tag Name      | Description                                                                          |
|---------------|--------------------------------------------------------------------------------------|
| `development` | Images that build successfully and pass automated tests                              |
| `testing`     | Images that pass acceptance testing by trusted operators                             |
| `stable`      | Images that have show promise in initial production, approved by the Release Manager |

The progression of an image build through the above tags is reflected below:

    timestamp/development -> testing -> stable

### Cleanup  ###

Previous timestamp tags will be removed after new builds are created for a new
[OSG release series](/policy/release-series).

Announcements
-------------

Container images that have been tagged as **stable** will be noted in the OSG release notes and announcements.
