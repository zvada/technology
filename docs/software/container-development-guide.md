Container Development Guide
===========================

Creating a New Container Image
------------------------------

1. Create a Git repository whose name is prefixed with `docker-`, e.g. `docker-frontier-squid`
1. Create a `README.md` file describing the software provided by the image
1. Create a `LICENSE` file containing the [Apache 2.0 license text](https://www.apache.org/licenses/LICENSE-2.0.txt)
1. Create a `Dockerfile` based off of the OSG Software Base image:

        FROM opensciencegrid/software-base:fresh

        LABEL maintainer OSG Software <help@opensciencegrid.org>
        
        RUN \
            yum update -y && yum clean all && rm -rf /var/cache/yum/*

        RUN yum install -y <PACKAGE> --enablerepo=osg-development && yum clean all && rm -rf /var/cache/yum/*


    Replacing `<PACKAGE>` with the name of the RPM you'd like to provide in this container image

Pushing Images to DockerHub
---------------------------

### Using Travis-CI ###

1. Create a Docker Hub repo in the OSG organization.
1. Go to the permissions tab and give the `robots` team `Read & Write` access
1. Copy over `.travis.yml` and `travis/` from a previous docker build (e.g., <https://github.com/opensciencegrid/docker-frontier-squid>).
   Update the `docker_repos` in `build_docker.sh` to the name of the Docker Hub repo
1. Send the `opensciencegrid` GitHub repoository URL to the Software Manager and ask them to do the following:
    1. Enable the repository in Travis-CI
    1. Add the OSG Software Docker Hub account credentials to the Travis CI repository as secure variables
       `DOCKER_USERNAME` and `DOCKER_PASSWORD`.
       Ensure that `Display value in build log` remains unset.
       Escape any special characters with `\`.
    1. Enable weekly cron builds from `master` and set `Always run`

### Built-in integration ###

Managing Tags in DockerHub
--------------------------

### Adding tags ###

Images that have passed acceptance testing should be tagged as `stable`:

1. Install the `jq` utility:

        yum install jq
        
1. Get the SHA256 repo digest of the image that the user has tested
1. Go to the Docker Hub repo (e.g., <https://hub.docker.com/r/opensciencegrid/frontier-squid/tags>) and find the
   `<TIMESTAMP TAG>` (e.g., `20191118-1706`) corresponding to the digest in the previous step
1. Add your Docker Hub user/pass to a file with `600` permissions:

        export user=<dockerhub username>
        export pass=<dockerhub password>

1. Run the Docker container image tagging command:

        ./dockerhub-tag-fresh-to-stable.sh <IMAGE NAME> <TIMESTAMP TAG>

1. Clean up your Docker Hub user/pass file

### Removing tags ###

Via the web interface, requires write permissions

Making Slim Containers
----------------------

Here are some resources for creating slim, efficient containers:

- <https://github.com/opensciencegrid/topology/pull/399>
- <https://docs.docker.com/develop/develop-images/multistage-build/>
- <https://medium.com/travis-on-docker/multi-stage-docker-builds-for-creating-tiny-go-images-e0e1867efe5a>
- <https://medium.com/travis-on-docker/triple-stage-docker-builds-with-go-and-angular-1b7d2006cb88>
