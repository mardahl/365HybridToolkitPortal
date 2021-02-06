if(-not (Get-PSSession)) {
    Write-Verbose "Connecting to Exchange online" -Verbose
    try {
        [xml]$config = Get-Content "$HomeDirectory\config.xml"
        $exAuth = $config.configuration.ExchangeOnline.Authentication
        Connect-ExchangeOnline -CertificateThumbprint $exAuth.clientCert -AppId $exAuth.appId -Organization $exAuth.tenantName -ShowBanner:$false -Prefix "EOL"
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