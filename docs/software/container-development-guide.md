Container Development Guide
===========================

1. `osgsoftware` DockerHub user account/password needs to be added to encrypted Travis variables

Creating a New Container Image
------------------------------



1. Create a Git repository whose name is prefixed with `docker-`, e.g. `docker-frontier-squid`
1. Create a `README.md` file describing the software provided by the image
1. Create a `LICENSE` file containing the [Apache 2.0 license text](https://www.apache.org/licenses/LICENSE-2.0.txt)
1. Create a `Dockerfile` based off of the OSG Software Base image:

        FROM opensciencegrid/software-base:fresh

        LABEL maintainer OSG Software <help@opensciencegrid.org>
        
        RUN yum clean all && \
            yum update -y 

        RUN yum install -y <PACKAGE> --enablerepo=osg-development

        RUN yum clean all --enablerepo=* && rm -rf /var/cache/yum/

    Replacing `<PACKAGE>` with the name of the RPM you'd like to provide in this container image

Pushing Images to DockerHub
---------------------------

### Using Travis-CI ###

1. Create a Docker Hub repo in the OSG organization.
   Give the OSG Software Docker Hub account write access.
1. Copy over `.travis.yml` and `travis/` from a previous docker build.
   Update the `docker_repos` in `build_docker.sh` to the name of the Docker Hub repo
1. Add the OSG Software Docker Hub account credentials to the Travis CI repository as secure variables `DOCKER_USERNAME` and `DOCKER_PASSWORD`.
   Ensure that `Display value in build log` remains unset. Escape any special characters with `\`.
1. Enable weekly cron builds from `master` and set `Do not run if there has been a build in the last 24h`

### Built-in integration ###

Managing Tags in DockerHub
--------------------------

### Adding tags ###

https://dille.name/blog/2018/09/20/how-to-tag-docker-images-without-pulling-them/

For images that already exist in DockerHub

1. `docker logout`
1.  Pull the docker image and tag it:
    - If you know the tag name:
        1. `docker pull opensciencegrid/<IMAGE NAME>:<TAG>`
        1. `docker tag opensciencegrid/<IMAGE NAME>:<TAG> opensciencegrid/<IMAGE NAME>:stable`
    - If you only know the digest:
        1. `docker pull opensciencegrid/<IMAGE NAME>@sha256:<IMAGE DIGEST>`
        1. Get the image ID: `docker images opensciencegrid/<IMAGE _NAME>`
        1. `docker tag <IMAGE ID> opensciencegrid/<IMAGE NAME>:stable`
1. `docker login`
1. `docker push opensciencegrid/<IMAGE NAME>:<TAG>`

### Removing tags ###

Via the web interface, requires write permissions

Making Slim Containers
----------------------

Here are some resources for creating slim, efficient containers:

- <https://github.com/opensciencegrid/topology/pull/399>
- <https://docs.docker.com/develop/develop-images/multistage-build/>
- <https://medium.com/travis-on-docker/multi-stage-docker-builds-for-creating-tiny-go-images-e0e1867efe5a>
- <https://medium.com/travis-on-docker/triple-stage-docker-builds-with-go-and-angular-1b7d2006cb88>
