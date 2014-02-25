_index	=0;
lbClear 1500;
if (isMultiplayer) then {
	{
		if(side _x == playerSide)then{
			_index = _index +1;	
			lbAdd[1500,name _x];
			if(!isNil{ _x getVariable "TAA_TAG_PLAYER_CUSTOM"})then{
			_RGB = [_x getVariable "TAA_TAG_PLAYER_CUSTOM"] call fnc_HEX_to_RGB;
			_colorarma= _RGB call fnc_RGB_to_armaColor;
			_colorarma set [3,1];
				lbSetColor[1500,lbSize 1500-1,_colorarma]; 
			};
		};
	}foreach playableUnits;
}else{
	{
		if(side _x == playerSide)then{
			_index = _index +1;
			lbAdd[1500,name _x];
			if(!isNil{ _x getVariable "TAA_TAG_PLAYER_CUSTOM"})then{
				_RGB = [_x getVariable "TAA_TAG_PLAYER_CUSTOM"] call fnc_HEX_to_RGB;
				_colorarma= _RGB call fnc_RGB_to_armaColor;
				_colorarma set [3, 1];
				lbSetColor[1500,lbSize 1500-1,_colorarma]; 
			};
		};
	}foreach allUnits;
};
sliderSetRange[1900,0,255];
sliderSetRange[1901,0,255];
sliderSetRange[1902,0,255];