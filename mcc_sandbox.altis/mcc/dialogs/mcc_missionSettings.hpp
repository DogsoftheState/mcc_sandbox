// By: Shay_gman
// Version: 1.1 (September 2011)
#define missionSettings_IDD 2997

#define RESISTANCE_HOSTILE 8401 
#define T2T_AD 8402
#define AI_SKILL 8403 
#define AI_AIM 8404 
#define AI_SPOT 8405 
#define AI_COMMAND 8406
#define MCC_MSCONSOLEGPS 8407
#define MCC_MSCONSOLESHOWFRIENDS 8408
#define MCC_MSCONSOLECOMMANDAI 8409
#define MCC_IDCNAMETAGS 8410
#define mcc_artilleryTitleIDC 8411
#define mcc_saveGearComboIDC 8412

//-----------------------------------------------------------------------------
// Main dialog
//-----------------------------------------------------------------------------
class missionSettings {
  idd = missionSettings_IDD;
  movingEnable = true;
  onLoad = __EVAL("[] execVM '"+MCCPATH+"mcc\dialogs\mcc_missionSettings_init.sqf'"); 
  
  controlsBackground[] = 
  {
  RscPicture_1200
  };
  

  //---------------------------------------------
  objects[] = 
  { 
  };
  
  controls[] = 
  {
	missionSettingsTittle,
	resistanceHostileTittle,
	resistanceHostileCombo,
	t2tTittle,
	t2tCombo,
	AISkillTittle,
	AISkillSlider,
	AIAimTittle,
	AIAimSlider,
	AISpotTittle,
	AISpotSlider,
	AICommandTittle,
	AICommandSlider,
	ConsoleGPSTittle,
	ConsoleGPS,
	ConsoleShowFriendlyWPTittle,
	ConsoleShowFriendlyWP,
	ConsoleCanCommandAI,
	ConsoleCanCommandAITittle,
	mcc_nameTags,
	mcc_nameTagsCombo,
	mcc_artilleryTitle,
	mcc_artilleryCombo,
	mcc_saveGearTitle,
	mcc_saveGearCombo,
	confirmButton,
	CancelButton	
  };
  
//========================================= Background========================================
	class RscPicture_1200: MCC_RscText 
	{
		idc = -1;
		moving = true;
		x = 0.286417 * safezoneW + safezoneX;
		y = 0.26909 * safezoneH + safezoneY;
		w = 0.360938 * safezoneW;
		h = 0.549786 * safezoneH;
		text = "";
		colorBackground[] = { 0, 0, 0, 0.6 };
	};
//Tittle
	class missionSettingsTittle: MCC_RscText
	{
		idc = -1;

		text = "Mission Settings:"; //--- ToDo: Localize;
		x = 0.410052 * safezoneW + safezoneX;
		y = 0.289982 * safezoneH + safezoneY;
		w = 0.133125 * safezoneW;
		h = 0.0299633 * safezoneH;
		colorText[] = {0,1,1,1};
		colorBackground[] = {1,1,1,0};
	};
	class resistanceHostileTittle: MCC_RscText
	{
		idc = -1;

		text = "Resistance Hostile To:"; //--- ToDo: Localize;
		x = 0.305208 * safezoneW + safezoneX;
		y = 0.324069 * safezoneH + safezoneY;
		w = 0.25 * safezoneW;
		h = 0.0219914 * safezoneH;
	};
	class resistanceHostileCombo: MCC_RscCombo
	{
		idc = RESISTANCE_HOSTILE;
		Tooltip = "Change only once before placing any units"; 

		x = 0.557292 * safezoneW + safezoneX;
		y = 0.324069 * safezoneH + safezoneY;
		w = 0.0687499 * safezoneW;
		h = 0.0211735 * safezoneH;
	};
	class t2tTittle: resistanceHostileTittle
	{
		idc = -1;

		text = "Teleport To Team:"; //--- ToDo: Localize;
		x = 0.305208 * safezoneW + safezoneX;
		y = 0.357056 * safezoneH + safezoneY;
		w = 0.25 * safezoneW;
		h = 0.0219914 * safezoneH;
	};
	class t2tCombo: MCC_RscCombo
	{
		idc = T2T_AD;
		Tooltip = "Enable/Disable Teleport to team for all player"; 
		
