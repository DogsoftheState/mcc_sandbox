_unit = vehicle (_this select 0);
_id = _this select 2;
_arg = _this select 3;
_unit removeaction _id;
_unit setVariable ["Nux_tvs_onf",_arg];
if (_arg == 1) then {_unit addAction ["<t color='#FFBD4C'>Tvs off</t>", "TVS\scripts\tvsaction.sqf",0,0,false,true,"","(player == gunner _target) or ((player == driver _target) and not (isPlayer gunner _target))"];};
if (_arg == 0) then {_unit addAction ["<t color='#FFBD4C'>Tvs on</t>", "TVS\scripts\tvsaction.sqf",1,0,false,true,"","(player == gunner _target) or ((player == driver _target) and not (isPlayer gunner _target))"];};


