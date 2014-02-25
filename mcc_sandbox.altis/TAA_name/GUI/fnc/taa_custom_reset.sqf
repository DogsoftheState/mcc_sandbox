
_RED 	= ceil sliderPosition 1900;
_GREEN	= ceil sliderPosition 1901;
_BLUE 	= ceil sliderPosition 1902;

_HexColor = [_RED,_GREEN,_BLUE] call fnc_RGB_to_HEX;
_CURNAMESEL = lbText [1500, lbCurSel 1500];

if (isMultiplayer)then{
	{
		if(_CURNAMESEL == name _x)then{
			_x setVariable["TAA_TAG_PLAYER_CUSTOM",nil,false];
		};
	}foreach playableUnits;
}else{
	{
		if(_CURNAMESEL == name _x)then{
			_x setVariable["TAA_TAG_PLAYER_CUSTOM",nil,false];

		};
	}foreach allUnits;
};