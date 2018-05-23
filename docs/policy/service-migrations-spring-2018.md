Service Migrations - Spring 2018
================================

The Open Science Grid (OSG) is transitioning effort from Indiana, requiring a redistribution of support and services.
Some services will be retired, most services will be migrated to other locations (with minimal expected sites impact),
and some services will be migrated that will result in significant impact on sites.

This document is intended to guide OSG site administrators through these changes, highlighting where the site administrator
action is required.

!!! note
    Specific service migrations will be announced prior to retirement or migration.

We understand sites will have many questions regarding this transition.
The OSG Technology team will be holding office hours for any questions or comments about these service 
changes; see the [Office Hours section](#office-hours) for details.

Site Checklist Summary
----------------------

The remainder of the document provides a service-by-service overview of site impacts.  In this section, we
provide a short outline of the steps sites are recommended to take:

1. Review all site configuration (yum repositories, CVMFS configurations) to ensure they are the latest from the
   OSG.  In particular, replace all references to `grid.iu.edu` with equivalent `opensciencegrid.org` entries.
1. Renew all local host certificates within the OSG CA prior to May 1.  A list of affected hosts at your sites
   can be provided by OSG support upon request.
1. LHC sites should verify local admins have a GGUS accounts and are familiar with its web interface.
1. Sites at institutions with an [InCommon CA subscription](https://incommon.org/certificates/subscribers.html)
   should determine their local procedure for obtaining certificates.
1. Sites should transition to the
   [LCMAPS VOMS authentication method](http://opensciencegrid.github.io/docs/security/lcmaps-voms-authentication/)
   if they have not done so already.

Office Hours
------------

!!! note
    Office hours are canceled on 2018-05-22 and 2018-05-24 due to [HTCondor week](https://agenda.hep.wisc.edu/event/1201/).
    We will resume office hours on 2018-05-29.

If you have questions or concerns that are not addressed in this document, please join us for our office hours!

**Where:**

* <https://unl.zoom.us/j/277958559>
* Or Telephone: US: +1 408 638 0968  or +1 646 876 9923  or +1 669 900 6833
  Meeting ID: 277 958 559

**When:**

* Tuesdays, 2-3 PM CDT
* Thursdays, 10-11 AM CDT

We can also be contacted at the usual locations:

-  [help@opensciencegrid.org](mailto:help@opensciencegrid.org)
-  [osg-software@opensciencegrid.org](mailto:osg-software@opensciencegrid.org) - General discussion amongst team members
-  [Slack channel](https://opensciencegrid.slack.com/messages/osg-software) - if you can't create an account, 
   send an e-mail to [osg-software@opensciencegrid.org](mailto:osg-software@opensciencegrid.org)

Service-specific details
------------------------

### OSG CA ###

!!! note
    Retirement of the OSG CA service is planned for May 31, 2018 11:59PM EDT.

The OSG CA service offers certificate request, renewal, and revocation through the [OIM](#myosg-and-oim) web interface, 
the OIM REST API, and the `osg-pki-tools` command-line tool.
This service will be retired by May 31 but the OSG CA certificate will remain in the IGTF distribution, so
your certificates remain valid until they expire.
Therefore, to extend the window for transitioning to any new CA service, we have the following recommendations:

!!! info "Action item(s)"
    1. Request fresh certificates for each publicly facing host and service at your site, such as:

        * HTCondor-CE
        * GlideinWMS VO Frontend: frontend, proxy, and VOMS certificates
        * GlideinWMS Factory
        * GridFTP
        * XRootD
        * RSV
        * GUMS
        * BeStMan
        * VOMS Admin Server

    1. Renew your [user certificate](https://oim.opensciencegrid.org/oim/certificateuser).  LHC sites should take the
       opportunity to switch users to the CERN CA.

In the future, we will use the following CA certificate services:

| For...                        | We plan to use the following Certificate Authorities...                             |
|-------------------------------|-------------------------------------------------------------------------------------|
| Host and Service Certificates | [InCommon](https://www.incommon.org/) and [Let’s Encrypt](https://letsencrypt.org/) |
| User Certificates             | [CILogon Basic](https://cilogon.org/) for non-LHC users                             |
|                               | LHC users should continue to request their user certificates from CERN.             |
| Web-Based services            | [Let's Encrypt](https://letsencrypt.org)                                            |

!!! note
    The semantics of Let's Encrypt certificates are different from those of previous CAs.
    Please see
    [the security team's position on Let's Encrypt](https://opensciencegrid.github.io/security/LetsEncryptOSGCAbundle/)
    for the security and setup implications of switching to a Let's Encrypt host or service certificate.

New processes for requesting host, service, and user certificates against the aforementioned CAs are forthcoming.

If you experience any problems with the OSG CA service, please contact us at
[help@opensciencegrid.org](mailto:help@opensciencegrid.org).


### Software Repository ###

!!! note
    Migration of the software repository occurred on May 1, 2018.
    Retirement of the old host, `repo.grid.iu.edu`, occurred on May 23, 2018 10AM EDT.

The OSG Software repository includes the YUM repositories, client tarballs, and CA tarballs.
The physical hosting location of this service will be changing; no other changes are planned.
To ensure a smooth transition at your site, verify that the OSG repository files are up to date on all of your OSG hosts:

!!! info "Action item"
    - If your OSG repository files have been installed via RPM, verify that the version of `osg-release` is at least 
      `3.3-6` or `3.4-4`, for OSG 3.3 and 3.4, respectively:

            :::console
            user@host $ rpm -q osg-release

        If the version is older, update your `osg-release` RPM:

            :::console
            root@host # yum update osg-release

    - If your OSG repository files have not been installed via RPM, ensure that there are no references to `grid.iu.edu`:

            :::console
            user@host $ grep grid.iu.edu /etc/yum.repos.d/osg*.repo

        Replace all instances of `grid.iu.edu` with `opensciencegrid.org`.

If you experience any problems with the OSG Software repository, please contact us at
[help@opensciencegrid.org](mailto:help@opensciencegrid.org).

### MyOSG and OIM ###

!!! note
    Migration of MyOSG and the OIM site topology, project, VO, and downtime data is planned for May 24, 2018 10AM EDT.
    Retirement of the old MyOSG host, `myosg.grid.iu.edu`, is planned for May 30, 2018 10AM EDT.
    Retirement of OIM is planned for May 31, 2018 11:59PM EDT.

The [MyOSG](https://my.opensciencegrid.org/about) service provides web and REST interfaces to access information about
OSG resource topology, projects, and VOs.
The MyOSG web interface will be retired but we will continue to offer the same REST interface.
If you run a service that queries MyOSG:

!!! info "Action items"
    - Ensure that the services use <https://my.opensciencegrid.org> instead of <https://myosg.grid.iu.edu>
    - Let us know what queries you’re making and why you’re making them

[OIM](https://oim.opensciencegrid.org/oim/home) serves as the database for the information used by MyOSG with a web
interface for data updates.
The OIM web interface will be retired but we will migrate its data to a series of YAML files held in a GitHub repository.
After OIM is retired, updates to the aforementioned data can be requested via email or pull request.
Documentation forthcoming.

!!! note
    Please see the [OSG CA](#osg-ca) section for information regarding the OIM certificate service.

If you experience any problems with the OSG Software repository, please contact us at
[help@opensciencegrid.org](mailto:help@opensciencegrid.org).

### GRACC Accounting and WLCG Accounting ###

No changes are planned for the [GRACC accounting](https://gracc.opensciencegrid.org/dashboard/db/gracc-home?orgId=1)
service at this time.  The integration of OSG with WLCG accounting should see no interruption.
If you experience any problems with GRACC accounting, please contact us at
[help@opensciencegrid.org](mailto:help@opensciencegrid.org).

### Ticket ###

The Footprints ticketing system at <https://ticket.opensciencegrid.org> is used to track support and security issues as
well as certificate and membership requests.
This service will be retired in favor of two different ticketing systems, depending on the VOs you support at your site:

| If your site primarily supports... | Submit new tickets to...                         |
|------------------------------------|--------------------------------------------------|
| LHC VOs                            | [GGUS](https://ggus.eu)                          |
| Anyone else                        | [Freshdesk](https://support.opensciencegrid.org) |

Throughout this migration, [help@opensciencegrid.org](mailto:help@opensciencegrid.org) will be available for all
support requests or inquiries.
We do not expect this migration to require site administrator action.

The retirement of the Footprints ticketing system will occur no later than May 31, 2018. The exact date will be announced.
If you experience any problems with ticketing, please contact us at
[help@opensciencegrid.org](mailto:help@opensciencegrid.org).

### OASIS and CVMFS ###

The OASIS (OSG Application and Software Installation Service) is a service used to distribute common applications and
software to OSG sites via CVMFS.
The OSG hosts a CVMFS Stratum-0 for keysigning, a repository server, and a CVMFS Stratum-1.
The physical hosting location of these services will be moved to Nebraska but we do not plan any other changes and do not expect
this to affect sites.
If you experience any problems with OASIS or CVMFS, please contact us at
[help@opensciencegrid.org](mailto:help@opensciencegrid.org).

### VOMS Admin Server ###

!!! note
    Retirement of the OSG VOMS service occurred on May 23, 2018.

The [OSG VOMS](https://voms.opensciencegrid.org:8443/voms/osg/user/home.action) service is used to sign VOMS attributes
for members of the OSG VO and can respond to queries for a list of VO members.
The [deprecation of VOMS Admin Server](/policy/voms-admin-retire) software (and therefore VOMS servers), started 10 months ago;
the OSG VOMS servers will be retired as previously planned.

!!! info "Action item"
    If your site accepts OSG jobs, transition your hosts to 
    [LCMAPS VOMS authentication](http://opensciencegrid.github.io/docs/security/lcmaps-voms-authentication/).


### RSV ###

!!! note
    Retirement of the central RSV service occurred on May 15, 2018.

The [central RSV service](https://my.opensciencegrid.org/rgcurrentstatus/index?summary_attrs_showservice=on&summary_attrs_showrsvstatus=on&summary_attrs_showfqdn=on&current_status_attrs_shownc=on&gip_status_attrs_showtestresults=on&downtime_attrs_showpast=&account_type=cumulative_hours&ce_account_type=gip_vo&se_account_type=vo_transfer_volume&bdiitree_type=total_jobs&bdii_object=service&bdii_server=is-osg&start_type=7daysago&start_date=04%2F19%2F2018&end_type=now&end_date=04%2F19%2F2018&all_resources=on&gridtype=on&gridtype_1=on&active_value=1&disable_value=1)
is a monitoring tool that displays every service status information about OSG sites that elect to provide it.
It will be retired since there is no longer a need to monitor OSG site status as a whole.
If you would like to monitor your OSG services, you can access the status page of your local
[RSV](https://opensciencegrid.github.io/docs/monitoring/install-rsv/) instance.

!!! info "Action item"
    Before the retirement, you will need to disable the `gratia-consumer` on your local RSV host,
    which uploads status data to the central RSV service:

    - **If you are on OSG 3.4**, update the `rsv` and `osg-configure` packages:

            :::console
            root@rsv-host # yum update rsv\* osg-configure --enablerepo=osg-testing

    - **If you are on OSG 3.3**, run the following commands:

            :::console
            root@rsv-host # rsv-control --disable gratia-consumer
            root@rsv-host # rsv-control --off gratia-consumer

        And set `enable_gratia = False` in `/etc/osg/config.d/30-rsv.ini`.

If you experience any problems with the central RSV service, please contact us at
[help@opensciencegrid.org](mailto:help@opensciencegrid.org).

### Collector ###

!!! note
    Migration of the central collector occurred on May 21, 2018.
    Retirement of the old central collector occurred on May 23, 2018.

The [central Collector](http://collector.opensciencegrid.org/) is a central database service that provides details about
pilot jobs currently running in the OSG.
The physical hosting location of the central Collector will be moved but we do not for plan any other changes and do not
expect this to affect sites. 
If you experience any problems with the central Collector, please contact us at
[help@opensciencegrid.org](mailto:help@opensciencegrid.org).

!!! info "Action item"
    After the transition, run the following command on your HTCondor-CE to report to the migrated collector:

    ```
    root@htcondor-ce-host # condor_ce_reconfig
    ```

### Homepage ###

!!! note
    Migration of the OSG homepage occurred on May 15, 2018.

The [OSG homepage](https://opensciencegrid.org) is a Wordpress instance that will be moved to a static site.
You can preview the new website at <https://opensciencegrid.github.io>.
If you experience any problems with the homepage, please contact us at
[help@opensciencegrid.org](mailto:help@opensciencegrid.org).
