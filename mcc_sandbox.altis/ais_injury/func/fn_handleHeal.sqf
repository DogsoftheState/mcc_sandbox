// by chessmaster42
private ['_unit','_healer'];
_unit = _this select 0;
_healer = _this select 1;

if(_unit getVariable "tcb_ais_agony") exitWith {false};
if(_healer getVariable "tcb_ais_agony") exitWith {false};

_has_medikit = ((items _healer) find "Medikit" > -1);
_has_firstaidkit = ((items _healer) find "FirstAidKit" >= 0);
_isMedic = _healer call tcb_fnc_isMedic;

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

if(!isServer) then {
	//Broadcast the damage change
	tcb_ais_update_damage = [_unit, true, false, (_unit getVariable "tcb_ais_headhit"), (_unit getVariable "tcb_ais_bodyhit"), (_unit getVariable "tcb_ais_overall"), (_unit getVariable "tcb_ais_legshit"), (_unit getVariable "tcb_ais_handshit")];
	publicVariable "tcb_ais_update_damage";
};

false