Software Team Support
=====================

Incoming tickets (Operations staff)
-----------------------------------

When a ticket arrives at the GOC and the Operations staff member decides that the ticket should be assigned to the Software Team, the operations staff member will do two things:

1.  The ticket will be assigned to a pseudo-user called "Software".
2.  The "Next Action" field will be set to "SOFTWARE TRIAGE".
3.  The Software pseudo-user has an email list as its "personal" email address. This is: <osg-software-support-stream@opensciencegrid.org>.

Triage duty (Technology Area staff)
-----------------------------------

All OSG Technology Area Team members who are at least 50% on the will share triage duty (except Brian Bockelman). Each week (Monday through Friday), during normal work hours, there will be one person on triage duty. If you are on triage duty, this means:

-   Watch the software incoming tickets. **If a ticket has not been assigned to a software team member, you assign it appropriately.** You are responsible for assigning all incoming tickets that haven't been assigned. This includes tickets that have arrived over the weekend or were not handled by the previous person on triage duty.
-   If you can handle an incoming ticket, assign it to yourself and handle it. Leave the "software" user assigned to the ticket. Many tickets are common problems that most team members should be able to solve.
-   If you cannot handle an incoming ticket, collect initial details (versions, logs, etc...), and assign the ticket to the most appropriate software team member. Where appropriate, include people from other teams (i.e. security, operations, glidein...) Leave the "software" user assigned to the ticket.
-   Look at assigned tickets. For tickets that are not being handled in a timely fashion, please remind the person that owns the ticket, or, if the ticket is waiting on the user, remind the user.

Please note: being on triage duty does *not* mean that you must personally solve all new tickets. It means that you handle the easy tickets and assign the other tickets appropriately.

Note that the software pseudo-user has an email address that is a mailing list: <osg-software-support-stream@opensciencegrid.org>. If you find it convenient, you can sign up for the mailing list to see all the incoming tickets. Alain recommends you do this during your triage duty, but you do not need to stay subscribed when you are not on triage duty.

