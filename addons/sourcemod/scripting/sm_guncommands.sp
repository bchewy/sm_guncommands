#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "bchewy/shanapu/master shake sidezz/shadowz_au"
#define PLUGIN_VERSION "1.00"

#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <smlib>

stock SetClientMoney(int client, int value)
{
	int offset = FindSendPropInfo("CCSPlayer", "m_iAccount");
	SetEntData(client, offset, value);
}

stock GetClientMoney(int client) 
{
    int offset = FindSendPropInfo("CCSPlayer", "m_iAccount");
    return GetEntData(client, offset);
}

#pragma newdecls required
int g_iSpam[MAXPLAYERS+1];
ConVar g_AwpPrice;
ConVar g_M4Price;
ConVar g_Primary;
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
	g_AwpPrice = CreateConVar("sm_gc_awp_p", "2500", "Awp's price");
	g_M4Price = CreateConVar("sm_gc_m4_p", "2500", "M4's price");
	g_Primary = CreateConVar("sm_gc_primary", "1", "Must have a primary in order to spawn primary? 1- yes 0 - no");
	RegConsoleCmd("sm_ak47", Command_ak, "Spawns a ak47",0);
	RegConsoleCmd("sm_ak", Command_ak, "Spawns a ak47", 0);
	RegConsoleCmd("sm_bzn", Command_bzn, "Spawns a bizon", 0);
	RegConsoleCmd("sm_bizon", Command_bzn, "Spawns a bizon", 0);
	RegConsoleCmd("sm_flash", Command_flash, "Spawns a flashbang", 0);
	RegConsoleCmd("sm_awp", Command_awp, "AWP MANIA!", 0);
	RegConsoleCmd("sm_m4", Command_m4a1, "M4A1!", 0);
	RegAdminCmd("sm_anon", Command_anon,ADMFLAG_ROOT);
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
//	int cmoney = GetClientMoney(client);
//	SetClientMoney(client,cmoney - 2500);
	
	

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
//	int weapon = GetPlayerWeaponSlot(client, CS_SLOT_GRENADE);

	GivePlayerItem(client, "weapon_flashbang");
	PrintToChat(client, " \x04 A flashbang has been dropped for you!");
	g_iSpam[client] = GetTime()+5;

	}

	return Plugin_Handled;
}

public Action Command_awp(int client,int args)
{
	
	int cmoney = GetClientMoney(client);
	int gunprice = g_AwpPrice.IntValue;

	if(cmoney>gunprice && g_iSpam[client]<GetTime())
	{
	
	SetClientMoney(client,cmoney - gunprice);
	int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
	CS_DropWeapon(client, weapon, false, true);
	GivePlayerItem(client, "weapon_awp");
	PrintToChat(client, " \x04 An AWP has been dropped for you!");
	g_iSpam[client] = GetTime()+5;

	}
	else
	{
	
	PrintToChat(client, " \x04 You do not have enough money!");

	}


	

	return Plugin_Handled;
}
public Action Command_anon(int client,int args)
{
	int cmoney = GetClientMoney(client);
	SetClientMoney(client, cmoney + 5000);
	PrintToChat(client, " \x04 You've been given $5000!'");
	
	return Plugin_Handled;
}
public Action Command_m4a1(int client,int args)
{
	
	int cmoney = GetClientMoney(client);
	int gunprice = g_M4Price.IntValue;

	if (cmoney > gunprice && g_iSpam[client] < GetTime() && GetConVarInt(g_Primary)!=1))
	{
	
	SetClientMoney(client,cmoney - gunprice);
	int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
	//CS_DropWeapon(client, weapon, false, true);
	GivePlayerItem(client, "weapon_m4a1");
	PrintToChat(client, " \x04 An M4A1 has been dropped for you!");
	g_iSpam[client] = GetTime()+5;

	}
	else
	{
	
	PrintToChat(client, " \x04 You do not have enough money!");

	}


	

	return Plugin_Handled;
}