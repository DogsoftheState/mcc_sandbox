// by BonInf*
// changed by psycho, chessmaster42
private ["_injuredperson","_healer","_behaviour","_timenow","_relpos","_dir","_offset","_time","_damage","_heal_time","_isMedic","_animChangeEVH","_has_medikit","_has_firstaidkit"];
_unit = _this select 0;
_healer = _this select 1;
_behaviour = behaviour _healer;
_has_medikit = ((items _healer) find "Medikit" > -1);
_has_firstaidkit = ((items _healer) find "FirstAidKit" >= 0);
_isMedic = _healer call tcb_fnc_isMedic;

//If the healer is AI move them until they're within 4 meters of the injured
if (!isPlayer _healer && {_healer distance _unit > tcb_ais_firstaid_distance}) then {
	_healer setBehaviour "AWARE";
	_healer doMove (position _unit);
	_timenow = time;
	WaitUntil {
		_healer distance _unit <= tcb_ais_firstaid_distance		 		||
		{!alive _unit}			 					||
		{!(_unit getVariable "tcb_ais_agony")} 	||
		{!alive _healer}				 					||
		{_healer getVariable "tcb_ais_agony"}		 		||
		{_timenow + 120 < time}
	};
};

//If the healer is also in agony by the time they get to the injured then leave here
if (_healer getVariable "tcb_ais_agony") exitWith {};

//Stop the healing if the injured died before the healer arrived
if (!alive _unit) exitWith {
	_healer setBehaviour _behaviour;
	if (isPlayer _healer) then {["It's already too late for this guy."] spawn tcb_fnc_showMessage};
};

//Stop the healing if the healer is too far away
if (_healer distance _unit > tcb_ais_firstaid_distance) exitWith {
	_healer setBehaviour _behaviour;
	if (isPlayer _healer) then {[format ["%1 is too far away to be healed.", name _unit]] spawn tcb_fnc_showMessage};
};

//Stop the healing if the healer doesn't have enough supplies
if(!(_has_medikit && _isMedic) && !_has_firstaidkit) exitWith {
	_healer setBehaviour _behaviour;
	if (isPlayer _healer) then {[format ["%1 cannot be healed. No first aid available.", name _unit]] spawn tcb_fnc_showMessage};
};

rtn = call tcb_fnc_isHealable;
if (!rtn) exitWith {};

_unit setVariable ["healer", _healer, true];
tcb_healerStopped = false;

_healer selectWeapon primaryWeapon _healer;
sleep 1;
_healer playAction "medicStart";
tcb_animDelay = time + 2;

//If the healer is an AI then stop all other AI tasks
if (!isPlayer _healer) then {
	_healer stop true;
	_healer disableAI "MOVE";
	_healer disableAI "TARGET";
	_healer disableAI "AUTOTARGET";
	_healer disableAI "ANIM";
};

//If the healer is a player then run through the healing animations
if (isPlayer _healer) then {
	_animChangeEVH = _healer addEventhandler ["AnimChanged", {
		private ["_anim","_healer"];
		_healer = _this select 0;
		_anim = _this select 1;
		if (primaryWeapon _healer != "") then {
			if (time >= tcb_animDelay) then {tcb_healerStopped = true};
		} else {
			if (_anim in ["amovpknlmstpsnonwnondnon","amovpknlmstpsraswlnrdnon"]) then {
				_healer playAction "medicStart";
			} else {
				if (!(_anim in ["ainvpknlmstpsnonwnondnon_medic0s","ainvpknlmstpsnonwnondnon_medic"])) then {
					if (time >= tcb_animDelay) then {tcb_healerStopped = true};
				};
			};
		};	
	}];
};

//Attach the injured to the healer
_offset = [0,0,0]; _dir = 0;
_relpos = _healer worldToModel position _unit;
if((_relpos select 0) < 0) then{_offset=[-0.2,0.7,0]; _dir=90} else{_offset=[0.2,0.7,0]; _dir=270};
_unit attachTo [_healer, _offset];
_unit setDir _dir;

//Get some values for the first aid timer/progress
_time = time;
_damage = damage _unit;
_healed_counter = _unit getVariable "tcb_ais_healed_counter";

//Calculate the healing time in seconds
//Base is up to 60 seconds plus the healed counter penalty
//The healed counter penalty is 5 seconds for every revive the unit has undergone
//There is also a minimum time of 5 seconds regardless of the damage or healed counter
_heal_time = _damage * 60 + _healed_counter * 5;
if(_heal_time < 5) then {_heal_time = 5};

