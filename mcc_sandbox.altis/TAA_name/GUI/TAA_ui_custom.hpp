class TAA_Custom_settings{
    onLoad = "";
    idd = 10001 ;
    movingenable=false;

    class controls
    {
       class TAA_BOX: TAA_CUS_BOX
        {
            idc = -1;
            text= "";
			x = 0.29375 * safezoneW + safezoneX;
			y = 0.291 * safezoneH + safezoneY;
			w = 0.4125 * safezoneW;
			h = 0.396 * safezoneH;
        };
        class TAAFrame_1800: TAAFrame
        {
            idc = -1;
			x = 0.29375 * safezoneW + safezoneX;
			y = 0.291 * safezoneH + safezoneY;
			w = 0.4125 * safezoneW;
			h = 0.396 * safezoneH;
        };
        class _TITLE: TAAText
        {
            idc = -1;
            moving = 1;
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])",
                                 "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.7])"};
            text= "Tag Name System V3.1";
			x = 0.29375 * safezoneW + safezoneX;
			y = 0.269 * safezoneH + safezoneY;
			w = 0.4125 * safezoneW;
			h = 0.022 * safezoneH;
        };
		class TAAListbox_1500: TAAListbox
		{
			idc = 1500;
			x = 0.304062 * safezoneW + safezoneX;
			y = 0.313 * safezoneH + safezoneY;
			w = 0.128906 * safezoneW;
			h = 0.352 * safezoneH;
		};
		class TAAButton_1600: TAAButton
		{
			idc = 1600;
			text = "hide tag"; //--- ToDo: Localize;
			x = 0.453594 * safezoneW + safezoneX;
			y = 0.577 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class TAAButton_1601: TAAButton
		{
			idc = 1601;
			text = "apply for player"; //--- ToDo: Localize;
			x = 0.453594 * safezoneW + safezoneX;
			y = 0.533 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class TAASlider_1900: TAASlider
		{
			idc = 1900;
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.357 * safezoneH + safezoneY;
			w = 0.2475 * safezoneW;
			h = 0.022 * safezoneH;
			onSliderPosChanged="((findDisplay 10001) displayCtrl 1901) ctrlSetTooltip format['%2 (Current : %1)',sliderPosition 1901,localize 'STR_TAA_TAG_RED'];";
		};
		class TAASlider_1901: TAASlider
		{
			idc = 1901;
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.423 * safezoneH + safezoneY;
			w = 0.2475 * safezoneW;
			h = 0.022 * safezoneH;
			onSliderPosChanged="((findDisplay 10001) displayCtrl 1901) ctrlSetTooltip format['%2 (Current : %1)',sliderPosition 1901,localize 'STR_TAA_TAG_GREEN'];";
		};
		class TAASlider_1902: TAASlider
		{
			idc = 1902;
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.489 * safezoneH + safezoneY;
			w = 0.2475 * safezoneW;
			h = 0.022 * safezoneH;
			onSliderPosChanged="((findDisplay 10001) displayCtrl 1902) ctrlSetTooltip format['%2 (Current : %1)',sliderPosition 1902,localize 'STR_TAA_TAG_BLUE'];";
		};
		class TAAButton_1602: TAAButton
		{
			idc = 1602;
			text = "apply for group"; //--- ToDo: Localize;
			x = 0.453594 * safezoneW + safezoneX;
			y = 0.621 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.022 * safezoneH;
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
	};
};