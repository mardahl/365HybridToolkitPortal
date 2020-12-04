if(-not (Get-PSSession)) {
    Write-Verbose "Connecting to Exchange online" -Verbose
    try {
        Connect-ExchangeOnline -CertificateThumbprint "FE58F963AAA1A73F53FAE5E686BF9E910D39393A" -AppId "55a993b7-1bf9-460d-bec9-46f8a2312f76" -Organization "lemu.onmicrosoft.com" -ShowBanner:$false -Prefix "EOL"
    } catch {
        $Error
        exit 1
    }
}
$upn = [uri]::UnescapeDataString($PoSHPost.UPN)
$result = Get-User -Filter {(RecipientType -EQ "User") -and (Department -NE $null)} -WarningAction SilentlyContinue | Select Name, UserPrincipalName | Sort Name
@"
$($result | ConvertTo-Json)
"@