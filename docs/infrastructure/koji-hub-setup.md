Notes on Koji-Hub Setup
=======================

[Current Koji documentation](https://docs.pagure.org/koji/) may be of use.

Tags
----

### Base tags

#### dist-el\[567\]-build

[Tag list](https://koji.chtc.wisc.edu/koji/search?match=glob&type=tag&terms=dist-el%3F-build)

These tags contains 3 external repos each, hosted locally under <http://mirror.batlab.org/pub/linux>:

-   `dist-el[567]-epel`: A mirror of the EPEL 5/6/7 repositories
-   `dist-el[567]-centos*-os`: A mirror of the base CentOS repositories
-   `dist-el[567]-centos*-updates*`: A mirror of the CentOS Updates repositories

We don't put any packages in them (except for ones required for building, like `buildsys-macros` and `fetch-sources`), and generally don't build from them directly, but use tag inheritance.

#### osg-el\[567\]

[Tag list](https://koji.chtc.wisc.edu/koji/search?match=glob&type=tag&terms=osg-el%3F)

These tags contains all the *package names* that we put into OSG; `koji add-pkg` adds to them. `osg-build` does this automatically. The tags do not actually contain any builds (i.e. packages with version-release). All the other `osg-*` tags inherit from these (either directly or indirectly). The purpose of this is to make promoting builds easier, since it keeps you from having to run `add-pkg` when you promote.

#### kojira-fake

[Tag](https://koji.chtc.wisc.edu/koji/taginfo?tagID=10)

This tag (and targets building to it) were created because `kojira` does not automatically regenerate a repo unless it's the source of another repo. Without this, the osg-development tags (for example) wouldn't get regenerated automatically after a build.

### Main OSG tags

#### osg-3.\[123\]-el\[567\]-build

[Tag list](https://koji.chtc.wisc.edu/koji/search?match=glob&type=tag&terms=osg-3.%3F-el%3F-build)

These are used to initialize the buildroot of most packages we make. They inherit from their respective dist-build and osg-development tags. The EL5 and EL6 tags also contain the `jpackage[56]-bin` external repos under <http://mirror.batlab.org/pub/jpackage/> since we use those for some builds.

**Note** that the JPackage external repos must have a better priority than the OS and EPEL external repos to avoid build problems for Java packages.

#### osg-upcoming-el\[567\]-build

[Tag list](https://koji.chtc.wisc.edu/koji/search?match=glob&type=tag&terms=osg-upcoming-el%3F-build)

These tags are special in that they also need to inherit from the latest mainline osg-build repo (that is, if trunk is 3.3, then `osg-upcoming-el6-build` should inherit from `osg-3.3-el6-build`).

#### osg-\*-el\[567\]-development

[Tag list](https://koji.chtc.wisc.edu/koji/search?match=glob&type=tag&terms=osg-*-el%3F-development)

These contain the builds in the `osg-minefield` repos. The `osg-development` repos hosted by the GOC take packages from this, so `osg-development` is pretty much `osg-minefield` after a 1-hour delay. They inherit from osg-testing (and occasionally from the more specialized branches like el5-gt52-experimental, though that is now discouraged). Builds that are made using the `osg-el[567]` targets (default if you're using `osg-build`) get their buildroots from the newest osg-build tags and put their results in the newest osg-development tags.

#### osg-\*-el\[567\]-testing

[Tag list](https://koji.chtc.wisc.edu/koji/search?match=glob&type=tag&terms=osg-*-el%3F-testing)

These contain the builds in the `osg-testing` repos. They inherit from the respective `osg-release` tags.

#### osg-\*-el\[567\]-prerelease

[Tag list](https://koji.chtc.wisc.edu/koji/search?match=glob&type=tag&terms=osg-*-el%3F-prerelease)

These are a staging are for packages that we are *certain* will be released in the next release. They are otherwise empty. These are used for testing and for building the tarball clients.

#### osg-\*-el\[567\]-release

[Tag list](https://koji.chtc.wisc.edu/koji/search?match=glob&type=tag&terms=osg-*-el%3F-release)

These contain the builds in the `osg-release` repos. They should be locked except for when moving packages from the `osg-prerelease` repos to the `osg-release` repos. They inherit from `osg-el[567]`.

#### osg-3.\[123\]-el\[567\]-release-build

[Tag list](https://koji.chtc.wisc.edu/koji/search?match=glob&type=tag&terms=osg-3.%3F-el%3F-release-build)

These inherit the `dist-*-build` tags and the `osg-*-release` tags, putting a base OS along with OSG packages in a single repo, without the need for yum priorities. It is used, along with `osg-*-prerelease`, for building the tarball client. Note that there are no `release-build` repos for upcoming.

#### osg-3.\[123\]-el\[567\]-contrib

[Tag list](https://koji.chtc.wisc.edu/koji/search?match=glob&type=tag&terms=osg-*-contrib)

These contain the builds in the `osg-contrib` repos. Note that there are no `osg-upcoming-contrib` repos.

### Specialized tags

These tags are generally made for long projects which may be in an unstable state and should not interfere with the main development of OSG packages. An example is a full-scale Globus update, where many packages have to be built, using each other as dependencies, and the whole system is not considered usable until all the updates are done. They should generally be removed after the work is done.

#### el\[67\]-globus and el\[67\]-globus-build

These tags were made by Matyas Selmeci for mass Globus updates.

### Collaborator Tags

#### hcc-\*

For use by the Holland Computing Center at UNL.

Build Targets
-------------

A koji *target* pairs a build tag (which contains packages needed to build software) and a destination tag (which the software will be tagged into once it is built).

### osg-el\[567\]

These build from the osg-\*-el\[567\]-build tags for the current release series into the osg-\*-el\[567\]-development tags and are the primary targets used for building OSG software.

### osg-3.\[123\]-el\[567\]

These build from the osg-\*-el\[567\]-build tags into the osg-\*-el\[567\]-development tags and are used for building to releases other than the current one.

### osg-upcoming-el\[567\]

These build from the osg-upcoming-el\[567\]-build tags into the osg-upcoming-el\[567\]-development tags and are used for building to upcoming.

### dist-el\[567\]-build

These build from the `dist-el*-build` tag directly into the `dist-el*-build` tag. It is used for making builds that should be in every buildroot.

### kojira-fake-\*

These fool kojira into regenerating their build tags as repos we can yum install from. Without this, the osg-development tags (for example) wouldn't get regenerated and osg-minefield wouldn't work.

### hcc-el\[567\], panda-el6

These were made for builds made for our collaborators to build into their tags.

Signing plugin
--------------

The signing plugin is used to sign packages right after they are built. We give it a GPG signing key and corresponding passphrase. It is configured per build tag. The current default is to use the OSG key to sign if a configuration is not specified. This is because it's very difficult to sign packages after the fact, so it's better to erroneously sign some of them with the wrong key than to not sign them.

It is therefore important that whenever a new build tag is created, a corresponding config section for the signing plugin is added, too.

This comes from the package `koji-plugin-sign` and has configs in `/etc/koji-sign-plugin` and `/etc/koji-hub/plugins`. There is a script called `fix-permissions` in both directories that will make sure the plugin can read the config.

Tweaks
------

These are local config changes we needed to make to get certain features to work.

### Using proxy certs

`/etc/sysconfig/httpd` needed to be changed to include the following lines:

    OPENSSL_ALLOW_PROXY=1
    OPENSSL_ALLOW_PROXY_CERTS=1

    export OPENSSL_ALLOW_PROXY
    export OPENSSL_ALLOW_PROXY_CERTS

The user must use RFC proxies and must have a version of the koji client of 1.6.0-6.osg or newer.

Procedures
----------

### User cert switch

The following steps need to be taken for someone replacing their user cert:

-   An admin should log in to the database and update the `users` table with their new CN.
-   The user should import their new cert into their browser and rerun `osg-koji setup` to fix their `client.crt`.
-   If the user gets a Python stack trace when connecting to `koji.chtc.wisc.edu` via their browser, they should clear their cookies.

### Adding CAs for user authentication

Since our Koji instance uses certs for auth, we specify which CAs we trust for signing user certs. The CA certs for user auth are concatenated together in the file `/etc/pki/tls/certs/allowed-cas-for-users.crt`. A comment line before the `BEGIN CERTIFICATE` line is used to name the file the cert comes from. We take the certs from the `osg-ca-certs` repository.

For example, when I added the CERN CAs to the bundle, I installed osg-ca-certs onto a Fermicloud VM, copied `/etc/grid-security/certificates/CERN-TCA.pem` (which signed user certs) and `CERN-Root.pem` (which signed `CERN-TCA.pem`) to `koji.chtc.wisc.edu`, catted them to the end of the `allowed-cas-for-users.crt` file, edited the file to add comments before the certs, and restarted `httpd`.

A few tidbits of knowledge for administrators of our Koji server:

-   Three services need to be running for koji-hub to be functioning: kojira, kojid, and the Apache web server. To restart these:
    -   service kojid restart
    -   service kojira restart
    -   service httpd restart
-   Logfiles can be found here:
    -   /var/log/kojid.log
    -   /var/log/kojira.log
    -   /var/log/messages
-   kojid is configured to stop starting new tasks if it has less than 8GB free.
-   Failed build roots are kept for 4 hours, and each build root is about 1GB currently. Hence, if too many tasks fail, the kojid might stop accepting new tasks for 4 hours.
    -   Manually clean these out.

### Koji Permissions

To add a new user to Koji for someone with a given DN, first extract the CN. For example, Alain has the DN `/DC=org/DC=doegrids/OU=People/CN=Alain Roy 424511`, and the CN is just `Alain Roy 424511`. The commands below use just the CN.

``` console
[you@client ~]$ osg-koji add-user "<CN>"
[you@client ~]$ osg-koji grant-permission build "<CN>"
[you@client ~]$ osg-koji grant-permission repo "<CN>"
```

If you want to see the set of possible permissions:

``` console
[you@client ~]$ koji list-permissions 
Enter PEM pass phrase: 
admin
build
repo
livecd
maven-import
win-import
win-admin
appliance
```

If you want to see someone's permissions:

``` console
[you@client ~]$ koji list-permissions --user "Alain Roy 424511"
Enter PEM pass phrase: 
admin
```

If you want to see your own permissions:

``` console
[you@client ~]$ koji list-permissions --mine
Enter PEM pass phrase: 
admin
```

To see the list of users, go to the [Koji web site](https://koji.chtc.wisc.edu/koji/users).

### Renewing host and service certs

Certs and keys are stored in `/p/condor/home/certificates/...`

To obtain renewed certificates, use [the OSG PKI commandline clients](https://opensciencegrid.github.io/docs/security/certificate-management/#osg-pki-command-line-clients.md) or the web interface at <https://oim.opensciencegrid.org/oim/certificaterequesthost>.

The following cert files are necessary:

|                  |                                                                |
|------------------|----------------------------------------------------------------|
| `hostcert.pem`   | koji.chtc host cert (`CN=koji.chtc.wisc.edu`)                  |
| `hostkey.pem`    | koji.chtc host key                                             |
| `kojiracert.pem` | koji.chtc/kojira service cert (`CN=koji.chtc.wisc.edu/kojira`) |
| `kojirakey.pem`  | koji.chtc/kojira service key                                   |
| `kojiweb.pem`    | Concatenation of `hostcert.pem` and `hostkey.pem`              |
| `kojira.pem`     | Concatenation of `kojiracert.pem` and `kojirakey.pem`          |

To create `kojiweb.pem` and `kojira.pem` from their respective cert/key files, do:

``` console
[root@koji ~]# (dos2unix < hostcert.pem; echo; dos2unix < hostkey.pem) > kojiweb.pem
[root@koji ~]# chmod 0600 kojiweb.pem
[root@koji ~]# (dos2unix < kojiracert.pem; echo; dos2unix < kojirakey.pem) > kojira.pem
[root@koji ~]# chmod 0600 kojira.pem
```

As `root` in `/etc` on `koji.chtc.wisc.edu`:

1.  Run `git status`.
2.  Run `etckeeper commit` to commit any uncommited changes (including unversioned files).

Put the files onto `koji.chtc.wisc.edu` as follows:

| File           | Location                           | chown           | chmod  |
|:---------------|:-----------------------------------|:----------------|:-------|
| `hostcert.pem` | `/etc/pki/tls/certs/hostcert.pem`  | `root:root`     | `0644` |
| `hostkey.pem`  | `/etc/pki/tls/private/hostkey.pem` | `root:root`     | `0600` |
| `kojiweb.pem`  | `/etc/pki/tls/private/kojiweb.pem` | `apache:apache` | `0600` |
| `kojira.pem`   | `/etc/pki/tls/private/kojira.pem`  | `root:root`     | `0600` |

1.  Shut down `kojira` and `kojid`.
2.  Restart `httpd`.
3.  Log in via your own cert to the web interface to verify that it is working.
4.  Run `osg-koji list-permissions --mine` to verify command-line access is working.
5.  Run `etckeeper commit` to commit your changes in `/etc`.
6.  Start up `kojira` and `kojid`.

