/*****************************************************************************************************************
*@Version: V3.0		Display HUD																					 *
*																												 *
*@author : 																										 *
*	Black puma (Br.) for grizzly! don't remove this line														 *
*@description :																									 *
*	Allow to display the name of the teammates aim by the player (friendly or ennemy) and/or display teammates	 *
*	in the vehicle. 																							 *
*	/!\ run only for clients																					 * 
******************************************************************************************************************/
TAA_name = compile preprocessFileLineNumbers "TAA_name\TAA_name.sqf";
call compile preprocessFileLineNumbers "TAA_name\TAA_converter.sqf";

/***********************************************
********************HUD settings****************
************************************************/
// Available HUD : boolean (true = available / false = disable)
TAA_name_HUD_available			= 	true;
TAA_ui_IG						= 	true;
TAA_name_HUD_max_player			= 	64;
// Distance : number Display distance(meters)(recommended : 750)
TAA_name_HUD_distance		= 	75;
TAA_name_HUD_distance_max	= 	75;
//Color player : string(html value) Display friendly (recommended : "#FFFFFF")	
TAA_name_HUD_color_side			=   "#0098FF";
//Color player in group : string(html value) (recommended : "#A3FF00")	
TAA_name_HUD_color_squad		=   "#60FF00";
//Color Enemy : string(html value) Display enemy player 	(recommended : "#FF2323")
TAA_name_HUD_color_ennemy		=   "#FF0000";
TAA_name_HUD_insigna_color 		= "#FFFFFF";
//Size : number  Font size (recommended : 1)
TAA_name_HUD_size_font			=   1;
//Display Enemy: boolean Display enemy (recommended : false)	
TAA_name_HUD_Display_ennemy		=   false;
// AI Display : boolean Display ai name	(recommended : true)
TAA_name_HUD_AIDisplayName 		= true;//
// Display friendly Player : boolean Display player name (recommended : true)	
TAA_name_HUD_PlayerDisplayName 	= true;
TAA_name_HUD_key 		= 219;
TAA_name_HUD_key_ID 	= 0;
TAA_name_HUD_permanent	= false;
if(TAA_ui_IG&&TAA_name_HUD_available)then{
player addAction ["<t underline='true' color='#354EFB'>Tag Settings</t>","createDialog 'TAA_settings';","",1,false,true,"","true"];
	player addEventHandler ["killed",{
	[] spawn {
		waitUntil {sleep 1.5; alive player};
		player addAction ["<t underline='true' color='#354EFB'>Tag Settings</t>","createDialog 'TAA_settings';","",1,false,true,"","true"];};}];
};

/***************************************************
********************Don't edit below****************
****************************************************/
#define TAA_VERSION "V3.2"
TAA_MUTEX_HUD = false;
if(TAA_name_HUD_available)then{
waitUntil{player!=objNull};
sleep 1;
	HUD_NAME_KEYDOWN = (findDisplay 46) displayAddEventHandler ["KeyDown", "[_this select 1] call fnc_dynamic_name;"];
	HUD_NAME_KEYUP =(findDisplay 46) displayAddEventHandler ["KeyUp", "[_this select 1] call fnc_dynamic_name_hide;"];
	_Init_Mess	= localize "STR_TAA_TAG_SUBJECT";
	hint format [_Init_Mess,TAA_VERSION];
};

/********************************************
****************Enable cursor****************
********************************************/
TAA_cursor_enable			= true;
/********************************************
****************Distance settings************
*********************************************/
// Distance infantry : number Display distance(meters)(recommended : 150)	
TAA_name_distance_Infantry		= 150;
// Distance land vehicle	: number Display distance(meters)(recommended : 300)	
TAA_name_distance_Land_Vehicle	= 300;
// Distance air  vehicle	: number Display distance(meters)(recommended : 600)	
TAA_name_distance_Air_Vehicle	= 600;

/********************************************
****************Display settings*************
*********************************************/
// AI Display : boolean Display ai name	(recommended : true)
TAA_name_AIDisplayName 		= true;
// Display friendly Player : boolean Display player name (recommended : true)	
TAA_name_PlayerDisplayName 	= true;
//Display Ennemy: boolean Display ennemy (recommended : false)	
TAA_name_DisplayEnnemy		= false;
//Display In vehicle : boolean Display in vehicle (recommended : false)
TAA_name_DisplayInVehicle	= true;
/********************************************
*****************Color Settings**************
*********************************************/
//Color Ai : string(html value) Display friendly ais (recommended : "#FFFFFF")	
TAA_name_ColorAiFriendly	= "#FFFFFF";
//Color Player : string(html value) Display friendly player	(recommended : "#FFFFFF")
TAA_name_ColorPlayer		=  "#FFFFFF";
//Color Ennemy : string(html value) Display ais ennemy 	(recommended : "#FF2323")
TAA_name_ColorEnnemy		= "#FF2323";
//Color Ennemy : string(html value) Display ennemy player 	(recommended : "#FF2323")
TAA_name_ColorAIEnnemy		= "#FF2323";
/********************************************
********************Size font****************
*********************************************/
//Size : number  Font size (recommended : 0.5)			
TAA_name_Size				= 1;
/********************************************
********************Position****************
*********************************************/
//PosX : number Position x of the text(recommended : 0.5)		
TAA_name_Posx				= 0.6;
//PosY : number Position x of the text(recommended : 0.9)	
TAA_name_Posy				= 0.9;



TAA_CURSOR_MUTEX 	= false;
TAA_name_Show		= false;
_Subject_title = localize "STR_TAA_TAG_SUBJECT";
_Subject_title = format[_Subject_title,""];
player createDiarySubject [_Subject_title,_Subject_title];
_Help 			= localize "STR_TAA_TAG_ABOUT";
_Help_content = localize "STR_TAA_TAG_ABOUT_CONTENT";
_Help_content = format[_Help_content,"'http://www.armaholic.com/forums.php?m=posts&q=25214&n=last#bottom'"];

player createDiaryRecord [_Subject_title,[_Help,_Help_content]];

[] call TAA_name;

