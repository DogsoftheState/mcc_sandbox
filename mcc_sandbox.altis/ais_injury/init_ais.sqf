// by Psycho
// changed by chessmaster42

//Load the config file to get basic settings
#include "ais_config.sqf";

//Load AIS Wounding on the unit in the first parameter
AIS_Load =
{
	_unit = _this select 0;
	
	//Make sure that _unit is valid
	if (isNil "_unit") exitWith {};
	//No player unit controlled on a dedicated server
	if (isDedicated && {isPlayer _unit}) exitWith {};
	//No headless client
	if (!isDedicated && {!hasInterface}) exitWith {};
	
	//Make sure that AIS isn't already loaded on this unit
	if (!isNil {_unit getVariable "tcb_ais_aisInit"}) exitWith {};
	_unit setVariable ["tcb_ais_aisInit",true];
	
    //Synchronize the agony state using the public variable broadcast
	"tcb_ais_in_agony" addPublicVariableEventHandler {
		_unit = (_this select 1) select 0;
		_in_agony = (_this select 1) select 1;
		_side = _unit getVariable "tcb_ais_side";
		if (playerSide == _side) then {
			if (_in_agony) then {
				_unit setVariable ["tcb_ais_agony", true];
				
				[side _unit,"HQ"] sideChat format ["%1 is down and needs help at %2", name _unit, mapGridPosition _unit];
				
				[_unit] execFSM ("ais_injury\fsm\ais_marker.fsm");
			} else {
				_unit setVariable ["tcb_ais_agony", false];

				//Failsafe in case the FSM doesn't remove the actions
				_unit removeAction (_unit getVariable "fa_action");
				_unit removeAction (_unit getVariable "drag_action");
				_unit setVariable ["fa_action",nil];
				_unit setVariable ["drag_action",nil];
			};
		};
	};
	
	tcb_healerStopped = false;
	_unit setVariable ["unit_is_unconscious", false];
	_unit setVariable ["tcb_ais_headhit", 0];
	_unit setVariable ["tcb_ais_handshit", 0];
	_unit setVariable ["tcb_ais_bodyhit", 0];
	_unit setVariable ["tcb_ais_legshit", 0];
	_unit setVariable ["tcb_ais_overall", 0];
	_unit setVariable ["tcb_ais_unit_died", false];
	_unit setVariable ["tcb_ais_leader", false];
	_unit setVariable ["tcb_ais_fall_in_agony_time_delay", 999999];
	
	//Setup the 3D icons if enabled
	if (tcb_ais_show_3d_icons == 1) then {
		_3d = addMissionEventHandler ["Draw3D",
		{
			_playerFaction = side (group player);
			{
				if((side _x) == _playerFaction) then {
					{
						if ((_x distance player) < 30 && (_x getVariable "tcb_ais_agony") && (alive _x)) then {
							drawIcon3D["a3\ui_f\data\map\MapControl\hospital_ca.paa", [1,0,0,1], _x, 0.5, 0.5, 0, format["%1 (%2m)", name _x, ceil (player distance _x)], 0, 0.02];
						};
					} forEach units _x;
				};
			} forEach allGroups;
		}];
	};
	
	if (tcb_ais_delTime > 0) then {
		_unit addEventHandler ["killed",{[_this select 0, tcb_ais_delTime] spawn tcb_fnc_delbody}];
	};
	
	//Setup the damage handler
	if(!isServer) then {
		_timeend = time + 2;
		waitUntil {!isNil {_unit getVariable "BIS_fnc_feedback_hitArrayHandler"} || {time > _timeend}};	// work around to ensure this EH is the last one that was added
		_unit removeAllEventHandlers "HandleDamage";
		["AIS_Load: %1 --- adding HandleDamage eventhandler", _unit] call BIS_fnc_logFormat;
		_unit addEventHandler ["HandleDamage", {_this call tcb_fnc_handleDamage}];
	};
	
	//Start the Finite State Machine
	[_unit] execFSM ("ais_injury\fsm\ais.fsm");
	
    //Setup an event to trigger on all KeyDown input events
	if (isPlayer _unit) then {
		waitUntil {sleep 0.3; !isNull (findDisplay 46)};
		(findDisplay 46) displayAddEventHandler ["KeyDown", "_this call tcb_fnc_keyUnbind"];
	};
	
	//Setup the death cam if enabled
	if (tcb_ais_dead_dialog == 1) then {
		if (isNil "respawndelay") then {
			_num = getNumber (missionConfigFile/"respawndelay");
			if (_num != 0) then {
				missionNamespace setVariable ["tcb_ais_respawndelay", _num];
			};
		} else {
			missionNamespace setVariable ["tcb_ais_respawndelay", 999];
		};
		
		if (_unit == player) then {
			_unit addEventHandler ["killed",{_this spawn tcb_fnc_deadcam}];
		};
	};
	
    //If this unit is the player show a hint to let them know AIS Wounding is loaded
	if (isPlayer _unit) then {
		hint "AIS Wounding Loaded";
	};
	
    //Debug message to side chat so that everyone knows when units have AIS Wounding loaded
	_unit sideChat "AIS Wounding Loaded";
};

//Loads AIS Wounding on the unit that called the action
AIS_Action_Load =
{
	[_caller] spawn AIS_Load;
};

//Loads AIS Wounding on all playable units currently in the mission
AIS_Basic_Load =
{
	{[_x] spawn AIS_Load} forEach playableUnits;  
};

//Loads AIS Wounding on all units currently in the player's faction
AIS_Faction_Load =
{
	_playerFaction = side (group player);
	{
		if((side _x) == _playerFaction) then {
			{[_x] spawn AIS_Load} forEach units _x;
		};
	} forEach allGroups;
};

//Loads AIS Wounding on all playable/switchable units currently in the mission
//This also forces the loading globally on the server and all clients
AIS_Global_Load =
{
	[[2, {[] spawn AIS_Basic_Load}], "CP_fnc_globalExecute", true, true] spawn BIS_fnc_MP;
};

//Loads AIS Wounding on all units currently in the player's faction
//This also forces the loading globally on the server and all clients
AIS_Global_Load_Faction =
{
	[[2, {[] spawn AIS_Faction_Load}], "CP_fnc_globalExecute", true, false] spawn BIS_fnc_MP;
};

call AIS_Global_Load;