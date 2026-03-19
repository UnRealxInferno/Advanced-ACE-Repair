#include "..\script_component.hpp"
params ["_part"];
private["_part","_repair"];
private _type = typeOf _part;

private _initializedClasses = missionNamespace getVariable [QACEVAR(repair,initializedClasses),[]];
if (_type in _initializedClasses) exitWith {};
if (_type == "") exitWith {};

switch (_type) do {
    default                             {_repair = 20;};
    case "FL_parts_gunfcs":             {_repair = GVAR(GunFCSRepair)};
    case "FL_parts_turretdrive":        {_repair = GVAR(TurretDrive)};
    case "FL_parts_avionics":           {_repair = GVAR(Avionics)};
    case "FL_parts_controlsurfaces":    {_repair = GVAR(ControlSurfaces)};
    case "FL_parts_engineturbinesmall": {_repair = GVAR(EngTurbineSmall)};
    case "FL_parts_engineturbinelarge": {_repair = GVAR(EngTurbineLarge)};
    case "FL_parts_enginepistonsmall":  {_repair = GVAR(EngPistonSmall)};
    case "FL_parts_enginepistonmedium": {_repair = GVAR(EngPistonMedium)};
    case "FL_parts_enginepistonlarge":  {_repair = GVAR(EngPistonLarge)};
    case "FL_parts_rotorassembly":      {_repair = GVAR(RotorAssembly)};
    case "FL_parts_fueltanksmall":      {_repair = GVAR(FuelTankSmall)};
    case "FL_parts_fueltanklarge":      {_repair = GVAR(FuelTankLarge)};
    case "ACE_Wheel":                   {_repair = GVAR(WheelRepair)};
    case "ACE_Track":                   {_repair = GVAR(TrackRepair)};
};

private _icon = ["a3\ui_f\data\igui\cfg\actions\repair_ca.paa", "#FFFFFF"];
private _text = localize LSTRING(AdvMajorRepair);
private _text2 = format ["%1 %2%%",_text,_repair];
private _condition = {[_this select 1, _this select 0, "", "AdvMajorRepair"] call ace_repair_fnc_canRepair};
private _statement = {[_this select 1, _this select 0, "", "AdvMajorRepair"] call ace_repair_fnc_repair};
private _action = ["AdvMajorRepair", _text2, _icon, _statement, _condition, {}, [], "", 4] call ace_interact_menu_fnc_createAction;
[_type, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToClass;

_initializedClasses pushBack _type;
missionNamespace setVariable [QACEVAR(repair,initializedClasses),_initializedClasses];
20
