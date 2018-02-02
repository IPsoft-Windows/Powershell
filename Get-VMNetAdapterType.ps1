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

$VCs = @("aarwinvc01.corp.duracell.com", "becn-wvvctrp01.corp.duracell.com", "becn-wvvctrp02.corp.duracell.com", "dgwinvc02.corp.duracell.com")

foreach ($VC in $VCs) {
    Connect-VIServer $vc
    Get-VM | Get-NetworkAdapter |select @{N="vCenter";E={$vc}},@{N="VM";E={$_.Parent.Name}},@{N="OS";E={$_.Parent.ExtensionData.Guest.GuestFullName}},Name,Type |Export-Csv C:\Users\nadolski.r\Desktop\netadapters.csv -Append
    Disconnect-VIServer * -Confirm:$false
}