All the currently opened tickets assigned to the software team can be seen here: [GOC Open Tickets](https://ticket.opensciencegrid.org/goc/list/open)

### Flow of tickets

Note that if you follow the above, we will end up with three assignees to each ticket. This is the overall flow:

1.  A ticket arrives at the GOC, either via the ticket creator, or created by Operations in response to an email.
2.  **ASSIGNMENT \#1:** The ticket is assigned to an Operations member. They're in charge of ushering the ticket through its whole lifetime, though for software tickets they won't do a whole lot on the technical work. Note that some software tickets may not be assigned to us, because they might assign them to the VO support center. This is good.
3.  **ASSIGNMENT \#2:** The Operations member looks at the ticket and decides it's a software ticket. (They might do some upfront work if they can.) They then assign it to "Software Support (Triage)". We now have two people assigned to the ticket.
4.  When assigned to "Software Support (Triage)", all changes to the ticket are sent to <osg-software-support-stream@opensciencegrid.org>, so we leave this pseudo-person on the ticket. Watching the email to this mailing list is a nice (but optional) way for you to see what's happening when you're on triage duty.
5.  **ASSIGNMENT \#3:** The person on triage duty assigns it to the right person from the software team. We now have three assignees:
    1.  GOC member
    2.  Software Support (Triage)
    3.  The Software team member who will handle the ticket

    Inasmuch as possible, you should strive to handle the easier tickets and not pass them off to other people. For reference, see our [troubleshooting documents](https://opensciencegrid.github.io/docs/).

### LCMAPS VOMS Transition ###

This section contains the process for helping sites transition from edg-mkgridmap or GUMS to the LCMAPS VOMS plugin as
part of the [VOMS Admin Server retirement](/policy/voms-admin-retire).

1. Ask if the site is using edg-mkgridmap or GUMS. If they're using GUMS, find out what GUMS clients they have at their 
   site. Possibilities include:

    - HTCondor-CE
    - GridFTP
    - XRootD: if an ATLAS site, they use vomsxrd/xrootd-voms-plugin
    - dCache: if an ATLAS site, encourage them to consult US-ATLAS mailing lists
    - BeStMan: encourage the site to transition to GridFTP, as they cannot retire GUMS until BeStMan doesn't depend on it.
      If CMS/ATLAS, encourage them to consult their US-ATLAS/US-CMS mailing lists for assistance.

1. Ask them to follow the relevant instructions for their authorization solution 

    - [edg-mkgridmap](http://opensciencegrid.github.io/docs/security/lcmaps-voms-authentication/#migrating-from-edg-mkgridmap)
    - [GUMS](http://opensciencegrid.github.io/docs/security/lcmaps-voms-authentication/#migrating-from-gums)

1. After they've completed the above instructions, verify that they're still getting pilots:

    1. Add factory ops to the ticket under `OSG Support Centers`
    1. Verify that the site's [pilot numbers](http://gfactory-1.t2.ucsd.edu/factory/monitor/factoryStatus.html?entry=OSG_US_UConn_gluskap&frontend=OSG_Flock_frontend&infoGroup=running&elements=StatusRunning,ClientGlideRunning,ClientGlideIdle,&rra=0&wi)
       are non-zero.

### Updating the triage calendar ###

The calendar is hosted on Tim Cartwright’s Google Calendar account. If you need privileges to edit, ask Brian L. To update

1.  Update checkout ([GitHub](https://github.com/opensciencegrid/osg-triage-assignments))
2.  Generate next rotation:

        ./triage.py --generateNextRotation > rotation.txt
3.  Check and update assignments according to team member outages
4.  Load triage assignments into Google Calendar:

        ./triage.py --load rotation.txt

To subscribe to this calendar in your calendar program, use the iCal URL: `https://www.google.com/calendar/ical/h5t4mns6omp49db1e4qtqrrf4g%40group.calendar.google.com/public/basic.ics`

<iframe src="https://www.google.com/calendar/embed?height=600&showPrint=0&wkst=1&bgcolor=%23FFFFFF&src=h5t4mns6omp49db1e4qtqrrf4g%40group.calendar.google.com&color=%232F6309&ctz=America%2FChicago" style=" border-width:0 " width="800" height="600" frameborder="0" scrolling="no"></iframe>

Handling tickets
----------------

-   We need to take good care of our users. We are in a small community. Please be friendly and patient even when the user is frustrated or lacking in knowledge.
-   Always sign your ticket with your full name, so people know who is responding.
-   If it's easy for you, include a signature at the bottom of your response.
-   Remember that you can tell people to use the `osg-system-profiler` to collect information. It can shorten the number of times you ask for information because it collects quite a bit for you.
-   If you run across a problem that has a chance of being hit by other users, consider:
    -   Is there a bug we should fix in the software? Or something we could improve in the software?
    -   Is there a way to improve our documentation?
    -   Can you extend our troubleshooting documents to help people track this down more quickly? Consider the troubleshooting documents to be as much for us as for our users.

Direct E-mail vs. Support
-------------------------

If someone emails you directly for support, you have the choice of when to move it to a ticket. The recommended criteria are:

-   If it's easy to handle and you can definitely do it yourself, leave it in email.
-   If there's a chance that you can't do it in a timely fashion, turn it into a ticket.
-   If there's a chance that you might lose track of the email, turn it into a ticket.
-   If there's a chance that you might need help from others, turn it into a ticket.
-   If it's an unusual topic and other people would benefit from seeing the ticket (now or in the future), turn it into a ticket.

GOC vs JIRA
-----------

JIRA is for tracking our work.
It's meant for internal usage, not for user support.
In general, users should not ask for support via JIRA.
A single user support ticket might result in zero, one, or multiple JIRA tickets.

GOC tickets are for user support.
This is where we help users debug, understand their problems, etc.

If actionable software team tasks arise from a GOC ticket, JIRA ticket(s) should be created to track that work. 
Resultant JIRA tickets should:

- Include a link to the original GOC ticket, a description of the problem, and a proposed solution to the problem.
- Add the original reporter as a watcher if they have a JIRA account.

When all the relevant JIRA tickets are created, ask the user if they would be ok with tracking the issue via JIRA. 
If they say yes, close the GOC ticket.
