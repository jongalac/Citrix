function Test-DGAvailability ($payload)
{
    #Add citrix modules
    asnp citrix*
    #iterate through the required delivery groups
    foreach ($DG in $payload) {
        #get the number of machines that are either unregistered or in maintenance mode
        $UnavailableMachines = (Get-BrokerMachine|Where-Object {$_.DesktopGroupName -eq $dg.Name -and ($_.RegistrationState -ne "registered" -or $_.InMaintenanceMode -eq $true)}).count
        #check if we breached the WarnOn parameter
        if($UnavailableMachines -ge $dg.warnon) {
            #check if we breached the ErrorOn parameter
            if ($UnavailableMachines -ge $dg.ErrorOn) {
                #ErrorOn breached - log the message
                $message = "Delivery group: `""+$dg.name+"`" has "+$UnavailableMachines+" unavailable machines which is at or more than defined by ErrorOn Parameter"
                Log-Event -log "Application" -id 999 -level "Error" -message $message
                continue
            }
            #WarnOn breached - log the message
            $message = "Delivery group: `""+$dg.name+"`" has "+$UnavailableMachines+" unavailable machines which is at or more than defined by the WarnOn parameter"
            Log-Event -id 999 -level "Warning" -message $message
        }
    }
}
function Log-Event ($id,$level,$message){
if ((Get-ChildItem HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\application).pschildname -notcontains "CtxVDAScripting") {New-EventLog -LogName Application -Source "CtxVDAScripting"}
Write-EventLog -LogName Application -Source "CtxVDAScripting" -EntryType $level -Message $message -EventId $id
}
Export-ModuleMember -Function Test-DGAvailability
