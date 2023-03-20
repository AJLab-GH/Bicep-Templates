@description('Username for the FortiGate VM')
param adminUsername string

@description('Password for the FortiGate VM')
@secure()
param adminPassword string

@description('Naming prefix for all deployed resources. The FortiGate VMs will have the suffix \'-FGT-A\' and \'-FGT-B\'. For example if the prefix is \'ACME-01\' the FortiGates will be named \'ACME-01-FGT-A\' and \'ACME-01-FGT-B\'')
param fortiGateNamePrefix string

@description('Identifies whether to to use PAYG (on demand licensing) or BYOL license model (where license is purchased separately')
@allowed([
  'fortinet_fg-vm'
  'fortinet_fg-vm_payg_2022'
])
param fortiGateImageSKU string = 'fortinet_fg-vm'

@description('Select the image version')
@allowed([
  '6.2.0'
  '6.2.2'
  '6.2.4'
  '6.2.5'
  '6.4.0'
  '6.4.2'
  '6.4.3'
  '6.4.5'
  '6.4.6'
  '6.4.7'
  '6.4.8'
  '7.0.0'
  '7.0.1'
  '7.0.2'
  '7.0.3'
  '7.0.4'
  '7.0.5'
  'latest'
])
param fortiGateImageVersion string = 'latest'

@description('The ARM template provides a basic configuration. Additional configuration can be added here.')
param fortiGateAdditionalCustomData string = ''

@description('Virtual Machine size selection - must be F4 or other instance that supports 4 NICs')
@allowed([
  'Standard_F2s'
  'Standard_F4s'
  'Standard_F8s'
  'Standard_F16s'
  'Standard_F2'
  'Standard_F4'
  'Standard_F8'
  'Standard_F16'
  'Standard_F2s_v2'
  'Standard_F4s_v2'
  'Standard_F8s_v2'
  'Standard_F16s_v2'
  'Standard_F32s_v2'
  'Standard_DS1_v2'
  'Standard_DS2_v2'
  'Standard_DS3_v2'
  'Standard_DS4_v2'
  'Standard_DS5_v2'
  'Standard_D2s_v3'
  'Standard_D4s_v3'
  'Standard_D8s_v3'
  'Standard_D16s_v3'
  'Standard_D32s_v3'
  'Standard_D2_v4'
  'Standard_D4_v4'
  'Standard_D8_v4'
  'Standard_D16_v4'
  'Standard_D32_v4'
  'Standard_D2s_v4'
  'Standard_D4s_v4'
  'Standard_D8s_v4'
  'Standard_D16s_v4'
  'Standard_D32s_v4'
  'Standard_D2a_v4'
  'Standard_D4a_v4'
  'Standard_D8a_v4'
  'Standard_D16a_v4'
  'Standard_D32a_v4'
  'Standard_D2as_v4'
  'Standard_D4as_v4'
  'Standard_D8as_v4'
  'Standard_D16as_v4'
  'Standard_D32as_v4'
  'Standard_D2_v5'
  'Standard_D4_v5'
  'Standard_D8_v5'
  'Standard_D16_v5'
  'Standard_D32_v5'
  'Standard_D2s_v5'
  'Standard_D4s_v5'
  'Standard_D8s_v5'
  'Standard_D16s_v5'
  'Standard_D32s_v5'
  'Standard_D2as_v5'
  'Standard_D4as_v5'
  'Standard_D8as_v5'
  'Standard_D16as_v5'
  'Standard_D32as_v5'
  'Standard_D2ads_v5'
  'Standard_D4ads_v5'
  'Standard_D8ads_v5'
  'Standard_D16ads_v5'
  'Standard_D32ads_v5'
])
param instanceType string = 'Standard_D4as_v4'

@description('Accelerated Networking enables direct connection between the VM and network card. Only available on 2 CPU F/Fs and 4 CPU D/Dsv2, D/Dsv3, E/Esv3, Fsv2, Lsv2, Ms/Mms and Ms/Mmsv2')
@allowed([
  false
  true
])
param acceleratedNetworking bool = false

@description('Choose between an existing or new public IP address linked to the external interface of the FortiGate VM')
@allowed([
  'new'
  'existing'
  'none'
])
param publicIP1NewOrExisting string = 'new'

@description('Name of Public IP address, if no name is provided the default name will be the Resource Group Name as the Prefix and \'-FGT-PIP\' as the suffix')
param publicIP1Name string = ''

@description('Public IP Resource Group, this value is required if an existing Public IP is selected')
param publicIP1ResourceGroup string = ''

@description('Type of public IP address')
@allowed([
  'Dynamic'
  'Static'
])
param publicIP1AddressType string = 'Static'

