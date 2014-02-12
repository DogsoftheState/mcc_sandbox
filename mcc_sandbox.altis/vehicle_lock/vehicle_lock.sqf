JP_VL_Action = nil;

JP_VL_Lock = 
{
	_obj = _this select 0;
	
	_obj setvehiclelock "locked";
	_obj removeaction JP_VL_Action;
	JP_VL_Action = _obj addaction [format["<t color=""#F0F000"">Unlock Vehicle</t>"], {[(_this select 0)] spawn JP_VL_Global_Unlock}];
};

JP_VL_Unlock = 
{
	_obj = _this select 0;
	
	_obj setvehiclelock "unlocked";
	_obj removeaction JP_VL_Action;
	JP_VL_Action = _obj addaction [format["<t color=""#F0F000"">Lock Vehicle</t>"], {[(_this select 0)] spawn JP_VL_Global_Lock}];
};

JP_VL_Global_Lock = 
{
    _vehicle = _this select 0;
	[[_vehicle], "JP_VL_Lock", true, false] spawn BIS_fnc_MP;
};

JP_VL_Global_Unlock = 
{
    _vehicle = _this select 0;
	[[_vehicle], "JP_VL_Unlock", true, false] spawn BIS_fnc_MP;
};