private ["_unit","_goggles","_handgunitems","_primaryWeaponItems", "_headgear","_uniform","_uniformItems","_vest","_magazines","_primMag","_secmMag","_handMag","_assigneditems",
         "_vestItems","_secondaryWeaponItems","_handgunWeapon","_backpack","_backpackthings","_primaryWeapon","_secondaryWeapon","_null","_rating","_role","_exp","_level"];


_unit = _this;
if (CP_debug) then {player sidechat format ["rating add: %1", CP_rating]};

if (MCC_saveGear) then 
{
	_goggles = goggles _unit; 			//Can't  save gear after killed EH
	_headgear = headgear _unit; 
	_uniform = uniform _unit; 
	_vest = vest _unit;
	_backpack = backpack _unit;

	_primMag = primaryWeaponMagazine _unit;
	_secmMag = secondaryWeaponMagazine  _unit;
	_handMag = handgunMagazine _unit;
	_items = items _unit;
	_assigneditems = assigneditems _unit;

	//_primaryWeaponItems = primaryWeaponItems _unit;
	//_secondaryWeaponItems = secondaryWeaponItems _unit;
	//_handgunitems = handgunItems _unit; 
	_uniformItems = uniformItems _unit;
	_vestItems = vestItems _unit;

	_primaryWeapon = primaryWeapon _unit;
	_secondaryWeapon = secondaryWeapon _unit;
	_handgunWeapon = handgunWeapon _unit; 
	_magazines = magazines _unit;
};

if (!isnil "mcc_actionInedx") then
{	
	_unit removeAction mcc_actionInedx;
};

WaitUntil {alive player};

if (isnil ("MCC_TRAINING")) then {deleteVehicle _unit};

if (MCC_saveGear) then 
{
	removeGoggles player;
	removeHeadgear player;
	removeUniform player;
	removeVest player;
	removeBackpack player;

	removeAllWeapons player;
	removeAllItems player; 
	removeAllAssignedItems player;

	if (_goggles != "") then {player addGoggles _goggles};
	if (_headgear != "") then {player addHeadgear _headgear};
	if (_uniform != "") then {player addUniform _uniform};
	if (_vest != "") then {player addVest _vest};
	if (_backpack != "") then {player addBackpack _backpack};

	waituntil {backpack player == _backpack};
	
	if (!isnil "_uniformItems") then
	{
		{
			switch (true) do
				{
					case (isClass (configFile >> "CfgMagazines" >> _x)) : {player addmagazine _x};
					case (isClass (configFile >> "CfgWeapons" >> _x)) : {player additem _x};
					case (isClass (configFile >> "CfgGlasses" >> _x)) : {player additem _x};
				}; 
		} foreach _uniformItems;
	};
	
	if (!isnil "_assigneditems") then
	{
		{
			switch (true) do
				{
					case (isClass (configFile >> "CfgMagazines" >> _x)) : {player addmagazine _x};
					case (isClass (configFile >> "CfgWeapons" >> _x)) : {player addWeaponGlobal _x;player linkItem  _x};
					case (isClass (configFile >> "CfgGlasses" >> _x)) : {player additem _x;player assignItem _x};
				}; 
		} foreach _assigneditems;
	};
	
	
	if (!isnil "_vestItems") then
	{
		{
			switch (true) do
				{
					case (isClass (configFile >> "CfgMagazines" >> _x)) : {player addmagazine _x};
					case (isClass (configFile >> "CfgWeapons" >> _x)) : {player additem _x};
					case (isClass (configFile >> "CfgGlasses" >> _x)) : {player additem _x};
				}; 
		} foreach _vestItems;
	};
	
	if (!isnil "MCC_save_Backpack") then
	{
		{
			switch (true) do
			{
				case (isClass (configFile >> "CfgMagazines" >> _x)) : {(unitBackpack player) addMagazineCargo [_x,1]};
				case (isClass (configFile >> "CfgWeapons" >> _x)) : {(unitBackpack player) addItemCargo [_x,1]};
				case (isClass (configFile >> "CfgGlasses" >> _x)) : {(unitBackpack player) addItemCargo [_x,1]};
			}; 
		} foreach MCC_save_Backpack;
	};
	
	if (!isnil "_primaryWeapon") then 
	{
		player addWeaponGlobal  _primaryWeapon;
		{player addPrimaryWeaponItem _x} foreach MCC_save_primaryWeaponItems;
		
		{
			if (_x != "") then {player addmagazine _x};
		} foreach _primMag;
	};
	
	if (!isnil "_secondaryWeapon") then 
	{
		player addWeaponGlobal  _secondaryWeapon;
		{player addSecondaryWeaponItem _x} foreach MCC_save_secondaryWeaponItems;
		
		{
			if (_x != "") then {player addmagazine _x};
		} foreach _secmMag;
	};
	
	if (!isnil "_handgunWeapon") then 
	{
		player addWeaponGlobal  _handgunWeapon;
		{player addHandgunItem _x} foreach MCC_save_handgunitems;
		
			{
				if (_x != "") then {player addmagazine _x};
			} foreach _handMag;
	};

	if (!isnil "_primaryWeapon") then
	{
		player selectWeapon _primaryWeapon;
		_muzzles = getArray(configFile>>"cfgWeapons" >> _primaryWeapon >> "muzzles");
		player selectWeapon (_muzzles select 0);
	}; 
};
	
if (player getvariable ["MCC_allowed",false]) then 
	{
		mcc_actionInedx = player addaction ["<t color=""#99FF00"">--= Mission generator =--</t>", MCC_path + "mcc\dialogs\mcc_PopupMenu.sqf",[], 0,false, false, "teamSwitch","vehicle _target == vehicle _this"];
		//player setvariable ["MCC_allowed",true,true];
	};
	
_null = player addaction ["<t color=""#FFCC00"">Open MCC Console</t>", MCC_path + "mcc\general_scripts\console\conoleOpenMenu.sqf",[0],-1,false,true,"teamSwitch",MCC_consoleString];

if (CP_activated) exitWith 
{
	_role = player getvariable "CP_role";							//Get player's role
	_exp = call compile format  ["%1Level select 1",_role]; 		//Get role exp
	if (!isnil "_exp") then 
	{
		if (CP_debug) then {player sidechat format ["rating: %1", _exp]};
		_exp = (_exp + CP_rating);
		if (_exp < 0) then {_exp = 0}; 
		_level = call compile format ["[%1,%2]",floor (_exp/5000)+1 ,_exp];
		if (CP_debug) then {player sidechat format ["level: %1",_level]};
		[[format ["%1Level",_role],getplayeruID player,_level], "CP_fnc_setVariable", false, false] spawn BIS_fnc_MP;
	};
	
	_null=[] execVM CP_path + "scripts\player\player_init.sqf";
}; 