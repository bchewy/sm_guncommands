#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR ""
#define PLUGIN_VERSION "0.00"

#include <sourcemod>
#include <sdktools>
#include <cstrike>
//#include <sdkhooks>

#pragma newdecls required

EngineVersion g_Game;

public Plugin myinfo = 
{
	name = "Gun Commands",
	author = PLUGIN_AUTHOR,
	description = "",
	version = PLUGIN_VERSION,
	url = "bchewy.me"
};

public void OnPluginStart()
{
	g_Game = GetEngineVersion();
	if(g_Game != Engine_CSGO && g_Game != Engine_CSS)
	{
		SetFailState("This plugin is for CSGO/CSS only.");	
	}
	CreateConVar("sm_guncommands_version", PLUGIN_VERSION, "Guncommands version");
	RegConsoleCmd("sm_ak47", Command_GunKnife, "Spawns a knife", 0);
	
}
public Action Command_GunKnife(int client,int args)
{

	GivePlayerItem(client, "weapon_ak47");
	PrintToChat(client, "An AK47 has been dropped for you!");

	return Plugin_Handled;
}

