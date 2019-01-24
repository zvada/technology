<style type="text/css">
pre em { color: red; font-weight: normal; font-style: normal; }
.old { color: red; }
.off { color: blue; }
</style>

# Software/Release Team ITB Site Design


## Madison ITB Machines

All physical hosts are located in 3370A in the VDT rack.

| Host                                         | Purpose                 | OS     | CPU Model            | CPUs    | RAM   | Storage              | Notes                       |
|:---------------------------------------------|:------------------------|:-------|:---------------------|:--------|:------|:---------------------|:----------------------------|
| itb-data1                                    | worker node             | SL 6.9 | Celeron G530 2.4Ghz  | 2 / 2   | 8 GB  | 750 GB × 2 (RAID?)   | planned as HDFS data node   |
| itb-data2                                    | worker node             | SL 6.9 | Celeron G530 2.4Ghz  | 2 / 2   | 8 GB  | 750 GB × 2 (RAID?)   | planned as HDFS data node   |
| itb-data3                                    | worker node             | SL 7.4 | Celeron G530 2.4Ghz  | 2 / 2   | 8 GB  | 750 GB × 2 (RAID?)   | planned as HDFS data node   |
| itb-data4                                    | worker node             | SL 6.9 | Celeron G530 2.4Ghz  | 2 / 2   | 8 GB  | 750 GB × 2 (RAID?)   | planned as XRootD data node |
| itb-data5                                    | worker node             | SL 6.9 | Xeon E3-1220 3.10GHz | 2 / 4   | 8 GB  | 750 GB × 2 (RAID?)   | planned as XRootD data node |
| itb-data6                                    | worker node             | SL 7.4 | Xeon E3-1220 3.10GHz | 2 / 4   | 8 GB  | ???                  | planned as XRootD data node |
| itb-host-1                                   | KVM host                | SL 7.4 | Xeon E5-2450 2.10GHz | 16 / 32 | 64 GB | 1 TB × 4 (HW RAID 5) |                             |
|  ·  itb-ce1                                  | HTCondor-CE             | SL 6.9 | VM                   | 4       | 6 GB  | 192 GB               |                             |
|  ·  itb-ce2                                  | HTCondor-CE             | SL 6.9 | VM                   | 4       | 6 GB  | 192 GB               |                             |
|  ·  itb-cm                                   | HTCondor CM             | SL 7.4 | VM                   | 4       | 6 GB  | 192 GB               |                             |
|  ·  <span class="old">itb-glidein</span>     | GlideinWMS VO frontend? | SL 6.3 | VM                   | 3       | 6 GB  | 50 GB                |                             |
|  ·  <span class="old">itb-gums-rsv</span>    | GUMS, RSV               | SL 6.3 | VM                   | 3       | 6 GB  | 50 GB                |                             |
|  ·  <span class="off">itb-hdfs-name1</span>  | — (so far)              | SL ?   | VM                   | 4       | 6 GB  | 192 GB               |                             |
|  ·  <span class="old">itb-hdfs-name2</span>  | — (so far)              | SL 6.3 | VM                   | 3       | 6 GB  | 50 GB                |                             |
|  ·  <span class="old">itb-se-hdfs</span>     | — (so far)              | SL 6.3 | VM                   | 3       | 6 GB  | 50 GB                |                             |
|  ·  <span class="old">itb-se-xrootd</span>   | — (so far)              | SL 6.3 | VM                   | 3       | 6 GB  | 50 GB                |                             |
|  ·  itb-submit                               | HTCondor submit         | SL 6.9 | VM                   | 4       | 6 GB  | 192 GB               |                             |
|  ·  <span class="off">itb-xrootd</span>      | — (so far)              | SL ?   | VM                   | 4       | 6 GB  | 192 GB               |                             |
| itb-host-2                                   | worker node             | SL 6.9 | Xeon E5-2450 2.10GHz | 16 / 32 | 64 GB | 352 GB in $(EXECUTE) |                             |
| itb-host-3                                   | worker node             | SL 7.4 | Xeon E5-2450 2.10GHz | 16 / 32 | 64 GB | 352 GB in $(EXECUTE) |                             |

(Data last updated 2017-10-13 by Tim C. <span class="old">Red</span> indicates a host that has yet to be rebuilt; <span class="off">Blue</span> is rebuilt but currently off.)


## ITB Goals

