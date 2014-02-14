ii_idle_time = 300;
ii_enable_3d_icon = 1;
ii_enable_chat_messages = 0;

//Reset the player idle time
II_Reset_Idle =
{
	_unit = player;

    _unit setVariable ["ii_time_to_idle", time + ii_idle_time, true];

	if(_unit getVariable "ii_is_idle") then {
		_unit setVariable ["ii_is_idle", false];
	
		ii_unit_is_idle = [_unit, false];
		publicVariable "ii_unit_is_idle";

		if(ii_enable_chat_messages == 1) then {
			_unit sideChat "I am no longer idle!";
		};
	};
};

//This loop will check the idle state of the unit until it dies
II_Idle_Check_Loop =
{
	_unit = _this select 0;

	while{alive _unit} do
	{
		if (time > (_unit getVariable "ii_time_to_idle") && !(_unit getVariable "ii_is_idle")) then {
			_unit setVariable ["ii_is_idle", true];

			ii_unit_is_idle = [_unit, true];
			publicVariable "ii_unit_is_idle";
		};
		sleep 5;
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
	_unit setVariable ["ii_iiInit",true];
	
	_unit setVariable ["ii_is_idle", false];
	_unit setVariable ["ii_time_to_idle", time + ii_idle_time];

    //Synchronize the idle time using the public variable broadcast
	"ii_unit_is_idle" addPublicVariableEventHandler {
		_unit = (_this select 1) select 0;
		_is_idle = (_this select 1) select 1;
        
		if (_is_idle) then {
			_unit setVariable ["ii_is_idle", true];

			if(ii_enable_chat_messages == 1) then {
				_unit sideChat "I have just gone idle. Slap me!";
			};
		} else {
			_unit setVariable ["ii_is_idle", false];

			if(ii_enable_chat_messages == 1) then {
				_unit sideChat "I am no longer idle!";
			};
		};
	};

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

//Load the IdleInfo system on all players
II_Basic_Load =
{
	{[_x] spawn II_Load} forEach playableUnits;  
};

//Run the load function globally (all clients and server)
II_Global_Load =
{
	[[2, {[] spawn II_Basic_Load}], "CP_fnc_globalExecute", true, true] spawn BIS_fnc_MP;
};