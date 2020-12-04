if(-not (Get-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn)) {
    Write-Verbose "Connecting to Exchange on-prem" -Verbose
    try {
        Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn -ErrorAction Stop
    } catch {
        $Error
        exit 1
    }
}

$Filter = $PoSHQuery.Filter

if($Filter -like "false"){
    #filter cleared
    $users = Get-User -Filter {(RecipientType -EQ "User")} -WarningAction SilentlyContinue | Select Name, UserPrincipalName | Sort Name
} else {
    #default 2 months and defined department
    $months = (get-date).AddMonths(-2)
    $users = Get-User -Filter {(whenCreated -gt $months) -and (RecipientType -EQ "User") -and (Department -NE $null)} -WarningAction SilentlyContinue | Select Name, UserPrincipalName | Sort Name
}

@"
$($users | ConvertTo-Json)
"@