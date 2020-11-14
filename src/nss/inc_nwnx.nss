#include "nwnx_webhook"

// Sends a discord message to "DISCORD_WEBHOOK", retrieved as as local on the module.
void SendDiscordMessage(string sMessage);
void SendDiscordMessage(string sMessage)
{
    string sPath = GetLocalString(GetModule(), "DISCORD_WEBHOOK");

    if (sPath != "") NWNX_WebHook_SendWebHookHTTPS("discordapp.com", sPath, sMessage);
}

//void main() {}
