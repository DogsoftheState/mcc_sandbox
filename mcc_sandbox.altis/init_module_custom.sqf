//-----------------------BTC Logistic --------------------------------------------
call compile preprocessFile "=BTC=_Logistic\=BTC=_logistic_Init.sqf";

//--------------------------TcB AIS Wounding System ------------------------------
if (!isDedicated) then {
	TCB_AIS_PATH = "ais_injury\";
	{[_x] call compile preprocessFile (TCB_AIS_PATH+"init_ais.sqf")} forEach AllUnits;
	
	//{[_x] call compile preprocessFile (TCB_AIS_PATH+"init_ais.sqf")} forEach (if (isMultiplayer) then {playableUnits} else {switchableUnits});		// execute for every playable unit

	//{[_x] call compile preprocessFile (TCB_AIS_PATH+"init_ais.sqf")} forEach (units group player);													// only own group - you cant help strange group members

	//{[_x] call compile preprocessFile (TCB_AIS_PATH+"init_ais.sqf")} forEach [p1,p2,p3,p4,p5];														// only some defined units
};

//----------------------TAA Name Tag---------------------------------------------
// Source: http://www.armaholic.com/forums.php?m=posts&q=25214

[] execVM "TAA_name\TAA_name_init.sqf";

//----------------------MB Skillset----------------------------------------------
// Source: http://www.armaholic.com/page.php?id=21320

[] execVM "MB_SkillSet\initMBSkillSet.sqf";

//----------------------Group Manager--------------------------------------------
// Source: ??

[] execVM "group_manager.sqf";

//----------------------Task Force Radio-----------------------------------------
// Source: https://github.com/michail-nikolaev/task-force-arma-3-radio/blob/master/README_EN.md

tf_no_auto_long_range_radio = true;

//tf_same_sw_frequencies_for_side = true;
//tf_freq_west = 31;
//tf_freq_east = 31;
//tf_freq_guer = 31;

//tf_same_lr_frequencies_for_side = true;
//tf_freq_west_lr = 51;
//tf_freq_east_lr = 51;
//tf_freq_guer_lr = 51;