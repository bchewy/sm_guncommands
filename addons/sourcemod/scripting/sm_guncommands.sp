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
//stock bool CheckClientMoney(int client, int clientmoney, int weaponprice)
//{
//	if(clientmoney < weaponprice)
//	{
//		PrintToChat(client, " \x04 You do not have enough money!");
//		return false;
//	}
//	return true;
//}
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
ConVar g_DeagPrice;
ConVar g_F7Price;
ConVar g_GLOCKPrice;
ConVar g_P2KPrice;
ConVar g_CZ7Price;
ConVar g_ELITEPrice;
ConVar g_R8Price;
ConVar g_Tec9Price;
ConVar g_P250Price;
//Extras///////////////////////////////////////////////////////////////////////////////////////////////
ConVar g_DropPri;
ConVar g_DropSec;
ConVar g_DropNADE;
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
	g_USPPrice = CreateConVar("sm_gc_usp_p", "200", "USP's' Price");	
 	g_DeagPrice = CreateConVar("sm_gc_deag_p", "700", "Deagle's Price");	
	g_F7Price = CreateConVar("sm_gc_57_p", "500", "Five Seven's Price");	
	g_GLOCKPrice = CreateConVar("sm_gc_glock_p", "200", "Glock's Price!");	
	g_P2KPrice = CreateConVar("sm_gc_p2000_p", "200", "P2000's Price!");	
	g_CZ7Price = CreateConVar("sm_gc_cz_p", "500", "CZ's Price!");	
	g_ELITEPrice = CreateConVar("sm_gc_elites_p", "500", "Elite's Prices!!");	
	g_R8Price = CreateConVar("sm_gc_r8_p", "700", "R8's Price!");	
	g_Tec9Price = CreateConVar("sm_gc_tec9_p", "500", "Tec9's Price'!!");	
	g_P250Price = CreateConVar("sm_gc_p250_p", "300", "P250's Price");	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Extra convars/////////////////////////////////////////////////////////////////////////////////////////////////////////////
	g_DropPri = CreateConVar("sm_gc_dropprimary", "1", "Force the player to drop his/her primary weapon? 1- yes 0 - no");
	g_DropSec = CreateConVar("sm_gc_dropsecondary", "1", "Force the player to drop his/her secondary weapon? 1- yes 0 - no");
	g_DropNADE = CreateConVar("sm_gc_dropnades", "1", "Force the player to drop his/her nades? 1- yes 0 - no");
	g_GiveMoney = CreateConVar("sm_gc_givemoney", "10000", "The amount of money you're gonna set for /moneyg");
	// WIP
	g_MoneyFlag = CreateConVar("sm_moneygive_flag", "a", "The sourcemod flag client needs in order to use it, leave empty to disable.", g_MoneyFlag);
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Commands//////////////////////////////////////////////////////////
	//Primary
	RegConsoleCmd("sm_ak", Command_ak, "Spawns a ak47", 0);
	RegConsoleCmd("sm_ak47", Command_ak, "Spawns a ak47", 0);
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
	RegConsoleCmd("sm_glock", Command_glock, "USP MANIA", 0);
	RegConsoleCmd("sm_p250", Command_p250, "USP MANIA", 0);
	RegConsoleCmd("sm_deag", Command_deag, "USP MANIA", 0);
	RegConsoleCmd("sm_57", Command_57, "USP MANIA", 0);
	RegConsoleCmd("sm_five7", Command_57, "USP MANIA", 0);
	RegConsoleCmd("sm_cz", Command_cz, "USP MANIA", 0);
	RegConsoleCmd("sm_r8", Command_r8, "USP MANIA", 0);
	RegConsoleCmd("sm_elites", Command_elites, "USP MANIA", 0);
	RegConsoleCmd("sm_tec9", Command_tec9, "USP MANIA", 0);
	RegConsoleCmd("sm_t9", Command_tec9, "USP MANIA", 0);
	RegConsoleCmd("sm_p2000", Command_p2k, "USP MANIA", 0);
	RegConsoleCmd("sm_p2k", Command_p2k, "USP MANIA", 0);

	//Grenades
	RegConsoleCmd("sm_flash", Command_flash, "Spawns a flashbang", 0);
	RegConsoleCmd("sm_he", Command_he, "Spawns a flashbang", 0);
	RegConsoleCmd("sm_molo", Command_molot, "Spawns a flashbang", 0);
	RegConsoleCmd("sm_decoy", Command_decoy, "Spawns a flashbang", 0);
	
	RegConsoleCmd("sm_kevlar", Command_armor, "Spawns a flashbang", 0);
	RegConsoleCmd("sm_kev", Command_armor, "Spawns a flashbang", 0);
	RegAdminCmd("sm_moneyg", Command_moneyg,g_MoneyFlag);
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

	
	if (cmoney > gunprice && g_iSpam[client] < GetTime())
	{
		SetClientMoney(client,cmoney - gunprice);
		PrintToChat(client, " \x04 AK47 PRICE: $%i!", g_AKPrice.IntValue);
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
	else if (cmoney < gunprice && g_iSpam[client] > GetTime())
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

	
	if (cmoney > gunprice && g_iSpam[client] < GetTime())
	{
		SetClientMoney(client,cmoney - gunprice);
		PrintToChat(client, " \x04 BIZON PRICE: $%i!", g_BZNPrice.IntValue);
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
	else if (cmoney < gunprice && g_iSpam[client] > GetTime())
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

	
	if (cmoney > gunprice && g_iSpam[client] < GetTime())
	{
		SetClientMoney(client,cmoney - gunprice);
		PrintToChat(client, " \x04 P90 PRICE: $%i!", g_P90Price.IntValue);
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
	else if (cmoney < gunprice && g_iSpam[client] > GetTime())
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

	
	if (cmoney > gunprice && g_iSpam[client] < GetTime())
	{
		SetClientMoney(client,cmoney - gunprice);
		PrintToChat(client, " \x04 AWP PRICE: $%i!", g_AwpPrice.IntValue);
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
	else if (cmoney < gunprice && g_iSpam[client] > GetTime())
	{
		PrintToChat(client, " \x04 or.. please wait for %i seconds.",g_iSpam[client]-GetTime());
	}

	return Plugin_Handled;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////
//Money G command///////////////////////////////////////////////////////////////////////////////////////////////////////
public Action Command_moneyg(int client,int args)
{
	
	if(g_MoneyFlag == g_MoneyFlag)
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

	
	if (cmoney > gunprice && g_iSpam[client] < GetTime())
	{
		SetClientMoney(client,cmoney - gunprice);
		PrintToChat(client, " \x04 M4 PRICE: $%i!", g_M4Price.IntValue);
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
	else if (cmoney < gunprice && g_iSpam[client] > GetTime())
	{
		PrintToChat(client, " \x04 You do not have enough money! GunPrice:%i",gunprice);
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
	
	if (cmoney > gunprice && g_iSpam[client] < GetTime())
	{
		SetClientMoney(client,cmoney - gunprice);
		PrintToChat(client, " \x04 M4S PRICE: $%i!", g_M4SPrice.IntValue);
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
	else if (cmoney < gunprice && g_iSpam[client] > GetTime())
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

	
	if (cmoney > gunprice && g_iSpam[client] < GetTime())
	{
		SetClientMoney(client,cmoney - gunprice);
		PrintToChat(client, " \x04 AUG PRICE: $%i!", g_AUGPrice.IntValue);
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
	else if (cmoney < gunprice && g_iSpam[client] > GetTime())
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

	
	if (cmoney > gunprice && g_iSpam[client] < GetTime())
	{
		SetClientMoney(client,cmoney - gunprice);
		PrintToChat(client, " \x04 FAMAS PRICE: $%i!", g_FAMASPrice.IntValue);
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
	else if (cmoney < gunprice && g_iSpam[client] > GetTime())
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

	
	if (cmoney > gunprice && g_iSpam[client] < GetTime())
	{
		SetClientMoney(client,cmoney - gunprice);
		PrintToChat(client, " \x04 USP PRICE: $%i!", g_USPPrice.IntValue);
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
	else if (cmoney < gunprice && g_iSpam[client] > GetTime())
	{
		PrintToChat(client, " \x04 or.. please wait for %i seconds.",g_iSpam[client]-GetTime());
	}

	return Plugin_Handled;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////

//Glock///////////////////////////////////////////////////////////////////////////////////////////////////////
public Action Command_glock(int client,int args)
{
	//Declaring the client's money
	int cmoney = GetClientMoney(client);
	//Declaring gunprice that links to cvar
	int gunprice = g_GLOCKPrice.IntValue;

	
	if (cmoney > gunprice && g_iSpam[client] < GetTime())
	{
		SetClientMoney(client,cmoney - gunprice);
		PrintToChat(client, " \x04 Glock PRICE: $%i!", g_GLOCKPrice.IntValue);
		GivePlayerItem(client, "weapon_glock");
		PrintToChat(client, " \x04 A Glock Pistol has been dropped for you!");

		g_iSpam[client] = GetTime()+5;
		//Checks cvar
		if (g_DropSec.BoolValue)
		{
			//Forces player to drop his/her weapon=====
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY);
			CS_DropWeapon(client, weapon, false, true);
		}
	}
	else if (cmoney < gunprice && g_iSpam[client] > GetTime())
	{
		PrintToChat(client, " \x04 or.. please wait for %i seconds.",g_iSpam[client]-GetTime());
	}

	return Plugin_Handled;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////

//P250///////////////////////////////////////////////////////////////////////////////////////////////////////
public Action Command_p250(int client,int args)
{
	//Declaring the client's money
	int cmoney = GetClientMoney(client);
	//Declaring gunprice that links to cvar
	int gunprice = g_P250Price.IntValue;

	
	if (cmoney > gunprice && g_iSpam[client] < GetTime())
	{
		SetClientMoney(client,cmoney - gunprice);

		GivePlayerItem(client, "weapon_p250");
		PrintToChat(client, " \x04 A P250 Pistol has been dropped for you!");

		g_iSpam[client] = GetTime()+5;
		//Checks cvar
		if (g_DropSec.BoolValue)
		{
			//Forces player to drop his/her weapon=====
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY);
			CS_DropWeapon(client, weapon, false, true);
		}
	}
	else if (cmoney < gunprice && g_iSpam[client] > GetTime())
	{
		PrintToChat(client, " \x04 or.. please wait for %i seconds.",g_iSpam[client]-GetTime());
	}

	return Plugin_Handled;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////

//DEAGLE///////////////////////////////////////////////////////////////////////////////////////////////////////
public Action Command_deag(int client,int args)
{
	//Declaring the client's money
	int cmoney = GetClientMoney(client);
	//Declaring gunprice that links to cvar
	int gunprice = g_DeagPrice.IntValue;

	
	if (cmoney > gunprice && g_iSpam[client] < GetTime())
	{
		SetClientMoney(client,cmoney - gunprice);

		GivePlayerItem(client, "weapon_deagle");
		PrintToChat(client, " \x04 A Deagle has been dropped for you!");

		g_iSpam[client] = GetTime()+5;
		//Checks cvar
		if (g_DropSec.BoolValue)
		{
			//Forces player to drop his/her weapon=====
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY);
			CS_DropWeapon(client, weapon, false, true);
		}
	}
	else if (cmoney < gunprice && g_iSpam[client] > GetTime())
	{
		PrintToChat(client, " \x04 or.. please wait for %i seconds.",g_iSpam[client]-GetTime());
	}

	return Plugin_Handled;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////

//TEC9///////////////////////////////////////////////////////////////////////////////////////////////////////
public Action Command_tec9(int client,int args)
{
	//Declaring the client's money
	int cmoney = GetClientMoney(client);
	//Declaring gunprice that links to cvar
	int gunprice = g_Tec9Price.IntValue;

	
	if (cmoney > gunprice && g_iSpam[client] < GetTime())
	{
		SetClientMoney(client,cmoney - gunprice);

		GivePlayerItem(client, "weapon_tec9");
		PrintToChat(client, " \x04 A Tec9 has been dropped for you!");

		g_iSpam[client] = GetTime()+5;
		//Checks cvar
		if (g_DropSec.BoolValue)
		{
			//Forces player to drop his/her weapon=====
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY);
			CS_DropWeapon(client, weapon, false, true);
		}
	}
	else if (cmoney < gunprice && g_iSpam[client] > GetTime())
	{
		PrintToChat(client, " \x04 or.. please wait for %i seconds.",g_iSpam[client]-GetTime());
	}

	return Plugin_Handled;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////

//p2000///////////////////////////////////////////////////////////////////////////////////////////////////////
public Action Command_p2k(int client,int args)
{
	//Declaring the client's money
	int cmoney = GetClientMoney(client);
	//Declaring gunprice that links to cvar
	int gunprice = g_P2KPrice.IntValue;

	
	if (cmoney > gunprice && g_iSpam[client] < GetTime())
	{
		SetClientMoney(client,cmoney - gunprice);

		GivePlayerItem(client, "weapon_hkp2000");
		PrintToChat(client, " \x04 A p2000 has been dropped for you!");

		g_iSpam[client] = GetTime()+5;
		//Checks cvar
		if (g_DropSec.BoolValue)
		{
			//Forces player to drop his/her weapon=====
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY);
			CS_DropWeapon(client, weapon, false, true);
		}
	}
	else if (cmoney < gunprice && g_iSpam[client] > GetTime())
	{
		PrintToChat(client, " \x04 or.. please wait for %i seconds.",g_iSpam[client]-GetTime());
	}

	return Plugin_Handled;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////



//ELITES///////////////////////////////////////////////////////////////////////////////////////////////////////
public Action Command_elites(int client,int args)
{
	//Declaring the client's money
	int cmoney = GetClientMoney(client);
	//Declaring gunprice that links to cvar
	int gunprice = g_ELITEPrice.IntValue;

	
	if (cmoney > gunprice && g_iSpam[client] < GetTime())
	{
		SetClientMoney(client,cmoney - gunprice);

		GivePlayerItem(client, "weapon_elite");
		PrintToChat(client, " \x04 A Dualies has been dropped for you!");

		g_iSpam[client] = GetTime()+5;
		//Checks cvar
		if (g_DropSec.BoolValue)
		{
			//Forces player to drop his/her weapon=====
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY);
			CS_DropWeapon(client, weapon, false, true);
		}
	}
	else if (cmoney < gunprice && g_iSpam[client] > GetTime())
	{
		PrintToChat(client, " \x04 or.. please wait for %i seconds.",g_iSpam[client]-GetTime());
	}

	return Plugin_Handled;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////


//FIVESEVEN///////////////////////////////////////////////////////////////////////////////////////////////////////
public Action Command_57(int client,int args)
{
	//Declaring the client's money
	int cmoney = GetClientMoney(client);
	//Declaring gunprice that links to cvar
	int gunprice = g_F7Price.IntValue;

	
	if (cmoney > gunprice && g_iSpam[client] < GetTime())
	{
		SetClientMoney(client,cmoney - gunprice);

		GivePlayerItem(client, "weapon_fiveseven");
		PrintToChat(client, " \x04 A FiveSeven has been dropped for you!");

		g_iSpam[client] = GetTime()+5;
		//Checks cvar
		if (g_DropSec.BoolValue)
		{
			//Forces player to drop his/her weapon=====
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY);
			CS_DropWeapon(client, weapon, false, true);
		}
	}
	else if (cmoney < gunprice && g_iSpam[client] > GetTime())
	{
		PrintToChat(client, " \x04 or.. please wait for %i seconds.",g_iSpam[client]-GetTime());
		PrintToChat(client, " \x04 Gun price is :%i. Do you have enough?", gunprice);
	}

	return Plugin_Handled;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////


//R8///////////////////////////////////////////////////////////////////////////////////////////////////////
public Action Command_r8(int client,int args)
{
	//Declaring the client's money
	int cmoney = GetClientMoney(client);
	//Declaring gunprice that links to cvar
	int gunprice = g_R8Price.IntValue;

	
	if (cmoney > gunprice && g_iSpam[client] < GetTime())
	{
		SetClientMoney(client,cmoney - gunprice);

		GivePlayerItem(client, "weapon_revolver");
		PrintToChat(client, " \x04 A R8 has been dropped for you!");

		g_iSpam[client] = GetTime()+5;
		//Checks cvar
		if (g_DropSec.BoolValue)
		{
			//Forces player to drop his/her weapon=====
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY);
			CS_DropWeapon(client, weapon, false, true);
		}
	}
	else if (cmoney < gunprice && g_iSpam[client] > GetTime())
	{
		PrintToChat(client, " \x04 or.. please wait for %i seconds.",g_iSpam[client]-GetTime());
	}

	return Plugin_Handled;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////

//CZ///////////////////////////////////////////////////////////////////////////////////////////////////////
public Action Command_cz(int client,int args)
{
	//Declaring the client's money
	int cmoney = GetClientMoney(client);
	//Declaring gunprice that links to cvar
	int gunprice = g_CZ7Price.IntValue;

	
	if (cmoney > gunprice && g_iSpam[client] < GetTime())
	{
		SetClientMoney(client,cmoney - gunprice);

		GivePlayerItem(client, "weapon_cz75a");
		PrintToChat(client, " \x04 A CZ75 has been dropped for you!");

		g_iSpam[client] = GetTime()+5;
		//Checks cvar
		if (g_DropSec.BoolValue)
		{
			//Forces player to drop his/her weapon=====
			int weapon = GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY);
			CS_DropWeapon(client, weapon, false, true);
		}
	}
	else if (cmoney < gunprice && g_iSpam[client] > GetTime())
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
	

	if (cmoney > gunprice && g_iSpam[client] < GetTime())
	{
	SetClientMoney(client,cmoney - gunprice);
	
	if (g_DropNADE.BoolValue)
	{
		//Forces player to drop his/her weapon=====
		int weapon = GetPlayerWeaponSlot(client, CS_SLOT_GRENADE);
		GivePlayerItem(client, "weapon_hegrenade");

		CS_DropWeapon(client, weapon, false, true);
		PrintToChat(client, " \x04 A HE Nade has been dropped for you!");
	}
	//GivePlayerItem(client, "weapon_hegrenade");

	
	}
	else if (g_DropNADE.BoolValue != true)
	{
		GivePlayerItem(client, "weapon_hegrenade");
		PrintToChat(client, " \x04 A HE Nade has been dropped for you!");

	}
	else
	{
		PrintToChat(client, " \x04 You do not have enough money!");
		PrintToChat(client, " \x04 or.. please wait for %i seconds.",g_iSpam[client]-GetTime());
}
	g_iSpam[client] = GetTime()+5;
	return Plugin_Handled;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////
//MOLOTOV ///////////////////////////////////////////////////////////////////////////////////////////////////////
public Action Command_molot(int client,int args)
{	
	
	int cmoney = GetClientMoney(client);
	int gunprice = 11000;
	

	if (cmoney > gunprice && g_iSpam[client] < GetTime())
	{
	SetClientMoney(client,cmoney - gunprice);
	int weapon = GetPlayerWeaponSlot(client, CS_SLOT_GRENADE);
	CS_DropWeapon(client, weapon, true, false);

	GivePlayerItem(client, "weapon_molotov");
	PrintToChat(client, " \x04 A molotov has been dropped for you!");
	g_iSpam[client] = GetTime()+5;
	}
	else
	{
		PrintToChat(client, " \x04 You do not have enough money!");
		PrintToChat(client, " \x04 or.. please wait for %i seconds.",g_iSpam[client]-GetTime());
}

	return Plugin_Handled;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////
//FLASHBANG ///////////////////////////////////////////////////////////////////////////////////////////////////////
public Action Command_flash(int client,int args)
{
	int cmoney = GetClientMoney(client);
	int gunprice = 5000;
	
	if (cmoney > gunprice && g_iSpam[client] < GetTime())
	{
	SetClientMoney(client,cmoney - gunprice);
	int weapon = GetPlayerWeaponSlot(client, CS_SLOT_GRENADE);

	GivePlayerItem(client, "weapon_flash");
	PrintToChat(client, " \x04 A flashbang has been dropped for you!");
	g_iSpam[client] = GetTime()+5;

	}
	else
	{
		PrintToChat(client, " \x04 You do not have enough money!");
		PrintToChat(client, " \x04 or.. please wait for %i seconds.",g_iSpam[client]-GetTime());
}

	return Plugin_Handled;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////
//DECOY GRENADE///////////////////////////////////////////////////////////////////////////////////////////////////////
public Action Command_decoy(int client,int args)
{
	int cmoney = GetClientMoney(client);
	int gunprice = 7000;
	
	if (cmoney > gunprice && g_iSpam[client] < GetTime())
	{
	SetClientMoney(client,cmoney - gunprice);
	int weapon = GetPlayerWeaponSlot(client, CS_SLOT_GRENADE);

	GivePlayerItem(client, "weapon_decoy");
	PrintToChat(client, " \x04 A decoy has been dropped for you!");
	g_iSpam[client] = GetTime()+5;

	}
	else
	{
		PrintToChat(client, " \x04 You do not have enough money!");
		PrintToChat(client, " \x04 or.. please wait for %i seconds.",g_iSpam[client]-GetTime());
}

	return Plugin_Handled;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////
//ARMOR OR KEVLAR///////////////////////////////////////////////////////////////////////////////////////////////////////
public Action Command_armor(int client,int args)
{
	int cmoney = GetClientMoney(client);
	int gunprice = 1500;
	

	if (cmoney > gunprice && g_iSpam[client] < GetTime())
	{
	SetClientMoney(client,cmoney - gunprice);
	
	// Thanks to https://forums.alliedmods.net/showthread.php?t=250093
	SetEntProp( client, Prop_Data, "m_ArmorValue", 100, 1 );  
	PrintToChat(client, " \x04 Armor has been given to you!");
	g_iSpam[client] = GetTime()+5;

	}
	else if (cmoney < gunprice && g_iSpam[client] > GetTime())
	{
		PrintToChat(client, " \x04 or.. please wait for %i seconds.",g_iSpam[client]-GetTime());
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////
