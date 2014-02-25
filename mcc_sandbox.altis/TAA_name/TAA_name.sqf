/*****************************************************************************************************************
*@Version: V 3.0	Display HUD																					 *
*																												 *
*@author : 																										 *
*	Black puma (Br.) don't remove this line																		 *
*@description :																									 *
*	Allow to display the name of the teammates aim by the player (friendly or ennemy) and/or display teammates	 *
*	in the vehicle. 																							 *
*	/!\ run only for clients																					 * 
******************************************************************************************************************/
fnc_dynamic_name = 
{
if((_this select 0!= TAA_name_HUD_key) )exitWith{};
TAA_name_Show 	= true;
_Vehicles		= nearestObjects[getpos player, ["Car","boat","Motorcycle","Air"],TAA_name_HUD_distance];
_Units			= nearestObjects[getpos player, ["CAManBase"],TAA_name_HUD_distance];

if(TAA_MUTEX_HUD)exitWith{};
TAA_MUTEX_HUD 	= true;
//#define _DEBUG_HUD true 
#ifdef _DEBUG_HUD
	_initTime	= diag_tickTime;
	_frameNo 	= diag_frameNo;
#endif

		disableSerialization;

		1006 cutRsc ["TAA_dyn_name","PLAIN"];
		_ui 				= uiNameSpace getVariable "TAA_dyn_name";
		_index 				= 0;
		_Color 				= TAA_name_HUD_color_side;
		_Color_group		= TAA_name_HUD_color_squad;
		_Color_ennemy		= TAA_name_HUD_color_ennemy;
		_Size				= TAA_name_HUD_size_font;
		_Display_ennemy 	= TAA_name_HUD_Display_ennemy;
		_AIDisplayName		= TAA_name_HUD_AIDisplayName;
		_PlayerDisplayName 	= TAA_name_HUD_PlayerDisplayName;
		_insigna			= TAA_name_HUD_insigna_color;
			{
							
				_Display_x	= false;
				_Details 	= [_x] call fnc_Details_Infantry;
				_isPlayer 	= _Details select 0;
				_isEnnemy 	= _Details select 1;
				switch(true)do{
		//--- AI ennemy ---//
						case ((_AIDisplayName)&&!(_isPlayer)&&(_isEnnemy)&&(_Display_ennemy) && alive _x):
						{
						_Display_x = true;
						};
		//--- AI friendly ---//
						case ((_AIDisplayName)&&(!(_isPlayer))&&(!(_isEnnemy))&& alive _x):
						{
						_Display_x = true;
						};
		//--- Player ennemy ---//
						case ((_isPlayer)&&(_isEnnemy)&&(_Display_ennemy)&&(_PlayerDisplayName)&& alive _x):
						{
						_Display_x = true;
						};
		//--- Player friendly ---//
						case ((_isPlayer)&&(!(_isEnnemy))&&(_PlayerDisplayName)&& alive _x):
						{
						_Display_x = true;
						};
					};
				_ColorUI 	= "";
				if(!isNil{_x getVariable "TAA_tag_hide"})then{_Display_x = false;};
				if(_Display_x && _x != player)then{
				_Pos 		= getPos _x;
					if(surfaceIsWater position _x)then{ 
						_Pos 		= getPosASL _x; 
					}else{
						_Pos 		= (getPosATL  _x);
					};
				_PosZ 		= (_Pos select 2) + 2;
				_Pos set [2,_PosZ ];
				_ScreenPos 	=	worldToScreen _Pos;
					if(count _ScreenPos >= 1)then{
						_ScreenX 	=	_ScreenPos select 0;
						_ScreenY 	=	_ScreenPos select 1;
						
							if( (_ScreenX >-1) && (_ScreenX <= 2) &&  (_ScreenY >-1) && (_ScreenY < 2)&&(player distance _x) < TAA_name_HUD_distance)then{
								_rank 		= [_x,"displayNameShort"] call BIS_fnc_rankParams;
								_rankIcon 	= [_x,"texture"] call BIS_fnc_rankParams;
								_rankIcon	= format["<img size='1' image='%1'/>",_rankIcon];		
								_scale = 0.80;
								with uinamespace do{
									if(_x getVariable ["BTC_need_revive",-1] == 1) then {
										_rankIcon 	= format["<img size='1' color='#ff0000' image='\a3\ui_f\data\IGUI\Cfg\Actions\heal_ca.paa'/>"];
									};		  
									if(_x getVariable ["NORRN_unconscious",false]) then {
										_rankIcon 	= format["<img size='1' color='#ff0000' image='\a3\ui_f\data\IGUI\Cfg\Actions\heal_ca.paa'/>"];
									};	 
									if(_x getVariable "FAR_isUnconscious" == 1) then {
										_rankIcon 	= format["<img size='1' color='#ff0000' image='\a3\ui_f\data\IGUI\Cfg\Actions\heal_ca.paa'/>"];
									};
									_name = name _x;
									switch(true)do{
										case (_x in (units group player)):
										{
											_ColorUI 		= format["<t size='%1' color='%2'>",_Size,_Color_group];
										};
										case (_isEnnemy):
										{
											_ColorUI 		= format["<t size='%1' color='%2'>",_Size,_Color_ennemy];
										};
										case(!_isEnnemy):
										{
											_ColorUI 		= format["<t size='%1' color='%2'>",_Size,_Color];
										};
									};
									if(!isNil{_x getVariable "TAA_TAG_PLAYER_CUSTOM"})then{
										_ColorUI 		= format["<t size='%1' color='%2'>",_Size,(_x getVariable "TAA_TAG_PLAYER_CUSTOM")];
									};
									_colorInsigna = format["<t size='%1' color='%2'>",_Size,_insigna];
									_Content	= format["%1 %2</t>",_rank,_name];
									_Display 	= format["%4%3</t> %1%2 ", _ColorUI, _Content,_rankIcon,_colorInsigna];
									_index = _index +1;
									_IDC =  5000 + _index;
									_dyn_name = _ui displayCtrl _IDC;
									_dyn_name ctrlSetStructuredText parseText _Display;
									_dyn_name ctrlSetPosition [_ScreenX -0.15, _ScreenY, 0.5, 0.75];
									_dyn_name ctrlSetScale _scale;
									_dyn_name ctrlSetFade ((1- _scale ) / 1);
									_dyn_name ctrlCommit 0;
									_dyn_name ctrlShow true;
							};
						};
					};
				};
			}forEach _Units;
		{
		{
			_Display_x	= false;
			_Details 	= [_x] call fnc_Details_Infantry;
				_isPlayer 	= _Details select 0;
				_isEnnemy 	= _Details select 1;
				switch(true)do{
		//--- AI ennemy ---//
						case ((_AIDisplayName)&&!(_isPlayer)&&(_isEnnemy)&&(_Display_ennemy) && alive _x):
						{
						_Display_x = true;
						};
		//--- AI friendly ---//
						case ((_AIDisplayName)&&(!(_isPlayer))&&(!(_isEnnemy))&& alive _x):
						{
						_Display_x = true;
						};
		//--- Player ennemy ---//
						case ((_isPlayer)&&(_isEnnemy)&&(_Display_ennemy)&&(_PlayerDisplayName)&& alive _x):
						{
						_Display_x = true;
						};
		//--- Player friendly ---//
						case ((_isPlayer)&&(!(_isEnnemy))&&(_PlayerDisplayName)&& alive _x):
						{
						_Display_x = true;
						};
					};
				_ColorUI 	= "";
				if(!isNil{_x getVariable "TAA_tag_hide"})then{_Display_x = false;};
				if(_Display_x && _x != player)then{
				_Pos 		= getPos _x;
					if(surfaceIsWater position _x)then{ 
						_Pos 		= getPosASL _x; 
					}else{
						_Pos 		= (getPosATL  _x);
					};
				_PosZ 		= (_Pos select 2) + 2;
				_Pos set [2,_PosZ ];
				_ScreenPos 	=	worldToScreen _Pos;
					if(count _ScreenPos >= 1)then{
						_ScreenX 	=	_ScreenPos select 0;
						_ScreenY 	=	_ScreenPos select 1;
						
							if( (_ScreenX >-1) && (_ScreenX <= 2) &&  (_ScreenY >-1) && (_ScreenY < 2)&&(player distance _x) < TAA_name_HUD_distance)then{
								_rank 		= [_x,"displayNameShort"] call BIS_fnc_rankParams;
								_rankIcon 	= [_x,"texture"] call BIS_fnc_rankParams;
								_rankIcon	= format["<img size='1' image='%1'/>",_rankIcon];		
								_scale = 0.80;
								with uinamespace do{
									if(_x getVariable ["BTC_need_revive",-1] == 1) then {
										_rankIcon 	= format["<img size='1' color='#ff0000' image='\a3\ui_f\data\IGUI\Cfg\Actions\heal_ca.paa'/>"];
									};		  
									if(_x getVariable ["NORRN_unconscious",false]) then {
										_rankIcon 	= format["<img size='1' color='#ff0000' image='\a3\ui_f\data\IGUI\Cfg\Actions\heal_ca.paa'/>"];
									};	 
									if(_x getVariable "FAR_isUnconscious" == 1) then {
										_rankIcon 	= format["<img size='1' color='#ff0000' image='\a3\ui_f\data\IGUI\Cfg\Actions\heal_ca.paa'/>"];
									};
									_name = name _x;
									switch(true)do{
										case (_x in (units group player)):
										{
											_ColorUI 		= format["<t size='%1' color='%2'>",_Size,_Color_group];
										};
										case (_isEnnemy):
										{
											_ColorUI 		= format["<t size='%1' color='%2'>",_Size,_Color_ennemy];
										};
										case(!_isEnnemy):
										{
											_ColorUI 		= format["<t size='%1' color='%2'>",_Size,_Color];
										};
									};
									if(!isNil{_x getVariable "TAA_TAG_PLAYER_CUSTOM"})then{
										_ColorUI 		= format["<t size='%1' color='%2'>",_Size,(_x getVariable "TAA_TAG_PLAYER_CUSTOM")];
									};
									_colorInsigna = format["<t size='%1' color='%2'>",_Size,_insigna];
									_Content	= format["%1 %2</t>",_rank,_name];
									_Display 	= format["%4%3</t> %1%2 ", _ColorUI, _Content,_rankIcon,_colorInsigna];
									_index = _index +1;
									_IDC =  5000 + _index;
									_dyn_name = _ui displayCtrl _IDC;
									_dyn_name ctrlSetStructuredText parseText _Display;
									_dyn_name ctrlSetPosition [_ScreenX -0.15, _ScreenY, 0.5, 0.75];
									_dyn_name ctrlSetScale _scale;
									_dyn_name ctrlSetFade ((1- _scale ) / 1);
									_dyn_name ctrlCommit 0;
									_dyn_name ctrlShow true;
							};
						};
					};
				};
			}forEach crew _x;
		}forEach _Vehicles;
		#ifdef _DEBUG_HUD
			hint format["time: %1, frames: %2",(_initTime - diag_tickTime) ,(_frameNo - diag_frameNo)];
		#endif
		TAA_MUTEX_HUD = false;
		
};
fnc_dynamic_name_hide = {
	if(_this select 0!=TAA_name_HUD_key)exitWith{};
		disableSerialization;
		1006 cutRsc ["TAA_dyn_name","PLAIN"];
		_ui 		= 	uiNameSpace getVariable "TAA_dyn_name";
		_index = 5000;
			while{_index < 5000 + TAA_name_HUD_max_player}do{
				_dyn_name = _ui displayCtrl _index;
				_dyn_name ctrlShow false;
				_index = _index + 1;
			};
	TAA_name_Show = false;
};
fnc_assign_key={

TAA_name_HUD_key = _this;

hint format["%1",TAA_name_HUD_key];
(findDisplay 10000)  displayRemoveEventHandler ["KeyDown",TAA_name_HUD_key_ID];
hint format["You binded a new key to active tag name system",_binded];
true
};


