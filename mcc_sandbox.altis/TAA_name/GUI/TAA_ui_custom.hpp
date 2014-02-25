class TAA_Custom_settings{
    onLoad = "[] execVM 'TAA_name\GUI\fnc\taa_open_custom.sqf';";
    idd = 10001 ;
    movingenable=false;

    class controls
    {
       class TAA_BOX: TAA_CUS_BOX
        {
            idc = -1;
            text= "";
			x = 0.29375 * safezoneW + safezoneX;
			y = 0.225 * safezoneH + safezoneY;
			w = 0.4125 * safezoneW;
			h = 0.55 * safezoneH;
        };
		class RscFrame_1800: TAAFrame
		{
			idc = 1800;
			x = 0.29375 * safezoneW + safezoneX;
			y = 0.225 * safezoneH + safezoneY;
			w = 0.4125 * safezoneW;
			h = 0.55 * safezoneH;
		};
        class _TITLE: TAAText
        {
            idc = -1;
            moving = 1;
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])",
                                 "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.7])"};
            text= "Tag Name System V3.2 - custom";
			x = 0.29375 * safezoneW + safezoneX;
			y = 0.203 * safezoneH + safezoneY;
			w = 0.4125 * safezoneW;
			h = 0.022 * safezoneH;
        };
		class TAAListbox_1500: TAAListbox
		{
			idc = 1500;
			x = 0.304062 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.14 * safezoneW;
			h = 0.506 * safezoneH;
			onLBSelChanged="[] execVM 'TAA_name\GUI\fnc\taa_custom_player_color.sqf';";
		};

		class TAAButton_1601: TAAButton
		{
			idc = 1601;
			text = "$STR_TAA_TAG_APPLY_PLAYER"; //--- ToDo: Localize;
			x = 0.484531 * safezoneW + safezoneX;
			y = 0.687 * safezoneH + safezoneY;
			w = 0.0670312 * safezoneW;
			h = 0.022 * safezoneH;
			action="[] execVM 'TAA_name\GUI\fnc\taa_custom_apply.sqf';[] execVM 'TAA_name\GUI\fnc\taa_open_custom.sqf';";
		};
		class RscButton_1601: TAAButton
		{
			idc = 1601;
			x = 0.484531 * safezoneW + safezoneX;
			y = 0.731 * safezoneH + safezoneY;
			w = 0.0670312 * safezoneW;
			h = 0.022 * safezoneH;
			action="[] execVM 'TAA_name\GUI\fnc\taa_custom_reset.sqf';[] execVM 'TAA_name\GUI\fnc\taa_open_custom.sqf';";
			text="$STR_TAA_TAG_RESET";
		};
		class TAASlider_1900: TAASlider
		{
			idc = 1900;
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.357 * safezoneH + safezoneY;
			w = 0.2475 * safezoneW;
			h = 0.022 * safezoneH;
			onSliderPosChanged="((findDisplay 10001) displayCtrl 1900) ctrlSetTooltip format['%2 (Current : %1)',sliderPosition 1900,localize 'STR_TAA_TAG_RED'];[] execVM 'TAA_name\GUI\fnc\taa_custom_value.sqf';";
		};
		class TAASlider_1901: TAASlider
		{
			idc = 1901;
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.423 * safezoneH + safezoneY;
			w = 0.2475 * safezoneW;
			h = 0.022 * safezoneH;
			onSliderPosChanged="((findDisplay 10001) displayCtrl 1901) ctrlSetTooltip format['%2 (Current : %1)',sliderPosition 1901,localize 'STR_TAA_TAG_GREEN'];[] execVM 'TAA_name\GUI\fnc\taa_custom_value.sqf';";
		};
		class TAASlider_1902: TAASlider
		{
			idc = 1902;
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.489 * safezoneH + safezoneY;
			w = 0.2475 * safezoneW;
			h = 0.022 * safezoneH;
			onSliderPosChanged="((findDisplay 10001) displayCtrl 1902) ctrlSetTooltip format['%2 (Current : %1)',sliderPosition 1902,localize 'STR_TAA_TAG_BLUE'];[] execVM 'TAA_name\GUI\fnc\taa_custom_value.sqf';";
		};
		class TAAButtonMenu_2400: TAAButtonMenu
		{
			idc = 2400;
			x = 0.62375 * safezoneW + safezoneX;
			y = 0.687 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.022 * safezoneH;
			onButtonClick = "closeDialog 0;";
			text="$STR_TAA_TAG_OK";
		};
		class TAAText_1000: TAAText
		{
			idc = 1000;
			text = "$STR_TAA_TAG_RED"; //--- ToDo: Localize;
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.313 * safezoneH + safezoneY;
			w = 0.0567187 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class TAAText_1001: TAAText
		{
			idc = 1001;
			text = "$STR_TAA_TAG_GREEN"; //--- ToDo: Localize;
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.39 * safezoneH + safezoneY;
			w = 0.0567187 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class TAAText_1002: TAAText
		{
			idc = 1002;
			text = "$STR_TAA_TAG_BLUE"; //--- ToDo: Localize;
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.456 * safezoneH + safezoneY;
			w = 0.0567187 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class RscButtonMenu_2400: TAAButtonMenu_action
		{
			idc = 2400;
			x = 0.644375 * safezoneW + safezoneX;
			y = 0.775 * safezoneH + safezoneY;
			w = 0.061875 * safezoneW;
			h = 0.022 * safezoneH;
			text="$STR_TAA_TAG_CANCEL";
		};
		class RscButtonMenu_2401: TAAButtonMenu_action
		{
			idc = 2401;
			x = 0.577344 * safezoneW + safezoneX;
			y = 0.775 * safezoneH + safezoneY;
			w = 0.061875 * safezoneW;
			h = 0.022 * safezoneH;
			text="$STR_TAA_TAG_OK";
			};
		class RscStructuredText_1100: TAAStructuredText
		{
			idc = 1100;
			x = 0.567031 * safezoneW + safezoneX;
			y = 0.687 * safezoneH + safezoneY;
			w = 0.128906 * safezoneW;
			h = 0.066 * safezoneH;
		};
	};
};