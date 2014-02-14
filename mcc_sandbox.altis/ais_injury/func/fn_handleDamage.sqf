// by BonInf*
// changed by psycho, chessmaster42
private ['_agony','_unit','_bodypart','_damage','_source','_ammo','_return','_revive_factor'];
_unit 		= _this select 0;
_bodypart	= _this select 1;
_damage		= _this select 2;
_source		= _this select 3;
_ammo		= _this select 4;

//Stop any damage that doesn't have a source defined
//This is a known bug with HandleDamage EVH
if(isNull _source) exitwith {0};

//Make unconscious/agony players take no damage while in the captive state
//This state is intentionally lost via the FSM if the unit fires a weapon
if((_unit getVariable "tcb_ais_agony") && (captive _unit) && (isPlayer _unit)) exitwith {
	0
};

if (!(_unit getVariable "tcb_ais_agony") && {alive _unit}) then {
	_return = _damage / (tcb_ais_rambofactor max 1);
	_revive_factor = (tcb_ais_rambofactor max 1) * 1.5;
	_agony = false;

	switch _bodypart do {
		case "body" : {
			_damage = (_unit getVariable "tcb_ais_bodyhit") + _return;
			_unit setVariable ["tcb_ais_bodyhit", _damage];
			if (_damage >= 0.9) then {
				_unit allowDamage false;
				_agony = true;
				if (!tcb_ais_revive_guaranty) then {
					if (_damage > _revive_factor) then {_unit setVariable ["tcb_ais_unit_died", true]};
				};
			} else {
				_unit setHit ["body", _damage];
			};
		};
		
		if (tcb_ais_realistic_mode) then {
			case "head" : {
				_damage = (_unit getVariable "tcb_ais_headhit") + _return;
				_unit setVariable ["tcb_ais_headhit", _damage];
				if (_damage >= 0.9) then {
					_agony = true;
					if (!tcb_ais_revive_guaranty) then {
						if (_damage > _revive_factor) then {_unit setVariable ["tcb_ais_unit_died", true]};
					};
				} else {
					_unit setHit ["head", _damage];
				};
			};
		} else {
			case "head" : {};
		};
		
		case "legs" : {
			_damage = (_unit getVariable "tcb_ais_legshit") + _return;
			_unit setVariable ["tcb_ais_legshit", _damage];
			if (_damage >= 1.8) then {
				_agony = true;
			} else {
				_unit setHit ["legs",_damage];
			};
		};
		case "legs_l" : {
			_damage = (_unit getVariable "tcb_ais_legshit") + _return;
			_unit setVariable ["tcb_ais_legshit", _damage];
			if (_damage >= 1.8) then {
				_agony = true;
			} else {
				_unit setHit ["legs",_damage];
			};
		};
		case "legs_r" : {
			_damage = (_unit getVariable "tcb_ais_legshit") + _return;
			_unit setVariable ["tcb_ais_legshit", _damage];
			if (_damage >= 1.8) then {
				_agony = true;
			} else {
				_unit setHit ["legs",_damage];
			};
		};
		case "hands" : {
			_damage = (_unit getVariable "tcb_ais_handshit") + _return;
			_unit setVariable ["tcb_ais_handshit", _damage];
			if (_damage >= 2.3) then {
				_agony = true;
			} else {
				_unit setHit ["hands",_damage];
			};
		};
		case "hands_l" : {
			_damage = (_unit getVariable "tcb_ais_handshit") + _return;
			_unit setVariable ["tcb_ais_handshit", _damage];
			if (_damage >= 2.3) then {
				_agony = true;
			} else {
				_unit setHit ["hands",_damage];
			};
		};
		case "hands_r" : {
			_damage = (_unit getVariable "tcb_ais_handshit") + _return;
			_unit setVariable ["tcb_ais_handshit", _damage];
			if (_damage >= 2.3) then {
				_agony = true;
			} else {
				_unit setHit ["hands",_damage];
			};
		};
		
		case "" : {
			_damage = (damage vehicle _unit) + _return; //(_unit getVariable "tcb_ais_overall") + _return;
			_unit setVariable ["tcb_ais_overall", _damage];
			if (_damage >= 0.9) then {
				_unit allowDamage false;
				_agony = true;
				if (!tcb_ais_revive_guaranty) then {
					if (_damage > _revive_factor) then {_unit setVariable ["tcb_ais_unit_died", true]};
				};
			} else {
				_unit setDamage _damage;
			};
		};
		default {};
	};

	if (_agony && {!(_unit getVariable "tcb_ais_agony")}) exitwith {
		_unit setVariable ["tcb_ais_agony", true];
		_delay = time + 5;
		_unit setVariable ["tcb_ais_fall_in_agony_time_delay", _delay];
	};
    
	_return = 0;
} else {
	if (!alive _unit) exitWith {_unit setVariable ["tcb_ais_unit_died", true]; _damage};
	if (time > (_unit getVariable "tcb_ais_fall_in_agony_time_delay")) then {
		_unit setVariable ["tcb_ais_unit_died", true];
	};
	
	_return = _unit getVariable "tcb_ais_overall";
};

//Necessary for BIS stuff to work
//BIS_hitArray = [_unit, _bodypart, _damage, _source, _ammo];
//BIS_wasHit = true;

//_return

//Fix for critical damage. Players are still wounded but cannot die from a single, large amount of damage
_unit setDamage 0;
0