
title 'demo-01-vm'

# control 'demo-01-vm' do
#   impact 1.0
#   title 'Validate demo-01-vm'
#
#   vm = begin azure_virtual_machine(name: 'demo-01-vm', resource_group: 'demo-rg') rescue nil end
#
#   describe vm do
#     its('sku') { should eq '2016-Datacenter' }
#     its('publisher') { should ieq 'MicrosoftWindowsServer' }
#     its('offer') { should ieq 'WindowsServer' }
#   end
# end
