#include "..\script_component.hpp"

params ["_caller", "_target", "_hitPoint", "_className"];
TRACE_4("params",_caller,_target,_hitPoint,_className);

private _config = (configFile >> "ACE_Repair" >> "Actions" >> _className);
if !(isClass _config) exitWith {false}; // or go for a default?

private _engineerRequired = if (isNumber (_config >> "requiredEngineer")) then {
    getNumber (_config >> "requiredEngineer");
} else {
    // Check for required class
    if (isText (_config >> "requiredEngineer")) exitWith {
        missionNamespace getVariable [(getText (_config >> "requiredEngineer")), 0];
    };
    0;
};
if !([_caller, _engineerRequired] call ace_repair_fnc_isEngineer) exitWith {false};

if ((isEngineOn _target) && {ACEVAR(repair,autoShutOffEngineWhenStartingRepair)}) then {
    [QACEVAR(common,engineOn), [_target, false], _target] call CBA_fnc_targetEvent;
};
if ((isEngineOn _target) && {!ACEVAR(repair,autoShutOffEngineWhenStartingRepair)}) exitWith {
    [ACESTRING(shutOffEngineWarning), 1.5, _caller] call ace_common_fnc_displayTextStructured;
    false
};

private _items = _config call ace_repair_fnc_getRepairItems;
if (_items isNotEqualTo [] && {!([_caller, _items] call ace_repair_fnc_hasItems)}) exitWith {false};

private _return = true;
if (getText (_config >> "condition") != "") then {
    private _condition = getText (_config >> "condition");
    if (isNil _condition) then {
        _condition = compile _condition;
    } else {
        _condition = missionNamespace getVariable _condition;
    };
    if (_condition isEqualType false) then {
        _return = _condition;
    } else {
        _return = [_caller, _target, _hitPoint, _className] call _condition;
    };
};
if (!_return) exitWith {false};

// private _vehicleStateCondition = if (isText(_config >> "vehicleStateCondition")) then {
    // missionNamespace getVariable [getText(_config >> "vehicleStateCondition"), 0]
// } else {
    // getNumber(_config >> "vehicleStateCondition")
// };
// if (_vehicleStateCondition == 1 && {!([_target] call FUNC(isInStableCondition))}) exitWith {false};

private _repairLocations = getArray (_config >> "repairLocations");
if !("All" in _repairLocations) then {
    private _repairFacility = {([_caller] call ace_repair_fnc_isInRepairFacility) || ([_target] call ace_repair_fnc_isInRepairFacility)};
    private _repairVeh = {([_caller] call ace_repair_fnc_isNearRepairVehicle) || ([_target] call ace_repair_fnc_isNearRepairVehicle)};
    {
        if (_x == "field") exitWith {_return = true;};
        if (_x == "RepairFacility" && _repairFacility) exitWith {_return = true;};
        if (_x == "RepairVehicle" && _repairVeh) exitWith {_return = true;};
        if (!isNil _x) exitWith {
            private _val = missionNamespace getVariable _x;
            if (_val isEqualType 0) then {
                _return = switch (_val) do {
                    case 0: {true}; //useAnywhere
                    case 1: {call _repairVeh}; //repairVehicleOnly
                    case 2: {call _repairFacility}; //repairFacilityOnly
                    case 3: {(call _repairFacility) || {call _repairVeh}}; //vehicleAndFacility
                    default {false}; //Disabled
                };
            };
        };
    } forEach _repairLocations;
};

private _requiredObjects = getArray (_config >> "claimObjects");
private _claimObjectsAvailable = [];
if (_requiredObjects isNotEqualTo []) then {
    _claimObjectsAvailable = [_caller, 5, _requiredObjects, true] call ace_repair_fnc_getClaimObjects;
    if (_claimObjectsAvailable isEqualTo []) then {
        TRACE_2("Missing Required Objects",_requiredObjects,_claimObjectsAvailable);
        _return = false
    };
};

if !(_return && alive _target) exitWith {false};
//Last exitWith: repair_success or repair_failure will be run

//Claim required objects
{
    TRACE_2("Claiming",_x,(typeOf _x));
    [_caller, _x, false] call ace_common_fnc_claim;
} forEach _claimObjectsAvailable;

private _consumeItems = if (isNumber (_config >> "itemConsumed")) then {
    getNumber (_config >> "itemConsumed");
} else {
    // Check for required class
    if (isText (_config >> "itemConsumed")) exitWith {
        missionNamespace getVariable [(getText (_config >> "itemConsumed")), 0];
    };
    0;
};

private _usersOfItems = [];
if (_consumeItems > 0) then {
    _usersOfItems = ([_caller, _items] call ace_repair_fnc_useItems) select 1;
};

// Parse the config for the progress callback
private _callbackProgress = getText (_config >> "callbackProgress");
if (_callbackProgress == "") then {
    _callbackProgress = {
        (_this select 0) params ["_caller", "_target", "", "", "", "", "_claimObjectsAvailable"];
        (
            (alive _target) &&
            {(abs speed _target) < 1} && // make sure vehicle doesn't drive off
            {_claimObjectsAvailable findIf {!alive _x || {_x getVariable [QACEVAR(common,owner), objNull] isNotEqualTo _caller}} == -1} // make sure claim objects are still available
        )
    };
} else {
    if (isNil _callbackProgress) then {
        _callbackProgress = compile _callbackProgress;
    } else {
        _callbackProgress = missionNamespace getVariable _callbackProgress;
    };
};


