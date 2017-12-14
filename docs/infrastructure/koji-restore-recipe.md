How to Restore Koji
===================

This document contains recipes on how to restore the Koji services and the database they require. It is divided into two sections: one for the database (to be done if something happens to *db-01*), and one for the server hosting the koji services (to be done if something happens to *koji.chtc*).

In case both the database and the hub need to be restored, the database should be restored first.

Background information
----------------------

Backups of *koji.chtc.wisc.edu* and *db-01.batlab.org* are on *host-3.chtc.wisc.edu* in `/export/backup/<DATE>`. That machine is in WID. (Same room as *koji.chtc* itself, which is why we have offsite backups). It's a homebrew rsync-based backup system. (Not our home -- Nate told me it was written for Midwest Tier 2.) They go back up to a week, with a monthly snapshot for a year.

Setting up your environment
---------------------------

For all of these steps, you will need a root shell on *host-3.chtc.wisc.edu* and have the following environment variables defined:
``` console
NEWDB=<FQDN OF NEW DATABASE SERVER>
NEWKOJI=<FQDN OF NEW KOJI HOST>
DATE=<YYYY-MM-DD DATE OF MOST RECENT GOOD BACKUP>
DBBACKUP=/export/backup/$DATE/db-01.batlab.org
KOJIBACKUP=/export/backup/$DATE/koji.chtc.wisc.edu
RSYNC="rsync --archive --hard-links --verbose"
```

Restoring the database
----------------------

The entire filesystem of *db-01* is backed up -- this includes all of `/var/lib/pgsql`, including the database as-is. In theory, this means that we could just rsync all the files to a blank hard drive, boot up, and we'd have a *db-01* again. However, the Postgres manual warns against restoring the database from a filesystem backup that was made while the database was live, and we do not shut down the database before backups.

We might be able to restore every other part of the filesystem besides the database, which would speed up the overall restoration process, but only the fresh install was tested.

The new database server is called *newdb* in these instructions.

### Restoring Services

Prerequisites for *newdb*: an EL 6+ host with an SSH server set up and accessible (as root) from *host-3.chtc.wisc.edu*

``` console
## On newdb:
## Install postgres, get a blank DB up and create the user that koji
## will be using.
[root@newdb]# yum install -y postgresql-server
[root@newdb]# service postgresql initdb
[root@newdb]# useradd -r -m koji
## Make a directory we'll put the restored files into.
[root@newdb]# mkdir -p /root/dbrestore

## On host-3:
[you@host-3]$ sudo $RSYNC $DBBACKUP/homefs/  $NEWDB:/root/dbrestore/home
[you@host-3]$ for dir in root etc var; do \
   sudo $RSYNC $DBBACKUP/rootfs/$dir/ \
      $NEWDB:/root/dbrestore/$dir \
   done
```

Continue on to the next section

### Restoring Database Contents

Assumes you have restored the /var directory from backup into `/root/dbrestore/var`.

1.  Restore the postgres config files so the koji-hub daemon can log in:

        :::console
        ## On newdb:
        [root@newdb]# service postgresql stop
        [root@newdb]# cp -a /root/dbrestore/var/lib/pgsql/data/{*.conf,postmaster.opts} \
            /var/lib/pgsql/data/

1.  Edit `/var/lib/pgsql/data/pg_hba.conf`. There are lines like:

        # Koji-hub IPv4:
        host koji koji 128.104.100.41/32 md5

    Change the IP address to the public IP address of the host that will serve as the new hub.

1.  Restore the actual database:

        :::console
        ## On newdb:
        [root@newdb]# chown -R postgres:postgres /var/lib/pgsql/*
        [root@newdb]# service postgresql start
        [root@newdb]# gunzip -c /root/dbrestore/var/lib/pgsql-backup/postgres-db-01.sql.gz |
            psql -U postgres postgres


### Validation

Do the following tests to make sure the database is ready to use:

