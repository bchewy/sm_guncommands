# Gun Commands for Sourcemod
# Made specifically for zombie escape servers <ZE>

TODO: 
- cleanup code
- more guns/custom models for guns? (not weapon skins)
- chat triggers in a config file for different gun types
- convar to remove chat triggers
- flag for certain commands
- moneygive admin command <with specified flag>
## Installation

Upload .smx file to /plugins/ folder
Configure configs in /cfg/sm_guncommands_csgo.cfg/

## Gun List (Case sensitive)
```
ak - AK47
awp - AWP sniper
m4 - M4A1 
m4s - M4A1-Silenced
aug - AUG 
famas - Famas
bizon/bzn - Bizon
p90 - P90
usp - usp pistol
glock - glock pistol
p250 - p250 pistol
deag - deagle
57/five7 - fiveseven pistol
cz - cz pistol
r8 - revolver/r8 pistol
elites - elites/dual berratas
tec9/t9 - tec9/t9 pistols
p2000/p2k - p2000 pistol
flash - flash grenade
he - he grenade 
molo - molotov grenade
decoy - decoy grenade
kev/kevlar - armor

a/b - a comes first for convars
<gunname> is only specified by this list... not EVERY csgo gun/weapon id
```
## Commands
```
sm_<gunname> - Drops the mentioned guns for players
sm_moneyg - Gives the client $x to spend.
```
##Convars
```
sm_gc_<gunname>_p <value> - Price for the gun in integer value(Default:Base gun price)
sm_gc_dropprimary <0/1> - Force the player to drop his/her current primary weapon? 1- Yes 0- No (Default :1)
sm_gc_dropsecondary <0/1> - Force the player to drop his/her current secondary weapon? 1- Yes 0-No (Default :1)
sm_gc_givemoney <value> - Amount of money given when client uses sm_moneyg (Default:10000)
sm_moneygive_flag <flags> - WIP
```
Discussion : https://forums.alliedmods.net/showthread.php?p=2512096
