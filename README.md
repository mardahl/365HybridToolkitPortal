# 365HybridToolkitPortal
A web based interface to managing your Microsoft 365 Hybrid environment

Current features:
- Start AADSync from webinterface
 - Allows users with access to the portal to start a sync, without having access to the actual sync server.
- Create new Exchange Online User without having to create migration batch.
 - Script will sync the Exchange Guid in reverse to enable off-boarding from EXO

Quick and Dirty setup check list:
- Made to be installed on a server with Exchange Online Management Tools installed (uses the powershell modules)
- place code in c:\365HTK\
- Create a service account to run the PoSH web server
 - Member of Exchange Admins
 - Member of Remote management users and AADSync admins on the sync server
- install PoSH server
- Create selfsigned cert for the service account running the PoSh server (because the service account must have access to cert store) - get the tumbprint for the config xml.
- Create app registratin in Azure AD - use the self signed certificate for access, and give Exchange.ManageAsApp permission.
- Add required details to the config xml in PSWWWRoot
- Create a scheduled task to run the start webserver script as the service account when computer starts.
- edit start web server script as you see fit.
- start the scheduled task and access the local web server to use the portal.

# Access restriction
The web server uses integrated windows authentication, and access is granted by membership of "365HTK-Access" AD group, if user is not a member, they will be told.
If you dont have the AD group, just create it and add members, or edit the code in authentication.ps1.
