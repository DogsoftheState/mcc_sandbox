// let the unit settle
sleep (random 3);
_t = time;

/*
if (isNil ("alertdebug")) then
{
	alertdebug = [] execVM "Garrison_fncs\alerted_debug.sqf";
};
*/

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// run as  nul = [unit,radius,stationary (bool),capacityarray (  [(0 - 100),max in one building] default [60,0]  ),warping (bool),allUseCQC_AI (including non Garrisoned units) (bool)] execVM "Garrison_script.sqf"	
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

private ["_unit","_radius","_buildingslist","_cnt","_posarray","_build","_i","_nbuild","_localbuilding","_buildpos","_group","_buildingsleft","_npos","_bposleft"];

_unit = leader (_this select 0);
_radius = _this select 1;
_patrolRadius = _radius; if (_patrolRadius < 30) then {_patrolRadius = 30};
_stationary = _this select 2;

_capacityarray = _this select 3; if (isNil("_capacityarray")) then {_capacityarray = [60,0];};

if ((count _capacityarray) == 0) then {_capacityarray = [60,0];};

_capacity = _capacityarray select 0;
_maxcap = _capacityarray select 1;

_warping = _this select 4; if (isNil("_warping")) then {_warping  = false;};

_allUseCQC_AI = _this select 5; if (isNil("_allUseCQC_AI")) then {_allUseCQC_AI  = true};
missionNameSpace getVariable ["allUseCQC_AI",_allUseCQC_AI];

_group = group _unit;
_waypointNo = currentWaypoint _group;
_group setVariable ["GarrisonWPNo",_waypointNo];
_group setVariable ["Garrisoning",true];
_group setvariable ["defending",_stationary];
_groupUnits = units _group;

nul = [_group,_groupUnits] execVM "Garrison_fncs\leaving_check.sqf"; // leaving check;

{
	if (isPlayer _x) then
	{
		_groupUnits = _groupUnits - [_x];
	};
}foreach _groupUnits;
_side = side _unit;

missionnamespace setvariable [format ["group1%1",name _unit],createGroup _side];
_patrolgroup = missionnamespace getvariable (format ["group1%1",name _unit]);

_objectslist = nearestObjects [_unit,["House"],_radius];
_buildingslist = [];
_buildingsleft = [];

//define functions hint


if (isnil("fnc_vision_check")) then {
	fnc_vision_check = compile preProcessFileLineNumbers "Garrison_fncs\fnc_vision_check.sqf";
	//hint "fnc_vision_check compiled";
};

if (isnil("fnc_MoveTo")) then {
	// [_unit,_pos];
	fnc_MoveTo = compile preProcessFileLineNumbers "Garrison_fncs\fnc_MoveTo.sqf";
};

if (isnil("fnc_Patrol")) then {
	// [_leader,_patrolCenter,_patrolRadius,_bRepeating (after contact)];
	fnc_Patrol = compile preProcessFileLineNumbers "Garrison_fncs\patrol.sqf";
};

if (isnil("fnc_Prone_Limit")) then {
	// [_leader,_patrolCenter,_patrolRadius,_bRepeating (after contact)];
	fnc_Prone_Limit = compile preProcessFileLineNumbers "Garrison_fncs\fnc_Prone_Limit.sqf";
};

if (isnil("fnc_smartlook")) then {
	fnc_smartlook = compile preProcessFileLineNumbers "Garrison_fncs\fnc_smartlook.sqf";
	//hint "smartlook compiled";
};

if (isnil("fnc_seek")) then {
	fnc_seek= compile preProcessFileLineNumbers "Garrison_fncs\fnc_seek.sqf";
	//hint "seek compiled";
};

if (isnil("fnc_get_angle")) then {
	fnc_get_angle = compile preProcessFileLineNumbers "Garrison_fncs\fnc_get_angle.sqf";
	//hint "get_angle compiled";
};

if (isnil("fnc_cansee")) then {
	fnc_cansee = compile preProcessFileLineNumbers "Garrison_fncs\fnc_cansee.sqf";
	//hint "cansee compiled";
};

if (isnil("fnc_get_DoorPositions")) then {
	// [_house]; returns doorpositionsin model coords;
	fnc_get_DoorPositions = compile preProcessFileLineNumbers "Garrison_fncs\fnc_get_DoorPositions.sqf";
};

// rework due to redundant code


if (isnil("fnc_willsee")) then {
	fnc_willsee = compile preProcessFileLineNumbers "Garrison_fncs\fnc_willsee.sqf";
	//hint "willsee compiled";
};


