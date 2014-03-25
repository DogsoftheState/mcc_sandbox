private["_heli", "_route", "_endpos", "_height", "_landing ", "_pilot", "_i", "_j", "_pos", "_dist", "_distold", "_angh", "_dir","_startPos",
		"_accel", "_speed", "_steps", "_inipos", "_offset","_nearSmokes","_wp","_wp2","_distance","_relDirHor","_velocityX","_velocityY","_cargoUnits"];

_route         = _this select 0;
_height        = _this select 1;
_landing       = _this select 2;
_heli          = _this select 3;

if (!local _heli) exitWith {hint "vehicle must be local";};

if (_height == 5000) then //We got a vehicle
{								
	for [{_j = 0},{_j < count _route},{_j = _j + 1}] do
	{ 
		if ((getText(configFile >> "CfgVehicles" >> typeOf _heli  >> "simulation")) == "submarinex") then {_heli swimInDepth -4};
		_pos = _route select _j;
		_wp = (group driver _heli) addWaypoint [_pos, 0];
		_wp setWaypointType "MOVE";
		_wp setWaypointCombatMode "BLUE";
		_wp setWaypointSpeed "FULL";
		_wp setWaypointBehaviour "CARELESS";
		
		_wp2 = (group gunner _heli) addWaypoint [_pos, 0];
		_wp2 setWaypointType "MOVE";
		_wp2 setWaypointCombatMode "YELLOW";
		_wp2 setWaypointSpeed "FULL";
		_wp2 setWaypointBehaviour "COMBAT";
	};
	if (_landing == 1) then {_wp setWaypointStatements ["true", " driver (vehicle this) action ['ENGINEOFF', (vehicle this)];"]};
}
else
{
	// First of all chopper gets its indicated flying height for the route
	_pilot = driver _heli;
	_heli setfuel 1; 
	_heli flyinHeight _height;
	_heli setVariable ["wp_complete", false];
	
	_startPos = _heli getVariable"MCC_evacStartPos";
	_cargoUnits = assignedCargo _heli;
	
	for [{_j = 0},{_j < count _route},{_j = _j + 1}] do
	{ 
		_pos = _route select _j;
		_wp = (group driver _heli) addWaypoint [_pos, 0];
		_wp setWaypointType "MOVE";
		_wp setWaypointCombatMode "BLUE";
		_wp setWaypointSpeed "FULL";
		_wp setWaypointBehaviour "CARELESS";
		
		_wp2 = (group gunner _heli) addWaypoint [_pos, 0];
		_wp2 setWaypointType "MOVE";
		_wp2 setWaypointCombatMode "YELLOW";
		_wp2 setWaypointSpeed "FULL";
		_wp2 setWaypointBehaviour "COMBAT"
	};
	
	_wp setWaypointCompletionRadius 10;
	_wp setWaypointStatements ["true", " (vehicle this) setVariable ['wp_complete', true];"];
	
	while {!(_heli getVariable "wp_complete")} do {sleep 1};
	
	switch (_landing) do		//Which insertion do we want
	{
		case 0:			//Free Landing engine on
		{
			_heli land "GET IN";
		};
		
		case 1:			//Free Landing engine off
		{
			_heli land "LAND";
		};
		
		case 2:			//Hover
		{
			_heli flyinHeight _height;
		};
		
		case 3:			//Helocasting
		{
			//while {(_heli distance _pos)>55} do {_pilot doMove _pos; sleep 5;};
			_heli flyinHeight 3;
			waituntil {((getposasl _heli) select 2) < 8};
			_heli globalChat "Golf 1 in position, clear for helocasting";
			
			{					
				[_x] spawn 
					{
						private ["_unit","_timeOut"];
						_unit = _this select 0;
						
						if (isPlayer _unit) then
						{
							 [[0,{unassignVehicle player; player action ["eject", vehicle player];}], "MCC_fnc_globalExecute", _unit, false] call BIS_fnc_MP;
						};
						
						unassignVehicle _unit;
						_unit action ["eject", vehicle _unit];
					};
					
				sleep ( 1 + ((random 6)/10) );
			} foreach _cargoUnits;
		};
		
		case 4:			//Smoke signal
		{
			_heli globalChat "Waiting for smoke signal to land";
			_nearSmokes = []; 
			while {(count _nearSmokes < 1)} do 
			{
				_nearSmokes = (getPos _heli) nearObjects ["SmokeShell", 300];
				sleep 1;
				if (!(alive _pilot) || (damage _heli >= 0.5)) exitWith {};
			};
			
			_endpos = getpos(_nearSmokes select 0);
			_distance = [_heli, _endpos] call BIS_fnc_distance2D;
			
			while {_distance>5} do 
			{
				if (!(alive _pilot) || (damage _heli >= 0.5)) exitWith {};
				_relDirHor = [getpos _heli, _endpos] call BIS_fnc_DirTo;
				_heli setDir _relDirHor;
				_velocityX = ((_endpos select 0) - ((getPosASL _heli) select 0)) / 4;
				_velocityY = ((_endpos select 1) - ((getPosASL _heli) select 1)) / 4;
				_heli setVelocity [_velocityX,_velocityY,0];
				_distance = [_heli, _endpos] call BIS_fnc_distance2D;
				sleep 0.2;
			};
			
			_heli setVelocity [0,0,0];
			_heli flyinHeight 2;
		};
		
		case 5:			//Fast-rope
		{
			private ["_rope","_actualRopes","_ropes","_zc"];
			_actualRopes = []; 
			
			switch (typeOf _heli) do
			{
				case "B_Heli_Light_01_F":
				{
					_ropes = [[0.6,0.5,-25.9],[-0.8,0.5,-25.9]];
				}; 
				
				case "B_Heli_Transport_01_F":
				{
					_ropes = [[-1.11,2.5,-24.7],[1.11,2.5,-24.7]];
				};
				
				case "I_Heli_Transport_02_F":
				{
					_ropes = [[1,-5,-26],[-1,-5,-26]];
				};
				
				case "O_Heli_Attack_02_F":
				{
					_ropes = [[1.35,1.35,-24.95],[-1.45,1.35,-24.95]];
				};
				
				case "O_Heli_Light_02_F":
				{
					_ropes = [[1.3,1.3,-25],[-1.3,1.3,-25]];
				};
				
				case "I_Heli_light_03_F":
				{
					_ropes = [[1.3,1.3,-25],[-1.3,1.3,-25]];
				};
				
				case "I_Heli_light_03_unarmed_F":
				{
					_ropes = [[1.3,1.3,-25],[-1.3,1.3,-25]];
				};
				
				default 
				{
					_ropes = [[1.3,1.3,-25],[-1.3,1.3,-25]];
				};
			};
			
			_distance = [_heli, _pos] call BIS_fnc_distance2D;
			while {_distance>5 && (alive _heli) && (canMove _heli) && (alive _pilot) && (damage _heli < 0.5)} do 
			{
				_relDirHor = [getpos _heli, _pos] call BIS_fnc_DirTo;
				_heli setDir _relDirHor;
				_velocityX = ((_pos select 0) - ((getPosASL _heli) select 0)) / 4;
				_velocityY = ((_pos select 1) - ((getPosASL _heli) select 1)) / 4;
				_heli setVelocity [_velocityX,_velocityY,0];
				_distance = [_heli, _pos] call BIS_fnc_distance2D;
				sleep 0.2;
			};
			
			_heli setVelocity [0,0,0];
			sleep 1; 
			_heli flyInHeight 35;
			sleep 4;		
			_heli globalChat "Golf 1 in position, get ready for fast rope";
			waitUntil { sleep 1; ( (abs(speed _heli) < 0.5) && ((getPos _heli select 2) < 40) ) || !alive _heli || !alive (driver _heli)};
			if (!alive _heli) exitWith {}; 
			
			{	
				_rope = createVehicle ["land_rope_f", [0,0,0], [], 0, "CAN_COLLIDE"];
				sleep 0.3;
				_rope allowDamage false;
				_rope disableCollisionWith _heli;
				_actualRopes set [count _actualRopes, _rope];
				_rope setdir (getdir _heli);
				_rope attachto [_heli, _x];

				sleep 0.5;
			} forEach _ropes;
			
			sleep 1+ random 2; 
			

			{					
				_rope = _actualRopes select (_forEachIndex % 2);
				
				[_x, _rope] spawn 
					{
						private ["_unit", "_zc", "_zdelta", "_rope","_timeOut","_attachPoint","_time"];
						_unit = _this select 0;
						_rope = _this select 1;
						_zdelta = 7 / 10;
						_zc = 22;
						
						if (isPlayer _unit && isMultiplayer) then
						{
							 [[2,{unassignVehicle player; player action ["eject", vehicle player];player switchmove "AdvePercMstpSnonWrflDnon_goup";}], "MCC_fnc_globalExecute", _unit, false] call BIS_fnc_MP;
						}
						else
						{
							unassignVehicle _unit;
							_unit action ["eject", vehicle _unit];
							_unit switchmove "AdvePercMstpSnonWrflDnon_goup";
						};						
						
						_time = time + 5; 
						waituntil {(vehicle _unit == _unit) || _time < time};
						if (_time < time) exitWith {}; 
						//gunner_standup01
						
						_unit setpos [(getpos _unit select 0), (getpos _unit select 1), 0 max ((getpos _unit select 2) - 3)];
						
						while { (alive _unit) && ( (getpos _unit select 2) > 1 ) && ( _zc > -24 ) } do 
						{
							_unit attachTo [_rope, [0,0,_zc]];
							_zc = _zc - _zdelta;
							sleep 0.1;
						};
						
						if (isPlayer _unit && isMultiplayer) then
						{
							 [[2,{ player switchmove ""; detach player;}], "MCC_fnc_globalExecute", _unit, false] call BIS_fnc_MP;
						}
						else
						{
							_unit switchmove "";
							detach _unit;
						};
					};
					
				sleep ( 1 + ((random 6)/10) );
			} foreach _cargoUnits;
			
			//make sure all AI cargo has left the chopper - give 4 seconds for last unit to slide down the rope
			_timeOut = time + 10; 
			waitUntil { sleep 1; (count (assignedCargo _heli) == 0) || (time > _timeOut)  || (!alive _heli) || (!alive (driver _heli))};		
			sleep 3;
			
			// drop the ropes and delete them
			{
				_attachPoint = _ropes select _forEachIndex;
				_zc = -22;
				while { _zc > -50 } do 
				{
					_x attachTo [_heli, [_attachPoint select 0 , _attachPoint select 1,_zc]];
					_zc = _zc - 2;
					sleep 0.1;
				};
				deletevehicle _x;
			} foreach _actualRopes;
		};
	};
	
	//Do we have return trip
	if (count _cargoUnits > 0) then
	{
		_timeOut = time + 20;
		waitUntil { sleep 1; (count (assignedCargo _heli) == 0) || (time > _timeOut)  || (!alive _heli) || (!alive (driver _heli))};
		if ((count (assignedCargo _heli) == 0) && (!isnil "_startPos")) then
		{
			[[[_startPos], _height, 1, [netid _heli,_heli]],"MCC_fnc_evacMove",_heli,false] spawn BIS_fnc_MP;
		}; 
	};
};