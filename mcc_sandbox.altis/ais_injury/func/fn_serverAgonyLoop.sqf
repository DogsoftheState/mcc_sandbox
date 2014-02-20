// by chessmaster42
private["_unit"];
_unit = _this select 0;

if(isServer) then {
	if (isNil {_unit getVariable "tcb_ais_agony"}) then {
		_unit setVariable ["tcb_ais_agony", false];
	};

	if(tcb_ais_debugging) then {
		diag_log format ["Starting server agony loop for %1", _unit];
	};

	while{(_unit getVariable "tcb_ais_agony") && (alive _unit)} do {
		if(tcb_ais_debugging) then {
			diag_log format ["%1 agony state sending ...", _unit];
		};

		tcb_ais_in_agony = [_unit, true];
		publicVariable "tcb_ais_in_agony";

		if(tcb_ais_debugging) then {
			diag_log format ["%1 agony state sent", _unit];
		};

		sleep 15;
	};
};