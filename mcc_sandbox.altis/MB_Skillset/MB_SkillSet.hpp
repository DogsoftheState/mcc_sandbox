// MB_SkillSet_Tables is an array of skill tables.
// Each skill table is a unit-characteristic key, followed by an array of skill values.
//
// The unit-characteristic key is a string.  It is compared to each unit's RANK and CLASS NAME,
// and if either of those contains the specified key, then that table is applied.
// E.g. a key value of "_SL_F" would match any RANK or CLASS that contains that text - in this
//      case, all the "squad leader" classes of unit.
//
// Use values between 0.0 and 1.0, and set them so that the total can never be more than 1.0.

MB_SkillSet_CycleInterval = 30; // seconds between each skill adjustment cycle.
MB_SkillSet_UnitPause = 0.2;    // seconds between adjusting each unit during a skill adjustment cycle.

MB_SkillSet_Tables = [
	[ "",                         // DEFAULT SKILL SET - MUST COME FIRST!
		[                           // skills to apply
			["aimingSpeed",0.4,0.2],  // ["skillName",baseValue,plusRandom]
			["aimingAccuracy",0.2,0.4], 
			["aimingShake",0.7,0.3], 
			["spotDistance",0.7,0.2], 
			["spotTime",0.7,0.2], 
			["reloadSpeed",0.2,0.6], 
			["commanding",0.4,0.4], 
			["endurance",0.6,0.4], 
			["courage",0.5,0.5],  
			["general",0.6,0.4]  
		]
	],

	[ "_SL_F",                    // Squad Leaders
		[                           // (more skilled)
			["aimingSpeed",0.6,0.2],  //
			["aimingAccuracy",0.4,0.4], 
			["aimingShake",0.8,0.2], 
			["spotDistance",0.9,0.1], 
			["spotTime",0.8,0.2], 
			["reloadSpeed",0.2,0.6], 
			["commanding",0.8,0.2], 
			["endurance",0.4,0.4], 
			["courage",0.3,0.3],  
			["general",0.6,0.4]  
		]
	],

	[ "_TL_F",                    // Team Leaders
		[                           // (more skilled)
			["aimingSpeed",0.6,0.2],  
			["aimingAccuracy",0.4,0.4], 
			["aimingShake",0.7,0.3], 
			["spotDistance",0.9,0.1], 
			["spotTime",0.8,0.2], 
			["reloadSpeed",0.2,0.6], 
			["commanding",0.8,0.2], 
			["endurance",0.4,0.4], 
			["courage",0.3,0.3],  
			["general",0.6,0.4]  
		]
	],

	[ "_sniper_",                 // Snipers
		[                           // (accurate, but slow and methodical)
			["aimingSpeed",0.3,0.3],  
			["aimingAccuracy",0.7,0.3], 
			["aimingShake",0.9,0.1], 
			["spotDistance",0.9,0.1], 
			["spotTime",0.6,0.4], 
			["reloadSpeed",0.2,0.5], 
			["commanding",0.2,0.4], 
			["endurance",0.6,0.4], 
			["courage",0.3,0.3],  
			["general",0.6,0.4]  
		]
	],

	[ "_helipilot_",              // Pilots
		[                           // (not fighters!)
			["aimingSpeed",0.3,0.2],  
			["aimingAccuracy",0.2,0.4], 
			["aimingShake",0.8,0.2], 
			["spotDistance",0.6,0.2], 
			["spotTime",0.6,0.2], 
			["reloadSpeed",0.3,0.4], 
			["commanding",0.3,0.3], 
			["endurance",0.5,0.4], 
			["courage",0.3,0.4],  
			["general",0.5,0.5]  
		]
	],

	[ "_medic_",                  // Medics
		[                           // (not fighters!)
			["aimingSpeed",0.3,0.2],  
			["aimingAccuracy",0.2,0.4], 
			["aimingShake",0.8,0.2], 
			["spotDistance",0.6,0.2], 
			["spotTime",0.6,0.2], 
			["reloadSpeed",0.3,0.4], 
			["commanding",0.3,0.3], 
			["endurance",0.6,0.4], 
			["courage",0.3,0.4],  
			["general",0.5,0.5]  
		]
	],

	[ "_man_",                    // Civilians
		[                           // (less skilled than soldiers)
			["aimingSpeed",0.2,0.2],  
			["aimingAccuracy",0.1,0.5], 
			["aimingShake",0.7,0.2], 
			["spotDistance",0.6,0.2], 
			["spotTime",0.6,0.2], 
			["reloadSpeed",0.2,0.4], 
			["commanding",0.3,0.3], 
			["endurance",0.3,0.4], 
			["courage",0.3,0.4],  
			["general",0.4,0.4]  
		]
	],

	[ "SERGEANT",                 // Sergeants not otherwise covered above
		[                           // (these guys are tough)
			["aimingSpeed",0.6,0.2],  
			["aimingAccuracy",0.4,0.4], 
			["aimingShake",0.9,0.1], 
			["spotDistance",0.8,0.2], 
			["spotTime",0.8,0.2], 
			["reloadSpeed",0.4,0.6], 
			["commanding",0.8,0.2], 
			["endurance",0.7,0.3], 
			["courage",0.6,0.4],  
			["general",0.6,0.4]  
		]
	],

	[ "LIEUTENANT",                 // Sergeants
		[                           // (these guys are tough)
			["aimingSpeed",0.5,0.2],  
			["aimingAccuracy",0.4,0.4], 
			["aimingShake",0.7,0.3], 
			["spotDistance",0.7,0.2], 
			["spotTime",0.7,0.2], 
			["reloadSpeed",0.4,0.4], 
			["commanding",0.8,0.2], 
			["endurance",0.4,0.4], 
			["courage",0.3,0.3],  
			["general",0.6,0.4]  
		]
	],

	[ "CAPTAIN",                  // Captains
		[                           // (these guys are tough)
			["aimingSpeed",0.4,0.3],  
			["aimingAccuracy",0.3,0.4], 
			["aimingShake",0.8,0.2], 
			["spotDistance",0.7,0.2], 
			["spotTime",0.7,0.2], 
			["reloadSpeed",0.4,0.4], 
			["commanding",0.8,0.2], 
			["endurance",0.4,0.4], 
			["courage",0.3,0.3],  
			["general",0.6,0.4]  
		]
	],

	[ "MAJOR",                    // Majors
		[                           // (these guys are tough)
			["aimingSpeed",0.4,0.3],  
			["aimingAccuracy",0.3,0.4], 
			["aimingShake",0.8,0.2], 
			["spotDistance",0.7,0.2], 
			["spotTime",0.7,0.2], 
			["reloadSpeed",0.4,0.4], 
			["commanding",0.8,0.2], 
			["endurance",0.4,0.4], 
			["courage",0.3,0.3],  
			["general",0.6,0.4]  
		]
	],

	[ "COLONEL",                  // Colonels
		[                           // (Spend too much time doing admin)
			["aimingSpeed",0.4,0.2],  
			["aimingAccuracy",0.2,0.3], 
			["aimingShake",0.7,0.2], 
			["spotDistance",0.6,0.2], 
			["spotTime",0.6,0.2], 
			["reloadSpeed",0.3,0.3], 
			["commanding",0.8,0.2], 
			["endurance",0.4,0.3], 
			["courage",0.3,0.3],  
			["general",0.6,0.4]  
		]
	] // Note: last entry has no comma!
];