# Get-vCenter-Security.ps1
# Exports source Folders/Roles/Permissions/VM Locations

Import-Module "VMware.VimAutomation.Core"

$creds = Get-Credential
Connect-VIServer "aarwinvc01.corp.duracell.com" -Credential $creds

$directory = "c:\temp"
$datacenter = "Aarschot DC"

new-item $directory -type directory -erroraction silentlycontinue
get-virole | where {$_.issystem -eq $false} | export-clixml $directory\roles.xml
Get-VIPermission | export-clixml $directory\permissions.xml
$dc = get-datacenter $datacenter
$dc | get-folder | where {$_.type -eq "VM"} | select name,parent | export-clixml -depth 5 $directory\folders.xml
$dc | get-vm | select name,folder | export-clixml -depth 6 $directory\vm-locations.xml 

Disconnect-VIServer * -Confirm:$false