//Run the healing progress bar
sleep 1;
while {
	time - _time < _heal_time
	&& {alive _healer}
	&& {alive _unit}
	&& {(_healer distance _unit) < tcb_ais_firstaid_distance}
	&& {!(_healer getVariable "tcb_ais_agony")}
	&& {!tcb_healerStopped}
} do {
	sleep 0.5;
	if (isPlayer _healer) then {["Applying First Aid", ((time - _time) / (_heal_time)) min 1] spawn tcb_fnc_progressbar};

	//Refresh first aid checks in case the items are removed during the first aid process
	_has_medikit = ((items _healer) find "Medikit" > -1);
	_has_firstaidkit = ((items _healer) find "FirstAidKit" >= 0);
	if(!(_has_medikit && _isMedic) && !_has_firstaidkit) then {tcb_healerStopped = true};
};

if (isPlayer _healer) then {_healer removeEventHandler ["AnimChanged", _animChangeEVH]};

//Detach the injured from the healer
detach _healer;
detach _unit;
_unit setVariable ["healer", ObjNull, true];

//If the healer is an AI then start up all other AI tasks
if (!isPlayer _healer) then {
	_healer stop false;
	_healer enableAI "MOVE";
	_healer enableAI "TARGET";
	_healer enableAI "AUTOTARGET";
	_healer enableAI "ANIM";
};

//If the healer is still healthy stop animations and restore behaviour
if (alive _healer && {!(_healer getVariable "tcb_ais_agony")}) then {
	_healer playAction "medicStop";
	_healer setBehaviour _behaviour;
};

//If either the healer or the injured died during the healing, bail out
if (!alive _healer) exitWith {};
if (!alive _unit) exitWith {["It's already too late for this guy."] spawn tcb_fnc_showMessage};

//Do the actual unit healing as long as the process wasn't interrupted and we still have medical supplies
if (!tcb_healerStopped && ((_has_medikit && _isMedic) || _has_firstaidkit)) then {
	_current_headhit = _unit getVariable "tcb_ais_headhit";
	_current_bodyhit = _unit getVariable "tcb_ais_bodyhit";
	_current_overall = _unit getVariable "tcb_ais_overall";

	_current_legshit = _unit getVariable "tcb_ais_legshit";
	_current_handshit = _unit getVariable "tcb_ais_handshit";

	_core_healed = 1;
	_extremeties_healed = 1;
	switch (true) do {
		//Medic: Yes, Medikit: Yes - Free and heal 100% of damage
		case (_isMedic && _has_medikit) : {
			_core_healed = 0;
			_extremeties_healed = 0;
		};
		//Medic: Yes, FirstAid: Yes - Consume FirstAid and heal 75% of most damage and 50% of legs and hands
		case (_isMedic && _has_firstaidkit) : {
			_healer removeItem "FirstAidKit";
			_core_healed = 0.25;
			_extremeties_healed = 0.5;
		};
		//Medic: No, FirstAid: Yes - Consume FirstAid and heal 50% of damage of damage and 10% of legs and hands
		case (!_isMedic && _has_firstaidkit) : {
			_healer removeItem "FirstAidKit";
			_core_healed = 0.5;
			_extremeties_healed = 0.9;
		};
	};

	_unit setVariable ["tcb_ais_headhit", _core_healed * _current_headhit];
	_unit setVariable ["tcb_ais_bodyhit", _core_healed * _current_bodyhit];
	_unit setVariable ["tcb_ais_overall", _core_healed * _current_overall];

	_unit setVariable ["tcb_ais_legshit", _extremeties_healed * _current_legshit];
	_unit setVariable ["tcb_ais_handshit", _extremeties_healed * _current_handshit];

	//Broadcast the damage change
	tcb_ais_update_damage = [_unit, true, false, (_unit getVariable "tcb_ais_headhit"), (_unit getVariable "tcb_ais_bodyhit"), (_unit getVariable "tcb_ais_overall"), (_unit getVariable "tcb_ais_legshit"), (_unit getVariable "tcb_ais_handshit")];
	publicVariable "tcb_ais_update_damage";

	_unit setVariable ["tcb_ais_agony", false, true];
} else {
	if (isPlayer _healer) then {["You have stopped the healing process."] spawn tcb_fnc_showMessage};
};