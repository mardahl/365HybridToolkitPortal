#Authetnicated user check - since this is a priviledged action
. $HomeDirectory\Authentication.ps1
if($auth -eq $false) {
@"
<h1>ACCESS DENIED!</h1>
<p>You are not a member of $group</p>
"@
exit 0
}
#Get values from query string
$upn = [uri]::UnescapeDataString($PoSHQuery.UPN)
#kill existing EXO sessions
$killEXOsessions = Get-PSSession | Where ComputerName -like "outlook*" | Remove-PSSession
#EXO connection
try {
    write-verbose "connecting to exchange online..." -verbose
    #fetch config
    [xml]$config = Get-Content "$HomeDirectory\config.xml"
    $exAuth = $config.configuration.ExchangeOnline.Authentication
    Connect-ExchangeOnline -CertificateThumbprint $exAuth.clientCert -AppId $exAuth.appId -Organization $exAuth.tenantName -ShowBanner:$false -Prefix "EOL" -ErrorAction Stop
} catch {
    write-verbose "Exchange online connection failed!" -verbose
@"
{"result": "failed","message": "Could not connect to Exchange Online! $_"}
"@
    exit 1
}


#Exchange on-prem connection
if(-not (Get-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn)) {
    try {
        Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn -ErrorAction Stop
    } catch {
@"
{"result": "failed","message": "$_"}
"@
        exit 1
    }
}

#Wait for mailbox creating in case it is a newly synced mailbox
$found = $false
Do {
    $cmdresult = Get-EOLMailbox -Identity $upn -ErrorAction SilentlyContinue | Select *GUID* -ErrorAction Stop
    if ($cmdresult) {
        $found = $true
    } else {
        write-verbose "Still waiting on exchange online..." -verbose
        Start-Sleep -Seconds 5
    }
} While ($found -eq $false)
write-verbose "User is provisioned online!" -verbose
#get exchange GUIDs from Online
try { 
    [System.Guid]$exoGUID = $cmdresult.ExchangeGuid
    [System.Guid]$archGUID = $cmdresult.ArchiveGuid
} catch {
    $result = "failed"
    $returnValues = "The query against Exchange Online for exchange GUID failed! $_"
@"
{"result": "$($result)","message": "$returnValues"}
"@
    exit 1
}

#Set on-prem exchange GUIDs to match Online
try {
    $cmdresult = Set-RemoteMailbox $upn -ExchangeGuid $exoGUID -ArchiveGuid $archGUID -ErrorAction Stop
    $result = "ok"
    $returnValues = "Exchange GUID Sync completed!"
} catch {
    $result = "failed"
    $returnValues = "Attempting to set Exchange GUID on-prem failed! $_"
@"
{"result": "$($result)","message": "$returnValues"}
"@
    exit 1
}
@"
{"result": "$($result)","message": "$returnValues"}
"@