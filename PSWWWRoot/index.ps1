#Check for authentication
. $HomeDirectory\Authentication.ps1
if($auth -eq $false) {
@"
<h1>ACCESS DENIED!</h1>
<p>You are not a member of $group</p>
"@
exit 0
}

#Build the exchange tools webpage

#determine if we are on the start page or not
if($PoSHQuery.page){
    $securePage = $([uri]::EscapeDataString($PoSHQuery.page))
    $page = Join-Path $HomeDirectory $securePage
} else {
    $page = Join-Path $HomeDirectory "home"
}

#rendering
@"
$output
$(. $HomeDirectory\nav.ps1)
$(. "$page.ps1")
$(. $HomeDirectory\footer.ps1)
"@