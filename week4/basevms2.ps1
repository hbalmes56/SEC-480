$sourceVM = Read-Host "Enter the name of the VM to clone"
$snapshotName = Read-Host "Enter the snapshot to use for the base image"
$newVMName = Read-Host "Enter the name for the new VM"

#Connecting to server
$vserver = "vcenter.hadley.local"
$username = "hadley-adm@hadley.local"
$password = "Skittles101!"
Connect-VIServer -Server $vserver -User $username -Password $password

#Source VM
$vm = Get-VM -Name $sourceVM
$snapshot = Get-Snapshot -VM $vm -Name $snapshotName
$vmhost = Get-VMHost -Name "192.168.3.202"
$ds = Get-DataStore -Name "datastore2"
$linkedName = "{0}.linked" -f $vm.name

#Create temp VM
$linkedvm = New-VM -LinkedClone -Name $linkedName -VM $vm -ReferenceSnapshot $snapshot -VMHost $vmhost -Datastore $ds

#Create full VM
$newvm = New-VM -Name $newVMName -VM $linkedvm -VMHost $vmhost -Datastore $ds

#Create new snapshot
$newvm | new-snapshot -Name "Base"

#Cleanup temp linked clone
$linkedvm | Remove-VM
