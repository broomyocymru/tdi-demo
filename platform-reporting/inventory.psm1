Import-Module PSExcel -Force

Function GetSubscription
{
    param([string] $Id)
    $list = @()
    $sub = Get-AzureRmSubscription -SubscriptionId $Id
    $s = [PSCustomObject] @{
        SubscriptionId = ($sub).SubscriptionId
        TenantId = ($sub).TenantId
        Name = ($sub).Name
    }
    $list += $s
    return $list
}

Function GetResourceGroups
{
    $list = @()
    $rgs = Get-AzureRmResourceGroup
    Foreach($rg in $rgs)
    {
        $r = [PSCustomObject] @{
            Name = ($rg).ResourceGroupName
            Location = ($rg).Location
            ResourceId = ($rg).ResourceId
        }
        $list += $r
    }

    return $list
}

Function GetStorageAccounts
{
    $list = @()
    $storageAccounts = Get-AzureRmStorageAccount
    Foreach($sa in $storageAccounts)
    {
        $v = [PSCustomObject] @{
            Name = ($sa).StorageAccountName
            Location = ($sa).PrimaryLocation
            ResourceGroupName =($sa).ResourceGroupName
            Id = ($sa).Id
            Tier = ($sa).SKU.Tier
            Replication = ($sa).SKU.Name
        }

        $list += $v
    }

    return $list
}

Function GetVirtualMachines
{
    $list = @()

    $virtualMachines = Get-AzureRMVM
    Foreach($vm in $virtualMachines)
    {
        $resource = Get-AzureRmResource -ResourceId $vm.Id
        $v = [PSCustomObject] @{
            Name = ($resource).Name
            Location = ($resource).Location
            ResourceGroupName =($resource).ResourceGroupName
            VmSize = ($resource).Properties.HardwareProfile.VmSize
            OsType = ($resource).Properties.StorageProfile.OsDisk.OsType
            OsPublisher = ($resource).Properties.StorageProfile.ImageReference.Publisher
            OsOffer = ($resource).Properties.StorageProfile.ImageReference.Offer
            OsSKU =  ($resource).Properties.StorageProfile.ImageReference.Sku
            PrivateIP = (Get-AzureRmNetworkInterface | Where-Object {$_.ID -match $resource.Name}).IpConfigurations.PrivateIpAddress
            Subnet = ""
            VNet = (Get-AzureRmVirtualNetwork | Where-Object {$_.Subnets.ID -match (Get-AzureRmNetworkInterface | Where-Object {$_.ID -match $resource.Name}).IpConfigurations.subnet.id}).Name
            AvailabilitySet = ""
            DomainJoined = ""
            OU = ""
            SCOM = ""
            Shavlik = ""
            BackupVault = ""
        }

        $list += $v
    }

    return $list | Sort-Object Name
}

Function GetVirtualNetworks
{
    $list = @()

    $vnets = Get-AzureRmVirtualNetwork
    Foreach($vnet in $vnets){
        $v = [PSCustomObject] @{
            VNetName = ($vnet).Name
            Location = ($vnet).Location
            ResourceGroupName =($vnet).ResourceGroupName
        }

        $list += $v
    }

    return $list
}

Function GetSubnets
{
    $list = @()

    $vnets = Get-AzureRmVirtualNetwork
    Foreach($vnet in $vnets){
        Foreach($subnet in $vnet.Subnets)
        {
            $sn = Get-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name $subnet.Name

            $v = [PSCustomObject] @{
                VNetName = ($vnet).Name
                Location = ($vnet).Location
                ResourceGroupName =($vnet).ResourceGroupName
                SubnetName = ($subnet).Name
                SubnetId = ($subnet).Id
                SubnetRange = ($sn).AddressPrefix
                NsgName = (&{If([bool](($sn).Properties.name -match "NetworkSecurityGroup")){(Get-AzureRmResource -ExpandProperties -ResourceId ($sn).NetworkSecurityGroup.Id).Name}Else{""}})
                NsgId = ($sn).NetworkSecurityGroup.Id
            }

            $list += $v
        }
    }

    return $list
}

Function GetAvailabilitySets
{
    $list = @()
    $rgs = Get-AzureRmResourceGroup

    Foreach($rg in $rgs)
    {
        $sets = Get-AzureRmAvailabilitySet -ResourceGroupName $rg.ResourceGroupName

        Foreach($as in $sets)
        {
            #Availability Sets (name, rg, location, members)
            $members = @()
            Foreach($vm in $as.VirtualMachinesReferences)
            {
                $members += (Get-AzureRmResource -ResourceId $vm.Id).Name
            }

            $v = [PSCustomObject] @{
                Name = ($as).Name
                Location = ($as).Location
                ResourceGroupName =($as).ResourceGroupName
                Members = ($members -join ",")
            }

            $list += $v
        }
    }

    return $list
}

Function GetManagedDisks
{
    $list = @()

    $virtualMachines = Get-AzureRMVM

    Foreach($vm in $virtualMachines)
    {
        $resource = Get-AzureRmResource -ResourceId $vm.Id

        $disks = @()
        $disks += ($resource).Properties.StorageProfile.osDisk
        $disks += ($resource).Properties.StorageProfile.dataDisks


        Foreach($d in $disks)
        {
            $v = [PSCustomObject] @{
                Name = ($d).Name
                Location = ($resource).Location
                ResourceGroupName =($resource).ResourceGroupName
                AttchedTo = ($resource).Name
                Size = ($d).diskSizeGB
                Caching = ($d).caching
                Lun = ($d).lun
            }

            $list += $v
        }

    }

    return $list | Sort-Object Name
}