@description('Type of public IP address')
@allowed([
  'Basic'
  'Standard'
])
param publicIP1SKU string = 'Standard'

@description('Identify whether to use a new or existing vnet')
@allowed([
  'new'
  'existing'
])
param vnetNewOrExisting string = 'new'

@description('Name of the Azure virtual network, required if utilizing an existing VNET. If no name is provided the default name will be the Resource Group Name as the Prefix and \'-VNET\' as the suffix')
param vnetName string = ''

@description('Resource Group containing the existing virtual network, leave blank if a new VNET is being utilize')
param vnetResourceGroup string = ''

@description('Virtual Network Address prefix')
param vnetAddressPrefix string = '172.16.136.0/22'

@description('Subnet 1 Name')
param subnet1Name string = 'ExternalSubnet'

@description('Subnet 1 Prefix')
param subnet1Prefix string = '172.16.136.0/26'

@description('Subnet 1 start address, 1 consecutive private IPs are required')
param subnet1StartAddress string = '172.16.136.4'

@description('Subnet 2 Subnet')
param subnet2Name string = 'InternalSubnet'

@description('Subnet 2 Prefix')
param subnet2Prefix string = '172.16.136.64/26'

@description('Subnet 2 start address, 1 consecutive private IPs are required')
param subnet2StartAddress string = '172.16.136.68'

@description('Subnet 3 Name')
param subnet3Name string = 'ProtectedASubnet'

@description('Subnet 3 Prefix')
param subnet3Prefix string = '172.16.137.0/24'

@description('Enable Serial Console')
@allowed([
  'yes'
  'no'
])
param serialConsole string = 'yes'

@description('Connect to FortiManager')
@allowed([
  'yes'
  'no'
])
param fortiManager string = 'no'

@description('FortiManager IP or DNS name to connect to on port TCP/541')
param fortiManagerIP string = ''

@description('FortiManager serial number to add the deployed FortiGate into the FortiManager')
param fortiManagerSerial string = ''

@description('FortiGate BYOL license content')
param fortiGateLicenseBYOL string = '''-----BEGIN FGT VM LICENSE-----
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
c7b6yMxaQo2LAYYWZkXi7qMDYVvIHgXL
-----END FGT VM LICENSE-----
'''


@description('FortiGate BYOL Flex-VM license token')
param fortiGateLicenseFlexVM string = ''

@description('Location for all resources.')
param location string = resourceGroup().location
param fortinetTags object = {
  publisher: 'Fortinet'
  provider: '6EB3B02F-50E5-4A3E-8CB8-2E12925831VM'
}

