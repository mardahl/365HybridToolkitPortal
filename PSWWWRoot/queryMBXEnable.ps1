#Authetnicated user check - since this is a priviledged action
. $HomeDirectory\Authentication.ps1
if($auth -eq $false) {
@"
<h1>ACCESS DENIED!</h1>
<p>You are not a member of $group</p>
"@
exit 0
}

#execute section

if(-not (Get-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn)) {
    Write-Verbose "Connecting to Exchange on-prem" -Verbose
    try {
        Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn -ErrorAction Stop
    } catch {
        $Error
        exit 1
    }
}
$upn = [uri]::UnescapeDataString($PoSHQuery.UPN)
$group = [uri]::UnescapeDataString($PoSHQuery.Group)
$alias = $($upn -split "@")[0]
try {
    $enable = Enable-RemoteMailbox -Identity $upn -Alias $alias -RemoteRoutingAddress "$($alias)@lemu.mail.onmicrosoft.com" -ErrorAction Stop
    $licGroup = Get-ADGroup $group | select -First 1
    $licGroup | Add-ADGroupMember -Members $alias -ErrorAction SilentlyContinue
    start-sleep -Seconds 10
    $result = "ok"
} catch {
    $result = "failed"
}


@"
{"result": "$($result)"}
"@