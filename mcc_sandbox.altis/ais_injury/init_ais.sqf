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

	if(isServer) then {
		"tcb_ais_update_damage" addPublicVariableEventHandler {
			_unit = (_this select 1) select 0;
			_is_healing = (_this select 1) select 1;
			_agony = (_this select 1) select 2;
			_head_damage = (_this select 1) select 3;
			_body_damage = (_this select 1) select 4;
			_overall_damage = (_this select 1) select 5;
			_legs_damage = (_this select 1) select 6;
			_hands_damage = (_this select 1) select 7;

			if(!alive _unit) exitWith {};

			_current_head_damage = _unit getVariable "tcb_ais_headhit";
			_current_body_damage = _unit getVariable "tcb_ais_bodyhit";
			_current_overall_damage = _unit getVariable "tcb_ais_overall";
			_current_legs_damage = _unit getVariable "tcb_ais_legshit";
			_current_hands_damage = _unit getVariable "tcb_ais_handshit";

			if(isNil "_current_head_damage") then {_current_head_damage = 0};
			if(isNil "_current_body_damage") then {_current_body_damage = 0};
			if(isNil "_current_overall_damage") then {_current_overall_damage = 0};
			if(isNil "_current_legs_damage") then {_current_legs_damage = 0};
			if(isNil "_current_hands_damage") then {_current_hands_damage = 0};

			if(_is_healing) then {
				_unit setVariable ["tcb_ais_headhit", _head_damage min _current_head_damage, true];
				_unit setVariable ["tcb_ais_bodyhit", _body_damage min _current_body_damage, true];
				_unit setVariable ["tcb_ais_overall", _overall_damage min _current_overall_damage, true];
				_unit setVariable ["tcb_ais_legshit", _legs_damage min _current_legs_damage, true];
				_unit setVariable ["tcb_ais_handshit", _hands_damage min _current_hands_damage, true];
			} else {
				_unit setVariable ["tcb_ais_headhit", _head_damage max _current_head_damage, true];
				_unit setVariable ["tcb_ais_bodyhit", _body_damage max _current_body_damage, true];
				_unit setVariable ["tcb_ais_overall", _overall_damage max _current_overall_damage, true];
				_unit setVariable ["tcb_ais_legshit", _legs_damage max _current_legs_damage, true];
				_unit setVariable ["tcb_ais_handshit", _hands_damage max _current_hands_damage, true];
			};

			if (_agony && !(_unit getVariable "tcb_ais_agony")) then {
				_unit allowDamage false;
			
				//Set the invulnerability timer so the unit doesn't take damage when first going into agony
				_delay = time + 10;
				_unit setVariable ["tcb_ais_fall_in_agony_time_delay", _delay, true];
			
				//Set the agony state
				_unit setVariable ["tcb_ais_agony", true, true];
			};

			//If the unit is in agony
			if(_unit getVariable "tcb_ais_agony") then {
				//And has been down past the initial protection delay then allow for critical damage (aka death)
				if(time > _unit getVariable "tcb_ais_fall_in_agony_time_delay") then {
					[_unit, true] call tcb_fnc_setUnitDamage;
				};
			} else {
				//Otherwise prevent critical damage but still calculate damage normally
				[_unit, false] call tcb_fnc_setUnitDamage;
			};
			
			if(tcb_ais_debugging) then {
				diag_log format["server received damage broadcast: %1 has %2 AIS damage and %3 vanilla damage", _unit, [_unit] call tcb_fnc_getUnitDamage, damage _unit];
			};
		};
	};

	//Synchronize the agony state using the public variable broadcast
	"tcb_ais_in_agony" addPublicVariableEventHandler {
		_unit = (_this select 1) select 0;
		_in_agony = (_this select 1) select 1;

		if(!alive _unit) exitWith {};

		//Failsafe to load AIS in case the broadcast is sent to a player that connected after AIS loaded for this unit 
		if (isNil {_unit getVariable "tcb_ais_aisInit"}) then {
			[_unit] spawn AIS_Load;
		};

		if (isNil {_unit getVariable "tcb_ais_agony"}) then {
			_unit setVariable ["tcb_ais_agony", false];
		};

		if(tcb_ais_debugging) then {
			diag_log format ["%1 current agony state - %2", _unit, _unit getVariable "tcb_ais_agony"];
			diag_log format ["%1 agony state received - %2", _unit, _in_agony];
		};

		if (_in_agony) then {
			_side = _unit getVariable "tcb_ais_side";

			//Announce the unit down in side chat
			[_side, "HQ"] sideChat format ["%1 is down and needs help at %2", name _unit, mapGridPosition _unit];
		
			//And put up a map marker
			if (playerSide == _side) then {
				[_unit] execFSM ("ais_injury\fsm\ais_marker.fsm");
			};

			//Spawn the server loop for periodically broadcasting the agony state of the unit
			//[_unit] spawn tcb_fnc_serverAgonyLoop;
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
	_unit setVariable ["tcb_ais_fall_in_agony_time_delay", time];
	_unit setVariable ["tcb_ais_healed_counter", 0];
	_unit setVariable ["tcb_ais_bleedout_time", 0];
	
	//Setup the 3D icons if enabled
	if (tcb_ais_show_3d_icons == 1) then {
		_3d = addMissionEventHandler ["Draw3D",
		{
			_playerFaction = side (group player);
			{
				if((side _x) == _playerFaction) then {
					{
						if ((_x distance player) < tcb_ais_3d_icon_range && (_x getVariable "tcb_ais_agony") && (alive _x)) then {
							_message = format["%1 (%2m)", name _x, ceil (player distance _x)];
							if(player call tcb_fnc_isMedic) then {
								_life_remaining = _x getVariable "tcb_ais_bleedout_time";
								_message = _message + format[" (%1%2)", ceil (_life_remaining * 100), "%"];
							};
							drawIcon3D["a3\ui_f\data\map\MapControl\hospital_ca.paa", [1,0,0,1], _x, 0.5, 0.5, 0, _message, 0, 0.02];
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
	
	//Setup the healing handler (this is for the Treat action, not the First Aid revive action)
	_unit addEventHandler ["HandleHeal", {_this call tcb_fnc_handleHeal}];
	
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
	
    //If this unit is the local player show a hint to let them know AIS Wounding is loaded
	if (_unit == player) then {
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