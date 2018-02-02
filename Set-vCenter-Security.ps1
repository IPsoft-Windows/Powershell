# Set-vCenter-Security.ps1
# Run on destination vCenter to recreate VM folder structure and permissions

Import-Module "VMware.VimAutomation.Core"

$creds = Get-Credential
Connect-VIServer "server01.domain.com" -Credential $creds

$directory = "c:\temp"
$datacenter = "Site DC"

#Read in the folder structure from the Get script and create those VM Folders
foreach ($thisFolder in (import-clixml $directory\folders.xml | where {!($_.name -eq "vm")})) {(get-datacenter $datacenter) | get-folder $thisFolder.Parent | new-folder $thisFolder.Name -confirm:$false}

#Read in Roles from Get script and create those Roles
foreach ($thisRole in (import-clixml $directory\roles.xml)){if (!(get-virole $thisRole.name -erroraction silentlycontinue)){new-virole -name $thisRole.name -Privilege (get-viprivilege -id $thisRole.PrivilegeList)}}

#Read in Permissions from Get script and assign those permissions
foreach ($thisPerm in (import-clixml $directory\permissions.xml)) {get-folder $thisPerm.entity.name | new-vipermission -role $thisPerm.role -Principal $thisPerm.principal -propagate $thisPerm.Propagate}

#Read in the VM Folder locations and move the VMs to their Folders; only execute this line after all VMs have been moved into the new inventory
#$allVMs = import-clixml C:\Temp\vm-locations.xml
#foreach ($thisVM in $allVMs) {get-vm $thisVM.name | move-vm -destination (get-folder $thisVM.folder)} 

Disconnect-VIServer * -Confirm:$false