fnc_name_display	={

				_player		= _this select 0;
				_Display_x	= false;
				_Details 	= [_player] call fnc_Details_Infantry;
				_isPlayer 	= _Details select 0;
				_isEnnemy 	= _Details select 1;
				switch(true)do{
		//--- AI ennemy ---//
						case ((_AIDisplayName)&&!(_isPlayer)&&(_isEnnemy)&&(_Display_ennemy)):
						{
						_Display_x = true;
						};
		//--- AI friendly ---//
						case ((_AIDisplayName)&&(!(_isPlayer))&&(!(_isEnnemy))):
						{
						_Display_x = true;
						};
		//--- Player ennemy ---//
						case ((_isPlayer)&&(_isEnnemy)&&(_Display_ennemy)&&(_PlayerDisplayName)):
						{
						_Display_x = true;
						};
		//--- Player friendly ---//
						case ((_isPlayer)&&(!(_isEnnemy))&&(_PlayerDisplayName)):
						{
						_Display_x = true;
						};
					};
	_Display_x
};
fnc_cursor_show={
		if(TAA_name_Show)exitWith{ };
		//[_Formated,_Posx,_Posy,_refresh,0,0,0]
		disableSerialization;
		_Display 	= _this select 0;
		_Posx		= _this select 1;
		_Posy		= _this select 2;
		1006 cutRsc ["TAA_dyn_name","PLAIN"];
		_ui 				= uiNameSpace getVariable "TAA_dyn_name";
		_dyn_name = _ui displayCtrl 7000;
		_dyn_name ctrlSetStructuredText parseText _Display;
		_dyn_name ctrlSetPosition [_Posx -0.15, _Posy, 0.5, 0.5];
		_dyn_name ctrlCommit 0;
		_dyn_name ctrlShow true;	
		TAA_CURSOR_MUTEX = true;
};
fnc_cursor_hide={
		TAA_CURSOR_MUTEX = false;
		disableSerialization;
		_ui 				= uiNameSpace getVariable "TAA_dyn_name";
		_dyn_name = _ui displayCtrl 7000;
		_dyn_name ctrlShow false;	
};

