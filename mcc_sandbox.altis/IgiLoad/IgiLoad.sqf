//////////////////////////////////////////////////////////////////////////////////////////////
//	IgiLoad v0.9.6																			//
//	Author: Igi_PL																			//
//	Version date: 2014.02.02																//
//																							//
//	USE:																					//
//	In Vehicles "INITIALIZATION" field type: "null=[this] execVM "IgiLoad\IgiLoad.sqf";"	//
//////////////////////////////////////////////////////////////////////////////////////////////

//if true then show debug globalChat (TODO add more hints)
IL_DevMod = false;

//waitUntil { !(isNull player) };
//waitUntil { time > 0 };
IL_Script_Inst = time;

if (IL_DevMod) then
{
	Player globalChat Format["IgiLoad ""%1"" IN.", IL_Script_Inst];
};

//if (isDedicated) exitwith {};
//if (isServer) exitwith {};

//	VARIABLES
_obj_main = _this select 0;
_obj_main_type = (typeOf _obj_main);

//Dealing with cargo damage
//-1 - do nothing
//0 - set to 0
//1 - keep such as before loading/unloading
IL_CDamage = 0;

//AddAction menu position
_Action_LU_Priority = 30; //Load and (para)unload
_Action_O_Priority = 0;	//Open and close
_Action_S_Priority = 0; //Setup

//Maximum capacity for vehicles
IL_Num_Slots_MOHAWK = -7;
IL_Num_Slots_KAMAZ = -4;
IL_Num_Slots_HEMTT = -5;
IL_Num_Slots_MH9 = -1;

//The minimum altitude for the drop with parachute
IL_Para_Drop_ATL = 30;

//Set smoke and light for parachute drop.
IL_Para_Smoke = true;
IL_Para_Light = true;
//Additional smoke after landing
IL_Para_Smoke_Add = true;
//Additional light after landing
IL_Para_Light_Add = true;
//Smoke and light color
IL_Para_Smoke_Default = "SmokeshellGreen";
IL_Para_Light_Default = "Chemlight_green";
IL_Para_Smoke_Veh = "SmokeshellBlue";
IL_Para_Light_Veh = "Chemlight_blue";

//This allows for loading or unloading, if a player is in the area of loading or copilot
IL_Can_CoPilot = true;
IL_Can_Outside = true;

//
IL_SDistU = 7;
IL_SDistL = 2.5;
IL_SDistL_Heli_offset = 1;

//Load and unload (not para) max speed in km/h
IL_LU_Speed = 10;
//Load and unload (not para) max height in m
IL_LU_Alt = 3;
//Enable or disable usable cargo ramp in CH-49
IL_Ramp = true;

// Supported vehicles
IL_Supported_Vehicles_HEMTT = ["B_Truck_01_covered_F", "B_Truck_01_transport_F", "B_Truck_01_box_F"];
IL_Supported_Vehicles_KAMAZ = ["I_Truck_02_transport_F", "O_Truck_02_transport_F", "I_Truck_02_covered_F", "O_Truck_02_covered_F"];
IL_Supported_Vehicles_MOHAWK = ["I_Heli_Transport_02_F"];
IL_Supported_Vehicles_MH9 = ["B_Heli_Light_01_F"];

// Vehicles with the ability to dropping the load on the parachute
IL_Para_Drop_Vehicles = IL_Supported_Vehicles_MOHAWK;//["I_Heli_Transport_02_F"];

//Supported cargo types
IL_Supported_Quadbike = ["I_Quadbike_01_F", "C_Quadbike_01_F", "O_Quadbike_01_F", "B_G_Quadbike_01_F", "B_Quadbike_01_F"];
IL_Supported_Supply_Crate = ["B_supplyCrate_F", "IG_supplyCrate_F", "O_supplyCrate_F", "I_supplyCrate_F"];
IL_Supported_Veh_Ammo = ["Box_NATO_AmmoVeh_F", "Box_East_AmmoVeh_F", "Box_IND_AmmoVeh_F", "Land_CargoBox_V1_F"];
IL_Supported_Barrel = ["Land_BarrelEmpty_F", "Land_BarrelSand_F", "Land_BarrelTrash_F", "Land_BarrelWater_F", "Land_MetalBarrel_F"];//, "Land_MetalBarrel_empty_F", "MetalBarrel_burning_F"];
IL_Supported_Tank = ["Land_WaterBarrel_F", "Land_WaterTank_F"];
IL_Supported_Rubberboat = ["I_Boat_Transport_01_F", "O_Boat_Transport_01_F", "B_G_Boat_Transport_01_F", "B_Boat_Transport_01_F", "C_Rubberboat", "O_Lifeboat", "B_Lifeboat"];
IL_Supported_SDV = ["I_SDV_01_F", "O_SDV_01_F", "B_SDV_01_F"];
IL_Supported_Box_H1 = ["Box_NATO_Wps_F", "Box_East_Wps_F", "Box_IND_Wps_F", "Box_East_WpsLaunch_F", "Box_NATO_WpsLaunch_F", "Box_IND_WpsLaunch_F", "Box_IND_WpsSpecial_F", "Box_East_WpsSpecial_F", "Box_NATO_WpsSpecial_F"];
IL_Supported_Box_H2 = ["Box_NATO_AmmoOrd_F", "Box_East_AmmoOrd_F", "Box_IND_AmmoOrd_F", "Box_NATO_Grenades_F", "Box_East_Grenades_F", "Box_IND_Grenades_F", "Box_NATO_Ammo_F", "Box_East_Ammo_F", "Box_IND_Ammo_F", "Box_IND_Support_F", "Box_East_Support_F", "Box_NATO_Support_F"];
//TODO
//IL_Supported_Backpack = ["B_AssaultPack_blk", "B_AssaultPack_cbr", "B_AssaultPack_dgtl", "B_AssaultPack_khk", "B_AssaultPack_mcamo", "B_AssaultPack_ocamo", "B_AssaultPack_rgr", "B_AssaultPack_sgg", "B_AssaultPackG", "B_Bergen_blk", "B_Bergen_mcamo", "B_Bergen_rgr", "B_Bergen_sgg", "B_BergenC_blu", "B_BergenC_grn", "B_BergenC_red", "B_BergenG", "B_Carryall_cbr", "B_Carryall_khk", "B_Carryall_mcamo", "B_Carryall_ocamo", "B_Carryall_oli", "B_Carryall_oucamo", "B_FieldPack_blk", "B_FieldPack_cbr", "B_FieldPack_khk", "B_FieldPack_ocamo", "B_FieldPack_oli", "B_FieldPack_oucamo", "B_HuntingBackpack", "B_Kitbag_cbr", "B_Kitbag_mcamo", "B_Kitbag_sgg", "B_OutdoorPack_blk", "B_OutdoorPack_blu", "B_OutdoorPack_tan", "B_TacticalPack_blk", "B_TacticalPack_mcamo", "B_TacticalPack_ocamo", "B_TacticalPack_oli", "B_TacticalPack_rgr", "C_Bergen_blu", "C_Bergen_grn", "C_Bergen_red", "G_AssaultPack", "G_Bergen"];
//IL_Supported_Backpack_Support = ["B_HMG_01_support_F", "B_HMG_01_support_high_F", "B_Mortar_01_support_F", "I_Mortar_01_support_F", "O_Mortar_01_support_F"];
//IL_Supported_Backpack_Weapon = ["B_AA_01_weapon_F", "B_AT_01_weapon_F", "B_GMG_01_A_high_weapon_F", "B_GMG_01_A_weapon_F", "B_GMG_01_A_weapon_F", "B_GMG_01_high_weapon_F", "B_GMG_01_weapon_F", "B_HMG_01_A_high_weapon_F", "B_HMG_01_A_weapon_F", "B_HMG_01_high_weapon_F", "B_HMG_01_weapon_F", "B_Mortar_01_weapon_F"];
//IL_Supported_Backpack_Uav = ["B_UAV_01_backpack_F", "I_UAV_01_backpack_F", "O_UAV_01_backpack_F"];
//IL_Supported_Parachute = ["B_Parachute"];

