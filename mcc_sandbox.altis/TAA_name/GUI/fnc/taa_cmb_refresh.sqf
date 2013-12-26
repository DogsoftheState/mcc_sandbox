_CURSEL = lbText [2101, lbCurSel 2101];
_RGB = [];
if(_CURSEL == "Ennemy tags")then{ _RGB = [TAA_name_HUD_color_ennemy] call fnc_HEX_to_RGB; };
if(_CURSEL=="Friendly tags")then{ _RGB = [TAA_name_HUD_color_side] call fnc_HEX_to_RGB;};
if(_CURSEL=="Friendly squad tags")then{ _RGB = [TAA_name_HUD_color_squad] call fnc_HEX_to_RGB;};

 sliderSetPosition [1901, (_RGB select 0)];
 sliderSetPosition [1903, (_RGB select 2)];
 sliderSetPosition [1902, (_RGB select 1)];
[] execVM 'TAA_name\GUI\fnc\taa_color_value.sqf';