// Player Animation
private _callerAnim = [getText (_config >> "animationCaller"), getText (_config >> "animationCallerProne")] select (stance _caller == "PRONE");
private _loopAnim = (getNumber (_config >> "loopAnimation")) isEqualTo 1;

private _currentWeapon = currentWeapon _caller;

if (_currentWeapon != "") then {
    _caller setVariable [QACEVAR(repair,selectedWeaponOnrepair), (weaponState _caller) select [0, 3]];
};

// Cannot use secondairy weapon for animation
if (_currentWeapon == secondaryWeapon _caller) then {
    _caller selectWeapon (primaryWeapon _caller);
};

private _wpn = ["non", "rfl", "pst"] select (1 + ([primaryWeapon _caller, handgunWeapon _caller] find (currentWeapon _caller)));
_callerAnim = [_callerAnim, "[wpn]", _wpn] call CBA_fnc_replace;
if (isNull objectParent _caller && {_callerAnim != ""}) then {
    if (primaryWeapon _caller == "") then {
        _caller addWeapon "ACE_FakePrimaryWeapon";
    };
    if (currentWeapon _caller == "") then {
        _caller selectWeapon (primaryWeapon _caller); // unit always has a primary weapon here
    };

    if !(_caller call ace_common_fnc_isSwimming) then {
        if (stance _caller == "STAND") then {
            _caller setVariable [QACEVAR(repair,repairPrevAnimCaller), "amovpknlmstpsraswrfldnon"];
        } else {
            _caller setVariable [QACEVAR(repair,repairPrevAnimCaller), animationState _caller];
        };
        _caller setVariable [QACEVAR(repair,repairCurrentAnimCaller), toLowerANSI _callerAnim];
        [_caller, _callerAnim] call ace_common_fnc_doAnimation;
    };
};

if (_loopAnim) then {
    private _animDoneEh = _caller addEventHandler ["AnimDone", {
        params ["_caller", "_anim"];
        if (_anim isEqualTo (_caller getVariable [QACEVAR(repair,repairCurrentAnimCaller), ""])) then {
            [{
                params ["_caller", "_anim"];
                if !(isNil {_caller getVariable QACEVAR(repair,repairCurrentAnimCaller)}) then {
                    TRACE_2("loop",_caller,_anim);
                    _this call ace_common_fnc_doAnimation
                };
            }, [_caller, _anim], 2.5] call CBA_fnc_waitAndExecute;
        };
    }];
    _caller setVariable [QACEVAR(repair,repairLoopAnimEh), _animDoneEh];
};

private _soundPosition = _caller modelToWorldVisualWorld (_caller selectionPosition "RightHand");
["Acts_carFixingWheel", _soundPosition, nil, 50] call ace_common_fnc_playConfigSound3D;

// Get repair time
private _repairTime = [
    configOf _target >> QACEVAR(repair,repairTimes) >> configName _config,
    "number",
    -1
] call CBA_fnc_getConfigEntry;

if (_repairTime < 0) then {
    _repairTime = if (isNumber (_config >> "repairingTime")) then {
        getNumber (_config >> "repairingTime");
    } else {
        if (isText (_config >> "repairingTime")) exitWith {
            private _repairTimeConfig = getText (_config >> "repairingTime");
            if (isNil _repairTimeConfig) then {
                _repairTimeConfig = compile _repairTimeConfig;
            } else {
                _repairTimeConfig = missionNamespace getVariable _repairTimeConfig;
            };
            if (_repairTimeConfig isEqualType 0) exitWith {
                _repairTimeConfig;
            };
            [_caller, _target, _hitPoint, _className] call _repairTimeConfig;
        };
        0;
    };
};

// Find localized string
private _hitPointClassname = if (_hitPoint isEqualType "") then {
    _hitPoint
} else {
    ((getAllHitPointsDamage _target) select 0) select _hitPoint
};
private _processText = getText (_config >> "displayNameProgress");
private _backupText = format [localize ACESTRING(RepairingHitPoint), _hitPointClassname];
private _text = _processText;
if (getNumber (_config >> "forceDisplayName") isNotEqualTo 1) then {
    _text = ([_hitPointClassname, _processText, _backupText] call ace_repair_fnc_getHitPointString) select 0;
};

TRACE_4("display",_hitPoint,_hitPointClassname,_processText,_text);

// Start repair
[
    _repairTime,
    [_caller, _target, _hitPoint, _className, _items, _usersOfItems, _claimObjectsAvailable],
    ace_repair_fnc_repair_success,
    ace_repair_fnc_repair_failure,
    _text,
    _callbackProgress,
    ["isNotSwimming", "isNotOnLadder"]
] call ace_common_fnc_progressBar;

// Display Icon
private _iconDisplayed = getText (_config >> "actionIconPath");
if (_iconDisplayed != "") then {
    [QACEVAR(repair,repairActionIcon), true, _iconDisplayed, [1,1,1,1], getNumber(_config >> "actionIconDisplayTime")] call ace_common_fnc_displayIcon;
};

// handle display of text/hints
private _displayText = "";
if (_target != _caller) then {
    _displayText = getText(_config >> "displayTextOther");
} else {
    _displayText = getText(_config >> "displayTextSelf");
};

if (_displayText != "") then {
    [QACEVAR(common,displayTextStructured), [[_displayText, [_caller] call ace_common_fnc_getName, [_target] call ace_common_fnc_getName], 1.5, _caller], [_caller]] call CBA_fnc_targetEvent;
};

true;
