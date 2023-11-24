#Connect-AzAccount -SubscriptionId 6e4924ab-b00c-468f-ae01-e5d33e8786f8 -TenantId 459865f1-a8aa-450a-baec-8b47a9e5c904

New-AzResourceGroup -Name multistorage-group -Location uksouth

New-AzResourceGroupDeployment -ResourceGroupName multistorage-group -TemplateFile .\template.json -TemplateParameterFile .\parameters.json -Verbose