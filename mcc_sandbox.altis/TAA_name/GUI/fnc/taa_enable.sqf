
if((lbCurSel 2100 == 0) && (isNil "HUD_NAME_KEYUP") && (isNil "HUD_NAME_KEYDOWN"))then{
	HUD_NAME_KEYDOWN = (findDisplay 46) displayAddEventHandler ["KeyDown", "[_this select 1] call fnc_dynamic_name;"];
	HUD_NAME_KEYUP =(findDisplay 46) displayAddEventHandler ["KeyUp", "[_this select 1] call fnc_dynamic_name_hide;"];
	hintSilent "Tag name enable";
};
if((lbCurSel 2100 == 1) && !(isNil "HUD_NAME_KEYUP") && !(isNil "HUD_NAME_KEYDOWN"))then{

	hint format ["%1",lbCurSel 2100];
	(findDisplay 46)  displayRemoveEventHandler ["KeyDown",HUD_NAME_KEYDOWN];
	(findDisplay 46)  displayRemoveEventHandler ["KeyUp",HUD_NAME_KEYUP];
	HUD_NAME_KEYDOWN = nil;
	HUD_NAME_KEYUP   = nil;
	hintSilent "Tag name disable";
};
