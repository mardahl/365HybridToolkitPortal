$upn = $PoSHQuery.UPN
$result = Get-User -Filter {UserPrincipalName -EQ $upn} -WarningAction SilentlyContinue
@"
$($result | ConvertTo-Json)
"@