if (isnil("fnc_willwalk")) then {
	fnc_willwalk = compile preProcessFileLineNumbers "Garrison_fncs\fnc_willwalk.sqf";
	//hint "willwalk compiled";
};

if (isnil("fnc_indoors")) then {
	fnc_indoors = compile preProcessFileLineNumbers "Garrison_fncs\fnc_indoors.sqf";
	//hint "indoors compiled";
};

if (isnil("fnc_sillybuild_check")) then {
	fnc_sillybuild_check = compile preProcessFileLineNumbers "Garrison_fncs\fnc_sillybuild_check.sqf";
	//hint "sillybuild check compiled";
};
/*
if (isnil("fnc_cqc_target")) then {
	fnc_cqc_target = compile preProcessFileLineNumbers "Garrison_fncs\fnc_cqc_target.sqf";
	//hint "cqc target compiled";
};
*/
if (isnil("CQC_AI")) then {
	// [_unit]
	CQC_AI = compile preProcessFileLineNumbers "CQC_AI.sqf";
	//hint "CQC_AI compiled";
};


// make them aware;

{	
	_CQC_AI_Active = _x getVariable ["CQC_AI_Active",false];
	
	if (!_CQC_AI_Active) then
	{
		nul = [_x] spawn fnc_vision_check;
		nul = [_x] spawn CQC_AI;
	};
} foreach allunits;


// make sure they remeber where they come from

{
	_x setVariable ["GarrisonGroup",_group];
} foreach _groupUnits;

// Populate the building list with occupiable buildings

sleep 3;

