// by chessmaster42
private ["_unit","_average_damage"];
_unit = _this select 0;

//Calculate the average damage for the unit based on AIS damage values
_average_damage = (
	(_unit getVariable "tcb_ais_headhit") * 0.25 +
	(_unit getVariable "tcb_ais_bodyhit") * 0.25 +
	(_unit getVariable "tcb_ais_overall") * 0.25 +
	(_unit getVariable "tcb_ais_legshit") * 0.125 +
	(_unit getVariable "tcb_ais_handshit") * 0.125
);
if (isNil "_average_damage") then {_average_damage = 0.6};

_average_damage