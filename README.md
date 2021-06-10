# 365HybridToolkitPortal
A web based interface to managing your Microsoft 365 Hybrid environment [BETA]
(This is a work in progress, please feel free to contribute via pull requests)

Current features:
- Start AADSync from webinterface
  - Allows users with access to the portal to start a sync, without having access to the actual sync server.
- Create new Exchange Online User without having to create migration batch.
  - Script will sync the Exchange Guid in reverse to enable off-boarding from EXO

![demo of new user provisioning](https://github.com/mardahl/365HybridToolkitPortal/blob/4f174b8f8689e1053d2366b3d21e048a1a1ce0e9/newuser.gif "New User Provisioning")


Quick and Dirty setup check list:
- Made to be installed on a server with Exchange Management Tools installed (uses the powershell modules)
- place code in c:\365HTK\
- Install these modules in PS (5.1 minimum)
  - install-module az
  - install-module exchangeonlinemanagement 
- Create a service account to run the PoSH web server
  - Member of Organization Management security group (AD DS)
  - Member of Remote management users, ADSyncBrowse and ADSyncOperators local groups on the on-prem sync server
- install PoSH server
  - Enable Windows Auth in C:\Program Files\PoSHServer\modules\PoSHServer\modules\config.ps1
  - Documentation here: http://www.poshserver.net/files/PoSHServer.Documentation.pdf
- Create app registration in Azure AD - and give it the application permission "Exchange.ManageAsApp".
  - Look at this guide if you are having trouble finding the permissions https://www.michev.info/Blog/Post/3180/exchange-api-permissions-missing
- Create selfsigned cert for the service account running the PoSh server
  - Modify the script to use the app (Client) ID that you just created.
  - the service account must have access to cert store)
  - get the tumbprint for the config xml.
- Add required details to the config xml in PSWWWRoot
- Create a scheduled task to run the start webserver script as the service account when computer starts.
- edit start web server script as you see fit.
- start the scheduled task and access the local web server on port 8080 to use the portal.

# Access restriction
The web server uses integrated windows authentication, and access is granted by membership of "365HTK-Access" AD group, if user is not a member, they will be told.
If you dont have the AD group, just create it and add members, or edit the code in authentication.ps1.
