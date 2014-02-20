ii_idle_time = 300;
ii_enable_3d_icon = 1;

//Reset the player idle time
II_Reset_Idle =
{
	_unit = player;

    _unit setVariable ["ii_time_to_idle", ii_idle_time, true];
};

//This loop will check the idle state of the unit until it dies
II_Idle_Check_Loop =
{
	_unit = _this select 0;

	//Only let the server run this loop
	if(isServer) then {
		while{alive _unit} do
		{
			_unit_idle_time = _unit getVariable "ii_time_to_idle";
			if (_unit_idle_time <= 0) then {
				_unit setVariable ["ii_is_idle", true, true];
				_unit setVariable ["ii_time_to_idle", 0, true];
			} else {
				_unit setVariable ["ii_is_idle", false, true];
				_unit setVariable ["ii_time_to_idle", _unit_idle_time - 15, true];
			};
			sleep 15;
		};
	};
};

//Load the IdleInfo system on the unit given in the first argument
II_Load =
{
	_unit = _this select 0;

	//Make sure that _unit is valid
	if (isNil "_unit") exitWith {};

	//Make sure that IdleInfo isn't already loaded on this unit
	if (!isNil {_unit getVariable "ii_iiInit"}) exitWith {};
	_unit setVariable ["ii_iiInit", true];
	
	_unit setVariable ["ii_is_idle", false];
	_unit setVariable ["ii_time_to_idle", ii_idle_time];

	if(ii_enable_3d_icon == 1) then {
		//Setup the 3D icon that shows up when the unit is idle
		_3d = addMissionEventHandler ["Draw3D",
		{
			{
				if ((_x distance player) < 50 && (_x getVariable "ii_is_idle") && (alive _x)) then {
					drawIcon3D["a3\ui_f\data\map\Diary\Icons\playerconnecting_ca.paa", [0.15,1,0.3,1], _x, 0.5, 0.5, 0, format["%1 (%2m)", name _x, ceil (player distance _x)], 0, 0.02];
				};
			} forEach playableUnits;
		}];
	};

    //Setup an event to trigger on all KeyDown input events
	if (isPlayer _unit) then {
		waitUntil {sleep 0.3; !isNull (findDisplay 46)};
		(findDisplay 46) displayAddEventHandler ["KeyDown", "_this call II_Reset_Idle"];
	};

	//Load the main loop
	[_unit] spawn II_Idle_Check_Loop;
    
	_unit sideChat "IdleInfo loaded!";
};

//Run the load function globally (all clients and server)
II_Global_Load =
{
	[[2, {{[_x] spawn II_Load} forEach playableUnits}], "CP_fnc_globalExecute", true, true] spawn BIS_fnc_MP;
};