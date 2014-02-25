disableSerialization;
_RED 	= ceil sliderPosition 1900;
_GREEN	= ceil sliderPosition 1901;
_BLUE 	= ceil sliderPosition 1902;

_HexColor = [_RED,_GREEN,_BLUE] call fnc_RGB_to_HEX;
_CURNAMESEL = lbText [1500, lbCurSel 1500];
if(isNil{_CURNAMESEL})exitWith{};
_Text 		=  format["<t color='%1'>Tag color %1 <br /> %2</t>",_HexColor,_CURNAMESEL];
_display = findDisplay 10001;
_CtrlText = _display displayCtrl 1100;
_CtrlText ctrlSetStructuredText parseText _Text;