# Testing HTCondor Prereleases on the Madison ITB Site

This document contains a basic recipe for testing an HTCondor prerelease build on the Madison ITB site.

## Prerequisites

The following items are known prerequisites to using this recipe.  If you are not running the Ansible commands from
osghost, there are almost certainly other prerequisites that are not listed below.  And even using osghost for Ansible
and itb-submit for the submissions, there may be other prerequisites missing.  Please improve this document by adding
other prerequisites as they are identified!

* A checkout of the osgitb directory from our local git instance (not GitHub)
* Your X.509 DN in the `osgitb/unmanaged/htcondor/condor_mapfile` file and (via Ansible) on `itb-ce1` and `itb-ce2`

## Gather Information

Technically skippable, this section is about checking on the state of the ITB machines before making changes.  The plan
is to keep the ITB machines generally up-to-date independently, so those steps are not listed here.  And honestly, the
steps below are just some ideas; do whatever makes sense for the given update.

The commands can be run as-is from within the `osgitb` directory from git.

1. Check OS versions for all current ITB hosts:

        :::console
        ansible current -i inventory -f 20 -o -m command -a 'cat /etc/redhat-release'

2. Check HTCondor versions for all HTCondor hosts:

        :::console
        ansible condor -i inventory -f 20 -o -m command -a 'rpm -q condor'

3. Obtain the NVR of the HTCondor prerelease build from OSG to test.  Do this by talking to Tim&nbsp;T. and checking
   Koji.  The expectation is that the HTCondor prerelease build will be in the development repository (or
   upcoming-development).

## Install HTCondor Prerelease

1. Shut down HTCondor and HTCondor-CE on prerelease machines:

        :::console
        ansible condordev -i inventory -bK -f 20 -m service -a 'name=condor-ce state=stopped' -l 'itb-ce*'
        ansible condordev -i inventory -bK -f 20 -m service -a 'name=condor state=stopped'

2. Install new version of HTCondor on prerelease machines:

        :::console
        ansible condordev -i inventory -bK -f 10 -m command -a 'yum --enablerepo=osg-development --assumeyes update condor'

    or, if you need to install an NVR that is “earlier” (in the RPM sense) than what is currently installed:

        :::console
        ansible condordev -i inventory -bK -f 10 -m command -a 'yum --enablerepo=osg-development --assumeyes downgrade condor condor-classads condor-python condor-procd blahp'

3. Verify installation of correct RPM version:

        :::console
        ansible condor -i inventory -f 20 -o -m command -a 'rpm -q condor'

4. Restart HTCondor and HTCondor-CE on prerelease machines:

        :::console
        ansible condordev -i inventory -bK -f 20 -m service -a 'name=condor state=started'
        ansible condordev -i inventory -bK -f 20 -m service -a 'name=condor-ce state=started' -l 'itb-ce*'

## Run Tests

For the first two test workflows, use your personal space on `itb-submit`.  Copy or checkout the `osgitb/htcondor-tests`
directory to get the test directories.

### Submitting jobs directly

1. Change into the `1-direct-jobs` subdirectory

2. If there are old result files in the directory, remove them:

        :::console
        make distclean

3. Submit the test workflow

        :::console
        condor_submit_dag test.dag

4. Monitor the jobs until they are complete or stuck

    In the initial test runs, the entire workflow ran in a few minutes.  If the DAG or jobs exit immediately, go on
    hold, or otherwise fail, then you have some troubleshooting to do!  Keep trying steps 2 and 3 until you get a clean
    run (or one or more HTCondor bug tickets).

5. Check the final output file:

        :::console
        cat count-by-hostnames.txt

    You should see a reasonable distribution of jobs by hostname, keeping in mind the different number of cores per
    machine and the fact that HTCondor can and will reuse claims to process many jobs on a single host.  Especially
    watch out for a case in which no jobs run on the newly updated hosts (at the time of writing: `itb-data[456]`).

6. (Optional) Clean up, using the `make clean` or `make distclean` commands.

### Submitting jobs using HTCondor-C

If direct submissions fail, there is probably no point to doing this step.

1. Change into the `2-htcondor-c-jobs` subdirectory

1. If there are old result files in the directory, remove them:

        :::console
        make distclean

1. Get a proxy for your X.509 credentials

        :::console
        voms-proxy-init

1. Submit the test workflow

        :::console
        condor_submit_dag test.dag

1. Monitor the jobs until they are complete or stuck

    In the initial test runs, the entire workflow ran in 10 minutes or less; generally, this test takes longer than the
    direct submission test, because of the layers of indirection.  Also, status updates from the CEs back to the submit
    host are infrequent.  For direct information about the CEs, log in to `itb-ce1` and `itb-ce2` to check status; don’t
    forget to check both `condor_ce_q` and `condor_q` on the CEs, probably in that order.

    If the DAG or jobs exit immediately, go on hold, or otherwise fail, then you have some troubleshooting to do!  Keep
    trying steps 2 and 3 until you get a clean run (or one or more HTCondor bug tickets).

1. Check the final output file:

        :::console
        cat count-by-hostnames.txt

    Again, look for a reasonable distribution of jobs by hostname.

1. (Optional) Clean up, using the `make clean` or `make distclean` commands.

### Submitting jobs from a GlideinWMS VO Frontend

For this workflow, use your personal space on `glidein3.chtc.wisc.edu`.  Copy or checkout the `osgitb/htcondor-tests`
directory to get the test directories.  Again, if previous steps fail, do not bother with this step.

1. Change into the `3-frontend-jobs` subdirectory

1. If there are old result files in the directory, remove them:

        :::console
        make distclean

1. Submit the test workflow

        :::console
        condor_submit_dag test.dag

1. Monitor the jobs until they are complete or stuck

    This workflow could take much longer than the first two, maybe an hour or so.  Also, unless there are active
    glideins, it will take 10 minutes or longer for the first glideins to appear and start matching jobs.  Thus it is
    helpful to monitor `condor_q -totals` until all of the jobs are submitted (there should be 2001), then switch to
    monitoring `condor_status` until glideins start appearing.  After the first jobs start running and finishing, it is
    probably safe to ignore the rest of the run.  If the jobs do not appear in the local queue, if glideins do not
    appear, or if jobs do not start running on the glideins, it is time to start troubleshooting.

1. Check the final output file:

        :::console
        cat count-by-hostnames.txt

    The distribution of jobs per execute node may be more skewed than in the first two workflows, due to the way in
    which pilots ramp up over time and how HTCondor allocates jobs to slots.

1. (Optional) Clean up, using the `make clean` or `make distclean` commands.
