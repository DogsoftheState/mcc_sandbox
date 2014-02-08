#define Nux_tvs_Dialog				8560
#define Nux_Tvs_MainFrame_IDC 		8561
#define Nux_Tvs_Mousearea_IDC 		8562
#define Nux_Tvs_Optics_IDC 			8563
#define Nux_Tvs_Crosshair_IDC		8564
#define Nux_Tvs_Flirstate_IDC		8565
#define Nux_Tvs_Missilespeed_IDC	8566
#define Nux_Tvs_Missilealt_IDC		8567
#define Nux_Tvs_Missiledir_IDC		8568
#define Nux_Tvs_compass_N_IDC		8569
#define Nux_Tvs_compass_E_IDC		8570
#define Nux_Tvs_compass_S_IDC		8571
#define Nux_Tvs_compass_W_IDC		8572
#define Nux_Tvs_Angbar_IDC			8573
#define Nux_Tvs_Angbarmarker_IDC	8574
#define	Nux_Tvs_Compass_radius 0.2
#define	Nux_Tvs_Compass_line_radius 0.2
#define	Nux_Tvs_Compass_conpi (4 * atan(1) / 180)
#define Nux_Tvs_AngelbarcenterX 0.78 + (0.0025)
#define Nux_Tvs_AngelbarcenterY 0.5 - (0.02 / 2)	// 0.49 // difference to top .0.246. same to bottom. "range 0.492"

Nux_fnc_tvs_start = {
	private ["_unit", "_weapon", "_missile", "_validammo"];
	_unit = vehicle (_this select 0);
	_weapon = _this select 1;
	_missile = _this select 6;
	_validammo = _unit getvariable "Nux_tvs_ammo";
	
	// just exit if its not a valid weapon.
	if ((_weapon == "CMFlareLauncher") or (_unit getvariable "Nux_tvs_onf" == 0) or (typeof(_missile) != _validammo)) exitwith {};

	// prevent the plane/heli from crashing while in missile cam.
	if (_unit isKindOf "Plane") then {_unit action ["LAND",_unit];}else{if (_unit isKindOf "Helicopter") then {_unit action ["AutoHover",_unit];};};

	createDialog "Nux_Dlg_Tvs";
	waituntil{(dialog)};
	
	// center the mouse cursor
	setMousePosition [0.5,0.5];

	// Switch to the missile.
	_missile switchCamera "Internal";	
	
	// set the state of thermal info..
	_thermalmode = "Flir:off";
	switch (_unit getvariable "Nux_tvs_thermal") do {
		case 0 : {false setCamUseTi 0;_thermalmode = "Flir:off";};
		case 1 : {true setCamUseTi 0;_thermalmode = "Flir:m0";};
		case 2 : {true setCamUseTi 1;_thermalmode = "Flir:m1";};
		case 3 : {true setCamUseTi 2;_thermalmode = "Flir:m2";};
		case 4 : {true setCamUseTi 3;_thermalmode = "Flir:m3";};
	};
	((uiNamespace getVariable 'Nux_Tvs_Display') displayCtrl Nux_Tvs_Flirstate_IDC) ctrlSetText format["%1",_thermalmode];
	((uiNamespace getVariable 'Nux_Tvs_Display') displayCtrl Nux_Tvs_Flirstate_IDC) ctrlCommit 0;			
	
	_missile spawn Nux_fnc_tvs_compass;
	[_unit, _weapon, _missile] spawn Nux_fnc_tvs_misislecontrol;

};

// change thermal mode. 
Nux_fnc_tvs_keypress = {
	private ["_state","_thermalmode"];
	switch (_this select 1) do
	{
		// exit missile camera
		case 1:	{closeDialog 0;};
		// F , toggle through thermal modes.
		case 33:
		{
			_state = vehicle player getvariable "Nux_tvs_thermal";
			_state = _state + 1;
			if (_state > 4) then {_state = 0;};
			vehicle player setvariable ["Nux_tvs_thermal", _state];
			_thermalmode = "Flir:off";
			switch (_state) do {
				case 0 : {false setCamUseTi 0;_thermalmode = "Flir:off";};
				case 1 : {true setCamUseTi 0;_thermalmode = "Flir:m0";};
				case 2 : {true setCamUseTi 1;_thermalmode = "Flir:m1";};
				case 3 : {true setCamUseTi 2;_thermalmode = "Flir:m2";};
				case 4 : {true setCamUseTi 3;_thermalmode = "Flir:m3";};
			};
			((uiNamespace getVariable 'Nux_Tvs_Display') displayCtrl Nux_Tvs_Flirstate_IDC) ctrlSetText format["%1",_thermalmode];
			((uiNamespace getVariable 'Nux_Tvs_Display') displayCtrl Nux_Tvs_Flirstate_IDC) ctrlCommit 0;
		};
	};
};

