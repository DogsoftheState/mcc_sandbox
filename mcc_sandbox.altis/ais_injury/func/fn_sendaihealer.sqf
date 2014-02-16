// by BonInf*
// changed by Psycho, chessmaster42
#define __includedMates (units group _playerdown - [_playerdown])
private ["_playerdown","_closestsquadmate","_min_distance","_distance"];
_playerdown = _this select 0;
_closestsquadmate = if (count _this > 1) then {_this select 1} else {nil};

sleep 5;

//If we got a closest squadmate in the function call but they are dead or in agony, remove them from the check
if (count _this > 1) then {
	if (!alive _closestsquadmate || {_closestsquadmate getVariable "tcb_ais_agony"}) then {
		_closestsquadmate = Nil;
	};
};

//If the closest squadmate was not defined in the function call search through medics
if (isNil "_closestsquadmate") then {
	_closestsquadmate = _playerdown;
	_min_distance = 100000;
	{
		_distance = _playerdown distance _x;
		if (_distance < _min_distance && {!isPlayer _x} && {_x call tcb_fnc_isMedic}) then {
			_min_distance = _distance;
			_closestsquadmate = _x;
		};
	} foreach __includedMates;
};

if (!alive _closestsquadmate || {_closestsquadmate getVariable "tcb_ais_agony"}) then {
	_closestsquadmate = Nil;
};

//If we don't have a closest squadmate go through everyone else in the group and find the closest one
if (isNil "_closestsquadmate") then {
	_closestsquadmate = _playerdown;
	_min_distance = 100000;
	{
		_distance = _playerdown distance _x;
		if (_distance < _min_distance && {!isPlayer _x}) then {
			_min_distance = _distance;
			_closestsquadmate = _x;
		};
	} foreach __includedMates;
};

if (!alive _closestsquadmate || {_closestsquadmate getVariable "tcb_ais_agony"}) then {
	_closestsquadmate = Nil;
};

//Last ditch effort to find someone, somewhere to come help
//This only works if unit is within 500 meters
//TODO - Find a way to improve the speed of this check
if (isNil "_closestsquadmate") then {
	_closestsquadmate = _playerdown;
	_min_distance = 500;
	_playerFaction = side (group _playerdown);
	{
		//Ensure that the group we're checking is on the same side as the injured unit
		if((side _x) == _playerFaction) then {
			{
				_distance = _playerdown distance _x;
				if (_distance < _min_distance && {!isPlayer _x}) then {
					_min_distance = _distance;
					_closestsquadmate = _x;
				};
			} foreach units _x;
		};
	} forEach allGroups;
};

//Main loop to get the closest squadmate to the injured unit
While {alive _playerdown && {_playerdown getVariable "tcb_ais_agony"} && {_closestsquadmate distance _playerdown < 4} && {alive _closestsquadmate} && {!(_closestsquadmate getVariable "tcb_ais_agony")}} do {
	if (currentCommand _closestsquadmate != "MOVE") then {_closestsquadmate Stop false; _closestsquadmate doMove position _playerdown};
	sleep 3;
};

//If the closest squadmate goes down by the time they get to the injured unit, call this function again to calculate a new closest squadmate
if (!alive _closestsquadmate || {_closestsquadmate getVariable "tcb_ais_agony"} || {isNull _closestsquadmate}) then {
	[_playerdown] spawn tcb_fnc_sendaihealer;
};

//If the injured unit is still viable start the first aid
if (alive _playerdown && {_playerdown getVariable "tcb_ais_agony"}) then {
	if (_closestsquadmate != _playerdown && {!(_closestsquadmate getVariable "tcb_ais_agony")}) then {
		[_playerdown, _closestsquadmate] spawn tcb_fnc_firstAid;
	};
};