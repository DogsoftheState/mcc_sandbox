private["_unit"];
_unit = _this select 0;

if(isServer) then {
	if (isNil {_unit getVariable "tcb_ais_agony"}) then {
		_unit setVariable ["tcb_ais_agony", false];
	};
	while{(_unit getVariable "tcb_ais_agony") && (alive _unit)} do {
		//diag_log format ["%1 agony state sending ...", _unit];

		tcb_ais_in_agony = [_unit, true];
		publicVariable "tcb_ais_in_agony";

		//diag_log format ["%1 agony state sent", _unit];

		sleep 15;
	};
};