//IL_Supported_Backpack_All = IL_Supported_Backpack + IL_Supported_Backpack_Support + IL_Supported_Backpack_Weapon + IL_Supported_Backpack_Uav + IL_Supported_Parachute;
IL_Supported_Cargo_MH9 = IL_Supported_Supply_Crate + IL_Supported_Barrel;// + IL_Supported_Backpack_All;
IL_Supported_Cargo_Kamaz = IL_Supported_Quadbike + IL_Supported_Supply_Crate + IL_Supported_Veh_Ammo + IL_Supported_Barrel + IL_Supported_Tank + IL_Supported_Rubberboat + IL_Supported_Box_H1 + IL_Supported_Box_H2 + IL_Supported_SDV;
IL_Supported_Cargo_HEMMT = IL_Supported_Cargo_Kamaz;
IL_Supported_Cargo_Mohawk = IL_Supported_Quadbike + IL_Supported_Supply_Crate + IL_Supported_Veh_Ammo + IL_Supported_Barrel + IL_Supported_Tank + IL_Supported_Rubberboat;// + IL_Supported_SDV;

//	END VARIABLES

//	PROCEDURES AND FUNCTIONS

IL_Init_Veh =
{
	if (IL_DevMod) then
	{
		Player globalChat Format["IgiLoad ""%1"" IL_Init_Veh.", IL_Script_Inst];
	};

	private["_obj", "_obj_type", "_force"];
	_obj = _this select 0;
	_force = if (count _this > 1) then {_this select 1} else {false};
	_obj_type = (typeOf _obj);

	if (_obj_type in IL_Supported_Vehicles_MOHAWK) then
	{
		if ((isNil {_obj getVariable "box_num"}) || (_force)) then {_obj setVariable["box_num", 0, true];};
		if ((isNil {_obj getVariable "slots_num"}) || (_force)) then {_obj setVariable["slots_num", IL_Num_Slots_MOHAWK, true];};
		if ((isNil {_obj getVariable "can_load"}) || (_force)) then {_obj setVariable["can_load", true, true];};
		if ((isNil {_obj getVariable "can_copilot"}) || (_force)) then {_obj setVariable["can_copilot", IL_Can_CoPilot, true];};
		if ((isNil {_obj getVariable "can_outside"}) || (_force)) then {_obj setVariable["can_outside", IL_Can_Outside, true];};
		if ((isNil {_obj getVariable "zload"}) || (_force)) then {_obj setVariable["zload", -2.25, true];};
		if ((isNil {_obj getVariable "cargo_offset"}) || (_force)) then {_obj setVariable["cargo_offset", 4.5, true];};
		if ((isNil {_obj getVariable "usable_ramp"}) || (_force)) then {_obj setVariable["usable_ramp", IL_Ramp, true];};
	};
	if (_obj_type in IL_Supported_Vehicles_MH9) then
	{
		if ((isNil {_obj getVariable "box_l"}) || (_force)) then {_obj setVariable["box_l", _obj, true];};
		if ((isNil {_obj getVariable "box_r"}) || (_force)) then {_obj setVariable["box_r", _obj, true];};

		if ((isNil {_obj getVariable "box_num_l"}) || (_force)) then {_obj setVariable["box_num_l", 0, true];};
		if ((isNil {_obj getVariable "box_num_r"}) || (_force)) then {_obj setVariable["box_num_r", 0, true];};
		if ((isNil {_obj getVariable "slots_num_l"}) || (_force)) then {_obj setVariable["slots_num_l", IL_Num_Slots_MH9, true];};
		if ((isNil {_obj getVariable "slots_num_r"}) || (_force)) then {_obj setVariable["slots_num_r", IL_Num_Slots_MH9, true];};
		if ((isNil {_obj getVariable "can_load"}) || (_force)) then {_obj setVariable["can_load", true, true];};
		if ((isNil {_obj getVariable "can_copilot"}) || (_force)) then {_obj setVariable["can_copilot", IL_Can_CoPilot, true];};
		if ((isNil {_obj getVariable "can_outside"}) || (_force)) then {_obj setVariable["can_outside", IL_Can_Outside, true];};
		if ((isNil {_obj getVariable "zload"}) || (_force)) then {_obj setVariable["zload", -0.41, true];};
		if ((isNil {_obj getVariable "cargo_offset"}) || (_force)) then {_obj setVariable["cargo_offset", 1, true];};
	};
	if (_obj_type in IL_Supported_Vehicles_KAMAZ) then
	{
		if ((isNil {_obj getVariable "box_num"}) || (_force)) then {_obj setVariable["box_num", 0, true];};
		if ((isNil {_obj getVariable "slots_num"}) || (_force)) then {_obj setVariable["slots_num", IL_Num_Slots_KAMAZ, true];};
		if ((isNil {_obj getVariable "can_load"}) || (_force)) then {_obj setVariable["can_load", true, true];};
		if ((isNil {_obj getVariable "can_outside"}) || (_force)) then {_obj setVariable["can_outside", IL_Can_Outside, true];};
		if ((isNil {_obj getVariable "zload"}) || (_force)) then {_obj setVariable["zload", -0.8, true];};
		if ((isNil {_obj getVariable "cargo_offset"}) || (_force)) then {_obj setVariable["cargo_offset", -0.5, true];};
	};
	if (_obj_type in IL_Supported_Vehicles_HEMTT) then
	{
		if ((isNil {_obj getVariable "box_num"}) || (_force)) then {_obj setVariable["box_num", 0, true];};
		if ((isNil {_obj getVariable "slots_num"}) || (_force)) then {_obj setVariable["slots_num", IL_Num_Slots_HEMTT, true];};
		if ((isNil {_obj getVariable "can_load"}) || (_force)) then {_obj setVariable["can_load", true, true];};
		if ((isNil {_obj getVariable "can_outside"}) || (_force)) then {_obj setVariable["can_outside", IL_Can_Outside, true];};
		if (_obj_type == "B_Truck_01_box_F") then
		{
			if ((isNil {_obj getVariable "zload"}) || (_force)) then {_obj setVariable["zload", -0.4, true];};
			if ((isNil {_obj getVariable "cargo_offset"}) || (_force)) then {_obj setVariable["cargo_offset", 0.8, true];};
		}
		else
		{
			if ((isNil {_obj getVariable "zload"}) || (_force)) then {_obj setVariable["zload", -0.5, true];};
			if ((isNil {_obj getVariable "cargo_offset"}) || (_force)) then {_obj setVariable["cargo_offset", 0, true];};
		};
	};
};
// END IL_Init_Veh

