if (!isDedicated) then {
	{[_x] call compile preprocessFile ("ais_injury\init_ais.sqf")} forEach allUnits;
	
	//{[_x] call compile preprocessFile ("ais_injury\init_ais.sqf")} forEach (if (isMultiplayer) then {playableUnits} else {switchableUnits});		// execute for every playable unit

	//{[_x] call compile preprocessFile ("ais_injury\init_ais.sqf")} forEach (units group player);													// only own group - you cant help strange group members

	//{[_x] call compile preprocessFile ("ais_injury\init_ais.sqf")} forEach [p1,p2,p3,p4,p5];														// only some defined units
};