Function GetNics
{
    $list = @()
    $nics = Get-AzureRmNetworkInterface

    Foreach($nic in $nics)
    {
        $v = [PSCustomObject] @{
            Name = ($nic).Name
            ResourceGroupName =($nic).ResourceGroupName
            IP = ($nic).IpConfigurations[0].PrivateIpAddress
        }

        $list += $v

    }
    return $list
}

Function GetNsgs
{
    $list = @()
    $nsgs = Get-AzureRmNetworkSecurityGroup

    Foreach($nsg in $nsgs)
    {
        Foreach($rule in $nsg.SecurityRules)
        {
            $v = [PSCustomObject] @{
                Name = ($nsg).Name
                ResourceGroupName =($nsg).ResourceGroupName
                Location = ($nsg).Location

                RuleName = ($rule).Name
                SourcePort = (($rule).SourcePortRange -join ",")
                SourceAddress = (($rule).SourceAddressPrefix -join ",")
                DestinationPort = (($rule).DestinationPortRange -join ",")
                DestinationRange = (($rule).DestinationAddressPrefix -join ",")
                Access = ($rule).Access
                Priority = ($rule).Priority
                Direction = ($rule).Direction
            }

            $list += $v
        }
    }
    return $list
}

Function GetLoadBalancers
{
    Write-Output "Exporting Load Balancers"
    $list = @()
    $lbs = Get-AzureRmLoadBalancer

    Foreach($lb in $lbs)
    {
        $v = [PSCustomObject] @{
            Name = ($lb).Name
            ResourceGroupName =($lb).ResourceGroupName
            Location = ($lb).Location
        }

        $list += $v
    }
    return $list
}

Function GenerateReport
{
    param([string] $ReportPath, [string] $SubscriptionId, [string] $TenantId, [string] $DomainSuffix="", [string] $Format ="xlsx")

    Set-AzureRmContext -SubscriptionId $SubscriptionId -TenantId $TenantId

    If($Format -eq "xlsx")
    {
        $subscription = GetSubscription -Id $SubscriptionId
        $resourceGroups = GetResourceGroups
        $storageAccounts = GetStorageAccounts
        $vnets = GetVirtualNetworks
        $subnets = GetSubnets
        $availabilitySets = GetAvailabilitySets
        $virtualMachines = GetVirtualMachines
        $managedDisks = GetManagedDisks
        $nics = GetNics
        $nsgs = GetNsgs
        $lbs = GetLoadBalancers

        Write-Output "Exporting to XLSX"
        $subscription | Export-XLSX -Path $ReportPath -WorksheetName "Subscription" -ReplaceSheet -Table -Autofit
        $resourceGroups | Export-XLSX -Path $ReportPath -WorksheetName "Resource Groups" -ReplaceSheet -Table -Autofit
        $storageAccounts | Export-XLSX -Path $ReportPath -WorksheetName "Storage Accounts" -ReplaceSheet -Table -Autofit
        $vnets | Export-XLSX -Path $ReportPath -WorksheetName "VNets" -ReplaceSheet -Table -Autofit
        $subnets | Export-XLSX -Path $ReportPath -WorksheetName "Subnets" -ReplaceSheet -Table -Autofit
        $availabilitySets | Export-XLSX -Path $ReportPath -WorksheetName "Availability Sets" -ReplaceSheet -Table -Autofit
        $virtualMachines | Export-XLSX -Path $ReportPath -WorksheetName "Virtual Machines" -ReplaceSheet -Table -Autofit
        $managedDisks | Export-XLSX -Path $ReportPath -WorksheetName "Managed Disks" -ReplaceSheet -Table -Autofit
        $nics | Export-XLSX -Path $ReportPath -WorksheetName "NICs" -ReplaceSheet -Table -Autofit
        $nsgs | Export-XLSX -Path $ReportPath -WorksheetName "NSGs" -ReplaceSheet -Table -Autofit
        #$lbs | Export-XLSX -Path $ReportPath -WorksheetName "Load Balancers" -ReplaceSheet -Table -Autofit
    }
    ElseIF($Format -eq "json")
    {
        $subscription = GetSubscription -Id $SubscriptionId
        $resourceGroups = GetResourceGroups
        $storageAccounts = GetStorageAccounts
        $vnets = GetVirtualNetworks
        $subnets = GetSubnets
        $availabilitySets = GetAvailabilitySets
        $virtualMachines = GetVirtualMachines
        $managedDisks = GetManagedDisks
        $nics = GetNics
        $nsgs = GetNsgs
        $lbs = GetLoadBalancers

        Write-Output "Exporting to JSON"

        $inventory = [PSCustomObject] @{
            Subscription = $Subscription
            ResourceGroups = $resourceGroups
            StorageAccounts = $storageAccounts
            VNets = $vnets
            Subnets = $subnets
            AvailabilitySets = $availabilitySets
            VirtualMachines = $virtualMachines
            ManagedDisks = $managedDisks
            NICs = $nics
            #NSGs = $nsgs
            #LoadBalancers = $lbs
        }

        $inventory | ConvertTo-Json | Set-Content $ReportPath
    }
    ElseIF($Format -eq "rdg")
    {
        GenerateRDG -RDGFilePath $ReportPath -DomainSuffix $DomainSuffix
    }
}

Export-ModuleMember -Function 'GenerateReport'
