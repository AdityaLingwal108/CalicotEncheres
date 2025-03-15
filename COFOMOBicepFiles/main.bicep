param location string = 'Canada Central'
param resourceGroupName string = 'rg-calicot-web-dev-20'

resource appPlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: 'plan-calicot-dev-001'
  location: location
  sku: {
    tier: 'Standard'
    name: 'S1'
  }
}
resource webApp 'Microsoft.Web/sites@2021-02-01' = {
  name: 'app-calicot-dev-001'
  location: location
  properties: {
    httpsOnly: true
    siteConfig: {
      alwaysOn: true
      minTlsVersion: '1.2'
      http20Enabled: true
      appSettings: [
      {
        name: 'ImageUrl'
        value: 'https://stcalicotprod000.blob.core.windows.net/images/'
      }
    ]
    }
  }
  identity: {
    type: 'SystemAssigned'
  }
}
resource autoScale 'Microsoft.Insights/autoscaleSettings@2021-05-01' = {
  name: 'autoscale-webapp'
  location: location
  properties: {
    enabled: true
    targetResourceUri: webApp.id
    profiles: [
      {
        name: 'default'
        capacity: {
          minimum: 1
          maximum: 2
          default: 1
        }
        rules: [
          {
            metricTrigger: {
              metricName: 'CpuPercentage'
              operator: 'GreaterThan'
              threshold: 70
              timeAggregation: 'Average'
              metricNamespace: 'Microsoft.Web/serverfarms'
              timeGrain: 'PT1M'
            }
            scaleAction: {
              direction: 'Increase'
              type: 'ChangeCount'
              value: 1
              cooldown: 'PT5M'
            }
          }
        ]
      }
    ]
  }
}
