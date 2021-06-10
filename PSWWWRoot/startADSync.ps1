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

    try {
        #Fetch servername from config
            [xml]$config = Get-Content "$HomeDirectory\config.xml"
            [string[]]$aadSyncServer = $config.configuration.AzureADConnect.hostname


        if($aadSyncServer -eq "") {

            #Get ADSync server name automatically from MSOL account
            $MSOLusers = Get-ADUser -Filter {Name -like "msol_*"} -Properties * -ErrorAction Stop
            $currentMSOLdate = (Get-Date).AddYears(-10)
            foreach ($user in $MSOLusers) {
                if($currentMSOLdate -lt $user.whenChanged) {
                    $currentMSOLdate = $user.whenChanged
                    $syncServername = $user.Description -match "(?<=computer\s).*(?=\sconfigured)"
                    $syncServername = $Matches[0]
                }
            }
        } else {
            $syncServername = $aadSyncServer
        }
    } catch {
        $result = "failed"
        $returnValues = "host: could not determine host from MSOL account in AD - message: startADSync.ps failed"

@"
{"result": "$($result)"}
"@
        exit 1
    }



try {
    $session = New-PSSession -computerName $syncServername -ErrorAction Stop
    $outputCommand = Invoke-command { Import-module adsync; Start-adsyncsynccycle -policytype delta; } -session $session -ErrorAction Stop
    $returnValues = "host: $($outputCommand.PSComputerName) - message: $($outputCommand.Result)"
    $result = "ok"
} catch {
    $result = "failed"
    $returnValues = "host: $syncServername - message: Sync might already be running"
}

@"
{"result": "$($result)","output": "$returnValues"}
"@
