sliderSetRange [1900, 0, TAA_name_HUD_distance_max];
sliderSetPosition [1900, TAA_name_HUD_distance];
{ lbAdd [2100,_x];}forEach ["On","Off"];
if(TAA_name_HUD_available)then{lbSetCurSel[2100,0];}else{lbSetCurSel[2100,1];};
{sliderSetRange [_x, 0, 255];}forEach[1901,1903,1902];
if(TAA_name_HUD_Display_ennemy)then{ lbAdd [2101,"Ennemy tags"];};
if(TAA_name_HUD_AIDisplayName||TAA_name_HUD_PlayerDisplayName)then{ lbAdd [2101,"Friendly tags"];};
if(TAA_name_HUD_PlayerDisplayName||TAA_name_HUD_AIDisplayName)then{ lbAdd [2101,"Friendly squad tags"];};
lbSetCurSel[2101,0];
