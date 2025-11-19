#Pref
$WarningPreference = 'SilentlyContinue'

#Variables
$rg = "rg-appgw"
$region = "eastus"
$username = "azureuser" #username for the VM
$plainPassword = "P4ssw0rd11!" #your VM password

#Creating VM credential; use your own password and username by changing the variables if needed
$password = ConvertTo-SecureString $plainPassword -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($username, $password);

# Create Resource Group
New-AzResourceGroup -Name $rg -Location $region

# Create VNet and Subnets
$vnetName = "vnet-appgw"

# Create the subnets
$contacts = New-AzVirtualNetworkSubnetConfig -Name "snet-appgw-contacts" -AddressPrefix "10.0.0.0/24"
$help = New-AzVirtualNetworkSubnetConfig -Name "snet-appgw-help" -AddressPrefix "10.0.1.0/24"

# Creating the VNet with the subnets
New-AzVirtualNetwork -ResourceGroupName $rg -Location $region -Name $vnetName -AddressPrefix "10.0.0.0/16" -Subnet $contacts, $help

# Create virtual machines in each subnet

# Ubuntu VM in snet-appgw-contacts with nginx installation
$contactsScript = @"
#!/bin/bash
apt-get update
apt-get install -y nginx
sudo -s
echo 'This is the page contacts' > /var/www/html/index.html
systemctl restart nginx
"@

$contactsNic = New-AzNetworkInterface -ResourceGroupName $rg -Location $region -Name "nic-contacts" -SubnetId (Get-AzVirtualNetwork -ResourceGroupName $rg -Name $vnetName).Subnets[0].Id

$contactsVmConfig = New-AzVmConfig -VMName "vm-contacts" -VMSize "Standard_B1s" | `
   Set-AzVmOperatingSystem -Linux -ComputerName "vm-contacts" -Credential $credential | `
   Set-AzVmSourceImage -PublisherName "Canonical" -Offer "UbuntuServer" -Skus "18.04-LTS" -Version "latest" | `
   Add-AzVmNetworkInterface -Id $contactsNic.Id

New-AzVM -ResourceGroupName $rg -Location $region -VM $contactsVmConfig

# Run custom script on contacts VM
Invoke-AzVMRunCommand -ResourceGroupName $rg -VMName "vm-contacts" -CommandId 'RunShellScript' -ScriptString $contactsScript

# Ubuntu VM in snet-appgw-help with nginx installation
$helpScript = @"
#!/bin/bash
apt-get update
apt-get install -y nginx
sudo -s
echo 'This is the page help' > /var/www/html/index.html
systemctl restart nginx
"@

$helpNic = New-AzNetworkInterface -ResourceGroupName $rg -Location $region -Name "nic-help" -SubnetId (Get-AzVirtualNetwork -ResourceGroupName $rg -Name $vnetName).Subnets[1].Id

$helpVmConfig = New-AzVmConfig -VMName "vm-help" -VMSize "Standard_B1s" | `
   Set-AzVmOperatingSystem -Linux -ComputerName "vm-help" -Credential $credential | `
   Set-AzVmSourceImage -PublisherName "Canonical" -Offer "UbuntuServer" -Skus "18.04-LTS" -Version "latest" | `
   Add-AzVmNetworkInterface -Id $helpNic.Id

New-AzVM -ResourceGroupName $rg -Location $region -VM $helpVmConfig

# Run custom script on help VM
Invoke-AzVMRunCommand -ResourceGroupName $rg -VMName "vm-help" -CommandId 'RunShellScript' -ScriptString $helpScript
