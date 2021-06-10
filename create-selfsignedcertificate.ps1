<#
    Script to create self-signed 10 year valid cert and upload to App registration Modified version of MS script by @michael_mardahl
#>


$AppClientID = "55xxxxb7-1xx9-4x0d-bex9-x6f8xxxxx76" # App Id from Azure AD that needs certificate auth
$PfxCertPath = 'C:\365HTK\AppAuth.pfx' #Place to store temporary cert file
$CertificatePassword = $(get-date -Format ddMMMyyyy) #A password you choose to save the cert with
$certificateName = 'AZAppCert' #A certificate name you choose
$ErrorActionPreference = 'Stop'

try {
    Get-AzSubscription -ErrorAction stop
} catch {
    Connect-AzAccount
}
 
try {

#Creating secure password string
$SecurePassword = ConvertTo-SecureString -String $CertificatePassword -AsPlainText -Force
 
#Creating 10 year valid self-signed cert
$NewCert = New-SelfSignedCertificate -CertStoreLocation Cert:\LocalMachine\My `
                                     -DnsName $certificateName `
                                     -Provider 'Microsoft Enhanced RSA and AES Cryptographic Provider' `
                                     -KeyAlgorithm RSA `
                                     -KeyLength 2048 `
                                     -NotAfter (Get-Date).AddYears(10)
#Exporting cert to file
Export-PfxCertificate -FilePath $PfxCertPath `
                      -Password $SecurePassword `
                      -Cert $NewCert -Force
} catch {
    $_
    exit 1
}



#Configure required flags on the certificate
$flags = [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable `
    -bor [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::PersistKeySet `
    -bor [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::MachineKeySet

# Load the certificate into memory
$PfxCert = New-Object -TypeName System.Security.Cryptography.X509Certificates.X509Certificate2 -ArgumentList @($PfxCertPath, $CertificatePassword, $flags) -ErrorAction Stop



#Upload cert to Azure App Registration
$binCert = $PfxCert.GetRawCertData() 
$certValue = [System.Convert]::ToBase64String($binCert)
New-AzADAppCredential -ApplicationId $AppClientID -CertValue $certValue -StartDate $PfxCert.NotBefore -EndDate $PfxCert.NotAfter