IL_Init_Box =
{
	if (IL_DevMod) then
	{
		Player globalChat Format["IgiLoad ""%1"" IL_Init_Box.", IL_Script_Inst];
	};

	private["_obj", "_obj_type"];
	_obj = _this select 0;
	
	_obj setVariable["attachedPos", 0, true];
	_obj setVariable["attachedTruck", _obj, true];
	_obj setVariable["doors", "N", true];
	
	_obj setVariable["slots", 1, true];
	_obj setVariable["zload", 0, true];
	_obj setVariable["cargo_offset", 0, true];
	_obj_type = (typeOf _obj); 
	if (_obj_type in IL_Supported_Rubberboat) then
	{
		_obj setVariable["slots", 5, true];
		_obj setVariable["zload", 1.25, true];
		_obj setVariable["cargo_offset", 2, true];
	};
	if (_obj_type in IL_Supported_SDV) then
	{
		_obj setVariable["slots", 6, true];
		_obj setVariable["zload", 1.9, true];
		_obj setVariable["cargo_offset", 1.6, true];
	};
	if (_obj_type in IL_Supported_Quadbike) then
	{
		_obj setVariable["slots", 2, true];
		_obj setVariable["zload", 1.4, true];
		_obj setVariable["cargo_offset", 0.5, true];
	};
	if (_obj_type in IL_Supported_Veh_Ammo) then
	{
		_obj setVariable["slots", 2, true];
		_obj setVariable["zload", 0.75, true];
		_obj setVariable["cargo_offset", 0.4, true];
	};
	if (_obj_type in IL_Supported_Box_H1) then
	{
		_obj setVariable["zload", 0.16, true];
	};
	if (_obj_type in IL_Supported_Box_H2) then
	{
		_obj setVariable["zload", 0.25, true];
	};
	if (_obj_type in IL_Supported_Barrel) then
	{
		_obj setVariable["zload", 0.45, true];
	};
	if (_obj_type in IL_Supported_Tank) then
	{
		if (_obj_type == "Land_WaterTank_F") then
		{
			_obj setVariable["slots", 3, true];
			_obj setVariable["zload", 0.87, true];
			_obj setVariable["cargo_offset", 1, true];
		}
		else
		{
			_obj setVariable["slots", 2, true];
			_obj setVariable["zload", 0.62, true];
			_obj setVariable["cargo_offset", 0.4, true];
		};
		_turn = true;
	};
};
//	END IL_Init_Box

IL_Move_Attach=
{
	private ["_veh", "_obj", "_from", "_to", "_pos", "_step", "_steps", "_from_x", "_from_y", "_from_z", "_to_x", "_to_y", "_to_z", "_x", "_y", "_z", "_i", "_x_step", "_y_step", "_z_step", "_turn"];
	_veh = _this select 0;
	_obj = _this select 1;
	_from = _this select 2;
	_to = _this select 3;
	_step = _this select 4;
	_turn = if (count _this > 5) then {_this select 5} else {false};
	
	_from_x = _from select 0;
	_from_y = _from select 1;
	_from_z = _from select 2;
	if (IL_DevMod) then
	{
		Player globalChat Format ["IgiLoad ""%1"". IL_Move_Attach _from_x =""%2"", _from_y =""%3"", _from_z =""%4""", IL_Script_Inst, _from_x, _from_y, _from_z];
	};

	_to_x = _to select 0;
	_to_y = _to select 1;
	_to_z = _to select 2;
	if (IL_DevMod) then
	{
		Player globalChat Format ["IgiLoad ""%1"". IL_Move_Attach _to_x =""%2"", _to_y =""%3"", _to_z =""%4""", IL_Script_Inst, _to_x, _to_y, _to_z];
	};
	
	_x = _to_x - _from_x;
	_y = _to_y - _from_y;
	_z = _to_z - _from_z;
	if (IL_DevMod) then
	{
		Player globalChat Format ["IgiLoad ""%1"". IL_Move_Attach _x =""%2"", _y =""%3"", _z =""%4""", IL_Script_Inst, _x, _y, _z];
	};
	
	if (((abs _x) > (abs _y)) && ((abs _x) > (abs _z))) then
	{
		_steps = round ((abs _x) / _step);
		if (IL_DevMod) then
		{
			Player globalChat Format ["IgiLoad ""%1"". IL_Move_Attach _x > _y and _z, _steps =""%2""", IL_Script_Inst, _steps];
		};
	}
	else
	{
		if ((abs _y) > (abs _z)) then
		{
			_steps = round ((abs _y) / _step);
			if (IL_DevMod) then
			{
				Player globalChat Format ["IgiLoad ""%1"". IL_Move_Attach _y > _z, _steps =""%2""", IL_Script_Inst, _steps];
			};
		}
		else
		{
			_steps = round ((abs _z) / _step);
			if (IL_DevMod) then
			{
				Player globalChat Format ["IgiLoad ""%1"". IL_Move_Attach _z > _y, _steps =""%2""", IL_Script_Inst, _steps];
			};
		};
	};

	_i = 0;
//Arma bug http://feedback.arma3.com/view.php?id=7228
//	if (_turn) then
//	{
//		_obj AttachTo [_veh, _from];
//		_obj setVectorDirAndUp [[1,0,0],[0,0,1]];
//		_obj SetDir 90;
//		_obj AttachTo [_veh, _from];
//		_obj SetDir 90;
//	}
//	else
//	{
		_obj AttachTo [_veh, _from];
//	};
	while {_i < _steps} do
	{
		_i = _i + 1;
		_pos = [(((_x / _steps) * _i) + _from_x), (((_y / _steps) * _i) + _from_y), (((_z / _steps) * _i) + _from_z)];
//		if (_turn) then
//		{
//			_obj AttachTo [_veh, _pos];
//			_obj setVectorDirAndUp [[1,0,0],[0,0,1]];
//			_obj SetDir 90;
//			_obj AttachTo [_veh, _pos];
//			_obj SetDir 90;
//		}
//		else
//		{
			_obj AttachTo [_veh, _pos];
//		};
		if (IL_DevMod) then
		{
			Player globalChat Format ["IgiLoad ""%1"". IL_Move_Attach _pos =""%2""", IL_Script_Inst, _pos];
		};
		sleep 0.25;
	};

	if (_turn) then
	{
		_obj AttachTo [_veh, _to];
		_obj SetDir 90;
		_obj AttachTo [_veh, _to];
		_obj SetDir 90;
	}
	else
	{
		_obj AttachTo [_veh, _to];
	};
};
//	END IL_Move_Attach

IL_Create_And_Attach =
{
	if (IL_DevMod) then
	{
		Player globalChat Format ["IgiLoad ""%1"" in IL_Create_And_Attach", IL_Script_Inst];
	};
	_type = _this select 0;
	_to = _this select 1;
	_x = if (count _this > 2) then {_this select 2} else {0};
	_y = if (count _this > 3) then {_this select 3} else {0};
	_z = if (count _this > 4) then {_this select 4} else {0};
	_m = createVehicle [_type, position _to, [], 0, "CAN_COLLIDE"];
	_m AttachTo [_to,[_x,_y,_z]];
	_m
};
//	END IL_Create_And_Attach

