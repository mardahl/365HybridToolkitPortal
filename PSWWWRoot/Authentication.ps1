if ($PoSHUserName)
{
    $user = $PoSHUserName -split "\\"
    $userObj = Get-ADUser $user[1]

    $group = "ExchangeTools-Access"
    $members = Get-ADGroupMember -Identity $group -Recursive | Select -ExpandProperty SID

    If ($members -contains $userObj.SID) {
            $auth = "$($user[1]) exists in the group"
        } Else {
            $auth = $false
    }

}
else
{
    $auth = $false
}