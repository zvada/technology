Koji User Management
====================

All of these operations require Koji admin privileges.
You can see what privileges you have by running `osg-koji list-permissions --mine`.
If you don't see `admin`, you do not have Koji admin privileges.

As of March 2018, the people with `admin` privileges are:

-  Mat Selmeci
-  Carl Edquist
-  Brian Lin
-  Tim Cartwright
-  Tim Theisen


Adding a User
-------------

Adding a user requires two pieces of information about the user:

- the DN of the cert they're using
- their purpose for using Koji, e.g. what package(s) they are going to build, what repos they are going to build into,
  or whether they should have promotion abilities for certain repos

Koji only allows certs signed by one of the following CAs:

- ESnet Root CA 1
- CERN Trusted Certification Authority
- CERN Grid Certification Authority
- CILogon Basic CA 1 (note: Fermi certs are signed by this)
- CILogon OSG CA 1

This is controlled by the `/etc/pki/tls/CAs/allowed-cas-for-users.crt` file,
which contains the full cert chains for these CAs.

!!! note
    The file also contains the cert chains for the following two CAs, which are used for build hosts and automated users.

    - koji.chtc.wisc.edu
    - InCommon RSA Server CA

You can usually guess which CA signed the user's cert from their DN.
If unsure, ask them for the output of:
``` console
$ openssl x509 -in <CERTFILE> -noout -issuer
```
If the CA is not one of the above ones, you will have to add the CA.
Get permission to do this from the Software Manager, then follow the procedure on the [koji-hub setup page](https://opensciencegrid.github.io/technology/infrastructure/koji-hub-setup/#adding-cas-for-user-authentication).


The user's Koji username will be the _first_ Common Name (CN) of their certificate subject.
For example:
``` console
$ openssl x509 -in <CERTFILE> -noout -subject
subject= /DC=org/DC=cilogon/C=US/O=Fermi National Accelerator Laboratory/OU=People/CN=Matyas Selmeci/CN=UID:matyas
```
will result in the Koji username "Matyas Selmeci".
To add the user, run
``` console
$ osg-koji add-user "<USERNAME>"
```
This will create the user but will give them no permissions.

!!! warning
    It is effectively impossible to delete a user.
    If you get the name wrong, follow the [instructions below for renaming a user](#handling-user-cert-changes-renaming-a-user) below.

To give them permissions, use the command
``` console
$ osg-koji grant-permission <PERMISSION> "<USERNAME>"
```
Generally, the permissions you should give are (more explanation below):

- most people should be given `build` and `repo`
- HCC people should also be given `hcc-build`
- S&R people should also be given `software-team`
- Security people should also be given `security-team`
- Ops people should also be given `operations-team`
- other software devs should also be given `software-contributor`
- few people should be given `admin`

To revoke permissions, use the command
``` console
$ osg-koji revoke-permission <PERMISSION> "<USERNAME>"
```

### Permissions details

To list the available permissions, run
``` console
$ osg-koji list-permissions
```

The important permissions are:

- **repo**: the ability to run `osg-koji regen-repo`.
  Should be given to anyone that builds or tests packages.
- **build**: the ability to build (but not tag!) any package.
  Should be given to anyone that builds packages, including automated users.
  This perm is necessary but _not_ sufficient for them to build into the development repos;
  it _is_ enough to let them do scratch builds.
- **software-contributor**: the ability to build into _any_ of the development repos _and_ promote into the osg-testing repos (but not any other repos).
  Should be given to people that build specific software but do not belong to the OSG S&R team or HCC.
- **operations-team**: the ability to build into development and promote into testing the `vo-client` package.
  Should be given to people in OSG Operations.
- **security-team**: the ability to build into development and promote into testing the `*-ca-certs*` packages.
  Should be given to people in OSG Security.
- **hcc-build**: the ability to build and promote into any of the `hcc` tags.
  Should be given to people in Nebraska's Holland Computing Center.
- **software-team**, **release-team**: the ability to build any package into any development tag, and promote to any tag.
  Current policy does not distinguish between these two permissions.
  Should be given to people on the S&R team.
- **admin**: the ability to do anything (short of direct database or config manipulation).
  Should be given sparingly.

The `grant-permission` command can also be used to create new permissions; doing so is beyond the scope of this document.
For further permission details, see the [policy writing doc](https://opensciencegrid.github.io/technology/infrastructure/koji-policy-writing/)
and `/etc/koji-hub/hub.conf` on koji.chtc.wisc.edu.


Handling User Cert Changes / Renaming a User
--------------------------------------------

Koji users are identified by the _first_ Common Name (CN) of their X.509 certificate.
If this changes for a user (e.g. they get a cert from a new CA), someone with root access on koji.chtc.wisc.edu will
need to SSH there and do the following:

``` console
$ sudo /root/psql-kojidb
```
``` psql
koji=> BEGIN;
koji=> SELECT * FROM users WHERE name='<OLDNAME>';
-- make sure you find one and exactly one person
koji=> UPDATE users SET name='<NEWNAME>' WHERE name='<OLDNAME>';
-- 1 row should have been updated
koji=> SELECT * FROM users;
-- sanity check; if everything looks ok, commit
koji=> COMMIT;
koji=> \q
```
If you mess up, do `ROLLBACK; BEGIN;` and try again.

Inform the user:

- they can no longer use their old cert
- if they _aren't_ using a proxy for Koji auth, they must rerun `osg-koji setup` to fix their `client.crt` files
- they must import their new cert into their browsers
- they must clear their browser cache and cookies for koji.chtc.wisc.edu before using the web interface
  (or else they'll get a Python stack trace when they try to connect)


Disabling and Enabling a User
-----------------------------

Users cannot be deleted, but they can be disabled.

To disable a user, use the command:
``` console
$ osg-koji disable-user "<USERNAME>"
```
If you are feeling extra paranoid, use `osg-koji revoke-permission` to remove all their permissions.

To enable a user, use the command:
``` console
$ osg-koji enable-user "<USERNAME>"
```
