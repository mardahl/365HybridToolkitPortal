# 365HybridToolkitPortal
A web based interface to managing your Microsoft 365 Hybrid environment

Dirty check list:
- Made to be installed on a server with Exchange Online Management Tools installed (uses the powershell modules)
- Create a service account to run the PoSH web server
- install PoSH server
- Create selfsigned cert for the service account running the PoSh server (because the service account must have access to cert store).
- Create app registratin in Azure AD - use the self signed certificate for access, and give Exchange.ManageAsApp permission.
- Add required details to the config xml
- Create a scheduled task to run the start webserver script as the service account.
- edit start web server script as you see fit.
- start the scheduled task and access the local web server to use the portal.

# Access restriction
The werbserver uses integrated windows authentication, and access is granted by membership of an AD group, if user isnot a member, they will be told.
If you dont have the AD group, just create the one it mentions, or edit the code.