1.  Test that the contents got properly restored:

        :::console
        [root@newdb]# psql -U koji koji koji

    <!-- -->

        :::psql
        koji=> select * from users;
        koji=> select * from build order by id desc limit 10;

1.  Test logging in as the koji user:

        :::console
        [root@newdb]# psql -U koji -h newdb koji

    (you must use the FQDN of *newdb*, not *localhost*).
    Be sure you get prompted for a password, and the password from `/etc/koji-hub/hub.conf` works.

1.  Continue to "Restoring Koji" if needed, otherwise skip to "Starting Services and Validation"


Restoring Koji
--------------

Both the root filesystem of *koji.chtc* and `/mnt/koji` are backed up. The root filesystem backups are in the `rootfs` subdirectory of `/export/backup/$DATE/koji.chtc.wisc.edu` and the backups of `/mnt/koji` are in the `kojifs` subdirectory.

The following instructions show how to restore the critical components of Koji onto a new machine.

In the instructions, the new host will be named *newkoji*.

### Installing the OS

Prerequisites for *newkoji*: an EL 6 host with an SSH server set up and accessible (as root) from *host-3.chtc.wisc.edu*   
(This recipe was tested for EL 6, on the same machine as *newdb*).

1.  Install EPEL and OSG repos:

        :::console
        [root@newkoji]# rpm -Uvh \
            https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm \
            https://repo.grid.iu.edu/osg/3.4/osg-3.4-el6-release-latest.rpm
        [root@newkoji]# yum install -y yum-plugin-priorities

1.  Edit `/etc/yum.repos.d/osg-*development.repo`:
    -   Enable the development repo
    -   Add `includepkg=koji*` to the definition for the development repo

1.  Go through the other repo files and make sure that EPEL and OS priorities are worse than 98.
    This means absent or numerically greater.
    Especially look at `cobbler-config.repo` if it exists.

1.  Install the koji packages and dependencies, making sure the koji packages themselves come from osg:

        :::console
        [root@newkoji]# yum install koji koji-builder koji-hub koji-plugin-sign \
            koji-theme-fedora koji-utils koji-web mod_ssl postgresql

1.  Mount `/mnt/koji` if necessary
2.  Restore the contents of the koji filesystem. On *host-3*:

        :::console
        ## At a minimum, you must restore the /mnt/koji/packages directory
        [you@host-3]$ sudo $RSYNC $KOJIBACKUP/kojifs/packages/ $NEWKOJI:/mnt/koji/packages
        ## The other directories are optional, though it saves a lot of time to restore /mnt/koji/repos
        [you@host-3]$ sudo $RSYNC $KOJIBACKUP/kojifs/repos/ $NEWKOJI:/mnt/koji/repos
        [you@host-3]$ sudo $RSYNC $KOJIBACKUP/kojifs/work/ $NEWKOJI:/mnt/koji/work
        [you@host-3]$ sudo $RSYNC $KOJIBACKUP/kojifs/scratch/ $NEWKOJI:/mnt/koji/scratch
        ## Any dirs you did not restore should be created.

1.  Fix permissions if needed. On *newkoji*:

        :::console
        [root@newkoji]# chown -R apache:apache /mnt/koji/{packages,repos,work,scratch}
        [root@newkoji]# chmod 0755 /mnt/koji/{packages,repos,work,scratch}

1.  Continue on to the next section

### Restoring Configuration

On *newkoji*, define the shell function `dirclone`, listed below:

``` bash
dirclone () {
   srcdir=$(dirname "$1")/$(basename "$1")
   destdir=$(dirname "$2")/$(basename "$2")
   mkdir -p "$(dirname "$2")"
   rsync --archive --delete-after --acls --xattrs \
         --partial --partial-dir=.rsync-partial \
         "$srcdir/" "$destdir"
}
```

1.  On *newkoji*:

        :::console
        [root@newkoji]# mkdir -p /root/hubrestore