fnc_format_vehicle_air={
	private["_locked","_Color","_Size","_refresh","_Posx","_Posy","_Color","_ColorEmpty","_ColorVeh","_DriverImg","_GunnerImg","_CommanderIm","_END","_Formated","_SPACE","_Label","_EmptyConf","_EmptyPos"];
	
	_locked		= _this select 0;
	_Color		= _this select 1;
	_Size		= _this select 2;
	_refresh	= _this select 3;
	_Posx		= _this select 4;
	_Posy 		= _this select 5;

	_Color 		 =format["<t size='%1'   align='left' color='%2'>",_Size,_Color];
	_ColorEmpty	 =format["<t size='0.60' align='left' color='#FDFDFD'>",_Size];
	_ColorVeh	 =format["<t size='0.60' align='left' color='#FFFFFF'>",_Size];
	_DriverImg 	 ="<img size='0.6' align='left' image='\a3\ui_f\data\IGUI\Cfg\Actions\getindriver_ca.paa'/>";
	_GunnerImg	 ="<img size='0.6' align='left' image='\a3\ui_f\data\IGUI\Cfg\Actions\getingunner_ca.paa'/>";
	_CommanderImg="<img size='0.6' align='left' image='\a3\ui_f\data\IGUI\Cfg\Actions\getincommander_ca.paa'/>";
	
	_END		= "</ t><br />";
	_Formated 	= " ";
	_SPACE		= "	";
	_Label 		= getText (configFile >> "CfgVehicles" >> (typeOf _target) >> "displayName");
	_EmptyConf	= getNumber (configFile >> "CfgVehicles" >>(typeOf _target) >> "transportSoldier");
	_EmptyPos	= _target emptyPositions "cargo";

	if(_locked)then{
		_locked = "<img size='0.6' align='left' image='images\locked.paa'/>";
		}else{
		_locked = "<img size='0.6' align='left' image='images\unlocked.paa'/>";
		};
		_crews = crew _target;
		_Formated 	= format["%5%1(%2/%3 %6)%4",_Label,_EmptyPos,_EmptyConf,_END,_ColorVeh,_locked];
		_Driver		= 0;
		_Copilot 	= 0;
		_LGunner	= 0;
		_RGunner	= 0;
		_Commander	= 0;
		{
			_crew = _x;
			_Role = assignedVehicleRole _x;
			switch(_Role select 0)do{
				case "Driver":
				{
					_Driver 	= name _crew;				
				};
				case "Turret":
				{
					_TurretPath = _Role select  1;
					if(count _TurretPath == 1)then{
						
						switch(_TurretPath select 0)do{
							case 0:
							{
								_Copilot 	= name _crew;
							};
							case 1:
							{
								_RGunner 	= name _crew;	
							};
							case 2:
							{
								_LGunner 	= name _crew;	
							};
						};
					
					};
				};
			};
		}forEach _crews;
		if(typeName _Driver 	== "STRING")then{ _Formated = format ["%4%5%6%1%2%3",_Color, _Driver, _END,_Formated,_DriverImg,_SPACE];};
		if(typeName _Copilot  	== "STRING")then{ _Formated = format ["%4%5%6%1%2%3",_Color, _Copilot, _END,_Formated,_DriverImg,_SPACE];};
		if(typeName _RGunner	== "STRING")then{ _Formated = format ["%4%5%6%1%2%3",_Color, _RGunner, _END,_Formated,_GunnerImg,_SPACE];};
		if(typeName _LGunner  	== "STRING")then{ _Formated = format ["%4%5%6%1%2%3",_Color, _LGunner, _END,_Formated,_GunnerImg,_SPACE];};
		if(typeName _Commander	== "STRING")then{ _Formated = format ["%4%5%6%1%2%3",_Color, _Commander, _END,_Formated,_CommanderImg,_SPACE];};
		[_Formated,_Posx,_Posy,_refresh,0,0,0] spawn fnc_cursor_show;//--- add params : X Y 

};
fnc_Details_Infantry = {
private["_target","_isPlayer","_isEnnemy","_Details"];
	_target 	= _this select 0;
	_isPlayer 	= false;
	_isEnnemy	= if((playerSide) getFriend (side _target) > 0.6)then{false}else{true};
	if(isPlayer _target)then{ _isPlayer = true;};
	_Details = [_isPlayer,_isEnnemy];
_Details
};
fnc_Details_vehicle = {
private["_target","_isPlayer","_isEnnemy","_driver","_gunner","_commander","_driverStat","_gunnerStat","_commanderStat","_locked","_Details"];
	_target 		= _this select 0;
	_isPlayer 		= false;
	_isEnnemy		= true;
	_driver 		= driver _target;
	_gunner 		= gunner _target;
	_commander 		= commander _target;
	_driverStat		= false;
	_gunnerStat 	= false;
	_commanderStat 	= false;
	_locked			= false;
	
	if(isPlayer _driver)then{ _isPlayer = true;};
	_isEnnemy	= if((playerSide) getFriend (side _target) > 0.6)then{false}else{true};
	if(alive _driver)then{_driverStat = true;};
	if(alive _gunner)then{_gunnerStat = true;};
	if(alive _commander)then{_commanderStat = true;};
	if(locked _target == 2 )then{_locked = true;};
	_Details = [_isPlayer,_isEnnemy,_driverStat,_gunnerStat,_commanderStat,_locked ];
_Details
};
fnc_Format_vehicle = {
private["_Driver","_Gunner","_target","_commander","_locked","_Color","_Size","_refresh","_Posx","_PosY","_ColorEmpty","_ColorVeh","_END","_Formated","_SPACE","_Label","_EmptyConf","_EmptyPos"];
	_Driver 	= _this select 0;
	_Gunner 	= _this select 1;
	_commander 	= _this select 2;
	_target  	= _this select 3;
	_locked		= _this select 4;
	_Color		= _this select 5;
	_Size		= _this select 6;
	_refresh	= _this select 7;
	_Posx		= _this select 8;
	_PosY		= _this select 9;
	_Color 		= format["<t size='%1'   align='left' color='%2'>",_Size,_Color];
	_ColorEmpty	= format["<t size='%1' align='left' color='#FDFDFD'>",_Size];
	_ColorVeh	= format["<t size='%1' align='left' color='#FFFFFF'>",_Size];
	_END		= "</ t><br />";
	_Formated 	= " ";
	_SPACE		= "	";
	_Label 		= getText (configFile >> "CfgVehicles" >> (typeOf _target) >> "displayName");
	_EmptyConf	= getNumber (configFile >> "CfgVehicles" >>(typeOf _target) >> "transportSoldier");
	_EmptyPos	= _target emptyPositions "cargo";
	if(_locked)then{
		_locked = "<img size='0.6' align='left' image='images\locked.paa'/>";
		}else{
		_locked = "<img size='0.6' align='left' image='images\unlocked.paa'/>";
		};
		_Formated 	= format["%5%1(%2/%3 %6)%4",_Label,_EmptyPos,_EmptyConf,_END,_ColorVeh,_locked];
	if(_Driver)then{
		_DriverImg = "<img size='0.6' align='left' image='\a3\ui_f\data\IGUI\Cfg\Actions\getindriver_ca.paa'/>";
		_Driver = name (driver _target);
		_Formated =format ["%4%5%6%1 %2%3",_Color, _Driver, _END,_Formated,_DriverImg,_SPACE];
	};
	if(_Gunner)then{
		_GunnerImg	=  "<img size='0.6' align='left' image='\a3\ui_f\data\IGUI\Cfg\Actions\getingunner_ca.paa'/>";
		_Gunner 	= name (gunner _target);
		_Formated =format ["%4%5%6%1 %2%3",_Color, _Gunner, _END,_Formated,_GunnerImg,_SPACE];
	};
	if(_commander)then{
		_commander 		= name (commander _target);
		_commanderImg 	=  "<img size='0.6' align='left' image='\a3\ui_f\data\IGUI\Cfg\Actions\getincommander_ca.paa'/>";
		_Formated =format ["%4%5%6%1 %2%3",_Color, _commander,_END,_Formated,_commanderImg,_SPACE];
	};
	if(alive _Target)then{
		//[_Formated,_Posx,_Posy,_refresh,0,0,0] spawn bis_fnc_dynamicText;
		[_Formated,_Posx,_Posy,_refresh,0,0,0] spawn fnc_cursor_show;
	};
};
fnc_Format_infantry = {
private["_Target","_Color","_rank","_size","_refresh","_Posx","_Posy","_name","_Color","_Content","_Display"];
	_Target		= _this select 0;
	_Color 		= _this select 1;
	_rank		= _this select 2;
	_size		= _this select 3;
	_refresh	= _this select 4;
	_Posx		= _this select 5;
	_Posy		= _this select 6;
	_rankIcon   = _this select 7;
	_name 		= name _Target;
	_Color 		= format["<t size='%1' color='%2'>",_Size,_Color];
	_rankIcon	= format["<img size='0.5' image='%1'/>",_rankIcon];
	_Content	= format["%3 %1 %2</t>",_rank,_name,_rankIcon];
	_Display 	= format["%1 %2", _Color, _Content];
			if(alive _Target)then{
				//[_Display,_Posx,_Posy,_refresh,0,0,3] spawn bis_fnc_dynamicText;
				[_Display,_Posx,_Posy,_refresh,0,0,3] spawn fnc_cursor_show;
			};
};
/**********************************************************************************************/
/****************************************** MAIN CODE *****************************************/
/**********************************************************************************************/
//#define _DEBUG_ 	true