// update compass
Nux_fnc_tvs_compass = {
	private ["_missile","_conx,","_cony","_dir", "_startanglen","_startanglee","_startangles","_startanglew"];
		
	_missile = _this;
	if (isNull _missile) exitwith {};
	_conx = 0.5 - 0.018;
	_cony =  0.5 - 0.018;
	while {((dialog) && (alive _missile))} do
	{
		_dir = (getdir _missile);
		_startanglen = 270 - _dir;
		_startanglee = 360 - _dir;
		_startangles = 90 - _dir;
		_startanglew = 180 - _dir;

		// North
		((uiNamespace getVariable 'Nux_Tvs_Display') displayCtrl Nux_Tvs_compass_N_IDC) ctrlSetPosition [_conx + Nux_Tvs_Compass_radius * cos(_startanglen * Nux_Tvs_Compass_conpi), _cony + Nux_Tvs_Compass_radius * sin(_startanglen * Nux_Tvs_Compass_conpi)];
		((uiNamespace getVariable 'Nux_Tvs_Display') displayCtrl Nux_Tvs_compass_N_IDC) ctrlCommit 0;
		// East
		((uiNamespace getVariable 'Nux_Tvs_Display') displayCtrl Nux_Tvs_compass_E_IDC) ctrlSetPosition [_conx + Nux_Tvs_Compass_radius * cos(_startanglee * Nux_Tvs_Compass_conpi), _cony + Nux_Tvs_Compass_radius * sin(_startanglee * Nux_Tvs_Compass_conpi)];
		((uiNamespace getVariable 'Nux_Tvs_Display') displayCtrl Nux_Tvs_compass_E_IDC) ctrlCommit 0;
		// South
		((uiNamespace getVariable 'Nux_Tvs_Display') displayCtrl Nux_Tvs_compass_S_IDC) ctrlSetPosition [_conx + Nux_Tvs_Compass_radius * cos(_startangles * Nux_Tvs_Compass_conpi), _cony + Nux_Tvs_Compass_radius * sin(_startangles * Nux_Tvs_Compass_conpi)];
		((uiNamespace getVariable 'Nux_Tvs_Display') displayCtrl Nux_Tvs_compass_S_IDC) ctrlCommit 0;
		// West
		((uiNamespace getVariable 'Nux_Tvs_Display') displayCtrl Nux_Tvs_compass_W_IDC) ctrlSetPosition [_conx + Nux_Tvs_Compass_radius * cos(_startanglew * Nux_Tvs_Compass_conpi), _cony + Nux_Tvs_Compass_radius * sin(_startanglew * Nux_Tvs_Compass_conpi)];
		((uiNamespace getVariable 'Nux_Tvs_Display') displayCtrl Nux_Tvs_compass_W_IDC) ctrlCommit 0;
		sleep 0.01;
	};
};

// control the missile by mouse
Nux_fnc_tvs_misislecontrol = {
	private ["_unit","_weapon","_missile","_vink","_pitch","_turn","_dlgchk","_mx","_my"];

	_unit = _this select 0;
	_weapon = _this select 1;
	_missile = _this select 2;
	// get the roll/pitch/dir of the plane/heli onto the bomb
	_vink = -(asin(vectordir _missile select 2));
	_pitch=_vink;
	_turn = getdir vehicle _missile;
	_dlgchk = true;
	while {alive player && alive _missile} do
	{
		if (not dialog) exitwith {_dlgchk = false;};
		_turn = getdir _missile;	
		_mx = Nux_tvs_mousepos select 0;
		_my = Nux_tvs_mousepos select 1;		
		if (_my > 0.75) then { _pitch = _pitch + (_my /2);};
		if (_my < 0.75) then { _pitch = _pitch + (_my - 0.5);};
		if (_pitch >= 89) then {_pitch = 89;};
		if (_pitch <= -89) then {_pitch = -89;};
		_turn = _turn + ((_mx ) - 0.5);
		[_missile,[_turn,-_pitch,0]] call Nux_fnc_setvector;
		//update some ui info.. speed, alt and dir.
		((uiNamespace getVariable 'Nux_Tvs_Display') displayCtrl Nux_Tvs_Missilespeed_IDC) ctrlSetText format["SPD:%1",floor(speed _missile)];
		((uiNamespace getVariable 'Nux_Tvs_Display') displayCtrl Nux_Tvs_Missilespeed_IDC) ctrlCommit 0;
		((uiNamespace getVariable 'Nux_Tvs_Display') displayCtrl Nux_Tvs_Missilealt_IDC) ctrlSetText format["ALT:%1",floor(getposatl _missile select 2)];
		((uiNamespace getVariable 'Nux_Tvs_Display') displayCtrl Nux_Tvs_Missilealt_IDC) ctrlCommit 0;
		((uiNamespace getVariable 'Nux_Tvs_Display') displayCtrl Nux_Tvs_Missiledir_IDC) ctrlSetText format["DIR:%1",floor(_turn)];
		((uiNamespace getVariable 'Nux_Tvs_Display') displayCtrl Nux_Tvs_Missiledir_IDC) ctrlCommit 0;
		((uiNamespace getVariable 'Nux_Tvs_Display') displayCtrl Nux_Tvs_Angbarmarker_IDC) ctrlSetPosition [Nux_Tvs_AngelbarcenterX, (Nux_Tvs_AngelbarcenterY + ((((_pitch / 90) * 100) / 100) * 0.246))];
		((uiNamespace getVariable 'Nux_Tvs_Display') displayCtrl Nux_Tvs_Angbarmarker_IDC) ctrlCommit 0;
		sleep 0.001;
	};
	if (not alive _unit) then {_dlgchk=false; closeDialog Nux_tvs_Dialog;};
	if (_dlgchk) then {closeDialog Nux_tvs_Dialog;1 cuttext ["","black out", 0.0000001];2 cutRsc["RscNoise","PLAIN",0.0001];sleep 1.1;2 cutFadeOut 0;1 cutFadeOut 0;};
	vehicle _unit switchCamera "internal";
	vehicle _unit selectWeapon _weapon;
	if (_unit isKindOf "Plane") then {_unit action ["CancelLand",_unit];}else{if (_unit isKindOf "Helicopter") then {_unit action ["AutoHoverCancel",_unit];};};
};
