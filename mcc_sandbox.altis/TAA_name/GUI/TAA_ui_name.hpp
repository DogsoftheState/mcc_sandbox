class TAA_settings{
    onLoad = "[] execVM 'TAA_name\GUI\fnc\taa_fnc_open.sqf';";
    idd = 10000 ;
    movingenable=false;

    class controls
    {

        class TAA_BOX: TAA_CUS_BOX
        {
            idc = -1;
            text= "";
			x = 0.293628 * safezoneW + safezoneX;
			y = 0.291024 * safezoneH + safezoneY;
			w = 0.412744 * safezoneW;
			h = 0.428951 * safezoneH;
        };
        class TAAFrame_1800: TAAFrame
        {
            idc = -1;
			x = 0.293628 * safezoneW + safezoneX;
			y = 0.269026 * safezoneH + safezoneY;
			w = 0.412744 * safezoneW;
			h = 0.0219975 * safezoneH;
        };
        class _TITLE: TAAText
        {
            idc = -1;
            moving = 1;
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])",
                                 "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.7])"};
            text= "Tag Name System V3.2";
			x = 0.293628 * safezoneW + safezoneX;
			y = 0.269026 * safezoneH + safezoneY;
			w = 0.412744 * safezoneW;
			h = 0.0219975 * safezoneH;

        };
        class TAACombo_2100: TAACombo
        {
            idc = 2100;
            x = 0.417451 * safezoneW + safezoneX;
			y = 0.313021 * safezoneH + safezoneY;
			w = 0.268284 * safezoneW;
			h = 0.0219975 * safezoneH;
			toolTip = "$STR_TAA_TAG_ENABLE";
			onLBSelChanged = "[] execVM 'TAA_name\GUI\fnc\taa_enable.sqf';";

        };
        class TAASlider_1900: TAASlider
        {
            idc = 1900;
			x = 0.417451 * safezoneW + safezoneX;
			y = 0.357016 * safezoneH + safezoneY;
			w = 0.268284 * safezoneW;
			h = 0.0219975 * safezoneH;
			toolTip = "$STR_TAA_TAG_DISTANCE";
			onSliderPosChanged="TAA_name_HUD_distance =_this select 1;_text = localize 'STR_TAA_TAG_DISTANCE';((findDisplay 10000) displayCtrl 1900) ctrlSetTooltip format[_text,TAA_name_HUD_distance];";
        };
        class TAAText_1000: TAAText
        {
            idc = 1000;
            text = "$STR_TAA_TAG_ENABLE_DISABLE"; 
			x = 0.309106 * safezoneW + safezoneX;
			y = 0.313021 * safezoneH + safezoneY;
			w = 0.0877082 * safezoneW;
			h = 0.0219975 * safezoneH;
        };
        class TAAText_1001: TAAText
        {
            idc = 1001;
			text = "$STR_TAA_TAG_DISTANCE_TXT"; //--- ToDo: Localize;
			x = 0.309106 * safezoneW + safezoneX;
			y = 0.357016 * safezoneH + safezoneY;
			w = 0.0877082 * safezoneW;
			h = 0.0219975 * safezoneH;
        };
        class TAAText_1002: TAAText
        {
            idc = 1002;
			text = "$STR_TAA_TAG_COLOR_TXT"; //--- ToDo: Localize;
			x = 0.309106 * safezoneW + safezoneX;
			y = 0.401011 * safezoneH + safezoneY;
			w = 0.0877082 * safezoneW;
			h = 0.0219975 * safezoneH;
        };
        class TAACombo_2101: TAACombo
        {
            idc = 2101;
			x = 0.417451 * safezoneW + safezoneX;
			y = 0.401011 * safezoneH + safezoneY;
			w = 0.268284 * safezoneW;
			h = 0.0219975 * safezoneH;
			onLBSelChanged = "[] execVM 'TAA_name\GUI\fnc\taa_cmb_refresh.sqf';";
        };

        class TAAText_1003: TAAText
        {
            idc = 1003;
			text = "$STR_TAA_TAG_RED"; //--- ToDo: Localize;
			x = 0.309106 * safezoneW + safezoneX;
			y = 0.445006 * safezoneH + safezoneY;
			w = 0.0877082 * safezoneW;
			h = 0.0219975 * safezoneH;
        };
        class TAAText_1004: TAAText
        {
            idc = 1004;
			text = "$STR_TAA_TAG_GREEN"; //--- ToDo: Localize;
			x = 0.309106 * safezoneW + safezoneX;
			y = 0.510999 * safezoneH + safezoneY;
			w = 0.0877082 * safezoneW;
			h = 0.0219975 * safezoneH;
        };
        class TAAText_1005: TAAText
        {
            idc = 1005;
			text = "$STR_TAA_TAG_BLUE"; //--- ToDo: Localize;
			x = 0.309106 * safezoneW + safezoneX;
			y = 0.576991 * safezoneH + safezoneY;
			w = 0.0877082 * safezoneW;
			h = 0.0219975 * safezoneH;
        };
		  class TAASlider_1901: TAASlider
        {
            idc = 1901;
			x = 0.309106 * safezoneW + safezoneX;
			y = 0.478002 * safezoneH + safezoneY;
			w = 0.376629 * safezoneW;
			h = 0.0219975 * safezoneH;
			toolTip = "";
			onSliderPosChanged="[] execVM 'TAA_name\GUI\fnc\taa_color_value.sqf';((findDisplay 10000) displayCtrl 1901) ctrlSetTooltip format['%2 (Current : %1)',sliderPosition 1901,localize 'STR_TAA_TAG_RED'];";
        };
        class TAASlider_1903: TAASlider
        {
            idc = 1903;
			x = 0.309106 * safezoneW + safezoneX;
			y = 0.609988 * safezoneH + safezoneY;
			w = 0.376629 * safezoneW;
			h = 0.0219975 * safezoneH;
			toolTip = "";
			onSliderPosChanged="[] execVM 'TAA_name\GUI\fnc\taa_color_value.sqf';((findDisplay 10000) displayCtrl 1903) ctrlSetTooltip format['%2 (Current : %1)',sliderPosition 1903,localize 'STR_TAA_TAG_BLUE'];";
		};
        class TAASlider_1902: TAASlider
        {
            idc = 1902;
			x = 0.309106 * safezoneW + safezoneX;
			y = 0.543995 * safezoneH + safezoneY;
			w = 0.376629 * safezoneW;
			h = 0.0219975 * safezoneH;
			toolTip = "";
			onSliderPosChanged="[] execVM 'TAA_name\GUI\fnc\taa_color_value.sqf';((findDisplay 10000) displayCtrl 1902) ctrlSetTooltip format['%2 (Current : %1)',sliderPosition 1902,localize 'STR_TAA_TAG_GREEN'];";
        };
        class TAAStructuredText_1100: TAAStructuredText
        {
            idc = 1100;
			x = 0.345221 * safezoneW + safezoneX;
			y = 0.653983 * safezoneH + safezoneY;
			w = 0.283762 * safezoneW;
			h = 0.043995 * safezoneH;
        };
		class RscButton_2600: TAAButtonMenu_action
		{
			idc=-1;
			x = 0.634142 * safezoneW + safezoneX;
			y = 0.719975 * safezoneH + safezoneY;
			w = 0.0722302 * safezoneW;
			h = 0.0219975 * safezoneH;
			onButtonClick = "closeDialog 0;";
			text="$STR_TAA_TAG_OK";
		};
		class RscButton_2700: TAAButtonMenu_action
		{
		idc=-1;
			x = 0.561912 * safezoneW + safezoneX;
			y = 0.719975 * safezoneH + safezoneY;
			w = 0.0670709 * safezoneW;
			h = 0.0219975 * safezoneH;
			onButtonClick = "closeDialog 0;";
			text="$STR_TAA_TAG_CANCEL";
		};
		class RscButton_sq: TAAButtonMenu_action
		{
			idc=-1;
			x = 0.293628 * safezoneW + safezoneX;
			y = 0.719975 * safezoneH + safezoneY;
			w = 0.0670709 * safezoneW;
			h = 0.0219975 * safezoneH;
			toolTip = "$STR_TAA_TAG_ASSIGN";
			onButtonClick = "TAA_name_HUD_key_ID = (findDisplay 10000) displayAddEventHandler ['KeyDown', '_this select 1 call fnc_assign_key;'];";
			text="$STR_TAA_TAG_ASSIGN_TXT";
		};
		class RscButton_perm: TAAButtonMenu_action
		{
			idc=-1;
			x = 0.365858 * safezoneW + safezoneX;
			y = 0.719975 * safezoneH + safezoneY;
			w = 0.0670709 * safezoneW;
			h = 0.0219975 * safezoneH;
			toolTip = "";
			onButtonClick = "createDialog 'TAA_Custom_settings';";
			text="Custom";
		};
		class RscButton_1600: TAAButton
		{
			idc = 1600;
			x = 0.57739 * safezoneW + safezoneX;
			y = 0.654 * safezoneH + safezoneY;
			w = 0.0877082 * safezoneW;
			h = 0.0219975 * safezoneH;
			text="$STR_TAA_TAG_APPLY_TXT";
			action="[] execVM 'TAA_name\GUI\fnc\taa_color_apply.sqf'";
		};
    };
};

