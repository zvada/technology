OSG Community Software Testing
==============================

Introduction
------------

In the past, the OSG utilized internal staff for the bulk of software testing.
Interested external administrators also provided testing when their specialized installation was required.

More recently, we have been employing an ad hoc community testing program.
The release manager is responsible for notifying interested parties and coordinating their testing.
Often, the person that reported an issue was asked to verify that the issue was resolved.

Testing Model
-------------

We want to engage the OSG community in testing OSG software.
The community has a vested interest in ensuring that the software operates properly.
We will adopt a more formal testing policy which should require less effort from the release manager.

- Promotion: The software is ready to test when the release is promoted to osg-testing repository.
- Notification: Interested parties are informed of the software promotion (via some method such as email or a web page).
- Feedback: Testers provide positive or negative feedback about the software that they have tested. (Method TBD)
- Release: After the software has met the release requirements, it is released.
    - Major Packages
        - Spent at least 7 calendar days in the osg-testing repository
        - Approval of the Release Manager
        - No negative feedback
    - Minor Packages
        - Spent at least 7 calendar days in the osg-testing repository
        - No negative feedback
    - Timing
        - Releases are scheduled by the Release Manager
        - Releases will generally occur Monday - Thursday
        - Releases will generally not occur the day before an non-working day

