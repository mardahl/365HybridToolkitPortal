import-module ActiveDirectory
$result = Get-ADGroup -Filter {(Name -like "licens*") -and ((Name -like "*365*") -or (Name -like "*exchange*"))} -WarningAction SilentlyContinue | Select Name, SamAccountName | Sort Name
@"
$($result | ConvertTo-Json)
"@