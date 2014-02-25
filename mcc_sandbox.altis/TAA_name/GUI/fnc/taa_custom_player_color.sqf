disableSerialization;
_color = "";
_CURNAMESEL = lbText [1500, lbCurSel 1500];

if (isMultiplayer)then{
	{
		if(_CURNAMESEL == name _x)then{
			_color=_x getVariable "TAA_TAG_PLAYER_CUSTOM";
		};
	}foreach playableUnits;
}else{
	{
		if(_CURNAMESEL == name _x)then{
			_color=_x getVariable "TAA_TAG_PLAYER_CUSTOM";
			
		};
	}foreach allUnits;
};
if(isNil{_color})exitWith{
 sliderSetPosition [1900,0];
 sliderSetPosition [1901, 0];
 sliderSetPosition [1902, 0];
};
_Text 		=  format["<t color='%1'>Tag color %1 <br /> %2</t>",_color,_CURNAMESEL];
_display 	= findDisplay 10001;
_CtrlText 	= _display displayCtrl 1100;
_CtrlText ctrlSetStructuredText parseText _Text;
_RGB = [_color] call fnc_HEX_to_RGB;
 sliderSetPosition [1900, (_RGB select 0)];
 sliderSetPosition [1901, (_RGB select 1)];
 sliderSetPosition [1902, (_RGB select 2)];
