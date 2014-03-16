// Authored by chessmaster42
// Based on 'A3 Wounding System' by Psychobastard

//Load the config file to get basic settings
#include "cws_config.sqf";

//Load CWS on the unit in the first parameter
CWS_Load =
{
	_unit = _this select 0;
	
	//Make sure that _unit is valid
	if (isNil "_unit") exitWith {};
	
	//If this unit is already loaded then exit
	if (!isNil {_unit getVariable "cws_ais_aisInit"}) exitWith {};

	_unit setVariable ["cws_ais_aisInit", true];

	"cws_ais_start_heal" addPublicVariableEventHandler {
		_unit = (_this select 1) select 0;
		_healer = (_this select 1) select 1;

		_unit setVariable ["healer", _healer, true];
	};

	"cws_ais_healed" addPublicVariableEventHandler {
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

		_unit setVariable ["cws_ais_headhit", _head, true];
		_unit setVariable ["cws_ais_bodyhit", _body, true];
		_unit setVariable ["cws_ais_overall", _overall, true];
		_unit setVariable ["cws_ais_legshit", _legs, true];
		_unit setVariable ["cws_ais_handshit", _hands, true];

		[_unit] call cws_fnc_setUnitDamage;

		if(_revived_counter > 0) then {_unit setVariable ["cws_ais_revived_counter", _revived_counter, true]};
	};

	//Setup the 3D icons if enabled
	if (cws_ais_show_3d_icons == 1) then {
		_3d = addMissionEventHandler ["Draw3D", {
			_player_is_medic = player call cws_fnc_isMedic;
			_playerFaction = side (group player);
			{
				if((side _x) == _playerFaction) then {
					{
						if ((_x distance player) < cws_ais_3d_icon_range && (_x getVariable "cws_ais_agony") && (alive _x)) then {
							_message = format["%1 (%2m)", name _x, ceil (player distance _x)];
							_icon_size = 0.5;
							_text_size = 0.025;
							if(_player_is_medic) then {
								_life_remaining = _x getVariable "cws_ais_bleedout_time";
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
	if (cws_ais_delTime > 0) then {
		_unit addEventHandler ["killed",{[_this select 0, cws_ais_delTime] spawn cws_fnc_delbody}];
	};
	
	//Work around to ensure this damage EH is the last one that was added
	_timeend = time + 2;
	waitUntil {!isNil {_unit getVariable "BIS_fnc_feedback_hitArrayHandler"} || {time > _timeend}};
	_unit removeAllEventHandlers "HandleDamage";

	//Setup the damage handler
	_unit addEventHandler ["HandleDamage", {_this call cws_fnc_handleDamage}];
	
	//Setup the healing handler (this is for the Treat action, not the First Aid revive action)
	_unit addEventHandler ["HandleHeal", {_this call cws_fnc_handleHeal}];
	
	//Start the Finite State Machine
	[_unit] execFSM ("cws_injury\fsm\cws.fsm");
	
    //Setup an event to trigger on all KeyDown input events
	if (_unit == player) then {
		waitUntil {sleep 0.3; !isNull (findDisplay 46)};
		(findDisplay 46) displayAddEventHandler ["KeyDown", "_this call cws_fnc_handleKeys"];
	};
	
	//Setup the death cam if enabled
	if (cws_ais_dead_dialog == 1) then {
		if (isNil "respawndelay") then {
			_num = getNumber (missionConfigFile/"respawndelay");
			if (_num != 0) then {
				missionNamespace setVariable ["cws_ais_respawndelay", _num];
			};
		} else {
			missionNamespace setVariable ["cws_ais_respawndelay", 999];
		};
		
		if (_unit == player) then {
			_unit addEventHandler ["killed",{_this spawn cws_fnc_deadcam}];
		};
	};

    //If this unit is the local player show a hint to let them know CWS is loaded
	if (_unit == player) then {
		hint "CWS Wounding Loaded";
	};
	
    //Message to side chat so that everyone knows when units on their side have CWS loaded
	if(playerSide == (side _unit)) then {
		if(isPlayer _unit) then {
			[side _unit,"HQ"] sideChat format ["%1 - CWS Wounding Loaded!", name _unit];
		} else {
			[side _unit,"HQ"] sideChat format ["%1 (AI) - CWS Wounding Loaded!", name _unit];
		};
	};

	if(cws_ais_debugging) then {
		if(local _unit) then {
			diag_log format["%1 (Local) - CWS Wounding Loaded!", _unit];
		} else {
			diag_log format["%1 (Remote) - CWS Wounding Loaded!", _unit];
		};
	};
};

//Load CWS on all playable units
CWS_Load_Players =
{
	{
		[_x] spawn CWS_Load;
	} forEach playableUnits;
};

//Globally loads CWS Wounding on all playable units
CWS_Load_Global_Players =
{
	[[], "CWS_Load_Players", true, true] spawn BIS_fnc_MP;
};

call CWS_Load_Global_Players;