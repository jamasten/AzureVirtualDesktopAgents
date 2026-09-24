# Azure Virtual Desktop Agents

The easiest way to deploy this solution and add the AVD agents to your virtual machine is to use a template spec. To create the template spec, there are two files that are needed and must be downloaded:

1. solution.json
1. uiDefinition.json

Using PowerShell, create the template spec using the following example:

```powershell
$Location = ''
$ResourceGroupName = ''
$TemplateSpecName = ''

New-AzTemplateSpec `
    -ResourceGroupName $ResourceGroupName `
    -Name $TemplateSpecName `
    -Version 1.0 `
    -Location $Location `
    -TemplateFile ".\solution.json" `
    -UIFormDefinitionFile ".\uiDefinition.json" `
    -Force
```

NOTE: The variables must be updated with values.