		x = 0.557292 * safezoneW + safezoneX;
		y = 0.357056 * safezoneH + safezoneY;
		w = 0.0687499 * safezoneW;
		h = 0.0211735 * safezoneH;
	};
	class AISkillTittle: resistanceHostileTittle
	{
		idc = -1;

		text = "AI General Skill:"; //--- ToDo: Localize;
		x = 0.305208 * safezoneW + safezoneX;
		y = 0.390043 * safezoneH + safezoneY;
		w = 0.25 * safezoneW;
		h = 0.0219914 * safezoneH;
	};
	class AISkillSlider: MCC_RscCombo
	{
		idc = AI_SKILL;

		x = 0.557292 * safezoneW + safezoneX;
		y = 0.390043 * safezoneH + safezoneY;
		w = 0.06875 * safezoneW;
		h = 0.0219914 * safezoneH;
	};
	class AIAimTittle: resistanceHostileTittle
	{
		idc = -1;

		text = "AI Aiming Skill:"; //--- ToDo: Localize;
		x = 0.305208 * safezoneW + safezoneX;
		y = 0.42303 * safezoneH + safezoneY;
		w = 0.25 * safezoneW;
		h = 0.0219914 * safezoneH;
	};
	class AIAimSlider: MCC_RscCombo
	{
		idc = AI_AIM;

		x = 0.557292 * safezoneW + safezoneX;
		y = 0.42303 * safezoneH + safezoneY;
		w = 0.06875 * safezoneW;
		h = 0.0219914 * safezoneH;
	};
	class AISpotTittle: resistanceHostileTittle
	{
		idc = -1;

		text = "AI Spotting Skill:"; //--- ToDo: Localize;
		x = 0.305208 * safezoneW + safezoneX;
		y = 0.456017 * safezoneH + safezoneY;
		w = 0.25 * safezoneW;
		h = 0.0219914 * safezoneH;
	};
	class AISpotSlider: MCC_RscCombo
	{
		idc = AI_SPOT;

		x = 0.557292 * safezoneW + safezoneX;
		y = 0.456017 * safezoneH + safezoneY;
		w = 0.06875 * safezoneW;
		h = 0.0219914 * safezoneH;
	};
	class AICommandTittle: resistanceHostileTittle
	{
		idc = -1;

		text = "AI Commanding Skill:"; //--- ToDo: Localize;
		x = 0.305208 * safezoneW + safezoneX;
		y = 0.489004 * safezoneH + safezoneY;
		w = 0.25 * safezoneW;
		h = 0.0219914 * safezoneH;
	};
	class AICommandSlider: MCC_RscCombo
	{
		idc = AI_COMMAND;

		x = 0.557292 * safezoneW + safezoneX;
		y = 0.489004 * safezoneH + safezoneY;
		w = 0.06875 * safezoneW;
		h = 0.0219914 * safezoneH;
	};

	class ConsoleGPSTittle: MCC_RscText
	{
		idc = -1;

		text = "Console - Show units without GPS:"; //--- ToDo: Localize;
		x = 0.305208 * safezoneW + safezoneX;
		y = 0.521991 * safezoneH + safezoneY;
		w = 0.25 * safezoneW;
		h = 0.0219914 * safezoneH;
	};
	class ConsoleGPS: MCC_RscCombo
	{
		idc = MCC_MSCONSOLEGPS;
		Tooltip = "If disabled groups without GPS will not be shown in the Player's Console"; 

		x = 0.557292 * safezoneW + safezoneX;
		y = 0.521991 * safezoneH + safezoneY;
		w = 0.06875 * safezoneW;
		h = 0.0219914 * safezoneH;
	};
	class ConsoleShowFriendlyWPTittle: MCC_RscText
	{
		idc = -1;
		
		text = "Console - Show Freindly WP:"; //--- ToDo: Localize;
		x = 0.305208 * safezoneW + safezoneX;
		y = 0.554979 * safezoneH + safezoneY;
		w = 0.25 * safezoneW;
		h = 0.0219914 * safezoneH;
	};
	class ConsoleShowFriendlyWP: MCC_RscCombo
	{
		idc = MCC_MSCONSOLESHOWFRIENDS;
		Tooltip = "If enabled friendly AI and players' WP will be shown in the Player's Console"; 
		
