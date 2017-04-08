#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR ""
#define PLUGIN_VERSION "0.00"

#include <sourcemod>
#include <sdktools>
#include <cstrike>
//#include <sdkhooks>

#pragma newdecls required
int g_iSpam[MAXPLAYERS+1];
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
	RegConsoleCmd("sm_ak47", Command_ak, "Spawns a knife", 0);
	
}
public void OnClientConnected(int client){

	g_iSpam[client] = 0;

}
public Action Command_ak(int client,int args)
{


	if(g_iSpam[client]<GetTime())
	{
	GivePlayerItem(client, "weapon_ak47");
	PrintToChat(client, "An AK47 has been dropped for you!");
	g_iSpam[client] = GetTime()+60;

	}
		
	
	return Plugin_Handled;
}
public Action Command_bizon(int client,int args)
{

	GivePlayerItem(client, "weapon_bizon");
	PrintToChat(client, "A bizon has been dropped for you!");
	
	
	return Plugin_Handled;
}
public Action Command_negev(int client,int args)
{

	GivePlayerItem(client, "weapon_negev");
	PrintToChat(client, "A Negev has been dropped for you!");
	
	
	return Plugin_Handled;
}

