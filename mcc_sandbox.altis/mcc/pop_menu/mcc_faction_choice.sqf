private ["_Cfgside","_i","_j","_Cfgfaction","_k","_Cfgtype","_cfgname","_factionDisplayName","_CfgfactionName"];
if (isNil "mcc_faction") exitWith {}; 
//Create the groups type array
#define CONFIG (configFile >> "CfgGroups" )
MCC_groupTypes = []; 
_factionDisplayName = getText (configFile >> "CfgFactionClasses" >> MCC_faction >> "displayName");

for "_i" from 0 to ((count CONFIG) - 1)  do
{
    _Cfgside = (CONFIG select _i);  
    if (isClass(_cfgside)) then
	{
        for "_j" from 0 to ((count _Cfgside) - 1) do
		 
		 {
		    _Cfgfaction 	= (_cfgside select _j); 
            if (isClass(_cfgfaction)) then
			{
				_CfgfactionName	= getText (_cfgfaction >> "name");
				if (_CfgfactionName == _factionDisplayName) then 
					{
						for "_k" from 0 to ((count _Cfgfaction) - 1) do
						{
							_Cfgtype = (_cfgfaction select _k); 
							if (isClass(_cfgtype)) then
							{
								_cfgname 		= configname(_cfgtype );
								_cfgDisplayname = getText (_Cfgtype >> "name");
								MCC_groupTypes set [count MCC_groupTypes, [_cfgname,_cfgDisplayname]]; 
							};
						};
					};
			};
		 };
    };
};

//Add this two for general stuff
MCC_groupTypes set [count MCC_groupTypes, ["Paratroopers","Paratroopers"]]; 
MCC_groupTypes set [count MCC_groupTypes, ["Garrison","Garrison"]]; 

GEN_INFANTRY   		= [mcc_sidename,mcc_faction,(MCC_groupTypes select 0) select 0,"LAND"]   call mcc_make_array_grps;

/*// Load all possible groups from the config into the menu array format in arrays above
GEN_MECHANIZED 		= [mcc_sidename,mcc_faction, (MCC_groupTypes select SPAWNBRANCH) select 0,"LAND"] call mcc_make_array_grps;
GEN_MOTORIZED  		= [mcc_sidename,mcc_faction,"Motorized","LAND"]  call mcc_make_array_grps;
GEN_AIR        		= [mcc_sidename,mcc_faction,"Air","AIR"]         call mcc_make_array_grps;
GEN_ARMOR      		= [mcc_sidename,mcc_faction,"Armored","LAND"]    call mcc_make_array_grps;
GEN_SPECOPS   		= [mcc_sidename,mcc_faction,"SpecOps","WATER"]   call mcc_make_array_grps;
GEN_SUPPORT  		= [mcc_sidename,mcc_faction,"Support","LAND"]   call mcc_make_array_grps;
*/

// Create the units
// Load the different units into the arrays above
U_GEN_SHIP 			= [];
U_GEN_AIRPLANE		= [];
U_GEN_HELICOPTER 	= [];
U_GEN_TANK 			= [];
U_GEN_MOTORCYCLE	= [];
U_GEN_CAR			= [];
U_GEN_SOLDIER    	= [];

call mcc_make_array_units;

// Load DOC -> Dynamic Object Compositions

GEN_DOC1 = [];
GEN_DOC1 = [mcc_faction,0]  call mcc_make_array_comp;

if (!mcc_firstTime) then 
	{
	closeDialog 0;
	nul=[] execVM MCC_path + "mcc\Dialogs\mcc_PopupMenu.sqf";
	}
	else {mcc_firstTime=false}; //If it's not first time refresh the menu
