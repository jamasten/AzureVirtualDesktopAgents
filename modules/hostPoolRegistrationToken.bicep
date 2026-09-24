param hostPoolName string
param hostPoolType string
param loadBalancerType string
param location string
param maxSessionLimit int
param preferredAppGroupType string = 'Desktop'
param time string = utcNow('u')

resource hostPool_hosts 'Microsoft.DesktopVirtualization/hostPools@2023-09-05' = {
  name: hostPoolName
  location: location
  properties: {
    hostPoolType: hostPoolType
    loadBalancerType: loadBalancerType
    maxSessionLimit: maxSessionLimit
    preferredAppGroupType: preferredAppGroupType
    registrationInfo: {
      expirationTime: dateTimeAdd(time, 'PT2H')
      registrationTokenOperation: 'Update'
    }
  }
}
