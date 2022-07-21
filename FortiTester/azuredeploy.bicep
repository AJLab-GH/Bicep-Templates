@description('The region where these resources should be deployed (default is the resource group region)')
param location string = resourceGroup().location

@description('The Prefix to be appended to this deployments resources')
param deploymentPrefix string

@description('FortiTester version to be installed')
@allowed([
  '3.7.00'
  '3.8.0'
  '7.1.0'
  'latest'
])
param osVersion string = 'latest'

@description('Virtual Machine size selection')
@allowed([
  'Standard_F4'
  'Standard_F8'
  'Standard_F16'
  'Standard_F4s'
  'Standard_F8s'
  'Standard_F16s'
  'Standard_F8s_v2'
  'Standard_F16s_v2'
  'Standard_F32s_v2'
  'Standard_D8_v3'
  'Standard_D16_v3'
  'Standard_D8s_v3'
  'Standard_D16s_v3'
  'Standard_D32s_v3'
])
param instanceType string = 'Standard_F8s'

@description('Public IP for FortiTester for management purposes')
@allowed([
  'new'
  'existing'
])
param publicIPNewOrExisting string = 'new'

@description('Name of Public IP address for FortiTester, if no name is provided the default name will be the Deployment Prefix as the Prefix and \'-MGMT-PIP\' as the suffix')
param publicIPName string = ''

@description('Public IP Resource Group, this value is required if an existing Public IP is selected')
param publicIPResourceGroup string = ''

param adminUsername string

@secure()
param adminPassword string
@description('Identify whether to use a new or existing vnet')
@allowed([
  'new'
  'existing'
])
param vnetNewOrExisting string = 'new'

@description('Name of the Azure virtual network, required if utilizing and existing VNET. If no name is provided the default name will be the Resource Group Name as the Prefix and \'-VNET\' as the suffix')
param vnetName string = ''

@description('Resource Group containing the existing virtual network, leave blank if a new VNET is being utilized')
param vnetResourceGroup string = ''

@description('Virtual Network Address prefix')
param vnetAddressPrefix string = '172.16.136.0/21'

@description('Management Subnet for FortiTester Access')
param MgmtSubnet string = 'ManagementSubnet'

@description('Management Subnet Prefix')
param MgmtSubnetPrefix string = '172.16.136.0/24'

@description('First Traffic Subnet Name')
param Traffic1Subnet string = 'Traffic-A-Subnet'

@description('Traffic 1 Subnet Prefix')
param Traffic1SubnetPrefix string = '172.16.137.0/24'

@description('Second Traffic Subnet Name')
param Traffic2Subnet string = 'Traffic-B-Subnet'

@description('Traffic 2 Subnet Prefix')
param Traffic2SubnetPrefix string = '172.16.138.0/24'


var nic1Name = '${deploymentPrefix}-Mgmt-NIC'
var nic2Name = '${deploymentPrefix}-Traffic-A-NIC'
var nic3Name = '${deploymentPrefix}-Traffic-B-NIC'
var vnetName_var = ((vnetName == '') ? '${deploymentPrefix}-VNET' : vnetName)
var subnet1Id = ((vnetNewOrExisting == 'new') ? resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName_var, MgmtSubnet) : resourceId(vnetResourceGroup, 'Microsoft.Network/virtualNetworks/subnets', vnetName_var, MgmtSubnet))
var subnet2Id = ((vnetNewOrExisting == 'new') ? resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName_var, Traffic1Subnet) : resourceId(vnetResourceGroup, 'Microsoft.Network/virtualNetworks/subnets', vnetName_var, Traffic1Subnet))
var subnet3Id = ((vnetNewOrExisting == 'new') ? resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName_var, Traffic2Subnet) : resourceId(vnetResourceGroup, 'Microsoft.Network/virtualNetworks/subnets', vnetName_var, Traffic2Subnet))
var publicIPName_var = ((publicIPName == '') ? '${deploymentPrefix}-MGMT-PIP' : publicIPName)
var publicIPId = ((publicIPNewOrExisting == 'new') ? publicIPName_resource.id : resourceId(publicIPResourceGroup, 'Microsoft.Network/publicIPAddresses', publicIPName_var))
var nic1Id = mgmtNic_resource.id
var nic2Id = trafficANic_resource.id
var nic3Id = trafficBNic_resource.id
var vmName = '${deploymentPrefix}-FortiTester'
var nsgName_var = '${deploymentPrefix}-NSG'
var nsgId = nsgName.id

resource publicIPName_resource 'Microsoft.Network/publicIPAddresses@2020-04-01' = if (publicIPNewOrExisting == 'new') {
  name: publicIPName_var
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    dnsSettings: {
      domainNameLabel: '${toLower(vmName)}-${uniqueString(resourceGroup().id)}'
    }
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
        name: MgmtSubnet
        properties: {
          addressPrefix: MgmtSubnetPrefix
        }
      }
      {
        name: Traffic1Subnet
        properties: {
          addressPrefix: Traffic1SubnetPrefix
        }
      }
      {
        name: Traffic2Subnet
        properties: {
          addressPrefix: Traffic2SubnetPrefix
        }
      }
    ]
  }
}

resource mgmtNic_resource 'Microsoft.Network/networkInterfaces@2021-03-01' = {
  name: nic1Name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnet1Id
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPId
          }
        }
      }
    ]
    enableAcceleratedNetworking: true
    networkSecurityGroup: {
      id: nsgId
    }
  }
  dependsOn: [
    vnetName_resource
  ]
}

resource trafficANic_resource 'Microsoft.Network/networkInterfaces@2021-03-01' = {
  name: nic2Name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnet2Id
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
    enableAcceleratedNetworking: true
    networkSecurityGroup: {
      id: nsgId
    }
  }
  dependsOn: [
    vnetName_resource
  ]
}

resource trafficBNic_resource 'Microsoft.Network/networkInterfaces@2021-03-01' = {
  name: nic3Name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnet3Id
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
    enableAcceleratedNetworking: true
    networkSecurityGroup: {
      id: nsgId
    }
  }
  dependsOn: [
    vnetName_resource
  ]
}

resource nsgName 'Microsoft.Network/networkSecurityGroups@2020-04-01' = {
  name: nsgName_var
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


resource virtualMachineName_resource 'Microsoft.Compute/virtualMachines@2022-03-01' = {
  name: vmName
  location: location
  plan: {
    name: 'fts-vm-byol'
    publisher: 'fortinet'
    product: 'fortinet-fortitester'
  }
  properties: {
    hardwareProfile: {
      vmSize: instanceType
    }
    storageProfile: {
      osDisk: {
        createOption: 'fromImage'
      }
      imageReference: {
        publisher: 'fortinet'
        offer: 'fortinet-fortitester'
        sku: 'fts-vm-byol'
        version: osVersion
      }
      dataDisks: [
        {
          diskSizeGB: 64
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
          id: nic1Id
        }
        {
          properties: {
            primary: false
          }
          id: nic2Id
        }
        {
          properties: {
            primary: false
          }
          id: nic3Id
        }
      ]
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
      linuxConfiguration: {
        patchSettings: {
          patchMode: 'ImageDefault'
        }
      }
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

output adminUsername string = adminUsername
