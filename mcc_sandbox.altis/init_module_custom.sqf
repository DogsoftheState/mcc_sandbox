//-----------------------BTC Logistic -------------------------------------------
call compile preprocessFile "=BTC=_Logistic\=BTC=_logistic_Init.sqf";

//--------------------------AIS Wounding System ---------------------------------
call compile preprocessFile "ais_injury\init_ais.sqf";

//--------------------------Vehicle Locking System ------------------------------
call compile preprocessFile "vehicle_lock\vehicle_lock.sqf";

//--------------------------Idle Info System ------------------------------------
call compile preprocessFile "idle_info\idle_info.sqf";

//----------------------TAA Name Tag---------------------------------------------
// Source: http://www.armaholic.com/forums.php?m=posts&q=25214

[] execVM "TAA_name\TAA_name_init.sqf";

//----------------------MB Skillset----------------------------------------------
// Source: http://www.armaholic.com/page.php?id=21320

[] execVM "MB_SkillSet\initMBSkillSet.sqf";

//----------------------Group Manager--------------------------------------------
// Source: ??

[] execVM "group_manager.sqf";

//----------------------Task Force Radio-----------------------------------------
// Source: https://github.com/michail-nikolaev/task-force-arma-3-radio/

tf_no_auto_long_range_radio = true;

//tf_same_sw_frequencies_for_side = true;
//tf_freq_west = 31;
//tf_freq_east = 31;
//tf_freq_guer = 31;

//tf_same_lr_frequencies_for_side = true;
//tf_freq_west_lr = 51;
//tf_freq_east_lr = 51;
//tf_freq_guer_lr = 51;

//------------------------Misc-----------------------------------
//Override the MCC 3D editor script presets
mccPresets = [
	 ['======= Artillery =======','']
	,['AI Artillery - Cannon', '[_this,1,2000,100,12,5,"Sh_82mm_AMOS",20] execVM "'+MCC_path+'scripts\UPSMON\MON_artillery_add.sqf";']
	,['AI Artillery - Rockets', '[_this,6,5000,150,4,2,"Sh_82mm_AMOS",120] execVM "'+MCC_path+'scripts\UPSMON\MON_artillery_add.sqf";']
	,['Ambient Artillery - Cannon', '[0,_this] execVM "'+MCC_path+'mcc\general_scripts\ambient\amb_art.sqf";']
	,['Ambient Artillery - Rockets', '[1,_this] execVM "'+MCC_path+'mcc\general_scripts\ambient\amb_art.sqf";']
	,['Forward Observer Artillery', '[0,_this] execVM "'+MCC_path+'mcc\general_scripts\artillery\bon_art.sqf";']
	,['Ambient AA - Cannon/Rockets', '[2,_this] execVM "'+MCC_path+'mcc\general_scripts\ambient\amb_art.sqf";']
	,['Ambient AA - Search Light', '[3,_this] execVM "'+MCC_path+'mcc\general_scripts\ambient\amb_art.sqf";']
	,['======= Units =======','']
	,['Recruitable', '_this addAction [format ["Recruit %1", name _this], "'+MCC_path+'mcc\general_scripts\hostages\hostage.sqf",[2],6,false,true];']
	,['Make Hostage', '_this execVM "'+MCC_path+'mcc\general_scripts\hostages\create_hostage.sqf";']
	,['Join player', '[_this] join (group player);']
	,['Set Renegade', '_this addrating -2001;']
	,['Stand Up', '_this setUnitPos "UP";']
	,['Kneel', '_this setUnitPos "Middle";']
	,['Prone', '_this setUnitPos "DOWN";']
	,['Can be controled using MCC Console', '(group _this) setvariable ["MCC_canbecontrolled",true,true];']
	,['Load AIS Wounding', '[_this] spawn AIS_Load;']
	,['======= Vehicles =======','']
	,['Set Empty (Fuel)', '_this setfuel 0;']
	,['Set Empty (Ammo)', '_this setvehicleammo 0;']
	,['Set Empty (Cargo)', 'clearMagazineCargoGlobal _this; clearWeaponCargoGlobal _this; clearItemCargoGlobal _this;']
	,['Set Locked', '_this setVehicleLock "LOCKED";']
	,['Add Crew (UAV)','createVehicleCrew _this;group _this setvariable ["MCC_canbecontrolled",true,true];']
	,['ECM - can jamm IED','if (isServer) then {_this setvariable ["MCC_ECM",true,true]};']
	,['======= Objects =======','']
	,['Pickable Object','_this call MCC_fnc_pickItem;']
	,['Destroyable by satchels only', '_this addEventHandler ["handledamage", {if ((_this select 4) in ["SatchelCharge_Remote_Ammo","DemoCharge_Remote_Ammo"]) then {(_this select 0) setdamage 1} else {0}}];']
	,['Destroy Object', '_this setdamage 1;']
	,['Flip Object', '[_this ,0, 90] call bis_fnc_setpitchbank;']
	,['======= Effects =======','']
	,['Sandstorm','[_this] call BIS_fnc_sandstorm;']
	,['Flies','[getposatl _this] call BIS_fnc_flies;']
	,['Smoke','if (isServer) then {_effect = "test_EmptyObjectForSmoke" createVehicle (getpos _this); _effect attachto [_this,[0,0,0]];};']
	,['Fire','if (isServer) then {_effect = "test_EmptyObjectForFireBig" createVehicle (getpos _this); _effect attachto [_this,[0,0,0]];};']
	,['======= TV Guidance =======','']
	,['A-143 GBU12', '[_this,"Bo_GBU12_LGB_MI10"] execVM "TVS\scripts\init.sqf";']
	,['FA18 GBU12', '[_this,"js_a_fa18_GBU12_LGB"] execVM "TVS\scripts\init.sqf";']
	,['FA18 GBU38', '[_this,"js_a_fa18_GBU38_JDAM"] execVM "TVS\scripts\init.sqf";']
	,['FA18 GBU32', '[_this,"js_a_fa18_GBU32_JDAM"] execVM "TVS\scripts\init.sqf";']
	,['FA18 GBU31', '[_this,"js_a_fa18_GBU31_JDAM"] execVM "TVS\scripts\init.sqf";']
	,['======= Actions =======','']
	,['Virtual Ammobox System (VAS)', '_this addAction [format["<t color=""#F0F000"">Virtual Ammobox</t>"], "VAS\open.sqf", _this, 100, true];']
	,['Lock Vehicle', 'JP_VL_Action = _this addAction [format["<t color=""#F0F000"">Lock Vehicle</t>"], {[(_this select 0)] spawn JP_VL_Global_Lock}];']
	,['======= Misc =======','']
	,['Create Local Marker', '_this execVM "'+MCC_path+'mcc\general_scripts\create_local_marker.sqf";']
	,['Void Map Marker', '_this execVM "void_map_marker.sqf";']
];