#define _refresh	0.25
if(!isNil "DISPLAY_HUD_LAUNCH")exitWith{ hintSilent "Warning : display hud script is already running second instance exited";};
DISPLAY_HUD_LAUNCH = true;
private["_distance_Infantry","_distance_Land_Vehicle","_distance_Air_Vehicle","_AIDisplayName","_PlayerDisplayName","_DisplayEnnemy","_DisplayInVehicle","_ColorAiFriendly","_ColorPlayer","_ColorEnnemy","_ColorAIEnnemy","_Size","_Posx","_Posy","_initTime","_frameNo","_target","_Details","_isPlayer","_isEnnemy","_rank","_Driver","_gunner","_commander","_Locked"];

//--- display settings distance ---//
_distance_Infantry		= TAA_name_distance_Infantry;
_distance_Land_Vehicle	=TAA_name_distance_Land_Vehicle;
_distance_Air_Vehicle	= TAA_name_distance_Air_Vehicle;
//--- display settings who ---//
_AIDisplayName 		= TAA_name_AIDisplayName;
_PlayerDisplayName 	= TAA_name_PlayerDisplayName;
_DisplayEnnemy		= TAA_name_DisplayEnnemy;
_DisplayInVehicle	= TAA_name_DisplayInVehicle;
//--- Color Settings ---//
_ColorAiFriendly	= TAA_name_ColorAiFriendly;
_ColorPlayer		= TAA_name_ColorPlayer;
_ColorEnnemy		= TAA_name_ColorEnnemy;
_ColorAIEnnemy		= TAA_name_ColorAIEnnemy;
//--- Size font ---//
_Size				= TAA_name_Size;
//--- Position 	---//
_Posx				= TAA_name_Posx;
_Posy				= TAA_name_Posy;

