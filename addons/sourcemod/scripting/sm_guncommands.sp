// Made with help of the following people!
//	Shanapu - timer help!
////////////////////////////////////////////////////////////////////////////////////
//	Master Shake Sidezz! - A lot of help with									////
//	teaching me how to use create cvars and use them, along with the money!		////
// 	PS : Sidez wrote the stock functions for money too! Thanks <3<3<3			////
////////////////////////////////////////////////////////////////////////////////////
//	shadowz_au - some basic help along with the code clean up
//
//
//
#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "bchewy/shanapu/master shake sidezz/shadowz_au"
#define PLUGIN_VERSION "1.2"

#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <smlib>
// Written by master shake sidezz or Eassizde! Thanks a bunch :')/////////////////////////////////////////
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

//Use this to consolidate some text and shorten the plugin
//Plus this makes it easier to change what the text says since you
//Dont use translation files. -DeweY
stock bool CheckClientMoney(int client, int clientmoney, int weaponprice)
{
	if(clientmoney < weaponprice)
	{
		PrintToChat(client, " \x04 You do not have enough money!");
		return false;
	}
	return true;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma newdecls required
int g_iSpam[MAXPLAYERS+1];
//RIFLE////////////////////////////////////////////////////////////////////////////////////////////////
ConVar g_AKPrice;
ConVar g_M4Price;
ConVar g_AUGPrice;
ConVar g_FAMASPrice;
ConVar g_M4SPrice;

//SNIPER //////////////////////////////////////////////////////////////////////////////////////////////
ConVar g_AwpPrice;

//SMG//////////////////////////////////////////////////////////////////////////////////////////////////
ConVar g_BZNPrice;
ConVar g_P90Price;
// Pistols/////////////////////////////////////////////////////////////////////////////////////////////
ConVar g_USPPrice;

//Extras///////////////////////////////////////////////////////////////////////////////////////////////
ConVar g_DropPri;
ConVar g_DropSec;
ConVar g_GiveMoney;
ConVar g_MoneyFlag;
EngineVersion g_Game;
///////////////////////////////////////////////////////////////////////////////////////////////////////
public Plugin myinfo = 
{
	name = "SM Gun Commands CSGO",
	author = PLUGIN_AUTHOR,
	description = "Gun Commands, spawn your weapons with commands!",
	version = PLUGIN_VERSION,
	url = ""
};
 
public void OnPluginStart()
{
	//DEFAULT SPEDIT code, 
	// g_game is a global variable decleared with GetEngineVersion
	// an if statement is then written to confirm if it is indeed on CSGO
	// else write failstate
	g_Game = GetEngineVersion();
	if(g_Game != Engine_CSGO)
	{
		SetFailState("This plugin is for CSGO only");	
	}
	
	//Version
	CreateConVar("sm_guncommands_version", PLUGIN_VERSION, "Guncommands version");
	
	//Weapon price convars//////////////////////////////////////////////////////////////////////////////////////////////////////

	g_AKPrice = CreateConVar("sm_gc_ak_p", "2500", "AK's price");
	g_AwpPrice = CreateConVar("sm_gc_awp_p", "2500", "Awp's price");
	g_M4Price = CreateConVar("sm_gc_m4_p", "2500", "M4's price");
	g_M4SPrice = CreateConVar("sm_gc_m4s_p", "2500", "M4's price");
	g_AUGPrice = CreateConVar("sm_gc_aug_p", "2500", "AUG's price");
	g_FAMASPrice = CreateConVar("sm_gc_famas_p", "2500", "Famas's price");
	
	//SMG
	g_BZNPrice = CreateConVar("sm_gc_bizon_p", "2500", "Bizon's price");	
	g_P90Price = CreateConVar("sm_gc_p90_p", "2500", "P900000!");
	
	//Pistol convars
	g_USPPrice = CreateConVar("sm_gc_usp_p", "2000", "USP MANIA!");	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Extra convars/////////////////////////////////////////////////////////////////////////////////////////////////////////////
	g_DropPri = CreateConVar("sm_gc_dropprimary", "1", "Force the player to drop his/her primary weapon? 1- yes 0 - no");
	g_DropSec = CreateConVar("sm_gc_dropsecondary", "1", "Force the player to drop his/her secondary weapon? 1- yes 0 - no");
	g_GiveMoney = CreateConVar("sm_gc_givemoney", "10000", "The amount of money you're gonna set for /moneyg");
	// WIP
	//g_MoneyFlag = CreateConVar("sm_moneygive_flag", "a", "The sourcemod flag client needs in order to use it, leave empty to disable.", g_MoneyFlag);
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Commands//////////////////////////////////////////////////////////
	//Primary
	RegConsoleCmd("sm_ak", Command_ak, "Spawns a ak47", 0);
	RegConsoleCmd("sm_aug", Command_aug, "Spawns a aug", 0);
	RegConsoleCmd("sm_famas", Command_famas, "Spawns a famas", 0);
	RegConsoleCmd("sm_m4", Command_m4a1, "M4A1!", 0);
	RegConsoleCmd("sm_m4s", Command_m4a1s, "M4A1S!", 0);
	
	//SNIPER
	RegConsoleCmd("sm_awp", Command_awp, "AWP MANIA!", 0);
	//SMG
	RegConsoleCmd("sm_bzn", Command_bzn, "Spawns a bizon", 0);
	RegConsoleCmd("sm_bizon", Command_bzn, "Spawns a bizon", 0);
	RegConsoleCmd("sm_p90", Command_p90, "Spawns a p90", 0);
	
	//Pistols
	RegConsoleCmd("sm_usp", Command_usp, "USP MANIA", 0);
	
	//Grenades
	RegConsoleCmd("sm_flash", Command_flash, "Spawns a flashbang", 0);
	RegConsoleCmd("sm_he", Command_he, "Spawns a flashbang", 0);
	RegConsoleCmd("sm_molo", Command_molot, "Spawns a flashbang", 0);
	RegConsoleCmd("sm_decoy", Command_decoy, "Spawns a flashbang", 0);
	
	RegConsoleCmd("sm_kevlar", Command_armor, "Spawns a flashbang", 0);
	RegConsoleCmd("sm_kev", Command_armor, "Spawns a flashbang", 0);
	RegAdminCmd("sm_moneyg", Command_moneyg,ADMFLAG_ROOT);
	////////////////////////////////////////////////////////////////////
	AutoExecConfig(true, "sm_guncommands_csgo");
}

public void OnClientConnected(int client){

	g_iSpam[client] = 0;

}
//AK47//////////////////////////////////////////////////////////////////////////////////////////
public Action Command_ak(int client,int args)
{
	//Declaring the client's money
	int cmoney = GetClientMoney(client);
	//Declaring gunprice that links to cvar
	int gunprice = g_AKPrice.IntValue;

	bool pass = CheckClientMoney(client, cmoney, gunprice);
	if (pass && g_iSpam[client] < GetTime())
	{
		SetClientMoney(client,cmoney - gunprice);

		GivePlayerItem(client, "weapon_ak47");
		PrintToChat(client, " \x04 A AK47 has been dropped for you!");

		g_iSpam[client] = GetTime()+5;

		if (g_DropPri.BoolValue)
		{
			//Forces player to drop his/her weapon=====
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
			CS_DropWeapon(client, weapon, false, true);
		}
	}
	else if (pass && g_iSpam[client] > GetTime())
	{
		PrintToChat(client, " \x04 Please wait for %i seconds before using again.",g_iSpam[client]-GetTime());
	}

	return Plugin_Handled;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////
//BIZON///////////////////////////////////////////////////////////////////////////////////////////////////////
public Action Command_bzn(int client,int args)
{
	//Declaring the client's money
	int cmoney = GetClientMoney(client);
	//Declaring gunprice that links to cvar
	int gunprice = g_BZNPrice.IntValue;

	bool pass = CheckClientMoney(client, cmoney, gunprice);
	if (pass && g_iSpam[client] < GetTime())// && GetConVarInt(g_DropPri)!=1)
	{
		SetClientMoney(client,cmoney - gunprice);

		GivePlayerItem(client, "weapon_bizon");
		PrintToChat(client, " \x04 An Bizon has been dropped for you!");

		g_iSpam[client] = GetTime()+5;

		if (g_DropPri.BoolValue)
		{
			//Forces player to drop his/her weapon=====
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
			CS_DropWeapon(client, weapon, false, true);
		}
	}
	else if (pass && g_iSpam[client] > GetTime())
	{
		PrintToChat(client, " \x04 or.. please wait for %i seconds.",g_iSpam[client]-GetTime());
	}

	return Plugin_Handled;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////
//P90///////////////////////////////////////////////////////////////////////////////////////////////////////
public Action Command_p90(int client,int args)
{
	//Declaring the client's money
	int cmoney = GetClientMoney(client);
	//Declaring gunprice that links to cvar
	int gunprice = g_P90Price.IntValue;

	bool pass = CheckClientMoney(client, cmoney, gunprice);
	if (pass && g_iSpam[client] < GetTime())// && GetConVarInt(g_DropPri)!=1)
	{
		SetClientMoney(client,cmoney - gunprice);

		GivePlayerItem(client, "weapon_p90");
		PrintToChat(client, " \x04 A P90 has been dropped for you!");

		g_iSpam[client] = GetTime()+5;

		if (g_DropPri.BoolValue)
		{
			//Forces player to drop his/her weapon=====
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
			CS_DropWeapon(client, weapon, false, true);
		}
	}
	else if (pass && g_iSpam[client] > GetTime())
	{
		PrintToChat(client, " \x04 or.. please wait for %i seconds.",g_iSpam[client]-GetTime());
	}

	return Plugin_Handled;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////
//AWP///////////////////////////////////////////////////////////////////////////////////////////////////////
public Action Command_awp(int client,int args)
{
	
	//Declaring the client's money
	int cmoney = GetClientMoney(client);
	//Declaring gunprice that links to cvar
	int gunprice = g_AwpPrice.IntValue;

	bool pass = CheckClientMoney(client, cmoney, gunprice);
	if (pass && g_iSpam[client] < GetTime())
	{
		SetClientMoney(client,cmoney - gunprice);

		GivePlayerItem(client, "weapon_awp");
		PrintToChat(client, " \x04 An AWP has been dropped for you!");

		g_iSpam[client] = GetTime()+5;

		if (g_DropPri.BoolValue)
		{
			//Forces player to drop his/her weapon=====
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
			CS_DropWeapon(client, weapon, false, true);
		}
	}
	else if (pass && g_iSpam[client] > GetTime())
	{
		PrintToChat(client, " \x04 or.. please wait for %i seconds.",g_iSpam[client]-GetTime());
	}

	return Plugin_Handled;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////
//Money G command///////////////////////////////////////////////////////////////////////////////////////////////////////
public Action Command_moneyg(int client,int args)
{
	
	if(g_MoneyFlag)
	{
	//Declare client's money
	int cmoney = GetClientMoney(client);
	//Set's the client money following cvar
	SetClientMoney(client, cmoney + g_GiveMoney.IntValue);
	PrintToChat(client, " \x04 You've been given $%i!", g_GiveMoney.IntValue);
	}
	return Plugin_Handled;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////
//M4A1///////////////////////////////////////////////////////////////////////////////////////////////////////
public Action Command_m4a1(int client,int args)
{
	//Declaring the client's money
	int cmoney = GetClientMoney(client);
	//Declaring gunprice that links to cvar
	int gunprice = g_M4Price.IntValue;

	bool pass = CheckClientMoney(client, cmoney, gunprice);
	if (pass && g_iSpam[client] < GetTime())
	{
		SetClientMoney(client,cmoney - gunprice);

		GivePlayerItem(client, "weapon_m4a1");
		PrintToChat(client, " \x04 An M4A1 has been dropped for you!");

		g_iSpam[client] = GetTime()+5;

		if (g_DropPri.BoolValue)
		{
			//Forces player to drop his/her weapon=====
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
			CS_DropWeapon(client, weapon, false, true);
		}
	}
	else if (pass && g_iSpam[client] > GetTime())
	{
		PrintToChat(client, " \x04 You do not have enough money!");
		PrintToChat(client, " \x04 or.. please wait for %i seconds.",g_iSpam[client]-GetTime());
	}

	return Plugin_Handled;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////
//M4A1-Silenced ///////////////////////////////////////////////////////////////////////////////////////////////////////
public Action Command_m4a1s(int client,int args)
{
	//Declaring the client's money
	int cmoney = GetClientMoney(client);
	//Declaring gunprice that links to cvar
	int gunprice = g_M4SPrice.IntValue;

	bool pass = CheckClientMoney(client, cmoney, gunprice);
	if (pass && g_iSpam[client] < GetTime())
	{
		SetClientMoney(client,cmoney - gunprice);

		GivePlayerItem(client, "weapon_m4a1_silencer");
		PrintToChat(client, " \x04 An M4A1-s has been dropped for you!");

		g_iSpam[client] = GetTime()+5;

		if (g_DropPri.BoolValue)
		{
			//Forces player to drop his/her weapon=====
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
			CS_DropWeapon(client, weapon, false, true);
		}
	}
	else if (pass && g_iSpam[client] > GetTime())
	{
		PrintToChat(client, " \x04 or.. please wait for %i seconds.",g_iSpam[client]-GetTime());
	}

	return Plugin_Handled;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////
//AUG///////////////////////////////////////////////////////////////////////////////////////////////////////
public Action Command_aug(int client,int args)
{
	//Declaring the client's money
	int cmoney = GetClientMoney(client);
	//Declaring gunprice that links to cvar
	int gunprice = g_AUGPrice.IntValue;

	bool pass = CheckClientMoney(client, cmoney, gunprice);
	if (pass && g_iSpam[client] < GetTime())
	{
		SetClientMoney(client,cmoney - gunprice);

		GivePlayerItem(client, "weapon_aug");
		PrintToChat(client, " \x04 An AUG has been dropped for you!");

		g_iSpam[client] = GetTime()+5;
		//Checks cvar
		if (g_DropPri.BoolValue)
		{
			//Forces player to drop his/her weapon=====
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
			CS_DropWeapon(client, weapon, false, true);
		}
	}
	else if (pass && g_iSpam[client] > GetTime())
	{
		PrintToChat(client, " \x04 or.. please wait for %i seconds.",g_iSpam[client]-GetTime());
	}

	return Plugin_Handled;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////
//FAMAS///////////////////////////////////////////////////////////////////////////////////////////////////////
public Action Command_famas(int client,int args)
{
	//Declaring the client's money
	int cmoney = GetClientMoney(client);
	//Declaring gunprice that links to cvar
	int gunprice = g_FAMASPrice.IntValue;

	bool pass = CheckClientMoney(client, cmoney, gunprice);
	if (pass && g_iSpam[client] < GetTime())
	{
		SetClientMoney(client,cmoney - gunprice);

		GivePlayerItem(client, "weapon_famas");
		PrintToChat(client, " \x04 A Famas has been dropped for you!");

		g_iSpam[client] = GetTime()+5;
		//Checks cvar
		if (g_DropPri.BoolValue)
		{
			//Forces player to drop his/her weapon=====
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
			CS_DropWeapon(client, weapon, false, true);
		}
	}
	else if (pass && g_iSpam[client] > GetTime())
	{
		PrintToChat(client, " \x04 or.. please wait for %i seconds.",g_iSpam[client]-GetTime());
	}

	return Plugin_Handled;
}

//USP///////////////////////////////////////////////////////////////////////////////////////////////////////
public Action Command_usp(int client,int args)
{
	//Declaring the client's money
	int cmoney = GetClientMoney(client);
	//Declaring gunprice that links to cvar
	int gunprice = g_USPPrice.IntValue;

	bool pass = CheckClientMoney(client, cmoney, gunprice);
	if (pass && g_iSpam[client] < GetTime())
	{
		SetClientMoney(client,cmoney - gunprice);

		GivePlayerItem(client, "weapon_usp_silencer");
		PrintToChat(client, " \x04 A USP Pistol has been dropped for you!");

		g_iSpam[client] = GetTime()+5;
		//Checks cvar
		if (g_DropSec.BoolValue)
		{
			//Forces player to drop his/her weapon=====
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY);
			CS_DropWeapon(client, weapon, false, true);
		}
	}
	else if (pass && g_iSpam[client] > GetTime())
	{
		PrintToChat(client, " \x04 or.. please wait for %i seconds.",g_iSpam[client]-GetTime());
	}

	return Plugin_Handled;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////
//HE GRENADE///////////////////////////////////////////////////////////////////////////////////////////////////////
public Action Command_he(int client,int args)
{
	int cmoney = GetClientMoney(client);
	int gunprice = 5000;
	
	bool pass = CheckClientMoney(client, cmoney, gunprice);
	if (pass && g_iSpam[client] < GetTime())
	{
	SetClientMoney(client,cmoney - gunprice);
	int weapon = GetPlayerWeaponSlot(client, CS_SLOT_GRENADE);
	CS_DropWeapon(client, weapon, true, false);
	GivePlayerItem(client, "weapon_hegrenade");
	PrintToChat(client, " \x04 A HE Nade has been dropped for you!");
		
	g_iSpam[client] = GetTime()+5;
	}

	return Plugin_Handled;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////
//MOLOTOV ///////////////////////////////////////////////////////////////////////////////////////////////////////
public Action Command_molot(int client,int args)
{	
	
	int cmoney = GetClientMoney(client);
	int gunprice = 10000;
	
	bool pass = CheckClientMoney(client, cmoney, gunprice);
	if (pass && g_iSpam[client] < GetTime())
	{
	SetClientMoney(client,cmoney - gunprice);
	int weapon = GetPlayerWeaponSlot(client, CS_SLOT_GRENADE);
	CS_DropWeapon(client, weapon, true, false);

	GivePlayerItem(client, "weapon_molotov");
	PrintToChat(client, " \x04 A molotov has been dropped for you!");
	g_iSpam[client] = GetTime()+5;
	}

	return Plugin_Handled;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////
//FLASHBANG ///////////////////////////////////////////////////////////////////////////////////////////////////////
public Action Command_flash(int client,int args)
{
	int cmoney = GetClientMoney(client);
	int gunprice = 5000;
	
	bool pass = CheckClientMoney(client, cmoney, gunprice);
	if (pass && g_iSpam[client] < GetTime())
	{
	SetClientMoney(client,cmoney - gunprice);
	int weapon = GetPlayerWeaponSlot(client, CS_SLOT_GRENADE);
	CS_DropWeapon(client, weapon, true, false);
		
	GivePlayerItem(client, "weapon_flash");
	PrintToChat(client, " \x04 A flashbang has been dropped for you!");
	g_iSpam[client] = GetTime()+5;

	}

	return Plugin_Handled;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////
//DECOY GRENADE///////////////////////////////////////////////////////////////////////////////////////////////////////
public Action Command_decoy(int client,int args)
{
	int cmoney = GetClientMoney(client);
	int gunprice = 5000;
	
	bool pass = CheckClientMoney(client, cmoney, gunprice);
	if (pass && g_iSpam[client] < GetTime())
	{
	SetClientMoney(client,cmoney - gunprice);
	int weapon = GetPlayerWeaponSlot(client, CS_SLOT_GRENADE);
	CS_DropWeapon(client, weapon, true, false);

	GivePlayerItem(client, "weapon_decoy");
	PrintToChat(client, " \x04 A decoy has been dropped for you!");
	g_iSpam[client] = GetTime()+5;
	}

	else if (pass && g_iSpam[client] > GetTime())
	{
		PrintToChat(client, " \x04 or.. please wait for %i seconds.",g_iSpam[client]-GetTime());
	}

	return Plugin_Handled;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////
//ARMOR OR KEVLAR///////////////////////////////////////////////////////////////////////////////////////////////////////
public Action Command_armor(int client,int args)
{
	int cmoney = GetClientMoney(client);
	int gunprice = 2500;
	
	bool pass = CheckClientMoney(client, cmoney, gunprice);
	if (pass && g_iSpam[client] < GetTime())
	{
	SetClientMoney(client,cmoney - gunprice);
	// Thanks to https://forums.alliedmods.net/showthread.php?t=250093
	SetEntProp( client, Prop_Data, "m_ArmorValue", 100, 1 );  
	PrintToChat(client, " \x04 Armor has been given to you!");
	g_iSpam[client] = GetTime()+5;

	}
	else if (pass && g_iSpam[client] > GetTime())
	{
		PrintToChat(client, " \x04 or.. please wait for %i seconds.",g_iSpam[client]-GetTime());
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////
