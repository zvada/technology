Ready for Testing Announcements
===============================

Per our [community testing policy](/policy/community-testing), we must send weekly digests of packages that are ready
for testing.

Announcement Template
---------------------

The following email template is filled out to announce that packages are ready for testing.
Text between `<ANGLE BRACKETS>` should be replaced and sections without packages to be tested should be omitted.

```
Subject: OSG Packages Available for Testing
```

```
Several packages are available for testing for tentative release the
week of <MONTH> <DAY>.

OSG 3.5 Only:
-   Major Components
    -   Major Package n.v.r (Comment, Security, etc.)
    -   Major Package n.v.r
-   Minor Components
    -   Minor Package n.v.r
    -   Minor Package n.v.r

Both OSG 3.5 and 3.4:
-   Major Components
    -   Major Package n.v.r (Comment, Security, etc.)
    -   Major Package n.v.r
-   Minor Components
    -   Minor Package n.v.r
    -   Minor Package n.v.r

OSG 3.4 Only:
-   Major Components
    -   Major Package n.v.r (Comment, Security, etc.)
    -   Major Package n.v.r
-   Minor Components
    -   Minor Package n.v.r
    -   Minor Package n.v.r

To install any of these packages, run the following command:

    # yum install --enablerepo=osg-testing <PACKAGE NAME>

JIRA Ticket Summary: https://opensciencegrid.atlassian.net/issues/?filter=12355

Please test this software and send end positive or negative feedback to
osg-software@opensciencegrid.org.  Be sure to include details describing your
testing platform, e.g. OSG 3.4 vs 3.5, EL6 vs EL7! If you any questions, you can
always contact us at help@opensciencegrid.org

As described by our Community Software Testing Policy,
(https://opensciencegrid.org/technology/policy/community-testing/)
Major components of the OSG software stack and need positive feedback and
the approval of the release manager before being marked "Ready for Release".

Feedback about the community testing process is also desired.
```
