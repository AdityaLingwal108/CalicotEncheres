// Parameters
param location string = 'Canada Central'
param keyVaultName string = 'kv-calicot-dev-001'
param webAppName string = 'app-calicot-dev-001'

// Create Key Vault
resource kv 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    enabledForDeployment: true  // Set to true if you want to enable deployment via Key Vault
    enabledForDiskEncryption: true  // Set to true if needed
    enabledForTemplateDeployment: true  // Set to true if needed
    tenantId: subscription().tenantId  // Use the tenant ID from the subscription
    enableSoftDelete: true
    softDeleteRetentionInDays: 90  // Retain soft-deleted vaults for 90 days
    accessPolicies: [
      {
        objectId: webApp.identity.principalId  // The Web App's Managed Identity objectId
        tenantId: subscription().tenantId
        permissions: {
          certificates: ['get', 'list']  // Add permissions for certificates
          keys: ['get', 'list']  // Add permissions for keys
          secrets: ['get', 'list']  // Add permissions for secrets
          storage: ['get', 'list']  // Add permissions for storage
        }
      }
    ]
    sku: {
      name: 'standard'  // SKU type (can change based on requirements)
      family: 'A'
    }
    networkAcls: {
      defaultAction: 'Allow'  // Set to 'Deny' if you want to restrict access
      bypass: 'AzureServices'  // Allow Azure Services to bypass network rules
    }
  }
}

// Get the Web App Managed Identity (assumes it has a Managed Identity)
resource webApp 'Microsoft.Web/sites@2024-04-01' existing = {
  name: webAppName
}
