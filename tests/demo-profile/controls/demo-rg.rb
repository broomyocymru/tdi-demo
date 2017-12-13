
control 'Subscription Tests' do
  impact 1.0
  title 'Demo Resource Groups'

  describe azure_generic_resource(group_name: 'demo-rg') do
     its('total') { should eq 2 }
     #its('Microsoft.Compute/virtualMachines') { should eq 1 }
     #its('Microsoft.Network/networkInterfaces') { should eq 1 }
     #its('Microsoft.Network/publicIPAddresses') { should eq 1 }
     #its('Microsoft.Network/networkSecurityGroups') { should eq 1 }
     #its('Microsoft.Storage/storageAccounts') { should eq 0 }
     #its('Microsoft.Network/virtualNetworks') { should eq 1 }
     #its('Microsoft.Compute/disks') { should eq 0 }
  end

  # describe azure_generic_resource(group_name: 'demo-rg', name: 'demo-vnet') do
  #   its('location') { should cmp 'ukwest' }
  #   its('properties.addressSpace.addressPrefixes') { should include '10.0.0.0/20'}
  # end

  # describe azure_generic_resource(group_name: 'demo-rg', name: 'demo-vnet') do
  #   its('location') { should cmp 'ukwest' }
  #   its('properties.addressSpace.addressPrefixes') { should include '10.0.0.0/20'}
  # end

end
