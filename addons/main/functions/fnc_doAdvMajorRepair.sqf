#include "..\script_component.hpp"

params ["_unit", "_vehicle", "_hitPoint"];
private["_unit", "_vehicle", "_hitPoint", "_repair"];
TRACE_3("params",_unit,_vehicle,_hitPoint);

_classname = typeOf _vehicle;

switch (_classname) do {
    default                             {_repair = 0.20;};
    case "FL_parts_gunfcs":             {_repair = GVAR(GunFCSRepair)/100};
    case "FL_parts_turretdrive":        {_repair = GVAR(TurretDrive)/100};
    case "FL_parts_avionics":           {_repair = GVAR(Avionics)/100};
    case "FL_parts_controlsurfaces":    {_repair = GVAR(ControlSurfaces)/100};
    case "FL_parts_engineturbinesmall": {_repair = GVAR(EngTurbineSmall)/100};
    case "FL_parts_engineturbinelarge": {_repair = GVAR(EngTurbineLarge)/100};
    case "FL_parts_enginepistonsmall":  {_repair = GVAR(EngPistonSmall)/100};
    case "FL_parts_enginepistonmedium": {_repair = GVAR(EngPistonMedium)/100};
    case "FL_parts_enginepistonlarge":  {_repair = GVAR(EngPistonLarge)/100};
    case "FL_parts_rotorassembly":      {_repair = GVAR(RotorAssembly)/100};
    case "FL_parts_fueltanksmall":      {_repair = GVAR(FuelTankSmall)/100};
    case "FL_parts_fueltanklarge":      {_repair = GVAR(FuelTankLarge)/100};
    case "ACE_Wheel":                   {_repair = GVAR(WheelRepair)/100};
    case "ACE_Track":                   {_repair = GVAR(TrackRepair)/100};
};

// get current hitpoint damage
private _VehPointDamage = damage _vehicle;

_newdamage = _VehPointDamage - _repair;
if (_newdamage <= 0) then {
	_newdamage = 0;
};

[QACEVAR(repair,setVehicleDamage), [_vehicle, _newdamage], _vehicle] call CBA_fnc_targetEvent;

// display text message if enabled
if (ACEVAR(repair,DisplayTextOnRepair)) then {
    [localize LSTRING(AdvMajorRepaired)] call ace_common_fnc_displayTextStructured;
};

_unit removeItem "advrepair_SpareParts";