		x = 0.557292 * safezoneW + safezoneX;
		y = 0.554979 * safezoneH + safezoneY;
		w = 0.06875 * safezoneW;
		h = 0.0219914 * safezoneH;
	};
	class ConsoleCanCommandAI: MCC_RscCombo
	{
		idc = MCC_MSCONSOLECOMMANDAI;
		Tooltip = "If enabled players can use the handheld console to control AI groups spawned with default BIS behavior."; 
		
		x = 0.557292 * safezoneW + safezoneX;
		y = 0.587966 * safezoneH + safezoneY;
		w = 0.06875 * safezoneW;
		h = 0.0219914 * safezoneH;
	};
	class ConsoleCanCommandAITittle: MCC_RscText
	{
		idc = -1;
				
		text = "Console - Can Command AI"; //--- ToDo: Localize;
		x = 0.305208 * safezoneW + safezoneX;
		y = 0.587966 * safezoneH + safezoneY;
		w = 0.25 * safezoneW;
		h = 0.0219914 * safezoneH;
	};
	
	class mcc_nameTags: MCC_RscText
	{
		idc = -1;

		text = "Name Tags:"; //--- ToDo: Localize;
		x = 0.305208 * safezoneW + safezoneX;
		y = 0.620953 * safezoneH + safezoneY;
		w = 0.25 * safezoneW;
		h = 0.0219914 * safezoneH;
	};
	class mcc_nameTagsCombo: MCC_RscCombo
	{
		idc = MCC_IDCNAMETAGS;
		Tooltip = "Disable/Enable name tags for all players."; 

		x = 0.557292 * safezoneW + safezoneX;
		y = 0.620953 * safezoneH + safezoneY;
		w = 0.06875 * safezoneW;
		h = 0.0219914 * safezoneH;
	};
	
	class mcc_artilleryTitle: MCC_RscText
	{
		idc = -1;

		text = "Artillery Computer:"; //--- ToDo: Localize;
		x = 0.305208 * safezoneW + safezoneX;
		y = 0.653940 * safezoneH + safezoneY;
		w = 0.25 * safezoneW;
		h = 0.0219914 * safezoneH;
	};
	class mcc_artilleryCombo: MCC_RscCombo
	{
		idc = mcc_artilleryTitleIDC;
		Tooltip = "Disable/Enable the artillery computer to all players"; 
		
		x = 0.557292 * safezoneW + safezoneX;
		y = 0.653940 * safezoneH + safezoneY;
		w = 0.06875 * safezoneW;
		h = 0.0219914 * safezoneH;
	};
	
	class mcc_saveGearTitle: MCC_RscText
	{
		idc = -1;

		text = "Save Gear:"; //--- ToDo: Localize;
		x = 0.305208 * safezoneW + safezoneX;
		y = 0.686927 * safezoneH + safezoneY;
		w = 0.25 * safezoneW;
		h = 0.0219914 * safezoneH;
	};
	
	class mcc_saveGearCombo: MCC_RscCombo
	{
		idc = mcc_saveGearComboIDC;
		Tooltip = "Disable/Enable MCC save gear (keep it disabled if you are using any medical system"; 
		
		x = 0.557292 * safezoneW + safezoneX;
		y = 0.686927 * safezoneH + safezoneY;
		w = 0.06875 * safezoneW;
		h = 0.0219914 * safezoneH;
	}
	
	class confirmButton: MCC_RscButton
	{
		idc = -1;
		action = __EVAL("[0] execVM '"+MCCPATH+"mcc\general_scripts\mission_settings\mission_settings_change.sqf'");

		text = "Confirm"; //--- ToDo: Localize;
		x = 0.511458 * safezoneW + safezoneX;
		y = 0.752901 * safezoneH + safezoneY;
		w = 0.120313 * safezoneW;
		h = 0.0439828 * safezoneH;
	};
	
	class CancelButton: MCC_RscButton
	{
		idc = -1;
		action = "closeDialog 0";

		text = "Cancel"; //--- ToDo: Localize;
		x = 0.299479 * safezoneW + safezoneX;
		y = 0.752901 * safezoneH + safezoneY;
		w = 0.120313 * safezoneW;
		h = 0.0439828 * safezoneH;
	};
 };
