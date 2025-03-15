resource vnet 'Microsoft.Network/virtualNetworks@2022-01-01' = {
  name: 'vnet-dev-calicot-cc-oesl96'
  location: 'Canada Central'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'snet-dev-web-cc-oesl96'
        properties: {
          addressPrefix: '10.0.1.0/24'
          networkSecurityGroup: null // This is the correct property to assign a Network Security Group (NSG)
          routeTable: null
        }
      }
      {
        name: 'snet-dev-db-cc-oesl96'
        properties: {
          addressPrefix: '10.0.2.0/24'
          networkSecurityGroup: null // Corrected here too
          routeTable: null
        }
      }
    ]
  }
}

output vnetId string = vnet.id