if ((count _objectslist) >= 1) then 
{
	for "_i" from 0 to ((count _objectslist)-1) do 
	{
		 _build = _objectslist select _i;
		 
		if (format ["%1",_build buildingPos 0] != "[0,0,0]") then 
		{
			_buildingslist set [count _buildingslist,_build];
		}; 
	};

	{
		_occupied = _x getvariable ["occupied",false];

		if (!(_occupied)) then 
		{
			_buildingsleft set [count _buildingsleft,_x];		
		};
	} foreach _buildingslist;

// make group enter random building and occupy the positions

// building randomly selected and array of positions generated

	if ((count _buildingsleft) >= 1) then 
	{
	 	_nbuild	= floor (random (count _buildingsleft));
		_localbuilding = _buildingsleft select _nbuild;
		_localbuilding setvariable ["occupied",true];
		_localbuilding setvariable ["doorPositions",([_localbuilding] call fnc_get_DoorPositions)]; 

		// Check if building is in array of predefined buildings that i know have issues. if so manaully set the positions to be used.

		_sillyarray = [_localbuilding] call fnc_sillybuild_check;
		_issilly = _sillyarray select 0;
		
		if (_issilly) then 
		{
			_bposleft = _sillyarray select 1;
		} 
		else 
		{
			_bposleft = [];
			_pcnt = 0;
			
		 	while {format ["%1", _localbuilding buildingPos (_pcnt)] != "[0,0,0]" } do 
			{
		 		_bposleft set [count _bposleft, (_pcnt)];
		 		_pcnt = _pcnt + 1;
		 	};
		};
		
		// adjust positions for requested capacity as per _capacity var
		_totalPositions = count _bposleft;
		_limitedPositions = ceil ((_totalPositions / 100) * _capacity);
		if (_limitedPositions < 1) then {
			_limitedPositions = 1;
		};
		
		//Handle for a fixed limit in the capacityarray
		if (_maxcap != 0) then {
			if (_limitedPositions > _maxcap) then {
				_limitedPositions = _maxcap;
			};
		};
		
		While {(count _bposleft) > _limitedPositions} do {	
			_rnum = floor (random (count _bposleft));
			_bposleft set [_rnum,-1];
			_bposleft = _bposleft - [-1];
		};
		
		//hint (str(_limitedPositions));

// units select a position and go, if building fills up a new building is selected and then populated.
// moveTO doesn't seem to work without a do stop and sleep of 0.01 :s

		{
			if ((count _bposleft) >= 1) then 
			{
				// select random position
				_buildpos = _bposleft select (floor (random (count _bposleft)));
				_bposleft = _bposleft - [_buildpos];
				
				_poscoords = (_localbuilding buildingPos _buildpos);
				
				// assign the selected position to the units "homepos" variable so it remembers where he's meant to be
				_x setvariable ["homepos",_buildpos];
				_x setvariable ["homebuild",_localbuilding];

				nul = [_x,_poscoords,_patrolgroup,_stationary,_warping] spawn {
					// Check that unit gets where he's trying to get to. if he doesn't after trying 4 times, joinsilent the patrol group
					private ["_unit","_dpos","_dist","_ball","_roof","_cnt","_patrolgroup","_house","_angle","_outdir","_warping"];

					_unit = _this select 0;
					_dpos = _this select 1;
					_patrolgroup = _this select 2;
					_staying = _this select 3;
					_warping = _this select 4;
					_group = group _unit;
					
					// moveTo or jump to position depending on if warping is true or false;
					_moveComplete = false;
					if (_warping) then 
					{	
						_unit setPos _dpos;
						_moveComplete = true;
					} else {
						_moveComplete = [_unit,_dpos] call fnc_MoveTo;
					};
							
					if (!_moveComplete) exitwith {[_unit] joinsilent _patrolgroup;};

					// if the unit is in position check the units height and whether or not he is indoors.
					if (_moveComplete) then 
					{
						_indoors = [_unit] call fnc_indoors;
						_uh = (getposATL _unit) select 2;
						// if he's not indoors and he is over 1 meter from the ground, crouch. if crouching makes him blind (from a wall) he will stand back up.
						if ((!(_indoors)) && (_uh > 1)) then 
						{

							_unit setunitpos "Middle";
							sleep 2; 
							if (!([_unit] call fnc_cansee)) then {_unit setunitpos "auto"};
							// check to make sure that when he is inside or on the ground again he stops crouching.
							nul = [_unit] spawn {

								_unit = _this select 0;

								while {sleep 2;alive _unit} do 
								{	
									_indoors = [_unit] call fnc_indoors;
									_uh = (getposATL _unit) select 2;

									if ((_indoors) or (_uh < 2)) exitwith {_unit setunitpos "AUTO";};
								};

							}; 

						};

						_group setCombatMode "YELLOW";
						
						if (_indoors) then {
							_unit setvariable ["indoors",true];
							
							nul = [_unit] spawn fnc_Prone_Limit;
							
							_unit forcespeed 0;
							_unit setvariable ["forcedspeed",0];

						};

						if (_staying) then {
							//_group setCombatMode "GREEN";
							_unit disableAI "TARGET";
							_unit disableAI "AUTOTARGET";
							_unit disableAI "FSM";
							_unit allowfleeing 0;
						};
						// make them randomly look around and move within the building.
						nul = [_unit] spawn fnc_smartlook;

					};	
				
				};

			} else {

		// remove building details of current select building from list of possible buildings 

				_buildingsleft = _buildingsleft - [_localbuilding];

				sleep 0.1;
				
				{
					_occupied = _x getvariable ["occupied",false];

					if (_occupied) then {
				
						_buildingsleft = _buildingsleft - [_x];		
		
					};
			
				} foreach _buildingslist;

			// building randomly selected and array of positions generated

				if ((count _buildingsleft) >= 1) then {

					_nbuild	= floor (random (count _buildingsleft));
					_localbuilding = _buildingsleft select _nbuild;
					_localbuilding setvariable ["occupied",true];

			// Check if building is in array of predefined buildings that i know have issues. if so manaully set the positions to be used.

					_sillyarray = [_localbuilding] call fnc_sillybuild_check;
					_issilly = _sillyarray select 0;
					if (_issilly) then {

						_bposleft = _sillyarray select 1;

					} else {


						_bposleft = [];

						_pcnt = 0;		 
		 
						while {format ["%1", _localbuilding buildingPos (_pcnt)] != "[0,0,0]" } do {

							_bposleft set [count _bposleft, (_pcnt)];
							_pcnt = _pcnt + 1;

						};

					};
					
					// adjust positions for requested capacity as per _capacity var
					_totalPositions = count _bposleft;
					_limitedPositions = ceil ((_totalPositions / 100) * _capacity);
					if (_limitedPositions < 1) then {
						_limitedPositions = 1;
					};
			
					//Handle for a fixed limit in the c_apacityarray
					if (_maxcap != 0) then {
						if (_limitedPositions > _maxcap) then {
							_limitedPositions = _maxcap;
						};
					};
			
					While {(count _bposleft) > _limitedPositions} do {
						_rnum = floor (random (count _bposleft));
						_bposleft set [_rnum,-1];
						_bposleft = _bposleft - [-1];
					};
					
					//hint (str(_limitedPositions));

					if ((count _bposleft) >= 1) then 
					{
					
						_buildpos = _bposleft select (floor (random (count _bposleft)));
						
						_bposleft = _bposleft - [_buildpos];
						
						_poscoords = (_localbuilding buildingPos _buildpos);
						_x setvariable ["homepos",_buildpos];
						_x setvariable ["homebuild",_localbuilding];
						
						nul = [_x,_poscoords,_patrolgroup,_stationary,_warping] spawn {

							private ["_unit","_dpos","_dist","_ball","_roof","_cnt","_patrolgroup","_housecenter"];

							_unit = _this select 0;
							_dpos = _this select 1;
							_patrolgroup = _this select 2;
							_staying = _this select 3;
							_warping = _this select 4;
							_group = group _unit;

							// moveTo or jump to position depending on if warping is true or false
							_moveComplete = false;
							if (_warping) then 
							{	
								_unit setPos _dpos;
								_moveComplete = true;
							} else {
								_moveComplete = [_unit,_dpos] call fnc_MoveTo;
							};
									
							if (!_moveComplete) exitwith {[_unit] joinsilent _patrolgroup;};
					
							if (_moveComplete) then 
							{

								_indoors = [_unit] call fnc_indoors;
								_uh = (getposATL _unit) select 2;

								if ((!(_indoors)) && (_uh > 1)) then 
								{
									_unit setunitpos "Middle";
									sleep 2; 
									if (!([_unit] call fnc_cansee)) then {_unit setunitpos "auto"};

									nul = [_unit] spawn {

										_unit = _this select 0;
										
										while {sleep 3;alive _unit} do {
							
											_indoors = [_unit] call fnc_indoors;
											_uh = (getposATL _unit) select 2;

											if ((_indoors) or (_uh < 2)) exitwith {_unit setunitpos "AUTO";};
										};
									};
								};
						
								_group setCombatMode "YELLOW";
								
								if (_indoors) then 
								{
									_unit setvariable ["indoors",true];
									
									nul = [_unit] spawn fnc_Prone_Limit;
									_unit forcespeed 0;
									_unit setvariable ["forcedspeed",0];
								};

								if (_staying) then 
								{
									//_group setCombatMode "GREEN";
									_unit disableAI "TARGET";
									_unit disableAI "AUTOTARGET";
									_unit disableAI "FSM";
									_unit allowfleeing 0;
								};

								nul = [_unit] spawn fnc_smartlook;
							};	
						};
					} 
					else 
					{
						_buildingsleft = _buildingsleft - [_localbuilding];

						[_x] joinsilent _patrolgroup;
					};	
				} 
				else 
				{
					[_x] joinsilent _patrolgroup;
				};
			};
		} foreach _groupUnits;
	} 
	else 
	{
		_groupPlaceHolder = "B_Soldier_02_f" createunit [[0,0,0],_group];
		{
			[_x] joinsilent _patrolgroup
		} foreach _groupUnits;
	};

} 
else 
{
	_groupPlaceHolder = "B_Soldier_02_f" createunit [[0,0,0],_group];
	{
		[_x] joinsilent _patrolgroup
	} foreach _groupUnits;
};

