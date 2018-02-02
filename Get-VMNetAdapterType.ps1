#########################################
#
# Loop through vCenters 
# Get type of network adapter for each VM
# Export to CSV
#
# -Rob Nadolski
# -7/7/2017
#
#########################################


Import-Module "VMware.VimAutomation.Core"

$VCs = @("server01.domain.com", "server02.domain.com")

foreach ($VC in $VCs) {
    Connect-VIServer $vc
    Get-VM | Get-NetworkAdapter |select @{N="vCenter";E={$vc}},@{N="VM";E={$_.Parent.Name}},@{N="OS";E={$_.Parent.ExtensionData.Guest.GuestFullName}},Name,Type |Export-Csv C:\Users\me\Desktop\netadapters.csv -Append
    Disconnect-VIServer * -Confirm:$false
}
