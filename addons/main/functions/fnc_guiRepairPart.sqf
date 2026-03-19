#include "..\script_component.hpp"

_Display = findDisplay 1665;
_lnb = _Display displayCtrl 1400;

_target = missionNamespace getVariable (_lnb lnbData [0,3]);
_rowsel = lnbCurSelRow _lnb;
_partsel = _lnb lnbText [_rowsel,1];
_dmg = _target getHitPointDamage _partsel;
_partheal = parseNumber (_lnb lnbText [_rowsel,2]);
_finalhp = _dmg - _partheal / 100;

if (_dmg <= 0) exitWith {
    _lnb lnbSetText [[_rowsel,0],"100% HP"];
    hint "Selected part is not in need of any repair.";
};
if !(([player, "advrepair_SpareParts"] call BIS_fnc_hasItem)) exitWith {
    hint "No spare parts found in inventory.";
};

if (_finalhp < 0) then {
    _finalhp = 0;
};

player removeItem "advrepair_SpareParts";
[QACEVAR(repair,setWheelHitPointDamage), [_target, _partsel, _finalhp], _target] call CBA_fnc_targetEvent;
_newdmg = format ["%1%% HP",round((100 - 100 * _finalhp) * (10 ^ 2)) / (10 ^ 2)];
_lnb lnbSetText [[_rowsel,0],_newdmg];

hint "Repair Successful";
