
title 'demo-01-vm'

# control 'demo-01-vm' do
#   impact 1.0
#   title 'Validate demo-01-vm'
#
#   vm = begin azure_virtual_machine(name: 'demo-01-vm', resource_group: 'demo-rg') rescue nil end
#
#   describe vm do
#      its('properties.storageProfile.imageReference.publisher') { should cmp 'MicrosoftWindowsServer' }
#      its('properties.storageProfile.imageReference.offer') { should cmp 'WindowsServer' }
#      its('properties.storageProfile.imageReference.sku') { should cmp '2016-Datacenter' }
#   end
# end
