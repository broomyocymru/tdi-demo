
control 'DevOps Resource Group' do
  impact 0.1
  title 'DevOps Resource Group'

  describe azure_generic_resource(group_name: 'devops-rg') do
     its('total') { should eq 11 }
     its('Microsoft.Compute/virtualMachines') { should eq 1 }
     its('Microsoft.Network/networkInterfaces') { should eq 1 }
     its('Microsoft.Network/publicIPAddresses') { should eq 1 }
     its('Microsoft.Network/networkSecurityGroups') { should eq 1 }
     its('Microsoft.Network/virtualNetworks') { should eq 1 }
     its('Microsoft.Compute/disks') { should eq 1 }
  end

  describe azure_generic_resource(group_name: 'devops-rg', name: 'JenkinsVNET') do
    its('location') { should cmp 'ukwest' }
    its('properties.addressSpace.addressPrefixes') { should include '10.0.0.0/16'}
  end

  describe azure_generic_resource(group_name: 'devops-rg', name: 'Jenkins') do
    its('properties.storageProfile.imageReference.publisher') { should cmp 'Canonical' }
    its('properties.storageProfile.imageReference.offer') { should cmp 'UbuntuServer' }
    its('properties.storageProfile.imageReference.sku') { should cmp '16.04-LTS' }

    its('properties.hardwareProfile.vmSize') { should cmp 'Standard_DS2_v2' }
  end


end
