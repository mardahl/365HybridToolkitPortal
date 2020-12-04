#Requires -RunAsAdministrator
Stop-Transcript
Start-Transcript -Path "C:\365HTK\startWebServer_lastStart_log.txt" -Force 
Try {
    $hostname= "$($env:COMPUTERNAME).$($env:USERDNSDOMAIN)"
    Start-PoSHServer -Hostname $hostname -Port 8080 –HomeDirectory “C:\365HTK\PSWWWRoot” –LogDirectory “C:\365HTK\PSWWWLogs” -ErrorAction Stop
} catch {
    Exit 1
} Finally {
    Stop-Transcript
}