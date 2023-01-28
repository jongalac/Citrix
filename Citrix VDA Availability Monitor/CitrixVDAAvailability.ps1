#Must be run with elevated rights to be able to quary the Citrix Site/Farm.
#The $ToMonitor variable is a list of hash table objects representing the Delivery Groups to monitor.
#Each hash table object requires the following properties-
# Name - The name of the Delivery group (As shown in Studio)
# WarnOn - The number of unavailable machines to trigger a warning alert.
# ErrorOn - The number of unavailabe machines to trigger an Error alert.
# example = $ToMonitor = @{"name"="Hosted Apps and Desktop";"WarnOn"=1;"ErrorOn"=2},@{"name"="Image UAT";"WarnOn"=1;"ErrorOn"=1}
#sample
$ToMonitor = @{"name"="Hosted Apps and Desktop";"WarnOn"=1;"ErrorOn"=2},@{"name"="Image UAT";"WarnOn"=1;"ErrorOn"=1}
Import-Module C:\Insentra\CitixVDAMonitorExtensions.psm1
Test-DGAvailability -payload $ToMonitor
