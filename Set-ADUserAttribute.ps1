
#
# Match "co" attribute with "c" attribute for all active users created after a certain date
#
# -Rob Nadolski
# -1/31/2018


Import-Module activedirectory

$Checkdate = Get-Date "2/12/2016"
$users = Get-ADUser -Filter {(whenCreated -le $Checkdate) -and (enabled -eq "True")} -property whenCreated,c,co |Select-Object Name,UserPrincipalName,whenCreated,c,co,enabled
$header = "Name,UPN,CreatedDate,c,co,enabled,corrected"
$header |out-file .\users.csv -Append -NoClobber

# Build hash table with Country Codes
# Format:
# c,co
# AE,Utd.Arab Emir.
# AT,Austria
# AU,Australia
# etc.
$hash = @{}
$CCTable = Import-Csv .\CountryCodes.csv
foreach ($r in $CCTable) { $hash[$r.c]=$r.co }

foreach ($user in $users) {

    if (!$user.c)
    {
        write-host $user.Name "- Null"
        $Corrected = "False"
    }
    elseif ($user.co -ne $hash[$user.c]) 
    {
        #Correct co attribute
        Set-ADUser $user.Name -Replace @{co=$user.c}
        write-host $user.Name "- Make correction"
        $Corrected = "True"
    }
    else
    {
        #Do not change co attribute
        write-host $user.Name "- No correction needed"
        $Corrected = "False"
    }
    $output = $user.Name + "," + $user.UserPrincipalName + "," + $user.whenCreated + "," + $user.c + "," + $user.co + "," + $user.enabled + "," + $Corrected
    $output |Out-File .\users.csv -Append -NoClobber    
    
}
