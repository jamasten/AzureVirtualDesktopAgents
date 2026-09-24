@description('The resource ID of the host pool.')
param hostPoolResourceId string

@description('The location for the deployments.')
param location string = resourceGroup().location

@description('DO NOT MODIFY THIS VALUE! The timestamp is needed to differentiate deployments for certain Azure resources and must be set using a parameter.')
param timestamp string = utcNow('yyyyMMddhhmmss')

@description('The resource ID for the target virtual machine.')
param virtualMachineResourceId string

resource hostPool 'Microsoft.DesktopVirtualization/hostPools@2025-10-10' existing = {
  name: split(hostPoolResourceId, '/')[8]
  scope: resourceGroup(split(hostPoolResourceId, '/')[2], split(hostPoolResourceId, '/')[4])
}

module hostPoolRegistrationToken 'modules/hostPoolRegistrationToken.bicep' = {
  name: 'HostPoolRegistrationToken_${timestamp}'
  scope: resourceGroup(split(hostPoolResourceId, '/')[2], split(hostPoolResourceId, '/')[4])
  params: {
    hostPoolName: split(hostPoolResourceId, '/')[8]
    hostPoolType: hostPool.properties.hostPoolType
    loadBalancerType: hostPool.properties.loadBalancerType
    location: hostPool.location
    maxSessionLimit: hostPool.properties.maxSessionLimit
    preferredAppGroupType: hostPool.properties.preferredAppGroupType
  }
}

module virtualMachine 'modules/virtualMachine.bicep' = {
  name: 'VirtualMachine_${timestamp}'
  scope: resourceGroup(split(virtualMachineResourceId, '/')[2], split(virtualMachineResourceId, '/')[4])
  params: {
    hostPoolResourceId: hostPoolResourceId
    location: location
    virtualMachineResourceId: virtualMachineResourceId
  }
  dependsOn: [
    hostPoolRegistrationToken
  ]
}
