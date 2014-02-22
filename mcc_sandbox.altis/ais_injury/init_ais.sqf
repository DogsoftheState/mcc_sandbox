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
	
	//If this unit is already loaded then sync the unit info and exit
	if (!isNil {_unit getVariable "tcb_ais_aisInit"}) exitWith {
		if(local _unit) then {
			_unit setVariable ["tcb_ais_headhit", (_unit getVariable "tcb_ais_headhit"), true];
			_unit setVariable ["tcb_ais_bodyhit", (_unit getVariable "tcb_ais_bodyhit"), true];
			_unit setVariable ["tcb_ais_overall", (_unit getVariable "tcb_ais_overall"), true];
			_unit setVariable ["tcb_ais_legshit", (_unit getVariable "tcb_ais_legshit"), true];
			_unit setVariable ["tcb_ais_handshit", (_unit getVariable "tcb_ais_handshit"), true];

			_unit setVariable ["tcb_ais_revived_counter", (_unit getVariable "tcb_ais_revived_counter"), true];

			if(_unit getVariable "tcb_ais_agony") then {
				tcb_ais_in_agony = [_unit, true];
				publicVariable "tcb_ais_in_agony";
			};

			if(tcb_ais_debugging) then {
				diag_log format["AIS already loaded for local %1", _unit];
			};
		} else {
			if(tcb_ais_debugging) then {
				diag_log format["AIS already loaded for remote %1", _unit];
			};
		};
	};

	_unit setVariable ["tcb_ais_aisInit", true];
	_unit setVariable ["tcb_ais_aisLoaded", false];

	"tcb_ais_healed" addPublicVariableEventHandler {
		_unit = (_this select 1) select 0;

		_head = (_this select 1) select 1;
		_body = (_this select 1) select 2;
		_overall = (_this select 1) select 3;
		_legs = (_this select 1) select 4;
		_hands = (_this select 1) select 5;

		_revived_counter = (_this select 1) select 6;

		//Make sure that _unit is valid
		if (isNil "_unit") exitWith {};

		//Make sure that _unit is alive
		if(!alive _unit) exitWith {};
	
		//Make sure that _unit is local
		if(!local _unit) exitWith {};

		_unit setVariable ["tcb_ais_headhit", _head, true];
		_unit setVariable ["tcb_ais_bodyhit", _body, true];
		_unit setVariable ["tcb_ais_overall", _overall, true];
		_unit setVariable ["tcb_ais_legshit", _legs, true];
		_unit setVariable ["tcb_ais_handshit", _hands, true];

		[_unit] call tcb_fnc_setUnitDamage;

		if(_revived_counter > 0) then {_unit setVariable ["tcb_ais_revived_counter", _revived_counter, true]};
	};

	//Setup the agony public variable handler
	"tcb_ais_in_agony" addPublicVariableEventHandler {
		_unit = (_this select 1) select 0;
		_in_agony = (_this select 1) select 1;

		//Make sure that _unit is valid
		if (isNil "_unit") exitWith {};

		//Make sure that _unit is alive
		if(!alive _unit) exitWith {};
	
		if(tcb_ais_debugging) then {
			diag_log format ["%1 agony: %2->%3", _unit, _unit getVariable "tcb_ais_agony", _in_agony];
		};

		if (_in_agony) then {
			_side = _unit getVariable "tcb_ais_side";

			//Announce the unit down in side chat
			[_side, "HQ"] sideChat format ["%1 is down and needs help at %2", name _unit, mapGridPosition _unit];
		
			//And put up a map marker
			if (playerSide == _side) then {
				[_unit] execFSM ("ais_injury\fsm\ais_marker.fsm");
			};
		};
	};

	//Setup the 3D icons if enabled
	if (tcb_ais_show_3d_icons == 1) then {
		_3d = addMissionEventHandler ["Draw3D", {
			_player_is_medic = player call tcb_fnc_isMedic;
			_playerFaction = side (group player);
			{
				if((side _x) == _playerFaction) then {
					{
						if ((_x distance player) < tcb_ais_3d_icon_range && (_x getVariable "tcb_ais_agony") && (alive _x)) then {
							_message = format["%1 (%2m)", name _x, ceil (player distance _x)];
							_icon_size = 0.5;
							_text_size = 0.025;
							if(_player_is_medic) then {
								_life_remaining = _x getVariable "tcb_ais_bleedout_time";
								_message = _message + format[" (%1%2)", ceil (_life_remaining * 100), "%"];
								_icon_size = 1.0;
								_text_size = 0.05;
							};
							drawIcon3D["a3\ui_f\data\map\MapControl\hospital_ca.paa", [1,0,0,1], _x, _icon_size, _icon_size, 0, _message, 0, _text_size];
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
	if (_unit == player) then {
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
	
    //Message to side chat so that everyone knows when units on their side have AIS Wounding loaded
	if(playerSide == (side _unit)) then {
		if(isPlayer _unit) then {
			[side _unit,"HQ"] sideChat format ["%1 - AIS Wounding Loaded!", name _unit];
		} else {
			[side _unit,"HQ"] sideChat format ["%1 (AI) - AIS Wounding Loaded!", name _unit];
		};
	};

	if(tcb_ais_debugging) then {
		if(local _unit) then {
			diag_log format["%1 (Local) - AIS Wounding Loaded!", _unit];
		} else {
			diag_log format["%1 (Remote) - AIS Wounding Loaded!", _unit];
		};
	};
};

//Globally loads AIS Wounding on all playable units
AIS_Load_Global_Players =
{
	[[2, {{[_x] spawn AIS_Load} forEach playableUnits}], "CP_fnc_globalExecute", true, true] spawn BIS_fnc_MP;
};

call AIS_Load_Global_Players;