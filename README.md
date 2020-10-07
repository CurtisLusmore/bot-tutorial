# BotTutorial

This tutorial will walk you through the steps required to create a Bot
Framework project from scratch, configure a Bot in Microsoft Teams, run it
locally, and then deploy it to Azure.


## Tools Installation

You will need to install the following tools

* [.NET Core SDK](https://docs.microsoft.com/en-us/dotnet/core/install/windows?tabs=netcore31)
* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
* [ngrok](https://ngrok.com/download)

You will also need to install the .NET Bot Framework project template via

```
dotnet new -i Microsoft.Bot.Framework.CSharp.EchoBot
```


## Project Setup

Create a new project via

```
mkdir BotTutorial
cd BotTutorial
dotnet new echobot -n BotTutorial -o .
```


## Bot Setup in Teams

Run through the following steps in Microsoft Teams to create your Teams
Application and Bot registration

1. Open Microsoft Teams
1. Open the App Studio
1. Go to the Manifest editor tab
1. Click Create a new app
1. Fill in the required fields on the App details tab
1. Click on the Bots tab
1. Click Set up
1. Enter the Name and check required options, click Create
1. Save the App ID (displayed under bot name)
1. Click Generate new password
1. Save the password
1. Test and distribute
1. Click Install
1. Click Add for me


## Project Configuration

1. Open `appsettings.json` and add the `MicrosoftAppId` and `MicrosoftAppPassword`


## Run Locally

1. In one terminal window, run `dotnet run`
1. In another terminal window, run `ngrok http -host-header=rewrite 3978` and
   grab the HTTPS Forwarding URL
1. Edit your app in the Manifest editor, and on the Bots tab set the Bot
   endpoint address to `https://<your-id>.ngrok.io/api/messages`
1. Send your bot a message


## Deploy to Azure

1. Run `Deploy.ps1` to create a resource group with the following resources
  1. App Service Plan
  1. Web App
  1. Storage Account
1. Grab the printed URL of the format `https://<your-app>.azurewebsites.net/api/messages`
1. Edit your app in the Manifest editor, and on the Bots tab set the Bot
   endpoint address to `https://<your-app>.azurewebsites.net/api/messages`