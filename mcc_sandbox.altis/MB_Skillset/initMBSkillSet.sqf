[] Spawn 
{
  waituntil {time > 1};
  
  if ((! IsServer) && (IsMultiplayer)) then // only do it on the server
  {
    waituntil {Time > 5}; 
    hint "MB_SkillSet disabled on multiplayer client.";
  }
  else
  {
    // Set default skillset table and settings...
    MB_SkillSet_Tables =  
      [ 
        [ "",                         // default skill set
          [                           // skills to apply
            ["aimingSpeed",0.3,0.2],  // ["skillName",baseValue,plusRandom]
            ["aimingAccuracy",0.4,0.2], 
            ["aimingShake",0.5,0.5], 
            ["spotDistance",0.6,0.4], 
            ["spotTime",0.3,0.7], 
            ["reloadSpeed",0.2,0.6], 
            ["commanding",0.6,0.4], 
            ["endurance",0.6,0.4], 
            ["courage",0.4,0.6],  
            ["general",0.5,0.5]  
          ]
        ]
      ];

    MB_SkillSet_CycleInterval = 30; // seconds between each skill adjustment cycle.
    MB_SkillSet_UnitPause = 0.2;    // seconds between adjusting each unit during a skill adjustment cycle.

    // Load custom skillset table and settings to override above defaults...
    _handle = [] ExecVM "MB_SkillSet.hpp";
    waitUntil {scriptDone _handle};

    while {true} do
    {
      {
        sleep MB_SkillSet_UnitPause; // pause between each unit, so the CPU load per frame is negligable.

        _unit = _x;

	_unitInfo = rank _unit + "+" + typeOf _unit; // used to select skill table by key.

        _skillTable = MB_SkillSet_Tables select 0; // assume default skill table

        {
          // Select the appropriate skill table for this unit...
          _skillKey = _x select 0;
          if (_skillKey != "") then
          {
            _match = [_skillKey,_unitInfo] call BIS_fnc_inString; // is key found in _UnitInfo?
            if (_match) exitWith { _skillTable = _x };            // if so use this skill table!
          }
        } foreach MB_SkillSet_Tables;
        // if no match, skill table will still be the default.

        // Apply the settings in the selected skill table...

        _skillValues = _skillTable select 1;

        {
          _name = _x select 0;
          _value = _x select 1;
          _rand = _x select 1;
          if ( _rand != 0 ) then // random 0.0 might be problematic?
          {
            _value = _value + (random _rand);
          };
          _unit setSkill [ _name, _value ];
        } forEach _skillValues;

      } forEach allUnits;

      sleep MB_SkillSet_CycleInterval; // wait a while before adjusting the skills again.

    }; // while true

  }; // else

};