IL_Cargo_Para =
{
	if (IL_DevMod) then
	{
		Player globalChat Format ["IgiLoad ""%1"" in IL_Cargo_Para", IL_Script_Inst];
	};
	private ["_smoke", "_light", "_damage", "_smoke_type", "_chemlight_type", "_cargo_pos"];
	_cargo = _this select 0;
	_v = _this select 1;
	_z = _this select 2;
	
	if (((IL_Para_Smoke) || (IL_Para_Smoke_Add)) && ((typeOf _cargo) in IL_Supported_Quadbike)) then
	{
		_smoke_type = IL_Para_Smoke_Veh;
	}
	else
	{
		_smoke_type = IL_Para_Smoke_Default;
	};
	if (((IL_Para_Light) || (IL_Para_Light_Add)) && ((typeOf _cargo) in IL_Supported_Quadbike)) then
	{
		_chemlight_type = IL_Para_Light_Veh;
	}
	else
	{
		_chemlight_type = IL_Para_Light_Default;
	};

	_cargo_pos = [0,0,1];
	
	_damage = getDammage _cargo;
	_chute = createVehicle ["NonSteerable_Parachute_F", position _cargo, [], 0, "CAN_COLLIDE"];
	_chute attachTo [_v,[0,-6,_z - 1]];
	if (IL_DevMod) then
	{
		Player globalChat Format["IgiLoad ""%1"". Chute ""%2"" attachTo vehicle ""%3""", IL_Script_Inst, _chute, _v];
	};
	detach _cargo;
	_cargo attachTo [_chute, _cargo_pos];
	detach _chute;

	if (IL_Para_Smoke) then
	{
		_smoke = [_smoke_type, _cargo] call IL_Create_And_Attach;
	};
	if (IL_Para_Light) then
	{
		_light = [_chemlight_type, _cargo] call IL_Create_And_Attach;
	};
	while {(getPos _cargo) select 2 > 2} do
	{
		sleep 0.2;
	};
	detach _cargo;
	if (IL_Para_Smoke) then
	{
		_smoke attachTo [_cargo,[0,0,2]];
		detach _smoke;
	};
	if (IL_Para_Light) then
	{
		_light attachTo [_cargo,[0,0,2]];
		detach _light;
	};
	//Additional lights and smoke
	if (IL_Para_Smoke_Add) then
	{
		_smoke = [_smoke_type, _cargo] call IL_Create_And_Attach;
		_smoke attachTo [_cargo,[0,0,2]];
		detach _smoke;
	};
	if (IL_Para_Light_Add) then
	{
		_light = [_chemlight_type, _cargo] call IL_Create_And_Attach;
		_light attachTo [_cargo,[0,0,2]];
		detach _light;
	};
	
	_cargo setPosASL getPosASL _cargo;
	
	if (IL_CDamage == 0) then
	{
		_cargo setDamage 0;
	};
	
	if (IL_CDamage == 1) then
	{
		_cargo setDamage _damage;
		if (_damage != (getDammage _cargo)) then
		{
			sleep 1;
			_cargo setDamage _damage;
		};
	};
};
//	END IL_Cargo_Para

