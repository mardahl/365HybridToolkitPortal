#Requires -RunAsAdministrator
Stop-Transcript
Start-Transcript -Path "C:\365HTK\startWebServer_lastStart_log.txt" -Force 
Try {

} catch {
    Exit 1
} Finally {
    Stop-Transcript
}

#Requires -RunAsAdministrator
Stop-Transcript
Start-Transcript -Path "C:\Scripts\startWebServer_lastStart_log.txt" -Force 
Try {
    $hostname= "$($env:COMPUTERNAME).$($env:USERDNSDOMAIN)"
    Start-PoSHServer -Hostname $hostname -Port 8080 –HomeDirectory “C:\365HTK\PSWWWRoot” –LogDirectory “C:\365HTK\PSWWWLogs” -ErrorAction Stop
    ###SSL version:
    #$hostname= "host.domain.tld"
    #Start-PoSHServer -Hostname $hostname -Port 8080 –SSL –SSLIP "10.x.x.x" -SSLName "host.domain.tld" –SSLPort 4443 –HomeDirectory “C:\365HTK\PSWWWRoot” –LogDirectory “C:\365HTK\PSWWWLogs” -ErrorAction Stop
} catch {
    Write-Verbose "Server initialization failed! ending transcript." -Verbose
    Write-Host $_
    Exit 1
} Finally {
    Write-Verbose "Server initialization completed, ending transcript." -Verbose
   Stop-Transcript
}
