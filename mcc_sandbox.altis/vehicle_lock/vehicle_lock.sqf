_obj = _this select 0;

_obj setvehiclelock "locked";
_obj removeaction lock;
unlock = _obj addaction [format["<t color=""#F0F000"">Unlock Vehicle</t>"], "vehicle_lock\vehicle_unlock.sqf"];

exit;