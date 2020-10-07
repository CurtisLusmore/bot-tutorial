Param(
    [string] $SubscriptionId,
    [string] $Location,
    [string] $Rg,
    [string] $Sa,
    [string] $Sp,
    [string] $Wa,
    [switch] $LoginRequired
)

if ($LoginRequired)
{
    az login
}

if (-not $SubscriptionId)
{
    az account list --output table
    $SubscriptionId = Read-Host "Subscription ID"
}

az account set --subscription $SubscriptionId

if (-not $Location)
{
    az account list-locations --output table
    $Location = Read-Host "Location Name"
}

if (-not $Rg)
{
    Write-Host "Resource group names only allow alphanumeric characters, periods, underscores, hyphens and parenthesis and cannot end in a period."
    $Rg = Read-Host "Resource Group Name"
}

az group create `
    --location $Location `
    --name $Rg

if (-not $Sa)
{
    Write-Host "Storage account names can contain only lowercase letters and numbers."
    $Sa = Read-Host "Storage Account Name"
}

az storage account create `
    --resource-group $Rg `
    --name $Sa `
    --location $Location `
    --sku Standard_LRS

if (-not $Sp)
{
    Write-Host "Service plan names can contain only letters, numbers and hyphens."
    $Sp = Read-Host "Serice Plan Name"
}

az appservice plan create `
    --resource-group $Rg `
    --name $Sp `
    --sku F1

if (-not $Wa)
{
    Write-Host "Web app names can contain only letters, numbers and hyphens."
    $Wa = Read-Host "Web App Name"
}

az webapp create `
    --resource-group $Rg `
    --name $Wa `
    --runtime '"aspnet|V4.7"' `
    --plan $Sp

$Key = az storage account show-connection-string `
    --resource-group $Rg `
    --name $Sa `
    --query connectionString `
    --output tsv

az webapp config appsettings set `
    --resource-group $Rg `
    --name $Wa `
    --settings BLOB_NAME=state BLOB_STRING=$Key

az webapp config set `
    --resource-group $Rg `
    --name $Wa `
    --web-sockets-enabled true

az bot prepare-deploy --lang Csharp --code-dir . --proj-file-path BotTutorial.csproj

Compress-Archive -Path .\* -DestinationPath 'deploy.zip' -Force

az webapp deployment source config-zip `
    --resource-group $Rg `
    --name $Wa `
    --src 'deploy.zip'

Write-Host "https://$Wa.azurewebsites.net/api/messages"