2.  On *host-3*:

        :::console
        [you@host-3]$ sudo $RSYNC $KOJIBACKUP/rootfs/{root,home,etc} $NEWKOJI:/root/hubrestore/
        [you@host-3]$ sudo $RSYNC $KOJIBACKUP/varfs/ $NEWKOJI:/root/hubrestore/var/

1.  On *newkoji*, install some utils we will need later:

        :::console
        [root@newkoji]# yum install -y dos2unix vim-enhanced

    (vim-enhanced is used for vimdiff)


1.  On *newkoji*:

        :::console
        ## Restore some of the directories in /etc:
        [root@newkoji]# while read subtree; do
            dirclone /root/hubrestore/etc/$subtree /etc/$subtree
        done <<___END___
        httpd
        kojid
        koji-hub
        kojira
        koji-sign-plugin
        kojiweb
        mock
        pki/koji
        pki/tls/certs
        pki/tls/private
        ___END___
        ## Restore some of the files:
        [root@newkoji]# cp -a /root/hubrestore/etc/koji.conf /etc/
        [root@newkoji]# cp -a /root/hubrestore/etc/sysconfig/{httpd,kojid,kojira} /etc/sysconfig/

1.  Restore users and home directories
    -   If *newkoji* is on a separate host from *newdb*, then just simply copy over the files:

            :::console
            [root@newkoji]# dirclone /root/hubrestore/home /home
            [root@newkoji]# cp -a /root/hubrestore/etc/{passwd,shadow,group,gshadow} /etc


    -   If *newkoji* is on the same host as *newdb*, then you will have to be more careful:

            :::console
            ## Skip home directories for the special users
            [root@newkoji]# for dir in /root/hubrestore/home/*; do
                bndir=$(basename "$dir")
                if [[ $bndir = koji && $bndir = postgres ]]; then
                    dirclone "$dir" /home/"$bndir"
                fi
            done
            ## Now merge the passwd, group, shadow, and gshadow files in /etc.
            ## Make sure that your editor does not create backup files
            ## ("set nobackup" in vim), and that shadow and gshadow are owned by
            ## root and have 0400 permissions.

1.  Ensure a 'koji' user exists

1.  Fix dirs in `/var`:

        :::console
        [root@newkoji]# rm -rf /var/lib/mock/*
        [root@newkoji]# chown root:mock /var/lib/mock
        [root@newkoji]# chmod 2775 /var/lib/mock

1.  Restore `/var/www/html` and `/var/spool/cron`   
    (TODO) `/var` should have been backed up, but in case it isn't, the following files need to exist in `/var/www/html`:
    -   A symlink `mnt -> /mnt`
    -   A robots.txt with contents

            User-agent: *
            Disallow: /


### Fixing Names

This section should be done if *newdb* or *newkoji* do not have the same as the previous db server and hub (i.e. *db-01.batlab.org* and *koji.chtc.wisc.edu*). This section should be completed on *newkoji*.

#### Fixing config files if *newdb* was renamed

The only change that's needed if *newdb* was renamed is to `/etc/koji-hub/hub.conf`. Edit that file and change the DBHost line to point to the new hostname. After editing, make sure `hub.conf` is owned by `root:apache` and chmodded 0640.

#### Installing new cert/key pairs for *newkoji*

You will need a cert/key pair for the new hostname. Run `dos2unix` on all cert and key files before using them. Define the shell function `makepem`, listed below. `makepem` combines a public and private keypair to make a .pem file that the Koji services use.

Usage: `makepem <CERTFILE> <KEYFILE> <OUTPUT_FILE>`
``` bash
makepem () {
    certfile=$1
    keyfile=$2
    outputfile=$3
    (set -e
    keymodulus=$(openssl rsa -noout -modulus -in "$keyfile")
    certmodulus=$(openssl x509 -noout -modulus -in "$certfile")
    if [[ $keymodulus = $certmodulus ]] ; then
        echo 'keyfile and certfile do not match'; return 1
    fi
    if [[ -f $outputfile ]] ; then
        mv -f "$outputfile"{,.bak}
    fi
    (dos2unix < "$certfile"; echo; dos2unix < "$keyfile") > "$outputfile"
    chmod 0600 "$outputfile"
    )
}
```

