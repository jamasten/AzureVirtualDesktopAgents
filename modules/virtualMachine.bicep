param hostPoolResourceId string
param location string
param virtualMachineResourceId string

resource hostPool 'Microsoft.DesktopVirtualization/hostPools@2025-10-10' existing = {
  name: split(hostPoolResourceId, '/')[8]
  scope: resourceGroup(split(hostPoolResourceId, '/')[2], split(hostPoolResourceId, '/')[4])
}

resource virtualMachine 'Microsoft.Compute/virtualMachines@2025-04-01' existing = {
  name: split(virtualMachineResourceId, '/')[8]
}

resource setSessionHostConfiguration 'Microsoft.Compute/virtualMachines/runCommands@2025-04-01' = {
  parent: virtualMachine
  name: 'Set-SessionHostConfiguration'
  location: location
  properties: {
    asyncExecution: false
    parameters: [
      {
        name: 'StorageSuffix'
        value: environment().suffixes.storage
      }
    ]
    protectedParameters: [
      {
        name: 'HostPoolRegistrationToken'
        value: hostPool.listRegistrationTokens().value[0].token
      }
    ]
    source: {
      script: loadTextContent('../scripts/Set-SessionHostConfiguration.ps1')
    }
    treatFailureAsDeploymentFailure: true
  }
}