// debug for building positions;
/*
_posarray = [];

{

	_posarray set [count _posarray,_x getvariable ["homepos","none"]];

}foreach _groupUnits;

//hint (str(_possarray));
*/
/*
hint (str(time - _t));
sleep 2;
*/

_generateCenter = 
{
	_lPos = getPosATL _unit;
	_lPos set [0,((_lPos select 0) + 5)];
	_patrolCenter = _lPos;
};

_t = time;

waituntil {((count units _patrolgroup) > 0) or ((time - _t) > 240)};

if ((count units _patrolgroup) > 0) then 
{
	_patrolCenter = [];
	if ((leader _patrolgroup) != _unit) then
	{
		_build = (nearestobjects [(getposATL (leader _patrolgroup)),["house"],(_radius * 2)] select 0);
		if (isNil("_build")) then 
		{
			call _generateCenter;
		}
		else
		{
			_patrolCenter = getposATL _build;
		};
	}
	else
	{
		call _generateCenter;
	};

	nul = [leader _patrolgroup,_patrolCenter,_patrolRadius,true] spawn fnc_Patrol;

	_t = time;
	_gnumber = 2;

	while {sleep 1;true} do 
	{
		waituntil {((count units _patrolgroup) > 4) or ((time - _t) > 120)};
	
		if ((count units _patrolgroup) > 4) then 
		{
			_allunits = units _patrolgroup;
			_gunits = [];

			for "_i" from 1 to 4 do 
			{
				_gunit = _allunits select _i;
				_gunits set [(count _gunits),_gunit];
			};

			missionnamespace setvariable [format ["group%1%2",_gnumber,name _unit],createGroup _side];
			_newgroup = missionnamespace getvariable (format ["group%1%2",_gnumber,name _unit]);

			_gnumber = _gnumber + 1;

			_gunits join _newgroup;	
	
			nul = [leader _newgroup,_patrolCenter,_patrolRadius,true] spawn fnc_Patrol;
		};
	};
};
