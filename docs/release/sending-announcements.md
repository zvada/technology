# Sending Announcements

This document describes the procedure for sending Security and Release
Announcements.

## Introduction

The Release and Security Teams need to send out announcement about various events (releases, security advisories, planned changes, etc).
The `osg-notify` tool handles these notifications.

## Prerequisites

To send announcements, the following conditions must be met.

-   The machine must have an internet address listed in the [SPF Record](https://mxtoolbox.com/SuperTool.aspx?action=spf%3aopensciencegrid.org&run=toolpage) for opensciencegrid.org
-   The machine must have the proper software installed
-   No http proxy
-   A properly configured Mail Transport Agent
-   A valid OSG User certificate to lookup contacts in the topology database
-   (Optional) A GPG Key to sign the announcement

## Installation

1.  Choose a machine.
    -   Make sure the the internet address is listed in the  [SPF Record](https://mxtoolbox.com/SuperTool.aspx?action=spf%3aopensciencegrid.org&run=toolpage) for opensciencegrid.org
    -   This procedure has been tested on a fermicloud Scientific Linux 7 VM and my Linux Mint 18.3 laptop.
    -   It is known not to work on a fermicloud Scientific 6 VM.
    -   Any sufficiently modern Linux will do.
2.  Install the software
    -   Enterprise Linux 7
        -   Enable the EPEL repository
        -   yum install git python-requests python-gnupg
    -   Ubuntu
        -   apt install git python-requests python-gnupg
    -   Common
        -   git clone [https://github.com/opensciencegrid/topology.git](https://github.com/opensciencegrid/topology.git)
3.  Disable any HTTP proxies
    -   Look in the environment for the following environment variable and unset them if present.
        -   HTTP_PROXY, HTTPS_PROXY, http_proxy, https_proxy.
4.  Ensure that the machine can send email.
    -   A fermicloud VM will need additional configuration to send email. Firewall rules prevent sending email directly.
        -   Update postfix to relay through FermiLab's official mail server

            ``` bash
            echo "transport_maps = hash:/etc/postfix/transport" >> /etc/postfix/main.cf
            ```

            ``` bash
            echo "*   smtp:smtp.fnal.gov" >> /etc/postfix/transport
            ```

            ``` bash
            postmap hash:/etc/postfix/transport
            postfix reload
            ```
5.  Ensure that you can lookup contacts in the topology database
    -   Use the `osg-topology` tool to list the contacts
        ``` bash
        cd topology
        PYTHONPATH=src python bin/osg-topology --cert publicCert.pem --key privateKey.pem list-resource-contacts

        !!! note
        -   If the contacts include email addresses, this is working properly
        -   If you type your password incorrecly, the authentication will silently fail and you won't get email addresses

## Sending the annoucement

Use the osg-notify tool to send the announcment. Here are the options that you need.
    -   `--dry-run` - Use this option until you are ready to actually send the message
    -   `--cert file` - File that contains your OSG User Certificate
    -   `--key file` - File that contains your Private Key for your OSG User Cerficiate
    -   `--no-sign` - Don't GPG sign the messaage (release only)
    -   `--type production` - Not a test message
    -   `--message file` - File containing your message
    -   `--subject "The Subject" - The subject of your message
    -   `--recipents "me@me.com you@you.com" - Recipients, must have at least one
    -   `--oim-recipients resources` - Select contact associated with resources
    -   `--oim-contact-type administrative' - `administrative` for release announcemnt, `security` for security announcements

!!! note
Security announcement must be signed.
    -   `--sign` - GPG sign the message
    -   `--sign-id KeyID` - The ID of the Key used for singing

For release announcements use the following command:
``` bash
PYTHONPATH=src python bin/osg-notify --cert your-cert.pem --key your-key.pem --no-sign --type production --message message-file --subject 'Your fine subject' --recipients "osg-general@opensciencegrid.org osg-operations@opensciencegrid.org osg-sites@opensciencegrid.org vdt-discuss@opensciencegrid.org" --oim-recipients resources --oim-contact-type administrative
```

