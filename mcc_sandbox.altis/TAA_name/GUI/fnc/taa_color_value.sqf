disableSerialization;
_RED 	= ceil sliderPosition 1901;
_GREEN	= ceil sliderPosition 1902;
_BLUE 	= ceil sliderPosition 1903;

_HexColor = [_RED,_GREEN,_BLUE] call fnc_RGB_to_HEX;

_Text =  format["<t color='%1'>Tag color %1</t>",_HexColor];
_display = findDisplay 10000;
_CtrlText = _display displayCtrl 1100;
_CtrlText ctrlSetStructuredText parseText _Text;