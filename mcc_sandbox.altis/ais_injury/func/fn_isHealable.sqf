// by psycho
// changed by chessmaster42
private["_injured","_return"];
_injured = _this select 0;

//Return true if the injured is alive, doesn't have a dragger, and doesn't already have a healer
_return = if (alive _injured && {isNull(_injured getVariable ["dragger",objNull])} && {isNull(_injured getVariable ["healer", objNull])}) then {true} else {false};

_return