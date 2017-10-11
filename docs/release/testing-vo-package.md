# Testing VO Package releases

This document contains a basic recipe for testing a VO Package release

## Prerequisites

Testing the VO package requires a few components:
   * X.509 certificate with membership to at least one VO
   * System with working GUMS installation
   * System with OSG installation (voms-proxy-init and edg-mkgridmap)
   

## Testing `voms-proxy-init`

Login in the system that has voms-proxy-init installed.  Make sure that you have the correct 
vo-client rpms installed and that your X.509 certificate is in your home directory.  For each
VO that you have membership in, run the following `voms-proxy-init -voms [VO]` where `[VO]` is 
the appropriate VO (e.g. osg, cms, etc.).  You should be able to generate a voms-proxy for that
VO without errors.


## Testing `edg-mkgridmap`

Log on to a system with `edg-mkgridmap` installed.  Make sure you have the correct vo-client rpms 
installed (vo-client-edgmkgridmap).  Run `edg-mkgridmap` and check the log output for errors.  
There will be some errors so compare your errors with the errors on previous vo-package tickets to
make sure no new errors have appeared.

## Testing GUMS

Log on to a system with a working GUMS install.  Make sure that you have the correct vo-client 
rpms (osg-gums-config) installed.  


1. Make a backup of `/etc/gums/gums.config` 
1. Copy the mysql database information from `/etc/gums/gums.config` to `/etc/gums/gums.config.template`
1. Copy `/etc/gums/gums.config.template` to `/etc/gums/gums.config`
1. Start the `tomcat6` service 
1. Go to the GUMS interface (e.g. https://my.host:8443/gums)
1. Go to the Update VO members page and click on the `update VO members` button
1. Once completed, there will probably be some errors.
1. Compare errors to errors on prior vo package update tickets and make sure no new errors have occurred. 

