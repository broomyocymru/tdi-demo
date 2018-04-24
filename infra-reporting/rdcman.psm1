#Module to generate RDG file based upon input CSV

Function RDGTemplate
{
[xml]$xml = @"
<?xml version="1.0" encoding="utf-8"?>
<RDCMan schemaVersion="1">
	<version>2.2</version>
	<file>
	</file>
</RDCMan>
"@

	return $xml
}

Function GetResourceGroups
{
    $list = @()
    $rgs = Get-AzureRmResourceGroup
    Foreach($rg in $rgs)
    {
        $list += ($rg).ResourceGroupName
    }

    return $list
}

Function GetVMsByResourceGroup
{
	param([string]$ResourceGroupName)

	$list = @()

    $virtualMachines = Get-AzureRMVM -ResourceGroupName $ResourceGroupName | Select-Object Name, Tags
    Foreach($vm in $virtualMachines)
    {
      $VirtualMachine = [PSCustomObject] @{
          Name = ($vm).Name
      }
  		$list += $VirtualMachine
    }

	return $list
}

Function GenerateRDG
{
	param([string]$RDGFilePath, [string]$DomainSuffix)

	$xml = rdgTemplate

	ForEach ($ResourceGroupName in GetResourceGroups){

		$serverList = GetVMsByResourceGroup -ResourceGroupName $ResourceGroupName

		If($serverList.Count -GT 0){
			$groupNode = $xml.CreateElement("group")
			$xml.SelectNodes('//file').AppendChild($groupNode)

			$propertiesNode = $xml.CreateElement("properties")
			$xml.SelectNodes('//group').AppendChild($propertiesNode)

			$envNameNode = $xml.CreateElement("name")
			$envNameNode.InnerXml = $ResourceGroupName
			$xml.SelectNodes('//properties').AppendChild($envNameNode)

			$expandedNode = $xml.CreateElement("expanded")
			$expandedNode.InnerXml = "true"
			$xml.SelectNodes('//properties').AppendChild($expandedNode)
		}

		Else{
			$propertiesNode = $xml.CreateElement("properties")
			$xml.SelectNodes('//file').AppendChild($propertiesNode)

			$envNameNode = $xml.CreateElement("name")
			$envNameNode.InnerXml = $ResourceGroupName
			$xml.SelectNodes('//properties').AppendChild($envNameNode)

			$expandedNode = $xml.CreateElement("expanded")
			$expandedNode.InnerXml = "true"
			$xml.SelectNodes('//properties').AppendChild($expandedNode)
		}

		If($serverList.Count -GT 0){
			ForEach ($server in $serverList){

				$serverNode = $xml.CreateElement("server")
				$xml.SelectNodes('//group').AppendChild($serverNode)

				$serverNameNode = $xml.CreateElement("name")
				$serverNameNode.InnerXml = "$($server.Name).$DomainSuffix"

				$xml.SelectNodes('//server').AppendChild($serverNameNode)

				$displayNameNode = $xml.CreateElement("displayName")
				$displayNameNode.InnerXml = "$($server.Name)"

				$xml.SelectNodes('//server').AppendChild($displayNameNode)
			}
		}
	}

	$xml.save($RDGFilePath)
}

Export-ModuleMember -Function 'generateRDG'
