#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "bchewy/shanapu"
#define PLUGIN_VERSION "1.00"

#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <morecolors.inc>
//#include <sdkhooks>

#pragma newdecls required
int g_iSpam[MAXPLAYERS+1];
int g_cvarRequiredFlag = -1;
EngineVersion g_Game;

public Plugin myinfo = 
{
	name = "Gun Commands",
	author = PLUGIN_AUTHOR,
	description = "gun commands",
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
	CreateConvar("sm_flag_guns", ADMFLAG_GENERIC, "Default flag for vip/admin commands")
	RegConsoleCmd("sm_ak47", Command_ak, "Spawns a ak47",0);
	RegConsoleCmd("sm_ak", Command_ak, "Spawns a ak47", 0);
	RegAdminCmd("sm_negev", Command_negev, ADMFLAG_CUSTOM1, "- Spawns you a RPG");
	
	
	
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
	PrintToChat(client, "{lime}An AK47 has been dropped for you!");
	g_iSpam[client] = GetTime()+60;

	}
		
	
	return Plugin_Handled;
}
public Action Command_negev(int client,int args)
{
	if []g_cvarRequiredFlag] && !GetClientPrivilege(client, [g_cvarRequiredFlag])
	{
		PrintToChat(client, "You do not have permission to spawn this weapon");
		return Plugin_Handled;
	
	}
	if(g_iSpam[client]<GetTime())
	{
	int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
	CS_DropWeapon(client, weapon, false, true);


	GivePlayerItem(client, "weapon_negev");
	PrintToChat(client, "A NEGEV has been dropped for you!");
	g_iSpam[client] = GetTime()+60;

	}
		
	
	return Plugin_Handled;
}


