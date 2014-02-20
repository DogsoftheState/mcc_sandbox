// by chessmaster42
private ["_unit","_average_damage"];
_unit = _this select 0;
_allow_critical_damage = _this select 1;

_average_damage = [_unit] call tcb_fnc_getUnitDamage;

//Critical damage prevention
if ((_average_damage >= 0.9) && !(_allow_critical_damage)) exitWith {
	_scale = 0.89 / _average_damage;

	_unit setVariable ["tcb_ais_headhit", (_unit getVariable "tcb_ais_headhit") * _scale];
	_unit setVariable ["tcb_ais_bodyhit", (_unit getVariable "tcb_ais_bodyhit") * _scale];
	_unit setVariable ["tcb_ais_overall", (_unit getVariable "tcb_ais_overall") * _scale];
	_unit setVariable ["tcb_ais_legshit", (_unit getVariable "tcb_ais_legshit") * _scale];
	_unit setVariable ["tcb_ais_handshit", (_unit getVariable "tcb_ais_handshit") * _scale];

	[_unit, false] call tcb_fnc_setUnitDamage;
};

_unit setDamage _average_damage;