/*********************************************************************************************/
/*******************************Checking Params***********************************************/
/*********************************************************************************************/
//--- Check display settings ---//
#ifdef _DEBUG_
	_text = format["Distance: %1 \n Distance land vehicle : %2 \n Distance Air vehicle : %3 \n Display AI name : %4 \n Display Ennemy : %5 \n Display player name : %6 \n Display name in vehicle : %7 \n Color friendly player : %8 \n Color AI player : %9 \n Color ennemy player : %10 \n Size of the font : %11 \n Position X : %11 \n Position Y : %11 ", _distance_Infantry, _distance_Land_Vehicle, _distance_Air_Vehicle,_AIDisplayName, _DisplayEnnemy, _PlayerDisplayName,_DisplayInVehicle,_ColorPlayer,_ColorAiFriendly	,_ColorAIEnnemy,_Size,_Posx,_Posy];
	diag_log _text;
	hintSilent _text;
#endif
/******************************************************************************************************/
/******************************* End of checking Params ***********************************************/
/*************************************** Loop *********************************************************/
/******************************************************************************************************/
if(!TAA_cursor_enable)exitWith{};
while{true}do{
#ifdef _DEBUG_
	_initTime	= diag_tickTime;
	_frameNo 	= diag_frameNo;
#endif
//--- Capture what is aiming the player ---//
	_target = cursorTarget;
		if((player distance _target) < _distance_Infantry && player == vehicle player)then{
/******************************************************************************************************/
/************************************** Infantry check ************************************************/
/******************************************************************************************************/
			if (_target isKindOf "Man")then{
				_Details 	= [_target] call fnc_Details_Infantry;
				_isPlayer 	= _Details select 0;
				_isEnnemy 	= _Details select 1;
				_rank 		= [_target,"displayNameShort"] call BIS_fnc_rankParams;
				_rankIcon 	= [_target,"texture"] call BIS_fnc_rankParams;
				switch(true)do{
//--- AI ennemy ---//
				case ((_AIDisplayName)&&!(_isPlayer)&&(_isEnnemy)&&(_DisplayEnnemy)):
				{
						[_target,_ColorAIEnnemy,_rank,_Size,_refresh,_posX,_posY,_rankIcon ] call fnc_Format_infantry;
				};
//--- AI friendly ---//
				case ((_AIDisplayName)&&(!(_isPlayer))&&(!(_isEnnemy))):
				{
						[_target,_ColorAIFriendly,_rank,_Size,_refresh,_posX,_posY,_rankIcon ] call fnc_Format_infantry;
				};
//--- Player ennemy ---//
				case ((_isPlayer)&&(_isEnnemy)&&(_DisplayEnnemy)&&(_PlayerDisplayName)):
				{
						[_target,_ColorEnnemy,_rank,_Size,_refresh,_posX,_posY,_rankIcon ] call fnc_Format_infantry;
				};
//--- Player friendly ---//
				case ((_isPlayer)&&(!(_isEnnemy))&&(_PlayerDisplayName)):
				{
						[_target,_ColorPlayer,_rank,_Size,_refresh,_posX,_posY,_rankIcon] call fnc_Format_infantry;
				};
			};
		};
	};
/******************************************************************************************************/
/****************************************** Vehicle check  ********************************************/
/******************************************************************************************************/
	if((player distance _target) < _distance_Land_Vehicle && player == vehicle player)then{
		if ((_target isKindOf "Car" || _target isKindOf "Motorcycle" || _target isKindOf "boat" || _target isKindOf "Tank") && player == vehicle player && ((count crew _target) > 0))then{

				_Details  = [_target] call fnc_Details_vehicle;
				_isPlayer = _Details select 0;
				_isEnnemy = _Details select 1;
				_Driver	  = _Details select 2;
				_gunner	  = _Details select 3;
				_commander= _Details select 4;
				_Locked	  = _Details select 5;
//--- AI ennemy ---//
				switch(true)do{
					case ((_AIDisplayName) &&(!(_isPlayer))&&(_isEnnemy)&&(_DisplayEnnemy)): 
					{
							[_Driver,_gunner,_commander,_target,_Locked,_ColorAIEnnemy,_Size,_refresh,_Posx,_Posy] call fnc_Format_vehicle;
					};
//--- AI friendly ---//        
					case ((_AIDisplayName)&&(!(_isPlayer))&&(!(_isEnnemy))):
					{
							[_Driver, _gunner, _commander, _target, _Locked, _ColorAiFriendly, _Size,_refresh,_Posx,_Posy] call fnc_Format_vehicle;
					};
//--- Player ennemy ---//
					case ((_isPlayer)&& (_isEnnemy) &&(_DisplayEnnemy)&&(_PlayerDisplayName)):
					{
							[_Driver, _gunner, _commander, _target, _Locked, _ColorEnnemy, _Size,_refresh,_Posx,_Posy] call fnc_Format_vehicle;
					};
//--- Player friendly ---//
					case ((_isPlayer)&& !(_isEnnemy)&&(_PlayerDisplayName)):
					{
							[_Driver, _gunner, _commander, _target, _Locked, _ColorPlayer, _Size,_refresh,_Posx,_Posy] call fnc_Format_vehicle;
					};
				};
			};
		};
/******************************************************************************************************/
/********************************* Air Vehicle ********************************************************/
/******************************************************************************************************/				
if((player distance _target) < _distance_Air_Vehicle && player == vehicle player)then{
		if ((_target isKindOf "air") && player == vehicle player && ((count crew _target) > 0))then{

				_Details  = [_target] call fnc_Details_vehicle;
				_isPlayer = _Details select 0;
				_isEnnemy = _Details select 1;
				_Driver	  = _Details select 2;
				_gunner	  = _Details select 3;
				_commander= _Details select 4;
				_Locked	  = _Details select 5;
				switch(true)do{
//--- AI ennemy ---//
					case ((_AIDisplayName) && !(_isPlayer)&& (_isEnnemy) &&(_DisplayEnnemy)):
					{
							[_Locked, _ColorAIennemy, _Size,_refresh,_Posx,_Posy] call fnc_Format_vehicle_air;
					};
//--- AI friendly ---//        
					case ((_AIDisplayName) && !(_isPlayer)&& !(_isEnnemy)):
					{
							[_Locked, _ColorAIfriendly, _Size,_refresh,_Posx,_Posy] call fnc_Format_vehicle_air;
					};
//--- Player ennemy ---//
					case ((_isPlayer)&& (_isEnnemy) &&(_DisplayEnnemy)&&(_PlayerDisplayName)):
					{
							[_Locked, _ColorEnnemy, _Size,_refresh,_Posx,_Posy] call fnc_Format_vehicle_air;
					};
//--- Player friendly ---//
					case ((_isPlayer)&& !(_isEnnemy)&&(_PlayerDisplayName)):
					{
							[_Locked, _ColorPlayer, _Size,_refresh,_Posx,_Posy] call fnc_Format_vehicle_air;
					};
				};
			};
		};
/******************************************************************************************************/
/********************************* Player in Vehicle **************************************************/
/******************************************************************************************************/				
		if((player != vehicle player)&&(_DisplayInVehicle))then{
			//--- AI ennemy ---//
				_target   = vehicle player;
				_Details  = [_target] call fnc_Details_vehicle;
				_isPlayer = _Details select 0;
				_isEnnemy = _Details select 1;
				_Driver	  = _Details select 2;
				_gunner	  = _Details select 3;
				_commander= _Details select 4;
				_Locked	  = _Details select 5;			
			if ((_target isKindOf "air"))then{

					switch(true)do{
//--- AI friendly ---//
							case ((_AIDisplayName) && !(_isPlayer)&& !(_isEnnemy)):
							{
									[_Locked, _ColorAIfriendly, _Size,_refresh,_Posx,_Posy] call fnc_Format_vehicle_air;
							};
//--- Player friendly ---//
							case ((_isPlayer)&& !(_isEnnemy)&&(_PlayerDisplayName)):
							{
									[_Locked, _ColorPlayer, _Size,_refresh,_Posx,_Posy] call fnc_Format_vehicle_air;
							};
						};
					};
			if ((_target isKindOf "Car" || _target isKindOf "Motorcycle" || _target isKindOf "boat" || _target isKindOf "Tank"))then{
				switch(true)do{
					case ((_AIDisplayName) && !(_isPlayer)&& (_isEnnemy) &&(_DisplayEnnemy)): 
					{
							[_Driver,_gunner,_commander,_target,_Locked,_ColorAIEnnemy,_Size,_refresh,_Posx,_Posy] call fnc_Format_vehicle;
					};
//--- AI friendly ---//        
					case ((_AIDisplayName)&&!(_isPlayer)&&!(_isEnnemy)):
					{
							[_Driver, _gunner, _commander, _target, _Locked, _ColorAiFriendly, _Size,_refresh,_Posx,_Posy] call fnc_Format_vehicle;
					};
//--- Player ennemy ---//
					case ((_isPlayer)&&(_isEnnemy)&&(_DisplayEnnemy)&&(_PlayerDisplayName)):
					{
							[_Driver, _gunner, _commander, _target, _Locked, _ColorEnnemy, _Size,_refresh,_Posx,_Posy] call fnc_Format_vehicle;
					};
//--- Player friendly ---//
					case ((_isPlayer)&& !(_isEnnemy)&&(_PlayerDisplayName)):
					{
							[_Driver, _gunner, _commander, _target, _Locked, _ColorPlayer, _Size,_refresh,_Posx,_Posy] call fnc_Format_vehicle;
					};
				};		
			};
		};

		#ifdef _DEBUG_
			hint format["time: %1, frames: %2 \n Position Y :%2 , Position X :%3",(_initTime - diag_tickTime) ,(_frameNo - diag_frameNo),_posy,_posx];
		#endif
		sleep _refresh;
		if(TAA_CURSOR_MUTEX&&!TAA_name_Show)then{[] spawn fnc_cursor_hide;};
	};
/****************************************************************************************************/
/****************************************** End Loops ***********************************************/
/****************************************************************************************************/
