GridFTP and GSI Migration
=========================

6 December 2019

Introduction
------------

The GridFTP protocol (for data transfer) and GSI (as an Authentication and Authorization Infrastructure, AAI) were
selected for the OSG ecosystem nearly 15 years ago.
In both cases, approaches are becoming increasingly niche; as they have not become widely adopted - indeed, as the
communities dramatically shrink while the Internet ecosystem grows - the support costs are increasingly directly
shouldered by the OSG.

For example, we currently use the GridFTP and GSI implementations in the Grid Community Toolkit (GCT).
While the OSG contributes to the GCT (a fork of the abandoned Globus Toolkit) to sustain operations, the long-term plan
is to migrate our community off these approaches.
The Globus Toolkit (is a stark reminder of how niche the current ecosystem is: even the original reference
implementation was abandoned.

Thus, OSG has the opportunity and motivation to evolve toward a data transfer protocol and security techniques that
better fit our needs and allow us to connect to more vibrant software communities.
For the data transfer, we are proposing HTTP; for the AAI, we are proposing the use of bearer tokens, HTTPS, and OAuth2.

The production-oriented nature of the OSG &mdash; and the embedding of OSG-LHC in the WLCG community &mdash; means that
careful coordination, communication, and planning are needed whenever we migrate away from production services.
OSG has executed several such technology transitions before and managing the full software lifecycle is part of our
value to stakeholders.  This document proposes affected services, replacement technologies, and rough timelines for a
transition.

Overall Timeline
----------------

| **Date**  | **Milestone or Deliverable**                                                                           | **Completed** |
|-----------|--------------------------------------------------------------------------------------------------------|---------------|
| Aug 2019  | Beginning of OSG 3.5 release series (last release series depending on GCT)                             | &#9989;       |
| Aug 2019  | Including HTCondor 8.9.2 in the ‘upcoming’ repository (first HTCondor version with SciTokens support). | &#9989;       |
| Oct 2019  | OSG no longer carries OSG-specific patches for the GCT.  All patches are upstreamed or retired.        |               |
| Jan 2020  | "GSI free" site demo. Show, at proof-of-concept / prototype level, all components without use of GCT.  |               |
| July 2020 | All GCT-free components are in OSG-Upcoming.                                                           |               |
| Jan 2021  | OSG series 3.6, without GCT dependencies, is released.                                                 |               |
| Jan 2022  | End of support for OSG 3.5.                                                                            |               |

Frequently Asked Questions
--------------------------

### How does SciTokens interoperate with other token technologies in the WLCG? ###

We have been very active with the WLCG AuthZ working group and the WLCG JWT profile incorporates many core pieces of
SciTokens -- enough that we feel confident in saying that we will support the relevant parts of WLCG JWT in the
SciTokens client library for existing adopters.

### Will a US-LHC migration from GridFTP to XRootD require the same migration for WLCG? ###

Europe has been an enthusiastic partner in doing this switch.
That said, there are a number of options to disentangle the two if the pace of evolution turns out to be very different.

### What role does LCMAPS play with SciTokens? ###

LCMAPS only works with GSI.
The model for SciTokens is sufficiently more simple for sites that the full complexity of LCMAPS is a bit overkill.

### What does a SciTokens transition for GlideinWMS mean for European sites? ###

The only piece that involves European sites is the factory to CE relationship:
given HTCondor-CE is covered, we need to focus on ARC-CE.

### What are the T1s going to do? No SRM? How does tape work with XRootD and HTTPS? ###

Note that CTA, which CERN is planning to transition to this year, only has XRootD support.

We don't think there's a clear HTTPS picture here (or a clear dCache picture for SRM-free) so there will need to be
coordination with other groups (e.g. the QoS working group).

### Can WLCG-FTS handle both SciTokens and x509 certificates at the same time? ###

Yes.

### Can PhEDEx handle SciTokens? ###

Yes.
