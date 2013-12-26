#define name_idc 5000

	
class Hud_struct_name:TAAStructuredText
{
			idc = -1;	 

			type = CT_STRUCTURED_TEXT;
			size = 0.040;
			x = 0.969219 * safezoneW + safezoneX;
			y = 0.225 * safezoneH + safezoneY;
			w = 0.134062 * safezoneW;
			h = 0.022 * safezoneH;
			colorText[] = {1,1,1,1};
			lineSpacing = 3;
			colorBackground[] = {0,0,0,0};
			text = "";
			font = "PuristaLight";
			shadow = 2;
			class Attributes {
				align = "center";
			};
		};
class TAA_dyn_name {
	idd = -1;
    fadeout=0;
    fadein=0;
	duration = 10000000000;
	name= "TAA_dyn_name";

	onLoad = "uiNamespace setVariable ['TAA_dyn_name', _this select 0]";
	class controlsBackground {
		class indexPlayer1:Hud_struct_name{idc = name_idc;};
		class indexPlayer2:Hud_struct_name{idc= 5001;};
		class indexPlayer3:Hud_struct_name{idc= 5002;};
		class indexPlayer4:Hud_struct_name{idc= 5003;};
		class indexPlayer5:Hud_struct_name{idc= 5004;};
		class indexPlayer6:Hud_struct_name{idc= 5005;};
		class indexPlayer7:Hud_struct_name{idc= 5006;};
		class indexPlayer8:Hud_struct_name{idc= 5007;};
		class indexPlayer9:Hud_struct_name{idc= 5008;};
		class indexPlayer10:Hud_struct_name{idc= 5009;};
		class indexPlayer11:Hud_struct_name{idc= 5010;};
		class indexPlayer12:Hud_struct_name{idc= 5011;};
		class indexPlayer13:Hud_struct_name{idc= 5012;};
		class indexPlayer14:Hud_struct_name{idc= 5013;};
		class indexPlayer15:Hud_struct_name{idc= 5014;};
		class indexPlayer16:Hud_struct_name{idc= 5015;};
		class indexPlayer17:Hud_struct_name{idc= 5016;};
		class indexPlayer18:Hud_struct_name{idc= 5017;};
		class indexPlayer19:Hud_struct_name{idc= 5018;};
		class indexPlayer20:Hud_struct_name{idc= 5019;};
		class indexPlayer21:Hud_struct_name{idc= 5020;};
		class indexPlayer22:Hud_struct_name{idc= 5021;};
		class indexPlayer23:Hud_struct_name{idc= 5022;};
		class indexPlayer24:Hud_struct_name{idc= 5023;};
		class indexPlayer25:Hud_struct_name{idc= 5024;};
		class indexPlayer26:Hud_struct_name{idc= 5025;};
		class indexPlayer27:Hud_struct_name{idc= 5026;};
		class indexPlayer28:Hud_struct_name{idc= 5027;};
		class indexPlayer29:Hud_struct_name{idc= 5028;};
		class indexPlayer30:Hud_struct_name{idc= 5029;};
		class indexPlayer31:Hud_struct_name{idc= 5030;};
		class indexPlayer32:Hud_struct_name{idc= 5031;};
		class indexPlayer33:Hud_struct_name{idc= 5032;};
		class indexPlayer34:Hud_struct_name{idc= 5033;};
		class indexPlayer35:Hud_struct_name{idc= 5034;};
		class indexPlayer36:Hud_struct_name{idc= 5035;};
		class indexPlayer37:Hud_struct_name{idc= 5036;};
		class indexPlayer38:Hud_struct_name{idc= 5037;};
		class indexPlayer39:Hud_struct_name{idc= 5038;};
		class indexPlayer40:Hud_struct_name{idc= 5039;};
		class indexPlayer41:Hud_struct_name{idc= 5040;};
		class indexPlayer42:Hud_struct_name{idc= 5041;};
		class indexPlayer43:Hud_struct_name{idc= 5042;};
		class indexPlayer44:Hud_struct_name{idc= 5043;};
		class indexPlayer45:Hud_struct_name{idc= 5044;};
		class indexPlayer46:Hud_struct_name{idc= 5045;};
		class indexPlayer47:Hud_struct_name{idc= 5046;};
		class indexPlayer48:Hud_struct_name{idc= 5047;};
		class indexPlayer49:Hud_struct_name{idc= 5048;};
		class indexPlayer50:Hud_struct_name{idc= 5049;};
		class indexPlayer51:Hud_struct_name{idc= 5050;};
		class indexPlayer52:Hud_struct_name{idc= 5051;};
		class indexPlayer53:Hud_struct_name{idc= 5052;};
		class indexPlayer54:Hud_struct_name{idc= 5053;};
		class indexPlayer55:Hud_struct_name{idc= 5054;};
		class indexPlayer56:Hud_struct_name{idc= 5055;};
		class indexPlayer57:Hud_struct_name{idc= 5056;};
		class indexPlayer58:Hud_struct_name{idc= 5057;};
		class indexPlayer59:Hud_struct_name{idc= 5058;};
		class indexPlayer60:Hud_struct_name{idc= 5059;};
		class indexPlayer61:Hud_struct_name{idc= 5060;};
		class indexPlayer62:Hud_struct_name{idc= 5061;};
		class indexPlayer63:Hud_struct_name{idc= 5062;};
        class indexPlayer64:Hud_struct_name{idc= 5063;};
        class Static_cursor:Hud_struct_name{idc= 7000;};
    };
};