var imagePublisher = 'fortinet'
var imageOffer = 'fortinet_fortigate-vm_v5'
var vnetName_var = ((vnetName == '') ? '${fortiGateNamePrefix}-VNET' : vnetName)
var subnet1Id = ((vnetNewOrExisting == 'new') ? resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName_var, subnet1Name) : resourceId(vnetResourceGroup, 'Microsoft.Network/virtualNetworks/subnets', vnetName_var, subnet1Name))
var subnet2Id = ((vnetNewOrExisting == 'new') ? resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName_var, subnet2Name) : resourceId(vnetResourceGroup, 'Microsoft.Network/virtualNetworks/subnets', vnetName_var, subnet2Name))
var fgtVmName_var = '${fortiGateNamePrefix}-FGT-A'
var fmgCustomData = ((fortiManager == 'yes') ? '\nconfig system central-management\nset type fortimanager\n set fmg ${fortiManagerIP}\nset serial-number ${fortiManagerSerial}\nend\n config system interface\n edit port1\n append allowaccess fgfm\n end\n config system interface\n edit port2\n append allowaccess fgfm\n end\n' : '')
var customDataFlexVM = ((fortiGateLicenseFlexVM == '') ? '' : 'exec vm-license ${fortiGateLicenseFlexVM}\n')
var customDataHeader = 'Content-Type: multipart/mixed; boundary="12345"\nMIME-Version: 1.0\n\n--12345\nContent-Type: text/plain; charset="us-ascii"\nMIME-Version: 1.0\nContent-Transfer-Encoding: 7bit\nContent-Disposition: attachment; filename="config"\n\n'
var customDataBody = 'config system sdn-connector\nedit AzureSDN\nset type azure\nnext\nend\nconfig router static\nedit 1\nset gateway ${sn1GatewayIP}\nset device port1\nnext\nedit 2\nset dst ${vnetAddressPrefix}\nset gateway ${sn2GatewayIP}\nset device port2\nnext\nend\nconfig system interface\nedit port1\nset mode static\nset ip ${sn1IPfgt}/${sn1CIDRmask}\nset description external\nset allowaccess ping ssh https\nnext\nedit port2\nset mode static\nset ip ${sn2IPfgt}/${sn2CIDRmask}\nset description internal\nset allowaccess ping ssh https\nnext\nend\n${fmgCustomData}${fortiGateAdditionalCustomData}\n${customDataFlexVM}\n'
var customDataLicenseHeader = '--12345\nContent-Type: text/plain; charset="us-ascii"\nMIME-Version: 1.0\nContent-Transfer-Encoding: 7bit\nContent-Disposition: attachment; filename="fgtlicense"\n\n'
var customDataFooter = '\n--12345--\n'
var customDataCombined = '${customDataHeader}${customDataBody}${customDataLicenseHeader}${fortiGateLicenseBYOL}${customDataFooter}'
var fgtCustomData = base64(((fortiGateLicenseBYOL == '') ? customDataBody : customDataCombined))
var routeTableProtectedName_var = '${fortiGateNamePrefix}-RouteTable-${subnet3Name}'
var routeTableProtectedId = routeTableProtectedName.id
var fgtNic1Name_var = '${fgtVmName_var}-Nic1'
var fgtNic1Id = fgtNic1Name.id
var fgtNic2Name_var = '${fgtVmName_var}-Nic2'
var fgtNic2Id = fgtNic2Name.id
var serialConsoleStorageAccountName_var = 'console${uniqueString(resourceGroup().id)}'
var serialConsoleStorageAccountType = 'Standard_LRS'
var serialConsoleEnabled = ((serialConsole == 'yes') ? true : false)
var publicIP1Name_var = ((publicIP1Name == '') ? '${fortiGateNamePrefix}-FGT-PIP' : publicIP1Name)
var publicIP1Id = ((publicIP1NewOrExisting == 'new') ? publicIP1Name_resource.id : resourceId(publicIP1ResourceGroup, 'Microsoft.Network/publicIPAddresses', publicIP1Name_var))
var publicIP1AddressId = {
  id: publicIP1Id
}
var NSGName_var = '${fortiGateNamePrefix}-${uniqueString(resourceGroup().id)}-NSG'
var NSGId = NSGName.id
var sn1IPArray = split(subnet1Prefix, '.')
var sn1IPArray2ndString = string(sn1IPArray[3])
var sn1IPArray2nd = split(sn1IPArray2ndString, '/')
var sn1CIDRmask = string(int(sn1IPArray2nd[1]))
var sn1IPArray3 = string((int(sn1IPArray2nd[0]) + 1))
var sn1IPArray2 = string(int(sn1IPArray[2]))
var sn1IPArray1 = string(int(sn1IPArray[1]))
var sn1IPArray0 = string(int(sn1IPArray[0]))
var sn1GatewayIP = '${sn1IPArray0}.${sn1IPArray1}.${sn1IPArray2}.${sn1IPArray3}'
var sn1IPStartAddress = split(subnet1StartAddress, '.')
var sn1IPfgt = '${sn1IPArray0}.${sn1IPArray1}.${sn1IPArray2}.${int(sn1IPStartAddress[3])}'
var sn2IPArray = split(subnet2Prefix, '.')
var sn2IPArray2ndString = string(sn2IPArray[3])
var sn2IPArray2nd = split(sn2IPArray2ndString, '/')
var sn2CIDRmask = string(int(sn2IPArray2nd[1]))
var sn2IPArray3 = string((int(sn2IPArray2nd[0]) + 1))
var sn2IPArray2 = string(int(sn2IPArray[2]))
var sn2IPArray1 = string(int(sn2IPArray[1]))
var sn2IPArray0 = string(int(sn2IPArray[0]))
var sn2GatewayIP = '${sn2IPArray0}.${sn2IPArray1}.${sn2IPArray2}.${sn2IPArray3}'
var sn2IPStartAddress = split(subnet2StartAddress, '.')
var sn2IPfgt = '${sn2IPArray0}.${sn2IPArray1}.${sn2IPArray2}.${int(sn2IPStartAddress[3])}'

resource serialConsoleStorageAccountName 'Microsoft.Storage/storageAccounts@2021-02-01' = if (serialConsole == 'yes') {
  name: serialConsoleStorageAccountName_var
  location: location
  kind: 'Storage'
  sku: {
    name: serialConsoleStorageAccountType
  }
}

