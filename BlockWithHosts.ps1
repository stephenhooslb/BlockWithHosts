# This was stolen from Tom's github and modified by Stephen Hoos.
# The goal to block the websites listed in a file "hostnames.txt" by adding a 127.0.0.1 entry to the hosts file for each hostname in the file.  
# I am sure this is inelegant, but I am new.  Read domains from a file, and one entry to the hosts file if it is not there already.
# By Tom Chantler - https://tomssl.com/2019/04/30/a-better-way-to-add-and-remove-windows-hosts-file-entries/

$DesiredIP = "127.0.0.1"

#Requires -RunAsAdministrator
$hostsFilePath = "$($Env:WinDir)\system32\Drivers\etc\hosts"
$hostsFile = Get-Content $hostsFilePath
Add-Content -Encoding UTF8  $hostsFilePath "" #add one carriage return so you are starting on a new line
foreach($Hostname in (Get-Content ".\hostnames.txt") ) {
    Write-Host "About to add $desiredIP for $Hostname to hosts file" -ForegroundColor Gray

    $escapedHostname = [Regex]::Escape($Hostname)
    $patternToMatch = If ($CheckHostnameOnly) { ".*\s+$escapedHostname.*" } Else { ".*$DesiredIP\s+$escapedHostname.*" }
    If (($hostsFile) -match $patternToMatch)  {
        Write-Host $desiredIP.PadRight(20," ") "$Hostname - not adding; already in hosts file" -ForegroundColor DarkYellow
    }    
    Else {
        Write-Host $desiredIP.PadRight(20," ") "$Hostname - adding to hosts file... " -ForegroundColor Yellow -NoNewline
        Add-Content -Encoding UTF8  $hostsFilePath ("$DesiredIP".PadRight(20, " ") + "$Hostname")
        Write-Host " done"
    }
    Start-Sleep -s 1 #sleep time because going too fast can create an error "editing an open file"
}
