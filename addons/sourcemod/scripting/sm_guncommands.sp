#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "bchewy/shanapu"
#define PLUGIN_VERSION "1.00"

#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <smlib>


#pragma newdecls required
int g_iSpam[MAXPLAYERS+1];
EngineVersion g_Game;

public Plugin myinfo = 
{
	name = "Gun Commands",
	author = PLUGIN_AUTHOR,
	description = "gun commands",
	version = PLUGIN_VERSION,
	url = ""
};
 
public void OnPluginStart()
{
	g_Game = GetEngineVersion();
	if(g_Game != Engine_CSGO && g_Game != Engine_CSS)
	{
		SetFailState("This plugin is for CSGO/CSS only.");	
	}
	CreateConVar("sm_guncommands_version", PLUGIN_VERSION, "Guncommands version");
	RegConsoleCmd("sm_ak47", Command_ak, "Spawns a ak47",0);
	RegConsoleCmd("sm_ak", Command_ak, "Spawns a ak47", 0);
	RegConsoleCmd("sm_bzn", Command_bzn, "Spawns a bizon", 0);
	RegConsoleCmd("sm_bizon", Command_bzn, "Spawns a bizon", 0);
	RegConsoleCmd("sm_flash", Command_flash, "Spawns a flashbang", 0);
}

public void OnClientConnected(int client){

	g_iSpam[client] = 0;

}
public Action Command_ak(int client,int args)
{

	if(g_iSpam[client]<GetTime())
	{
	int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
	CS_DropWeapon(client, weapon, false, true);


	GivePlayerItem(client, "weapon_ak47");
	PrintToChat(client, "\x04 An AK47 has been dropped for you!");
	g_iSpam[client] = GetTime()+5;

	}

	return Plugin_Handled;
}
public Action Command_bzn(int client,int args)
{

	if(g_iSpam[client]<GetTime())
	{
	int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
	CS_DropWeapon(client, weapon, false, true);


	GivePlayerItem(client, "weapon_bizon");
	PrintToChat(client, "\x04 A bizon has been dropped for you!");
	g_iSpam[client] = GetTime()+5;

	}

	return Plugin_Handled;
}
public Action Command_flash(int client,int args)
{

	if(g_iSpam[client]<GetTime())
	{
	int weapon = GetPlayerWeaponSlot(client, CS_SLOT_GRENADE);

	GivePlayerItem(client, "weapon_flashbang");
	PrintToChat(client, "\x04 A flashbang has been dropped for you!");
	g_iSpam[client] = GetTime()+5;

	}

	return Plugin_Handled;
}