resource routeTableProtectedName 'Microsoft.Network/routeTables@2020-04-01' = {
  name: routeTableProtectedName_var
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  location: location
  properties: {
    routes: [
      {
        name: 'VirtualNetwork'
        properties: {
          addressPrefix: vnetAddressPrefix
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: sn2IPfgt
        }
      }
      {
        name: 'Subnet'
        properties: {
          addressPrefix: subnet3Prefix
          nextHopType: 'VnetLocal'
        }
      }
      {
        name: 'Default'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: sn2IPfgt
        }
      }
    ]
  }
}

resource vnetName_resource 'Microsoft.Network/virtualNetworks@2020-04-01' = if (vnetNewOrExisting == 'new') {
  name: vnetName_var
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: subnet1Name
        properties: {
          addressPrefix: subnet1Prefix
        }
      }
      {
        name: subnet2Name
        properties: {
          addressPrefix: subnet2Prefix
        }
      }
      {
        name: subnet3Name
        properties: {
          addressPrefix: subnet3Prefix
          routeTable: {
            id: routeTableProtectedId
          }
        }
      }
    ]
  }
}

resource NSGName 'Microsoft.Network/networkSecurityGroups@2020-04-01' = {
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  name: NSGName_var
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowAllInbound'
        properties: {
          description: 'Allow all in'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowAllOutbound'
        properties: {
          description: 'Allow all out'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 105
          direction: 'Outbound'
        }
      }
    ]
  }
}

resource publicIP1Name_resource 'Microsoft.Network/publicIPAddresses@2020-04-01' = if (publicIP1NewOrExisting == 'new') {
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  name: publicIP1Name_var
  location: location
  sku: {
    name: publicIP1SKU
  }
  properties: {
    publicIPAllocationMethod: publicIP1AddressType
    dnsSettings: {
      domainNameLabel: '${toLower(fgtVmName_var)}-${uniqueString(resourceGroup().id)}'
    }
  }
}

resource fgtNic1Name 'Microsoft.Network/networkInterfaces@2020-04-01' = {
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  name: fgtNic1Name_var
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAddress: sn1IPfgt
          privateIPAllocationMethod: 'Static'
          publicIPAddress: ((publicIP1NewOrExisting != 'none') ? publicIP1AddressId : json('null'))
          subnet: {
            id: subnet1Id
          }
        }
      }
    ]
    enableIPForwarding: true
    enableAcceleratedNetworking: acceleratedNetworking
    networkSecurityGroup: {
      id: NSGId
    }
  }
  dependsOn: [
    vnetName_resource
    ]
}

resource fgtNic2Name 'Microsoft.Network/networkInterfaces@2020-04-01' = {
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  name: fgtNic2Name_var
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Static'
          privateIPAddress: sn2IPfgt
          subnet: {
            id: subnet2Id
          }
        }
      }
    ]
    enableIPForwarding: true
    enableAcceleratedNetworking: acceleratedNetworking
    networkSecurityGroup: {
      id: NSGId
    }
  }
  dependsOn: [
    vnetName_resource
  ]
}

resource fgtVmName 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: fgtVmName_var
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  identity: {
    type: 'SystemAssigned'
  }
  location: location
  plan: {
    name: fortiGateImageSKU
    publisher: imagePublisher
    product: imageOffer
  }
  properties: {
    hardwareProfile: {
      vmSize: instanceType
    }
    osProfile: {
      computerName: fgtVmName_var
      adminUsername: adminUsername
      adminPassword: adminPassword
      customData: fgtCustomData
    }
    storageProfile: {
      imageReference: {
        publisher: imagePublisher
        offer: imageOffer
        sku: fortiGateImageSKU
        version: fortiGateImageVersion
      }
      osDisk: {
        createOption: 'FromImage'
      }
      dataDisks: [
        {
          diskSizeGB: 30
          lun: 0
          createOption: 'Empty'
        }
      ]
    }
    networkProfile: {
      networkInterfaces: [
        {
          properties: {
            primary: true
          }
          id: fgtNic1Id
        }
        {
          properties: {
            primary: false
          }
          id: fgtNic2Id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: serialConsoleEnabled
        storageUri: ((serialConsole == 'yes') ? reference(serialConsoleStorageAccountName_var, '2021-08-01').primaryEndpoints.blob : json('null'))
      }
    }
  }
}



output o_fortiGateLicenseBYOL string = replace(fortiGateLicenseBYOL,'\n', '\\n')

output o_customDataHeader string = replace(customDataHeader,'\n', '\\n')

output o_fgaCustomDataBody string = replace(customDataBody,'\n', '\\n')

output o_customDataLicenseHeader string = replace(customDataLicenseHeader,'\n', '\\n')

output o_fgaCustomDataCombined string = replace(customDataCombined,'\n', '\\n')

output o_fgaCustomData string = replace(fgtCustomData,'\n', '\\n')


