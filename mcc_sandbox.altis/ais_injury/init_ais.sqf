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
	_unit setVariable ["tcb_ais_aisInit", true];
	_unit setVariable ["tcb_ais_aisLoaded", false];
	
    //Synchronize the agony state using the public variable broadcast
	"tcb_ais_in_agony" addPublicVariableEventHandler {
		_unit = (_this select 1) select 0;
		_in_agony = (_this select 1) select 1;

		if(!alive _unit) exitWith {};

		if (isNil {_unit getVariable "tcb_ais_agony"}) then {
			_unit setVariable ["tcb_ais_agony", false];
		};

		//diag_log format ["%1 current agony state - %2", _unit, _unit getVariable "tcb_ais_agony"];
		//diag_log format ["%1 agony state received - %2", _unit, _in_agony];

		//If agony is true and it's not already true on the unit
		if (_in_agony && !(_unit getVariable "tcb_ais_agony")) then {
			_unit setVariable ["tcb_ais_agony", true];

			_unit playActionNow "agonyStart";

			//Announce the unit down in side chat and put up a map marker
			//Note: This only applies to units on the player's side
			if (playerSide == side _unit) then {
				[side _unit,"HQ"] sideChat format ["%1 is down and needs help at %2", name _unit, mapGridPosition _unit];
				
				[_unit] execFSM ("ais_injury\fsm\ais_marker.fsm");
			};

			[_unit] spawn tcb_fnc_serverAgonyLoop;
		};

		if (!_in_agony) then {
			_unit setVariable ["tcb_ais_agony", false];

			_unit playActionNow "agonyStop";
			
			//Failsafe in case the FSM doesn't remove the actions
			_unit removeAction (_unit getVariable "fa_action");
			_unit removeAction (_unit getVariable "drag_action");
			_unit setVariable ["fa_action",nil];
			_unit setVariable ["drag_action",nil];
		};

		//Failsafe to load AIS in case the broadcast is sent to a player that connected after AIS loaded for this unit 
		if (isNil {_unit getVariable "tcb_ais_aisInit"}) then {
			[_unit] spawn AIS_Load;
		};
	};

	//Initialize some basic unit variables
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
						if ((_x distance player) < tcb_ais_3d_icon_range && (_x getVariable "tcb_ais_agony") && (alive _x)) then {
							drawIcon3D["a3\ui_f\data\map\MapControl\hospital_ca.paa", [1,0,0,1], _x, 0.5, 0.5, 0, format["%1 (%2m)", name _x, ceil (player distance _x)], 0, 0.02];
						};
					} forEach units _x;
				};
			} forEach allGroups;
		}];
	};
	
	//If the body delete time is configured then add the event handler to remove the body
	if (tcb_ais_delTime > 0) then {
		_unit addEventHandler ["killed",{[_this select 0, tcb_ais_delTime] spawn tcb_fnc_delbody}];
	};
	
	//Work around to ensure this damage EH is the last one that was added
	_timeend = time + 2;
	waitUntil {!isNil {_unit getVariable "BIS_fnc_feedback_hitArrayHandler"} || {time > _timeend}};
	_unit removeAllEventHandlers "HandleDamage";

	//Setup the damage handler
	_unit addEventHandler ["HandleDamage", {_this call tcb_fnc_handleDamage}];
	
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

	//Finished loading so set the flag
	_unit setVariable ["tcb_ais_aisLoaded", true];
	
    //If this unit is the player show a hint to let them know AIS Wounding is loaded
	if (isPlayer _unit) then {
		hint "AIS Wounding Loaded";
	};
	
    //Debug message to side chat so that everyone knows when units on their side have AIS Wounding loaded
	if(playerSide == (side _unit)) then {
		[side _unit,"HQ"] sideChat format ["%1 - AIS Wounding Loaded!", name _unit];
	};
};

//Globally loads AIS Wounding on all playable units
AIS_Load_Global_Players =
{
	[[2, {{[_x] spawn AIS_Load} forEach playableUnits}], "CP_fnc_globalExecute", true, true] spawn BIS_fnc_MP;
};

call AIS_Load_Global_Players;