Goals for the Madison ITB site are now maintained in [a Google document](https://docs.google.com/document/d/1H4r8d2cznTKwnvPZGhj63-c7HMF9c_7izeU8dxerPiM/).


## Configuration

Basic host configuration is handled by Ansible and a local Git repository of playbooks.

### Git Repository

The authoritative Git repository for Madison ITB configuration is `gitolite@git.chtc.wisc.edu:osgitb`.  Clone the
repository and push validated changes back to it.

### Ansible

The `osghost` machine has Ansible 2.3.1.0 installed via RPM.  Use other hosts and versions at your own risk.

#### Common Ansible commands

**Note:**

- For critical passwords, see Tim C. or other knowledgeable Madison OSG staff in person
- All commands below are meant to be run from the top directory of your `osgitb` Git repo (e.g. on `osghost`,
  not on the target machine)

To run Ansible for the first time for a new machine (using the `root` password for the target machine when prompted):

    :::console
    ansible-playbook secure.yml -i inventory -u root -k --ask-vault-pass -f 20 -l HOST-PATTERN
    ansible-playbook site.yml -i inventory -u root -k -f 20 -l HOST-PATTERN

The `HOST-PATTERN` can be a glob-like pattern or a regular expression that matches host names in the inventory file; see
Ansible documentation for details.

After initial successful runs of both playbooks, subsequent runs should replace the `-u root -k` part with `-bK` to use
your own login and `sudo` *on the target machine*.  For example:

    :::console
    ansible-playbook secure.yml -i inventory -bK --ask-vault-pass -f 20 -l HOST-PATTERN
    ansible-playbook site.yml -i inventory -bK -f 20 [ -l HOST-PATTERN ]

Omit the `-l` option to apply configuration to all hosts.

If you want to run only a single role from a playbook, use the `-t` option with the corresponding tag name.
For example, to run the iptables tag/role:

    :::console
    ansible-playbook secure.yml -i inventory -bK --ask-vault-pass -f 20 -l HOST-PATTERN -t iptables

If you have your own playbook to manage personal configuration, run it as follows:

    :::console
    ansible-playbook PLAYBOOK-PATH -i inventory -f 20 [ -l HOST-PATTERN ]

#### Adding host and other certificates

(This is in very rough form, but the key bits are here.)

1. Ask Mat to get new certificates — be sure to think about `http`, `rsv`, and other service certificates
2. Wait for Mat to tell you that the new certificates are in `/p/condor/home/certificates`
3. `scp -p` the certificate(s) (`*cert.pem*` and `*key.pem`) to your home directory on `osghost` or whatever machine you use for Ansible
   Note that if you are renewing a certificate, only the `*cert.pem` will be updated and the `*key.pem` will remain the same.
4. Find the corresponding certificate location(s) in the Ansible `roles/certs/files` directory
5. `cp -p` the certificate files over the top of the existing Ansible ones (or create new, equivalent paths)
6. Run `ansible-vault encrypt FILE(S)` to encrypt the files — get the Ansible vault password from Tim C. if you need it
   Note that only the `*key.pem` files need to be encrypted, as the `*cert.pem` files are meant to be public.
   If the (unencrypted) `*key.pem` file is not getting updated, there is no need to re-encrypt a new copy.
7. Verify permissions, contents (you can `cat` the encrypted files), etc.
8. Apply the files with something like `ansible-playbook secure.yml -i inventory -bK -f 20 -t certs --ask-vault-pass`
9. Commit changes (now or after applying)
10. Push changes to origin (`gitolite@git.chtc.wisc.edu:osgitb`)

#### Doing yum updates

1. Check to see if updates are needed and, if so, what would be updated:

        :::console
        ansible [ HOST | GROUP ] -i inventory -bK -f 20 -m command -a 'yum check-update'

    You can name a single `HOST` or an inventory `GROUP` (such as the handy `current` group); with a group, you can
    further restrict the hosts with a `-l` option.

    **Note:** `yum check-update` exits with status code `100` when it succeeds in identifying packages to update;
    therefore Ansible shows such results as failures.

1. Review the package lists to be updated and decide whether to proceed with all updates or limited ones

1. Do updates:

        :::console
        ansible [ HOST | GROUP ] -i inventory -bK -f 20 -m command -a 'yum --assumeyes update' [ -l LIMITS ]

1. Check if anything needs restarting:

        :::console
        ansible [ HOST | GROUP ] -i inventory -bK -f 20 -m command -a 'needs-restarting'

1. If needed (and if unsure, ask a sysadmin), reboot machines:

        :::console
        ansible [ HOST | GROUP ] -i inventory -bK -f 20 -m command -a '/sbin/shutdown -r +1' [ -l LIMITS ]

1. Check if machines are up, running, and synchronized to the time servers

        :::console
        ansible [ HOST | GROUP ] -i inventory -f 20 -m command -a '/usr/sbin/ntpq -p'

#### Updating HTCondor from Upcoming

Something like this:

    :::console
    ansible condordev -i inventory -bK -f 10 -m command -a 'yum --enablerepo=osg-upcoming --assumeyes update condor'


## Monitoring

### HTCondor-CE View

Once we sort out our firewall rules, pilot, VO, and schedd availability graphs should be available
[here](http://itb-ce1.chtc.wisc.edu:59619) through HTCondor-CE View.

### Tracking payload jobs via Kibana

At this time, the easest way to verify that payload jobs are running within the glideinWMS pilots is to track their records via <a href="https://gracc.opensciencegrid.org/kibana/app/kibana#/discover?_g=(refreshInterval:(display:Off,pause:f,value:0),time:(from:now%2Fw,mode:quick,to:now%2Fw))&_a=(columns:!(_source),index:%27gracc.osg-itb.raw-\*%27,interval:auto,query:(query_string:(analyze_wildcard:!f,query:%27\*%27)),sort:!(EndTime,desc))">Kibana</a>. To view all payload jobs that have run on our ITB site in the past week, use <a href="https://gracc.opensciencegrid.org/kibana/app/kibana#/discover?_g=(refreshInterval:(display:Off,pause:f,value:0),time:(from:now%2Fw,mode:quick,to:now%2Fw))&_a=(columns:!(ProbeName),index:%27gracc.osg-itb.raw-\*%27,interval:auto,query:(query_string:(analyze_wildcard:!f,query:%27ResourceType:%20Payload%20AND%20ProbeConfig:%20%22condor:itb-ce1.chtc.wisc.edu%22%27)),sort:!(EndTime,desc))">this query</a>.


## Making a New Virtual Machine on itb-host-1

For this procedure, you will need login access to the CHTC Cobbler website, which is separate from other CHTC logins.
If you do not have an account, request one from the CHTC system administrators.

1. If this is a new host (combination of MAC address, IP address, and hostname), set up host with CHTC Infrastructure
    1. Pick a MAC address, starting with `00:16:3e:` followed by three random octets (e.g., `00:16:3e:f7:29:ee`)
    1. Email <htcondor-inf@cs.wisc.edu> with a request for a new OSG ITB VM, including the chosen MAC address
    1. Wait to receive the associated IP address for the new host

1. Create or edit the Cobbler system object for the host
    1. Access <https://cobbler-widmir.chtc.wisc.edu/cobbler_web>
    1. In the left navigation area, under “Configuration”, click the “Systems” link
    1. If desired, filter (at the bottom) by “name” on something like `itb-*.chtc.wisc.edu`
    1. For a new host, select an existing, similar one and click “Copy” to the right of its entry, then give it a name and click “OK”
    1. For a newly copied or any existing host, click “Edit” to the right of its entry
    1. In the **first** “General” section: select a “Profile” of “Scientific\_6\_8\_osg\_vm” or “Scientific\_7\_2\_osg\_vm”
    1. In the **second** “General” section, check the “Netboot Enabled” checkbox
    1. In the “Networking (Global)” section, set “Hostname” to the fully qualified hostname for the virtual machine
    1. In the “Networking” section, select the “eth0” interface to edit, and set the “MAC Address”, “IP Address”, and “DNS Name” fields for the host
    1. Click the “Save” button
    1. In the left navigation area, under “Actions”, click the “Sync” link

1. Log in to `itb-host-1` and become `root`

1. Create the libvirt definition file
    1. Create a new XML file named after the desired hostname (e.g., `itb-ce2.xml`) and copy in the template below
    1. Replace `{{ HOSTNAME }}` with the fully qualified hostname of the new virtual host
    1. Replace `{{ MAC_ADDRESS }}` with the MAC address of the new virtual host (from above)
    1. If desired, edit other values in the XML definition file; ask CHTC Infrastructure for help, if needed
    1. Save the XML file
    1. Create a new, empty disk image for the virtual host, in its correct location (as specified in the XML file):

            :::console
            truncate -s 192G /var/lib/libvirt/images/HOSTNAME.dd
            chown qemu:qemu /var/lib/libvirt/images/HOSTNAME.dd

    1. Load the new host definition into libvirt:

            :::console
            virsh define XML-FILE

1. Install the new machine
    1. Start the virtual machine:

            :::console
            virsh start HOSTNAME

        At this time, the machine will boot over the network, and Cobbler will install and minimally configure the OS,
        then reboot the now-installed machine.  The whole process typically takes 15–20 minutes.  You may be able to
        `ssh` into the machine during the install process, but there is no need to monitor or interfere.

    1. Once the machine is available (which you can only guess at), `ssh` in and verify that the machine basically works
    1. Immediately run Ansible on the machine, first with the `secure.yml` playbook, then the `site.yml` one (see above)
    1. Log in to the machine and look around to make sure it seems OK
    1. When things look good, tell virsh to start the virtual machine when the host itself starts:

            :::console
            virsh autostart HOSTNAME

### Libvirt VM Template

``` xml
<domain type='kvm'>

  <name>{{ HOSTNAME }}</name>

  <memory unit='GiB'>6</memory>
  <vcpu>4</vcpu>
  <os>
    <type>hvm</type>
    <boot dev='network'/>
    <boot dev='hd'/>
    <bios useserial='yes' rebootTimeout='0'/>
  </os>
  <features>
    <acpi/>
    <apic/>
    <pae/>
  </features>

  <devices>

    <emulator>/usr/libexec/qemu-kvm</emulator>

    <disk type='file' device='disk'>
      <source file='/var/lib/libvirt/images/{{ HOSTNAME }}.dd'/>
      <target dev='vda' bus='virtio'/>
    </disk>

    <interface type='bridge'>
      <mac address='{{ MAC_ADDRESS }}'/>
      <source bridge='br0'/>
      <model type='virtio'/>
    </interface>

    <serial type='pty'>
      <target port='0'/>
    </serial>
    <console type='pty'>
      <target type='serial' port='0'/>
    </console>

    <graphics type='vnc' autoport='yes' listen='127.0.0.1'/>

  </devices>
</domain>
```
