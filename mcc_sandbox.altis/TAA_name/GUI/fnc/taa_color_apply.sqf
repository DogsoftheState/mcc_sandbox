_RED 	= ceil sliderPosition 1901;
_GREEN	= ceil sliderPosition 1902;
_BLUE 	= ceil sliderPosition 1903;

_HexColor = [_RED,_GREEN,_BLUE] call fnc_RGB_to_HEX;
_CURSEL = lbText [2101, lbCurSel 2101];
switch(_CURSEL)do{
	case "Ennemy tags":
	{
		TAA_name_HUD_color_ennemy=_HexColor;
	};
	case "Friendly tags":
	{
		TAA_name_HUD_color_side = _HexColor;
	};
	case "Friendly squad tags":
	{
		TAA_name_HUD_color_squad = _HexColor;
	};
};