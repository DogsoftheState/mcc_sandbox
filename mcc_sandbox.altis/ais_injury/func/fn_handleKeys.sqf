// by chessmaster42
// handle key presses for AIS Wounding
private ["_key","_shift_state","_ctrl_state","_return","_isMedic"];
_key = _this select 1;
_shift_state = _this select 2;
_ctrl_state = _this select 3;

_return = [_this] call tcb_fnc_keyUnbind;

//If one of the unbindings triggered then leave here
if(_return) exitWith {true};

//Check for self-revive key binding (Ctrl+E)
//The First Aid function checks that the player is a medic and has supplies, no need to check it here
if(_ctrl_state && _key == 12 && (player getVariable 'unit_is_unconscious')) then {
	[player, player, true] call tcb_fnc_firstaid;
};

false