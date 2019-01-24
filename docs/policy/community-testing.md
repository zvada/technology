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

- Promotion: The software is `Ready to Test` when the release is promoted to `osg-testing` repository.
- Notification: The release manager posts a message to the community when testing is desired.
- Feedback: Interested testers provide positive or negative feedback about the software by responding to the posted message.
- Release: After the software has met the release requirements, it is released.
    - Major Packages
        - Spent at least 7 calendar days in the osg-testing repository
        - Some positive feedback
        - Approval of the Release Manager
        - No negative feedback
    - Minor Packages
        - Spent at least 7 calendar days in the osg-testing repository
        - No negative feedback
    - Timing
        - Releases are scheduled by the Release Manager
        - Releases will generally occur Monday - Thursday
        - Releases will generally not occur the day before an non-working day

Implementation
--------------

We will use an `osg-testing` Google group to manage the notifications and feedback.
The release manager posts a message requesting testing to the `osg-testing` group
for each package or related set of packages to be tested.
Interested parties will test the software a provide feedback by replying to the post.
The release manager will periodically review the postings in the Google group and
mark tickets `Ready to Release` when they meet the release requirements.

Package are designated `major` or `minor` at the descretion of the release manager
with input from the Software and Operation teams.
