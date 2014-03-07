// by chessmaster42
private ["_unit","_average_damage"];
_unit = _this select 0;
_allow_critical_damage = if (count _this > 1) then {_this select 1} else {false};

_average_damage = [_unit] call tcb_fnc_getUnitDamage;

//Critical damage prevention
if ((_average_damage >= tcb_ais_damage_limit) && !(_allow_critical_damage)) then {
	_average_damage = tcb_ais_damage_limit;
};

_unit setDamage _average_damage;