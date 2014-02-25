#define A 10
#define B 11
#define C 12
#define D 13
#define E 14
#define F 15

#define armaColor 	(1/255)
#define maxRange 	255

fnc_armaColor_to_RGB = {
//--- arma R G B value as params
	_Red 	= _this select 0;
	_Green 	= _this select 1;
	_Blue 	= _this select 2;
//--- Convert
	_R 		= round (_Red	/armaColor);
	_G 		= round (_Green	/armaColor);
	_B 		= round (_Blue	/armaColor);
//--- to return
_RGB = [_R, _G, _B];
//--- return
_RGB
};

fnc_RGB_to_armaColor = {
private ["_ArmaColor","_Red","_Blue","_Green"];
//--- RGB value as params
	_Red 	= _this select 0;
	_Green 	= _this select 1;
	_Blue 	= _this select 2;
//--- Convert
	_R 		= _Red	/255;
	_G 		= _Green	/255;
	_B 		= _Blue	/255;
//--- to return
_ArmaColor	= [_R, _G, _B];
//--- return
_ArmaColor
};

fnc_RGB_to_HEX ={
private ["_Value","_Red","_Blue","_Green","_hexaString"];
//--- RGB value as params
	_Red 	= _this select 0;
	_Green 	= _this select 1;
	_Blue 	= _this select 2;
//--- Converting
_hexaString = "#";
	{
		_Value = _x;
		_SValue = _value%16;
		_FValue =  _value - _SValue;
		_FValue =	_FValue /16;
		_FValue = [_FValue] call fnc_format_HEX;
		_SValue = [_SValue] call fnc_format_HEX;
		_hexaString= _hexaString +_FValue;
		_hexaString= _hexaString +_SValue;
	}forEach [_Red, _Green,_Blue];
_hexaString
};

fnc_HEX_to_RGB={

_Hexa = toArray(_this select 0);
_Hexa set [0 , -1];
_Hexa = _Hexa - [-1];
_RED 	= [_Hexa select 0,_Hexa select 1];
_GREEN 	= [_Hexa select 2,_Hexa select 3];
_BLUE 	= [_Hexa select 4,_Hexa select 5];

_RED 	= [_RED] 	call fnc_format_RGB;
_GREEN 	= [_GREEN] 	call fnc_format_RGB;
_BLUE 	= [_BLUE] 	call fnc_format_RGB;
_RGB 	= [_RED,_GREEN,_BLUE ];
_RGB
};

fnc_format_HEX ={
private ["_valueFormatted"];
_valueFormatted="";
	_value = _this select 0;

	switch (_value) do
	{
	    case 0:{_valueFormatted = "0";};
	    case 1:{_valueFormatted = "1";};
		case 2:{_valueFormatted = "2";};
		case 3:{_valueFormatted = "3";};
		case 4:{_valueFormatted = "4";};
		case 5:{_valueFormatted = "5";};
		case 6:{_valueFormatted = "6";};
		case 7:{_valueFormatted = "7";};
		case 8:{_valueFormatted = "8";};
		case 9:{_valueFormatted = "9";};
		case A:{_valueFormatted = "A";};
		case B:{_valueFormatted = "B";};
		case C:{_valueFormatted = "C";};
		case D:{_valueFormatted = "D";};
		case E:{_valueFormatted = "E";};
		case F:{_valueFormatted = "F";};
	    default{_valueFormatted = "G";};
	};
_valueFormatted
};
fnc_format_RGB={
_value = _this select 0;
_Color = [];
{
	switch(_x)do{
			case 48 :{_Color set [ count _Color, 0];};	
			case 49 :{_Color set [ count _Color, 1];};	
			case 50 :{_Color set [ count _Color, 2];}; 	
			case 51 :{_Color set [ count _Color, 3];};
			case 52 :{_Color set [ count _Color, 4];};
			case 53 :{_Color set [ count _Color, 5];};
			case 54 :{_Color set [ count _Color, 6];};
			case 55 :{_Color set [ count _Color, 7];};
			case 56 :{_Color set [ count _Color, 8];};
			case 57 :{_Color set [ count _Color, 9];};
			case 65 :{_Color set [ count _Color, 10];};
			case 66 :{_Color set [ count _Color, 11];};
			case 67 :{_Color set [ count _Color, 12];};
			case 68 :{_Color set [ count _Color, 13];};
			case 69 :{_Color set [ count _Color, 14];};
			case 70 :{_Color set [ count _Color, 15];};
		};
}foreach _value;
_ColorValue = (_Color select 0) + ((_Color select 1)*16);
_ColorValue
};