IL_Do_Load =
{
	if (IL_DevMod) then
	{
		Player globalChat Format ["IgiLoad ""%1"" in IL_Do_Load", IL_Script_Inst];
	};

	private["_NoBoxHint", "_v", "_supported_cargo", "_zload", "_cargo_offset", "_sdist", "_spoint", "_slot_num", "_counter", "_done", "_obj_lst", "_damage", "_obj_type", "_doors", "_box_num", "_dummy", "_nic", "_turn"];
	_NoBoxHint = "The box is in the vicinity. Perhaps it is outside of the loading area.";
	_v = _this select 0;
	_supported_cargo = _this select 1;
	_doors = if (count _this > 2) then {_this select 2} else {"B"};
	
	_v setVariable["can_load", false, true];
	_zload = _v getVariable "zload";
	_obj_type = (typeOf _v);
	_sdist = 0;
	if (((_obj_type in IL_Supported_Vehicles_HEMTT) || (_obj_type in IL_Supported_Vehicles_KAMAZ)) && (_doors == "B")) then
	{
		if (IL_DevMod) then
		{
			Player globalChat Format ["IgiLoad ""%1"". Do_load vehicle type: ""%2"" and doors: ""%3""", IL_Script_Inst, _obj_type, _doors];
		};
		_sdist = IL_SDistL;
		_spoint = _v modelToWorld [0,-6 - (_v getVariable "cargo_offset"),0];
		_box_num = _v getVariable "box_num";
		_slot_num = _v getVariable "slots_num";
	};
	if ((_obj_type in IL_Supported_Vehicles_MOHAWK) && (_doors == "B")) then
	{
		if (IL_DevMod) then
		{
			Player globalChat Format ["IgiLoad ""%1"". Do_load vehicle type: ""%2"" and doors: ""%3""", IL_Script_Inst, _obj_type, _doors];
		};
		_sdist = IL_SDistL + IL_SDistL_Heli_offset;
		_spoint = _v modelToWorld [0,-6,-3];
		_box_num = _v getVariable "box_num";
		_slot_num = _v getVariable "slots_num";
	};
	if ((_obj_type in IL_Supported_Vehicles_MH9) && (_doors == "L")) then
	{
		if (IL_DevMod) then
		{
			Player globalChat Format ["IgiLoad ""%1"". Do_load vehicle type: ""%2"" and doors: ""%3""", IL_Script_Inst, _obj_type, _doors];
		};
		_sdist = IL_SDistL + IL_SDistL_Heli_offset;
		_spoint = _v modelToWorld [0-3,1.3,-1.3];
		_box_num = _v getVariable "box_num_l";
		_slot_num = _v getVariable "slots_num_l";
	};
	if ((_obj_type in IL_Supported_Vehicles_MH9) && (_doors == "R")) then
	{
		if (IL_DevMod) then
		{
			Player globalChat Format ["IgiLoad ""%1"". Do_load vehicle type: ""%2"" and doors: ""%3""", IL_Script_Inst, _obj_type, _doors];
		};
		_sdist = IL_SDistL + IL_SDistL_Heli_offset;
		_spoint = _v modelToWorld [0+3,1.3,-1.3];
		_box_num = _v getVariable "box_num_r";
		_slot_num = _v getVariable "slots_num_r";
	};
	
	_counter = 0;
	_done = false;
	_turn = false;
	_obj_lst = nearestObjects[ _spoint, _supported_cargo, _sdist];
	
	if (count (_obj_lst) > 0) then
	{
		{
			if (IL_DevMod) then
			{
				Player globalChat Format ["IgiLoad ""%1"". Cargo: ""%2"" found.", IL_Script_Inst, _x];
			};
			if (isNil {_x getVariable "attachedPos"}) then
			{
				if (IL_DevMod) then
				{
					Player globalChat Format ["IgiLoad ""%1"". Init box: ""%2"".", IL_Script_Inst, _x];
				};
				[_x] call IL_Init_Box;
			};
			if ((typeOf _x) == "Land_WaterTank_F") then
			{
				_turn = true;
			};
			//It allows you to load oversize loads, but they must be on the list of supported cargo!!!
			if ((abs(_slot_num - _box_num) < (_x getVariable "slots")) && (_box_num != 0)) then
			{
				_v vehicleChat "This box is to big. ";
			}
			else
			{
				if (IL_DevMod) then
				{
					Player globalChat Format ["IgiLoad ""%1"". _box_num: ""%2"" _slot_num: ""%3""", IL_Script_Inst,  _box_num, _slot_num];
				};
				if ((_box_num > _slot_num) && !_done) then
				{
					_v vehicleChat Format ["Loading ""%1"" on ""%2"" started", getText(configFile >> "cfgVehicles" >> typeOf _x >> "displayName"), getText(configFile >> "cfgVehicles" >> typeOf _v >> "displayName")];
					_done = true;
					_counter = (_box_num);
					_zload = (_v getVariable "zload") + (_x getVariable "zload");
					_cargo_offset = (_v getVariable "cargo_offset") + (_x getVariable "cargo_offset");
					_damage = getDammage _x;
					
					if ((typeOf _x) in IL_Supported_SDV) then
					{
						_x animate ["periscope", 3]; 
						_x animate ["Antenna", 3]; 
						_x animate ["HideScope", 3]; 
						_x animate["display_on_R", 1]; 
					};

					//_obj_type = (typeOf _v);
					if (((_obj_type in IL_Supported_Vehicles_HEMTT) || (_obj_type in IL_Supported_Vehicles_KAMAZ)) && (_doors == "B")) then
					{
						[_v, _x, [0,-6 - _cargo_offset,_zload], [0,_counter + 0.25 - _cargo_offset,_zload], 1, _turn] call IL_Move_Attach;
					};
					if ((_obj_type in IL_Supported_Vehicles_MOHAWK)  && (_doors == "B")) then
					{
						[_v, _x, [0,-6,-0.75 + _zload], [0,-4.5,-0.75 + _zload], 1, _turn] call IL_Move_Attach;
						[_v, _x, [0,-4.5,-0.75 + _zload], [0,-1.5,_zload], 1, _turn] call IL_Move_Attach;
						[_v, _x, [0,-1.5,_zload], [0,_counter + 9 - _cargo_offset,_zload], 1, _turn] call IL_Move_Attach;
					};
					if ((_obj_type in IL_Supported_Vehicles_MH9)  && (_doors == "L")) then
					{
						[_v, _x, [0-3,1.3,-1.3 + _zload], [-1,1.3,_zload], 1] call IL_Move_Attach;
					};
					if ((_obj_type in IL_Supported_Vehicles_MH9)  && (_doors == "R")) then
					{
						[_v, _x, [0+3,1.3,-1.3 + _zload], [1,1.3,_zload], 1] call IL_Move_Attach;
					};

					_counter = _counter - (_x getVariable "slots");

					//_obj_type = (typeOf _v);
					if (((_obj_type in IL_Supported_Vehicles_HEMTT) || (_obj_type in IL_Supported_Vehicles_KAMAZ) || (_obj_type in IL_Supported_Vehicles_MOHAWK)) && (_doors == "B")) then
					{
						_v setVariable["box_num", _counter, true];
					};
					if ((_obj_type in IL_Supported_Vehicles_MH9)  && (_doors == "L")) then
					{
						_v setVariable["box_num_l", _counter, true];
						_v setVariable["box_l", _x, true];
					};
					if ((_obj_type in IL_Supported_Vehicles_MH9)  && (_doors == "R")) then
					{
						_v setVariable["box_num_r", _counter, true];
						_v setVariable["box_r", _x, true];
					};

					_obj_type = (typeOf _x);
					if (_obj_type in IL_Supported_Quadbike) then
					{
						_x forceSpeed 0;
					};
					
					_x setVariable["attachedPos", _counter, true];
					_x setVariable["attachedTruck", _v, true];
					_x setVariable["doors", _doors, true];
					
					if (IL_CDamage == 0) then
					{
						_x setDamage 0;
					};
					
					if (IL_CDamage == 1) then
					{
						_x setDamage _damage;
						if (_damage != (getDammage _x)) then
						{
							sleep 1;
							_x setDamage _damage;
						};
					};
					
					if (_counter > _slot_num) then
					{
						_v vehicleChat Format ["""%1"" is loaded onto ""%2"". Free slots: ""%3"".", getText(configFile >> "cfgVehicles" >> typeOf _x >> "displayName"), getText(configFile >> "cfgVehicles" >> typeOf _v >> "displayName"), abs(_slot_num - _counter)];
					}
					else
					{
						_v vehicleChat Format ["""%1"" is loaded onto ""%2"" There is no more space.", getText(configFile >> "cfgVehicles" >> typeOf _x >> "displayName"), getText(configFile >> "cfgVehicles" >> typeOf _v >> "displayName")];
					};
				}
				else
				{
					if ((_box_num > _slot_num) && !_done) then
					{
						_v vehicleChat _NoBoxHint;
					};
				};
			};
			if (_done) exitWith {};
		} forEach (_obj_lst);
	}
	else
	{
		_v vehicleChat _NoBoxHint;
	};
	_v setVariable["can_load", true, true];
};
//	END IL_Do_Load

IL_Do_Unload =
{
	if (IL_DevMod) then
	{
		Player globalChat Format["IgiLoad ""%1"" IL_Do_Unload.", IL_Script_Inst];
	};

	private ["_v", "_para", "_supported_cargo", "_doors", "_counter", "_done", "_obj_lst", "_zload", "_cargo_offset", "_obj_type", "_damage", "_nic", "_free_slots", "_turn", "_skip"];
	_v = _this select 0;
	_para = _this select 1;
	_supported_cargo = _this select 2;
	_doors = if (count _this > 3) then {_this select 3} else {"B"};
	
	_v setVariable["can_load", false, true];
	_counter = 0;
	_done = false;
	_turn = false;
	_skip = true;
	_obj_lst = [];

	_obj_type = (typeOf _v);
	if (_obj_type in IL_Supported_Vehicles_MH9) then
	{
		if (_doors == "L") then
		{
			_obj_lst = [_v getVariable "box_l"];
		}
		else
		{
			_obj_lst = [_v getVariable "box_r"];
		};
	}
	else
	{
		_obj_lst = nearestObjects[_v, _supported_cargo, IL_SDistU];
	};
	
	if (count (_obj_lst) > 0) then
	{
		{
			_obj_type = (typeOf _v);
			if (_x getVariable "doors" == _doors) then
			{
				if (_doors == "B") then
				{
					_counter = (_v getVariable "box_num");
				};
				if (_doors == "L") then
				{
					_counter = (_v getVariable "box_num_l");
				};
				if (_doors == "R") then
				{
					_counter = (_v getVariable "box_num_r");
				};
				if (((_x getVariable "attachedTruck") == _v) && ((_x getVariable "attachedPos") == (_counter)) && (_counter < 0) && !_done) then
				{
					_v vehicleChat Format ["Unloading ""%1"" from ""%2"" started", getText(configFile >> "cfgVehicles" >> typeOf _x >> "displayName"), getText(configFile >> "cfgVehicles" >> typeOf _v >> "displayName")];
					_done = true;
					_skip = false;
					_zload = (_v getVariable "zload") + (_x getVariable "zload");
					_cargo_offset = (_v getVariable "cargo_offset") + (_x getVariable "cargo_offset");
					_damage = getDammage _x;
					if ((typeOf _x) == "Land_WaterTank_F") then
					{
						_turn = true;
					};

					_obj_type = (typeOf _v);
					if (((_obj_type in IL_Supported_Vehicles_HEMTT) || (_obj_type in IL_Supported_Vehicles_KAMAZ)) && (_doors == "B")) then
					{
						[_v, _x, [0,_counter + 0.25 - _cargo_offset,_zload], [0,-6 - _cargo_offset,_zload], 1, _turn] call IL_Move_Attach;
					};
					if ((_obj_type in IL_Supported_Vehicles_MOHAWK)  && (_doors == "B")) then
					{
						[_v, _x, [0,_counter + 9 - _cargo_offset,_zload], [0,-1.5,_zload], 1, _turn] call IL_Move_Attach;
						[_v, _x, [0,-1.5,_zload], [0,-4.5,-0.75 + _zload], 1, _turn] call IL_Move_Attach;
						[_v, _x, [0,-4.5,-0.75 + _zload], [0,-6,-0.75 + _zload], 1, _turn] call IL_Move_Attach;
					};
					if ((_obj_type in IL_Supported_Vehicles_MH9)  && (_doors == "L")) then
					{
						[_v, _x, [-1,1.3,_zload], [0-3,1.3,-0.75 + _zload], 1] call IL_Move_Attach;
					};
					if ((_obj_type in IL_Supported_Vehicles_MH9)  && (_doors == "R")) then
					{
						[_v, _x, [1,1.3,_zload], [0+3,1.3,-0.75 + _zload], 1] call IL_Move_Attach;
					};
					
					if ((_para) && (_obj_type in IL_Para_Drop_Vehicles)) then
					{
						[_x, _v, -3.5] spawn IL_Cargo_Para;
					}
					else
					{
						sleep 0.2;
						detach _x;
						_x setVelocity [0, 0, -0.2];
					};

					_obj_type = (typeOf _x);
					if (_obj_type in IL_Supported_Quadbike) then
					{
						_x forceSpeed -1;
					};
					
					_counter = _counter + (_x getVariable "slots");
					if (_doors == "B") then
					{
						_v setVariable["box_num", _counter, true];
						_free_slots = abs((_v getVariable "slots_num") - (_v getVariable "box_num"));
					};
					if (_doors == "L") then
					{
						_v setVariable["box_num_l", _counter, true];
						_v setVariable["box_l", _v, true];
						_free_slots = abs((_v getVariable "slots_num_l") - (_v getVariable "box_num_l"));
					};
					if (_doors == "R") then
					{
						_v setVariable["box_num_r", _counter, true];
						_v setVariable["box_r", _v, true];
						_free_slots = abs((_v getVariable "slots_num_r") - (_v getVariable "box_num_r"));
					};
					_x setVariable["attachedPos", 0, true];
					_x setVariable["attachedTruck", _x, true];
					_x setVariable["doors", "N", true];

					if (IL_CDamage == 0) then
					{
						_x setDamage 0;
					};
					
					if (IL_CDamage == 1) then
					{
						_x setDamage _damage;
						if (_damage != (getDammage _x)) then
						{
							sleep 1;
							_x setDamage _damage;
						};
					};
					_v vehicleChat Format ["""%1"" was unloaded from the ""%2"". Free slots: ""%3"".", getText(configFile >> "cfgVehicles" >> typeOf _x >> "displayName"), getText(configFile >> "cfgVehicles" >> typeOf _v >> "displayName"), _free_slots];
					sleep 1;
				};
			};
			if (_done) exitWith {};
		} forEach (_obj_lst);
		if (_skip) then
		{
			_v vehicleChat "Can not find cargo. Try again.";
			_counter = _counter + 1;
			if (_doors == "B") then
			{
				_v setVariable["box_num", _counter, true];
				_free_slots = abs((_v getVariable "slots_num") - (_v getVariable "box_num"));
			};
			if (_doors == "L") then
			{
				_v setVariable["box_num_l", _counter, true];
				_v setVariable["box_l", _v, true];
				_free_slots = abs((_v getVariable "slots_num_l") - (_v getVariable "box_num_l"));
			};
			if (_doors == "R") then
			{
				_v setVariable["box_num_r", _counter, true];
				_v setVariable["box_r", _v, true];
				_free_slots = abs((_v getVariable "slots_num_r") - (_v getVariable "box_num_r"));
			};
		};
	}
	else
	{
		_v vehicleChat "BOX 404 error. Box not found O.o. Vehicle data reset...";
		[_v, true] call IL_Init_Veh;
		_v vehicleChat "Vehicle data reset is done.";
	};
	_v setVariable["can_load", true, true];
};
//	END IL_Do_Unload

IL_GetOut =
{
	if (IL_DevMod) then
	{
		Player globalChat Format["IgiLoad ""%1"" IL_GetOut.", IL_Script_Inst];
	};

	private ["_v", "_player", "_para", "_chute",  "_chute2", "_pos", "_x_offset"];
	_v = _this select 0;
	_player = _this select 1;
	_para = if (count _this > 2) then {_this select 2} else {false};

	_pos = (_v worldToModel (getPosATL _player));
	_x_offset = _pos select 0;
	if (_x_offset < 0) then
	{
		_x_offset = 8;
	}
	else
	{
		_x_offset = -8;
	};
	
	unassignVehicle _player;
	_player action ["EJECT",vehicle _player];
	sleep 0.5;
 
	if !(_para) then
	{
		_player setDir ((getDir _v) + 180);
		//_player setPosATL ([_v, 5, ((getDir _v) + 180 + _x_offset)] call BIS_fnc_relPos);
		_pos = ([_v, 5, ((getDir _v) + 180 + _x_offset)] call BIS_fnc_relPos);
		_pos = [_pos select 0, _pos select 1, ((getPosATL _v) select 2)];
		_player setPosATL _pos;
	}
	else
	{
		//_player setPosATL ([_v, 10, ((getDir _v) + 180 + _x_offset)] call BIS_fnc_relPos);
		_pos = ([_v, 11, ((getDir _v) + 180 + _x_offset)] call BIS_fnc_relPos);
		_pos = [_pos select 0, _pos select 1, ((getPosATL _v) select 2)];
		_player setPosATL _pos;
		_chute = createVehicle ["Steerable_Parachute_F", position _player, [], 0, "CAN_COLLIDE"];
		_chute setPos getPos _player;
		_player moveInDriver _chute;
	};
	if (IL_DevMod) then
	{
		Player globalChat Format["IgiLoad ""%1"" IL_GetOut.", IL_Script_Inst];
	};
	if (IL_DevMod) then
	{
		Player globalChat Format["IgiLoad ""%1"" IL_GetOut. Player ATL: ""%2""", IL_Script_Inst, _pos];
	};
};
//	END IL_GetOut
//	END PROCEDURES AND FUNCTIONS

//	MAIN CODE
if (_obj_main_type in IL_Supported_Cargo_HEMMT) then
{
	[_obj_main] call IL_Init_Box;
}
else
{
	_vsupported = false;
	if (_obj_main_type in IL_Supported_Vehicles_MOHAWK) then
	{
		if (IL_DevMod) then
		{
			Player globalChat Format["IgiLoad ""%1"" Vehicle is in IL_Supported_Vehicles_MOHAWK.", IL_Script_Inst];
		};
		_vsupported = true;
		[_obj_main] call IL_Init_Veh;

		_obj_main addAction [
		"<img image='IgiLoad\images\load.paa' /><t color=""#007f0e"">  Load cargo on CH-49</t>",
		{
			[_this select 0, IL_Supported_Cargo_Mohawk] call IL_Do_Load;
		},[],_Action_LU_Priority,true,true,"",
		"(count(nearestObjects[ _target modelToWorld [0,-6,-3], IL_Supported_Cargo_Mohawk, IL_SDistL + IL_SDistL_Heli_offset]) > 0) && (abs(speed _target) <= IL_LU_Speed) && ((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot')) || ((_this in (nearestObjects[ _target modelToWorld [0,-6,-3], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside'))) && (_target getVariable 'box_num' > _target getVariable 'slots_num') && (_target getVariable 'can_load') && (((getPos _target) select 2) <= IL_LU_Alt) && (_target animationPhase 'CargoRamp_Open' == 1)"
		];

		_obj_main addAction [
		"<t color=""#007f0e"">Get in CH-49</t>",
		{
			//_this select 1 action ["GetInCargo", _this select 0];
			(_this select 1) moveInCargo (_this select 0);
		},[],_Action_LU_Priority,false,true,"",
		"(_this in (nearestObjects[ _target modelToWorld [0,-6,-3], [], IL_SDistL + IL_SDistL_Heli_offset])) && ((_target emptyPositions 'cargo') > 0) && (abs(speed _target) <= IL_LU_Speed) && (((getPos _target) select 2) <= IL_LU_Alt) && (_target animationPhase 'CargoRamp_Open' > 0.43) && (_target getVariable 'usable_ramp')"
		];
		
		_obj_main addAction [
		"<t color=""#ff0000"">Get out CH-49</t>",
		{
			[_this select 0, _this select 1, false] call IL_GetOut;
		},[],_Action_LU_Priority,false,true,"",
		"('Cargo' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (abs(speed _target) <= IL_LU_Speed) && (((getPos _target) select 2) <= IL_LU_Alt) && (_target animationPhase 'CargoRamp_Open' > 0.43) && (_target getVariable 'usable_ramp')"
		];

		_obj_main addAction [
		"<img image='IgiLoad\images\unload_para.paa' /><t color=""#b200ff""> Eject</t>",
		{
			[_this select 0, _this select 1, true] call IL_GetOut;
		},[],_Action_LU_Priority,false,true,"",
		"('Cargo' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (((getPosATL _target) select 2) >= IL_Para_Drop_ATL) && (_target animationPhase 'CargoRamp_Open' > 0.43) && (_target getVariable 'usable_ramp')"
		];
		
		_obj_main addAction [
		"<img image='IgiLoad\images\unload.paa' /><t color=""#ff0000"">  Unload cargo from CH-49</t>",
		{
			[_this select 0, false, IL_Supported_Cargo_Mohawk] call IL_Do_Unload;
		},[],_Action_LU_Priority,false,true,"",
		"(_target getVariable 'box_num' < 0) && ((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot')) || ((_this in (nearestObjects[ _target modelToWorld [0,-6,-3], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside'))) && (_target getVariable 'can_load') && (abs(speed _target) <= IL_LU_Speed) && (((getPos _target) select 2) <= IL_LU_Alt) && (_target animationPhase 'CargoRamp_Open' == 1)"
		];

		_obj_main addAction [
		"<img image='IgiLoad\images\unload_para.paa' /><t color=""#b200ff"">  Unload cargo with parachute</t>",
		{
			[_this select 0, true, IL_Supported_Cargo_Mohawk] call IL_Do_Unload;
		},[],_Action_LU_Priority,false,true,"",
		"(_target getVariable 'box_num' < 0) && ((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot'))) && (_target getVariable 'can_load') && (((getPosATL _target) select 2) >= IL_Para_Drop_ATL) && (_target animationPhase 'CargoRamp_Open' == 1)"
		];
		
		_obj_main addAction [
		"<img image='IgiLoad\images\unload_all_para.paa' /><t color=""#a50b00"">  Unload ALL cargo with parachute</t>",
		{
			while {((_this select 0) getVariable "box_num") != 0} do
			{
				[_this select 0, true, IL_Supported_Cargo_Mohawk] call IL_Do_Unload;
			};
		},[],_Action_LU_Priority,false,true,"",
		"(_target getVariable 'box_num' < 0) && ((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot'))) && (_target getVariable 'can_load') && (((getPosATL _target) select 2) >= IL_Para_Drop_ATL) && (_target animationPhase 'CargoRamp_Open' == 1)"
		];

		_obj_main addAction [
		"<t color=""#0000ff"">Open cargo doors in CH-49</t>",
		{
			_this select 0 animate ['CargoRamp_Open', 1];
		},[],_Action_O_Priority,false,true,"",
		"((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot')) || ((_this in (nearestObjects[ _target modelToWorld [0,-6,-3], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside'))) && (_target animationPhase 'CargoRamp_Open' == 0) && (_target getVariable 'can_load')"
		];

		_obj_main addAction [
		"<t color=""#0000ff"">Close cargo doors in CH-49</t>",
		{
			_this select 0 animate ['CargoRamp_Open', 0];
		},[],_Action_O_Priority,false,true,"",
		"((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot')) || ((_this in (nearestObjects[ _target modelToWorld [0,-6,-3], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside'))) && (_target animationPhase 'CargoRamp_Open' == 1) && (_target getVariable 'can_load')"
		];
		
		_obj_main addAction [
		"<t color=""#0000ff"">Enable loading for Co-Pilot</t>",
		{
			(_this select 0) setVariable["can_copilot", true, true];;
		},[],_Action_S_Priority,false,true,"",
		"((driver _target == _this) && !(_target getVariable 'can_copilot') && IL_Can_CoPilot)"
		];

		_obj_main addAction [
		"<t color=""#0000ff"">Disable loading for Co-Pilot</t>",
		{
			(_this select 0) setVariable["can_copilot", false, true];;
		},[],_Action_S_Priority,false,true,"",
		"((driver _target == _this) && (_target getVariable 'can_copilot') && IL_Can_CoPilot)"
		];
		
		_obj_main addAction [
		"<t color=""#0000ff"">Enable loading from outside</t>",
		{
			(_this select 0) setVariable["can_outside", true, true];;
		},[],_Action_S_Priority,false,true,"",
		"(((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot'))) && !(_target getVariable 'can_outside') && IL_Can_Outside)"
		];

		_obj_main addAction [
		"<t color=""#0000ff"">Disable loading from outside</t>",
		{
			(_this select 0) setVariable["can_outside", false, true];;
		},[],_Action_S_Priority,false,true,"",
		"(((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot'))) && (_target getVariable 'can_outside') && IL_Can_Outside)"
		];

		_obj_main addAction [
		"<t color=""#0000ff"">Enable usable ramp</t>",
		{
			(_this select 0) setVariable["usable_ramp", true, true];;
		},[],_Action_S_Priority,false,true,"",
		"(((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot'))) && !(_target getVariable 'usable_ramp') && IL_Ramp)"
		];

		_obj_main addAction [
		"<t color=""#0000ff"">Disable usable ramp</t>",
		{
			(_this select 0) setVariable["usable_ramp", false, true];;
		},[],_Action_S_Priority,false,true,"",
		"(((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot'))) && (_target getVariable 'usable_ramp') && IL_Ramp)"
		];
	};
	if (_obj_main_type in IL_Supported_Vehicles_MH9) then
	{
		if (IL_DevMod) then
		{
			Player globalChat Format["IgiLoad ""%1"" Vehicle is in IL_Supported_Vehicles_MH9.", IL_Script_Inst];
		};
		_vsupported = true;
		[_obj_main] call IL_Init_Veh;

		_obj_main addAction [
		"<img image='IgiLoad\images\load.paa' /><t color=""#007f0e"">  Load cargo on left MH-9</t>",
		{
			[_this select 0, IL_Supported_Cargo_MH9, "L"] call IL_Do_Load;
		},[],_Action_LU_Priority,true,true,"",
		"(count (nearestObjects[ _target modelToWorld [0-3,1,-1.3], IL_Supported_Cargo_MH9, IL_SDistL + IL_SDistL_Heli_offset]) > 0) && (abs(speed _target) <= IL_LU_Speed) && ((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot')) || (((_this in (nearestObjects[ _target modelToWorld [0-3,1,-1.3], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside')))) && (_target getVariable 'box_num_l' > _target getVariable 'slots_num_l') && (_target getVariable 'can_load') && (((getPos _target) select 2) <= IL_LU_Alt)"
		];

		_obj_main addAction [
		"<img image='IgiLoad\images\load.paa' /><t color=""#007f0e"">  Load cargo on right MH-9</t>",
		{
			[_this select 0, IL_Supported_Cargo_MH9, "R"] call IL_Do_Load;
		},[],_Action_LU_Priority,true,true,"",
		"(count (nearestObjects[ _target modelToWorld [0+3,1,-1.3], IL_Supported_Cargo_MH9, IL_SDistL + IL_SDistL_Heli_offset]) > 0) && (abs(speed _target) <= IL_LU_Speed) && ((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot')) || (((_this in (nearestObjects[ _target modelToWorld [0+3,1,-1.3], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside')))) && (_target getVariable 'box_num_r' > _target getVariable 'slots_num_r') && (_target getVariable 'can_load') && (((getPos _target) select 2) <= IL_LU_Alt)"
		];

		_obj_main addAction [
		"<img image='IgiLoad\images\unload.paa' /><t color=""#ff0000"">  Unload cargo from left MH-9</t>",
		{
			[_this select 0, false, IL_Supported_Cargo_MH9, "L"] call IL_Do_Unload;
		},[],_Action_LU_Priority,false,true,"",
		"(_target getVariable 'box_num_l' < 0) && ((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot')) || (((_this in (nearestObjects[ _target modelToWorld [0-3,1,-1.3], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside')))) && (_target getVariable 'can_load') && (abs(speed _target) <= IL_LU_Speed) && (((getPos _target) select 2) <= IL_LU_Alt)"
		];

		_obj_main addAction [
		"<img image='IgiLoad\images\unload.paa' /><t color=""#ff0000"">  Unload cargo from right MH-9</t>",
		{ 
			[_this select 0, false, IL_Supported_Cargo_MH9, "R"] call IL_Do_Unload;
		},[],_Action_LU_Priority,false,true,"",
		"(_target getVariable 'box_num_r' < 0) && ((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot')) || (((_this in (nearestObjects[ _target modelToWorld [0+3,1,-1.3], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside')))) && (_target getVariable 'can_load') && (abs(speed _target) <= IL_LU_Speed) && (((getPos _target) select 2) <= IL_LU_Alt)"
		];

		_obj_main addAction [
		"<t color=""#0000ff"">Enable loading for Co-Pilot</t>",
		{
			(_this select 0) setVariable["can_copilot", true, true];;
		},[],_Action_S_Priority,false,true,"",
		"((driver _target == _this) && !(_target getVariable 'can_copilot') && IL_Can_CoPilot)"
		];

		_obj_main addAction [
		"<t color=""#0000ff"">Disable loading for Co-Pilot</t>",
		{
			(_this select 0) setVariable["can_copilot", false, true];;
		},[],_Action_S_Priority,false,true,"",
		"((driver _target == _this) && (_target getVariable 'can_copilot') && IL_Can_CoPilot)"
		];
		
		_obj_main addAction [
		"<t color=""#0000ff"">Enable loading from outside</t>",
		{
			(_this select 0) setVariable["can_outside", true, true];;
		},[],_Action_S_Priority,false,true,"",
		"(((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot'))) && !(_target getVariable 'can_outside') && IL_Can_Outside)"
		];

		_obj_main addAction [
		"<t color=""#0000ff"">Disable loading from outside</t>",
		{
			(_this select 0) setVariable["can_outside", false, true];;
		},[],_Action_S_Priority,false,true,"",
		"(((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot'))) && (_target getVariable 'can_outside') && IL_Can_Outside)"
		];
	};
	if (_obj_main_type in IL_Supported_Vehicles_KAMAZ) then
	{
		if (IL_DevMod) then
		{
			Player globalChat Format["IgiLoad ""%1"" Vehicle is in IL_Supported_Vehicles_KAMAZ.", IL_Script_Inst];
		};
		_vsupported = true;
		[_obj_main] call IL_Init_Veh;
		
		_obj_main addAction [
		"<img image='IgiLoad\images\load.paa' /><t color=""#007f0e"">  Load cargo on ZAMAK</t>",
		{
			[_this select 0, IL_Supported_Cargo_Kamaz] call IL_Do_Load;
		},[],_Action_LU_Priority,true,true,"",
		"(count(nearestObjects[ _target modelToWorld [0,-6 - (_target getVariable 'cargo_offset'),0], IL_Supported_Cargo_Kamaz, IL_SDistL]) > 0) && (abs(speed _target) <= IL_LU_Speed) && ((driver _target == _this) || ((((_this in (nearestObjects[ _target modelToWorld [0,-6 - (_target getVariable 'cargo_offset'),0], [], IL_SDistL + IL_SDistL_Heli_offset]))) && (_target getVariable 'can_outside')))) && (_target getVariable 'box_num' > _target getVariable 'slots_num') && (_target getVariable 'can_load')"
		];
		
		_obj_main addAction [
		"<img image='IgiLoad\images\unload.paa' /><t color=""#ff0000"">  Unload cargo from ZAMAK</t>",
		{
			[_this select 0, false, IL_Supported_Cargo_Kamaz] call IL_Do_Unload;
		},[],_Action_LU_Priority,false,true,"",
		"(_target getVariable 'box_num' < 0) && ((driver _target == _this) || (((_this in (nearestObjects[ _target modelToWorld [0,-6 - (_target getVariable 'cargo_offset'),0], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside')))) && (_target getVariable 'can_load') && (abs(speed _target) <= IL_LU_Speed)"
		];
		_obj_main addAction [
		"<t color=""#0000ff"">Enable loading from outside</t>",
		{
			(_this select 0) setVariable["can_outside", true, true];;
		},[],_Action_S_Priority,false,true,"",
		"((driver _target == _this) && !(_target getVariable 'can_outside') && IL_Can_Outside)"
		];

		_obj_main addAction [
		"<t color=""#0000ff"">Disable loading from outside</t>",
		{
			(_this select 0) setVariable["can_outside", false, true];;
		},[],_Action_S_Priority,false,true,"",
		"((driver _target == _this) && (_target getVariable 'can_outside') && IL_Can_Outside)"
		];
	};
	if (_obj_main_type in IL_Supported_Vehicles_HEMTT) then
	{
		if (IL_DevMod) then
		{
			Player globalChat Format["IgiLoad ""%1"" Vehicle is in IL_Supported_Vehicles_HEMTT.", IL_Script_Inst];
		};
		_vsupported = true;
		[_obj_main] call IL_Init_Veh;

		_obj_main addAction [
		"<img image='IgiLoad\images\load.paa' /><t color=""#007f0e"">  Load cargo on HEMTT</t>",
		{
			[_this select 0, IL_Supported_Cargo_HEMMT] call IL_Do_Load;
		},[],_Action_LU_Priority,true,true,"",
		"(count(nearestObjects[ _target modelToWorld [0,-6 - (_target getVariable 'cargo_offset'),0], IL_Supported_Cargo_HEMMT, IL_SDistL]) > 0) && (abs(speed _target) <= IL_LU_Speed) && ((driver _target == _this) || (((_this in (nearestObjects[ _target modelToWorld [0,-6 - (_target getVariable 'cargo_offset'),0], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside')))) && (_target getVariable 'box_num' > _target getVariable 'slots_num') && (_target getVariable 'can_load')"
		];

		_obj_main addAction [
		"<img image='IgiLoad\images\unload.paa' /><t color=""#ff0000"">  Unload cargo from HEMTT</t>",
		{
			[_this select 0, false, IL_Supported_Cargo_HEMMT] call IL_Do_Unload;
		},[],_Action_LU_Priority,false,true,"",
		"(_target getVariable 'box_num' < 0) && ((driver _target == _this) || (((_this in (nearestObjects[ _target modelToWorld [0,-6 - (_target getVariable 'cargo_offset'),0], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside')))) && (_target getVariable 'can_load') && (abs(speed _target) <= IL_LU_Speed)"
		];

		_obj_main addAction [
		"<t color=""#0000ff"">Enable loading from outside</t>",
		{
			(_this select 0) setVariable["can_outside", true, true];;
		},[],_Action_S_Priority,false,true,"",
		"((driver _target == _this) && !(_target getVariable 'can_outside') && IL_Can_Outside)"
		];

		_obj_main addAction [
		"<t color=""#0000ff"">Disable loading from outside</t>",
		{
			(_this select 0) setVariable["can_outside", false, true];;
		},[],_Action_S_Priority,false,true,"",
		"((driver _target == _this) && (_target getVariable 'can_outside') && IL_Can_Outside)"
		];
	};

	if (!(_vsupported) && (IL_DevMod)) then
	{
		Player globalChat Format["Object type: ""%1"" is not supported.", _obj_main_type];
	};

	if (IL_DevMod) then
	{
		Player globalChat Format["IgiLoad ""%1"" END.", IL_Script_Inst];
	};	
};