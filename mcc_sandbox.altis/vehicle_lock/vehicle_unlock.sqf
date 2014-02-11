_obj = _this select 0;

_obj setvehiclelock "unlocked";
_obj removeaction unlock;
lock = _obj addaction [format["<t color=""#F0F000"">Lock Vehicle</t>"], "vehicle_lock\vehicle_lock.sqf"];

exit;