Place cert and key files into the following paths:

|             |                        |
|-------------|------------------------|
| host cert   | `/root/hostcert.pem`   |
| host key    | `/root/hostkey.pem`    |

Then use `makepem` to combine the certs and put them in the proper locations.

``` console
[root@newkoji]# makepem /root/hostcert.pem /root/hostkey.pem \
   /etc/pki/tls/private/kojiweb.pem
[root@newkoji]# chown apache:apache /etc/pki/tls/private/kojiweb.pem
```

In addition, copy the host cert and key into the locations HTTPD expects it them.

``` console
[root@newkoji]# cp -a /root/hostcert.pem /etc/pki/tls/certs/hostcert.pem
[root@newkoji]# cp -a /root/hostkey.pem /etc/pki/tls/private/hostkey.pem
```

#### Fixing hostname in config files

Use sed to replace the hostname in the following config files in /etc:

-   `/etc/kojira/kojira.conf`
-   `/etc/koji.conf`
-   `/etc/koji-hub/hub.conf`
-   `/etc/httpd/conf.d/kojiweb.conf`
-   `/etc/httpd/conf/httpd.conf`
-   `/etc/kojid/kojid.conf`

You will need to fix `/etc/kojid/kojid.conf` on all builder machines as well (e.g. *kojibuilder2.chtc.wisc.edu*).

#### Fixing hostname in database

You will need to find and fix entries that contain the hostname in the following tables:

-   `host` (should be 1 entry)
-   `users` (should be 2 entries, one for the host, and one for the kojira user)

#### Fixing hostname elsewhere

These steps are only necessary if you cannot get a DNS Canonical Name (CN) record such that *koji.chtc.wisc.edu* resolves to *newkoji*.

1.  Update the repo definitions in the *osg-release* package
2.  Update the mash script(s) at the GOC
3.  Mail the software team and users that anyone using the *minefield* repos will need to update *osg-release*
4.  Fix all the build machines to point to the new name
5.  Fix the following files in *osg-build* and make a new release
    -   `data/osg-koji-home.conf`
    -   `data/osg-koji-site.conf`
    -   `osgbuild/constants.py`
    -   `osgbuild/kojiinter.py`
6.  Mail people that they will need to update *osg-build* and rerun `osg-koji setup`


### Starting Services and Validation

Now you will start up Koji services and verify that they function.
Prerequisite: previous restore steps have been completed and `postgresql` is running on the database host.

All steps will be run on *newkoji*.

1.  Start the main koji daemon:

        :::console
        [root@newkoji]# service httpd start

1.  Use `ps` to verify that it came up
1.  Connect to the web interface in your browser.
    Make sure you can use https and you can log in.
1.  As yourself, run the `koji` command-line tool and make a few queries (e.g. list-tags)
1.  Start the koji build daemon:

        :::console
        [root@newkoji]# service kojid start

1.  Use `ps` to verify that it came up

If you did not restore the `/mnt/koji/repos` directory, you will now need to regenerate the build repos.
Use `koji list-tags` to get a list of tags and run `koji regen-repo` on all of the ones with `-build` in the name.
This **will** take several hours.
You will also need to regen the `-development` repos so that *minefield* works again. Keep an eye on the tasks in the web interface to make sure they are getting farmed out to the right hosts.

1.  Try a scratch build
1.  Start `kojira`:

        :::console
        [root@newkoji]# service kojira start

1.  Use `ps` to verify that it came up
2.  Wait half a minute and use `ps` to verify that `kojid` is still up; the two processes can kick each other off if they are both using the same certificate
3.  Bump a package if needed and try a real, non-scratch build
4.  Make sure that kojira is regenerating the repos

If you have updated *osg-release* and/or *osg-build*, rebuild those packages now.

