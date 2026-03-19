#include "..\script_component.hpp"
/*
 * Author: commy2, kymckay
 * Checks if the vehicles class already has the actions initialized, otherwise add all available repair options. Calleed from init EH.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [vehicle] call ace_repair_fnc_addRepairActionsCar
 *
 * Public: No
 */
if !(ACEVAR(common,settingsInitFinished)) exitWith {
    ACEVAR(common,runAtSettingsInitialized) pushBack [FUNC(addAdvRepairActions), _this];
};

if !(hasInterface && {ACEVAR(repair,enabled)}) exitWith {};

params ["_vehicle"];
private _type = typeOf _vehicle;
TRACE_2("addAdvRepairActions",_vehicle,_type);

// do nothing if the class is already initialized
private _initializedClasses = missionNamespace getVariable [QACEVAR(repair,initializedClasses),[]];
if (_type in _initializedClasses) exitWith {};
if (_type == "") exitWith {};

// get selections to ignore
private _selectionsToIgnore = _vehicle call ace_repair_fnc_getSelectionsToIgnore;

// get all hitpoints and selections
(getAllHitPointsDamage _vehicle) params [["_hitPoints", []], ["_hitSelections", []]];  // Since 1.82 these are all lower case

// get hitpoints of wheels with their selections
([_vehicle] call ace_common_fnc_getWheelHitPointsWithSelections) params ["_wheelHitPoints", "_wheelHitSelections"];

private _hitPointsAddedNames = [];
private _hitPointsAddedStrings = [];
private _hitPointsAddedAmount = [];
private _icon = ["a3\ui_f\data\igui\cfg\actions\repair_ca.paa", "#FFFFFF"];

private _hitpointsMajor = [];
private _hitpointsMajorPart = [];
private _processedSelections = [];

private _vehCfg = configOf _vehicle;

private _vehenginesize = getNumber (_vehCfg >> "FL_advrepair" >> "vehicleenginesize");
private _vehfueltanksize = getNumber (_vehCfg >> "FL_advrepair" >> "vehiclefueltanksize");
private _veharmor = getNumber (_vehCfg  >> "FL_advrepair" >> "vehiclearmor");
private _vehengine = getText (_vehCfg  >> "FL_advrepair" >> "vehicleengine");
// Custom position can be defined via config for associated hitpoint
private _hitpointPositions = getArray (_vehCfg >> QACEVAR(repair,hitpointPositions));
// Get turret paths
private _turretPaths = ((fullCrew [_vehicle, "gunner", true]) + (fullCrew [_vehicle, "commander", true])) apply {_x # 3};

{
    private _selection = _x; 
    private _hitpoint = toLowerANSI (_hitPoints select _forEachIndex);

    // Skip ignored selections
    if (_forEachIndex in _selectionsToIgnore) then {
        TRACE_3("Skipping ignored hitpoint",_hitpoint,_forEachIndex,_selection);
        continue
    };

    if (_selection in _wheelHitSelections) then {
        
        private _position = compile format ["_target selectionPosition ['%1', 'HitPoints', 'AveragePoint'];", _selection];

        TRACE_3("Adding Wheel Actions",_hitpoint,_forEachIndex,_selection);

        // An action to replace the wheel is required
        private _name = format ["Replace_%1_%2", _forEachIndex, _hitpoint];
        private _text = localize ACESTRING(ReplaceWheel);
        private _condition = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceWheel"] call ace_repair_fnc_canRepair};
        private _statement = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceWheel"] call ace_repair_fnc_repair};
        private _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 2] call ace_interact_menu_fnc_createAction;
        [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;

        // Create a wheel interaction
        private _root = format ["Wheel_%1_%2", _forEachIndex, _hitpoint];
        private _action = [_root, localize ACESTRING(Wheel), ["","#FFFFFF"], {}, {true}, {}, [_hitpoint], _position, 2, nil, { call ace_repair_fnc_modifySelectionInteraction }] call ace_interact_menu_fnc_createAction;
        [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;

        // An action to remove the wheel is required
        private _name = format ["Remove_%1_%2", _forEachIndex, _hitpoint];
        private _text = localize ACESTRING(RemoveWheel);
        private _condition = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveWheel"] call ace_repair_fnc_canRepair};
        private _statement = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveWheel"] call ace_repair_fnc_repair};
        private _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 2] call ace_interact_menu_fnc_createAction;
        [_type, 0, [_root], _action] call ace_interact_menu_fnc_addActionToClass;

        // An action to patch the wheel is required.
        private _name = format ["Patch_%1_%2", _forEachIndex, _hitpoint];
        private _patchIcon = QPATHTOF(ui\patch_ca.paa);
        private _text = localize ACESTRING(PatchWheel);
        private _condition = {("vehicle" in ACEVAR(repair,patchWheelLocation)) && {[_this select 1, _this select 0, _this select 2 select 0, "PatchWheel"] call ace_repair_fnc_canRepair}};
        private _statement = {[_this select 1, _this select 0, _this select 2 select 0, "PatchWheel"] call ace_repair_fnc_repair};
        private _action = [_name, _text, _patchIcon, _statement, _condition, {}, [_hitpoint], _position, 2] call ace_interact_menu_fnc_createAction;
        [_type, 0, [_root], _action] call ace_interact_menu_fnc_addActionToClass;

        _hitpointsMajor pushBack _hitpoint;
        _hitpointsMajorPart pushBack "Spare Wheel";
    } else {
        // Some hitpoints do not have a selection but do have an armorComponent value (seems to mainly be RHS)
        // Ref https://community.bistudio.com/wiki/Arma_3_Damage_Enhancement
        // this code won't support identically named hitpoints (e.g. commander turret: Duplicate HitPoint name 'HitTurret')
        private _armorComponent = "";
        if (_selection == "") then {
            private _hitpointsCfg = "configName _x == _hitpoint" configClasses (_vehCfg >> "HitPoints");
            if (_hitpointsCfg isNotEqualTo []) then {
                _armorComponent = getText (_hitpointsCfg # 0 >> "armorComponent");
            };
            if (_armorComponent == "") then {
                {
                    private _turretHitpointCfg = ([_vehCfg, _x] call CBA_fnc_getTurret) >> "HitPoints";
                    private _hitpointsCfg = "configName _x == _hitpoint" configClasses _turretHitpointCfg;
                    if (_hitpointsCfg isNotEqualTo []) exitWith {
                        TRACE_2("turret hitpoint configFound",_hitpoint,_x);
                        _armorComponent = getText (_hitpointsCfg # 0 >> "armorComponent");
                    };
                } forEach _turretPaths;
            };
            if (_armorComponent != "") then { INFO_3("%1: %2 no selection: using armorComponent %3",_type,_hitpoint,_armorComponent); };
        };

        // Find the action position
        //IGNORE_PRIVATE_WARNING ["_target"];
        private _position = compile format ["_target selectionPosition ['%1', 'HitPoints'];", _selection];
        {
            _x params ["_hit", "_pos"];
            if (_hitpoint == _hit) exitWith {
                if (_pos isEqualType []) exitWith {
                    _position = _pos; // Position in model space
                };
                if (_pos isEqualType "") exitWith {
                    _position = compile format ["_target selectionPosition ['%1', 'HitPoints'];", _pos];
                };
                ERROR_3("Invalid custom position %1 of hitpoint %2 in vehicle %3.",_position,_hitpoint,_type);
            };
        } forEach _hitpointPositions;

        // if no selection then use the FireLOD to position the action
        if ((_selection == "") && {_position isEqualTo {_target selectionPosition ['', 'HitPoints'];}}) then {
            if ((_vehicle selectionPosition [_armorComponent, "FireGeometry"]) isEqualTo [0,0,0]) then {
                WARNING_3("[%1: %2: %3] armorComponent does not exist?",_type,_hitpoint,_armorComponent);
                _position = [0,0,0]; // just stick it on mainActions
            } else {
                _position = compile format ["_target selectionPosition ['%1', 'FireGeometry'];", _armorComponent];
            };
            TRACE_1("using armorComponent position",_position);
        };

        // Prepare the repair action
        private _name = format ["Repair_%1_%2", _forEachIndex, _selection];

        // Find localized string and track those added for numerization
        ([_hitpoint, "%1", _hitpoint, [_hitPointsAddedNames, _hitPointsAddedStrings, _hitPointsAddedAmount]] call ace_repair_fnc_getHitPointString) params ["_text", "_trackArray"];
        _hitPointsAddedNames = _trackArray select 0;
        _hitPointsAddedStrings = _trackArray select 1;
        _hitPointsAddedAmount = _trackArray select 2;
        if (_hitpoint in FUELTANK_HITPOINTS) exitWith {
            if (_vehfueltanksize == 0) then {
                if (_selection in _processedSelections) exitWith {TRACE_3("Duplicate Fueltank",_hitpoint,_forEachIndex,_selection);};
                

                private _position = compile format ["_target selectionPosition ['%1', 'HitPoints'];", _selection];

                TRACE_3("Adding engine Actions",_hitpoint,_forEachIndex,_selection);

                private _engineselect = [_vehenginesize,_vehengine] joinString "";
                // An action to remove the wheel is required
                private _name = format ["Remove_%1_%2", _forEachIndex, _hitpoint];
                private _text = localize LSTRING(RemoveFueltanksmall);
                private _condition = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveFueltanksmall"] call ace_repair_fnc_canRepair};
                private _statement = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveFueltanksmall"] call ace_repair_fnc_repair};
                private _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3, nil, ace_repair_fnc_modifySelectionInteraction] call ace_interact_menu_fnc_createAction;
                [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;

                // An action to replace the wheel is required
                _name = format ["Replace_%1_%2", _forEachIndex, _hitpoint];
                _text = localize LSTRING(ReplaceFueltanksmall);
                _condition = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceFueltanksmall"] call ace_repair_fnc_canRepair};
                _statement = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceFueltanksmall"] call ace_repair_fnc_repair};
                _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3] call ace_interact_menu_fnc_createAction;
                [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;

                _hitpointsMajor pushBack _hitpoint;
                _hitpointsMajorPart pushBack "Fuel Tank Small";              
            } else {
                if (_selection in _processedSelections) exitWith {TRACE_3("Duplicate Fueltank",_hitpoint,_forEachIndex,_selection);};
                

                private _position = compile format ["_target selectionPosition ['%1', 'HitPoints'];", _selection];

                TRACE_3("Adding engine Actions",_hitpoint,_forEachIndex,_selection);

                private _engineselect = [_vehenginesize,_vehengine] joinString "";
                // An action to remove the wheel is required
                private _name = format ["Remove_%1_%2", _forEachIndex, _hitpoint];
                private _text = localize LSTRING(RemoveFueltanklarge);
                private _condition = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveFueltanklarge"] call ace_repair_fnc_canRepair};
                private _statement = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveFueltanklarge"] call ace_repair_fnc_repair};
                private _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3, nil, ace_repair_fnc_modifySelectionInteraction] call ace_interact_menu_fnc_createAction;
                [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;

                // An action to replace the wheel is required
                _name = format ["Replace_%1_%2", _forEachIndex, _hitpoint];
                _text = localize LSTRING(ReplaceFueltanklarge);
                _condition = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceFueltanklarge"] call ace_repair_fnc_canRepair};
                _statement = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceFueltanklarge"] call ace_repair_fnc_repair};
                _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3] call ace_interact_menu_fnc_createAction;
                [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;

                _hitpointsMajor pushBack _hitpoint;
                _hitpointsMajorPart pushBack "Fuel Tank Large";     
            };
            _processedSelections pushBack _selection;
        };
		if (_hitpoint in GUN_HITPOINTS) exitWith {
            if (_selection in _processedSelections) exitWith {TRACE_3("Duplicate Avionics",_hitpoint,_forEachIndex,_selection);};

            private _position = compile format ["_target selectionPosition ['%1', 'HitPoints'];", _selection];

            TRACE_3("Adding Gun Actions",_hitpoint,_forEachIndex,_selection);

            private _engineselect = [_vehenginesize,_vehengine] joinString "";
            // An action to remove the wheel is required
            private _name = format ["Remove_%1_%2", _forEachIndex, _hitpoint];
            private _text = localize LSTRING(RemoveGunFCS);
            private _condition = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveGunFCS"] call ace_repair_fnc_canRepair};
            private _statement = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveGunFCS"] call ace_repair_fnc_repair};
            private _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3, nil, ace_repair_fnc_modifySelectionInteraction] call ace_interact_menu_fnc_createAction;
            [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;

            // An action to replace the wheel is required
            _name = format ["Replace_%1_%2", _forEachIndex, _hitpoint];
            _text = localize LSTRING(ReplaceGunFCS);
            _condition = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceGunFCS"] call ace_repair_fnc_canRepair};
            _statement = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceGunFCS"] call ace_repair_fnc_repair};
            _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3] call ace_interact_menu_fnc_createAction;
            [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;

            _hitpointsMajor pushBack _hitpoint;
            _hitpointsMajorPart pushBack "Gun FCS"; 
            _processedSelections pushBack _selection;   
        };
		if (_hitpoint in TURRET_HITPOINTS) exitWith {
            if (_selection in _processedSelections) exitWith {TRACE_3("Duplicate Avionics",_hitpoint,_forEachIndex,_selection);};
            

            private _position = compile format ["_target selectionPosition ['%1', 'HitPoints'];", _selection];

            TRACE_3("Adding Turret Actions",_hitpoint,_forEachIndex,_selection);

            private _engineselect = [_vehenginesize,_vehengine] joinString "";
            // An action to remove the wheel is required
            private _name = format ["Remove_%1_%2", _forEachIndex, _hitpoint];
            private _text = localize LSTRING(RemoveTurretdrive);
            private _condition = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveTurretdrive"] call ace_repair_fnc_canRepair};
            private _statement = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveTurretdrive"] call ace_repair_fnc_repair};
            private _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3, nil, ace_repair_fnc_modifySelectionInteraction] call ace_interact_menu_fnc_createAction;
            [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;

            // An action to replace the wheel is required
            _name = format ["Replace_%1_%2", _forEachIndex, _hitpoint];
            _text = localize LSTRING(ReplaceTurretdrive);
            _condition = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceTurretdrive"] call ace_repair_fnc_canRepair};
            _statement = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceTurretdrive"] call ace_repair_fnc_repair};
            _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3] call ace_interact_menu_fnc_createAction;
            [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;

            _hitpointsMajor pushBack _hitpoint;
            _hitpointsMajorPart pushBack "Turret Drive"; 
            _processedSelections pushBack _selection;
        };
        if (_vehicle isKindOf "Helicopter") exitWith {
		    if (_hitpoint in ROTOR_HITPOINTS) exitWith {
                if (_selection in _processedSelections) exitWith {TRACE_3("Duplicate RotorAssembly",_hitpoint,_forEachIndex,_selection);};
                

                private _position = compile format ["_target selectionPosition ['%1', 'HitPoints'];", _selection];

                TRACE_3("Adding Rotor Actions",_hitpoint,_forEachIndex,_selection);

                // An action to remove the wheel is required
                private _name = format ["Remove_%1_%2", _forEachIndex, _hitpoint];
                _text = localize LSTRING(RemoveRotorAssembly);
                private _condition = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveRotorAssembly"] call ace_repair_fnc_canRepair};
                private _statement = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveRotorAssembly"] call ace_repair_fnc_repair};
                private _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 8, nil, ace_repair_fnc_modifySelectionInteraction] call ace_interact_menu_fnc_createAction;
                [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;

                // An action to replace the wheel is required
                _name = format ["Replace_%1_%2", _forEachIndex, _hitpoint];
                _text = localize LSTRING(ReplaceRotorAssembly);
                _condition = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceRotorAssembly"] call ace_repair_fnc_canRepair};
                _statement = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceRotorAssembly"] call ace_repair_fnc_repair};
                _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 8] call ace_interact_menu_fnc_createAction;
                [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;


                _hitpointsMajor pushBack _hitpoint;
                _hitpointsMajorPart pushBack "Rotor Assembly"; 
                _processedSelections pushBack _selection;
            };
		    if (_hitpoint == "hitavionics") exitWith {
                if (_selection in _processedSelections) exitWith {TRACE_3("Duplicate Avionics",_hitpoint,_forEachIndex,_selection);};
                

                private _position = compile format ["_target selectionPosition ['%1', 'HitPoints'];", _selection];

                TRACE_3("Adding avionics Actions",_hitpoint,_forEachIndex,_selection);

                // An action to remove the wheel is required
                private _name = format ["Remove_%1_%2", _forEachIndex, _hitpoint];
                _text = localize LSTRING(RemoveAvionics);
                private _condition = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveAvionics"] call ace_repair_fnc_canRepair};
                private _statement = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveAvionics"] call ace_repair_fnc_repair};
                private _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3, nil, ace_repair_fnc_modifySelectionInteraction] call ace_interact_menu_fnc_createAction;
                [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;

                // An action to replace the wheel is required
                _name = format ["Replace_%1_%2", _forEachIndex, _hitpoint];
                _text = localize LSTRING(ReplaceAvionics);
                _condition = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceAvionics"] call ace_repair_fnc_canRepair};
                _statement = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceAvionics"] call ace_repair_fnc_repair};
                _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3] call ace_interact_menu_fnc_createAction;
                [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;


                _hitpointsMajor pushBack _hitpoint;
                _hitpointsMajorPart pushBack "Avionics"; 
                _processedSelections pushBack _selection;
            };
            if (_hitpoint in HELIENGINE_HITPOINTS) exitWith { 
                if (_selection in _processedSelections) exitWith {TRACE_3("Duplicate Avionics",_hitpoint,_forEachIndex,_selection);};
                

                private _position = compile format ["_target selectionPosition ['%1', 'HitPoints'];", _selection];

                TRACE_3("Adding engine Actions",_hitpoint,_forEachIndex,_selection);

                private _engineselect = [_vehenginesize,_vehengine] joinString "";
                switch (_engineselect) do {
                    default {
                        // An action to remove the wheel is required
                        private _name = format ["Remove_%1_%2", _forEachIndex, _hitpoint];
                        private _text = localize LSTRING(RemoveEnginepistonmedium);
                        private _condition = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveEnginepistonmedium"] call ace_repair_fnc_canRepair};
                        private _statement = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveEnginepistonmedium"] call ace_repair_fnc_repair};
                        private _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3, nil, ace_repair_fnc_modifySelectionInteraction] call ace_interact_menu_fnc_createAction;
                        [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;

                        // An action to replace the wheel is required
                        _name = format ["Replace_%1_%2", _forEachIndex, _hitpoint];
                        _text = localize LSTRING(ReplaceEnginepistonmedium);
                        _condition = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceEnginepistonmedium"] call ace_repair_fnc_canRepair};
                        _statement = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceEnginepistonmedium"] call ace_repair_fnc_repair};
                        _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3] call ace_interact_menu_fnc_createAction;
                        [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;

                        _hitpointsMajor pushBack _hitpoint;
                        _hitpointsMajorPart pushBack "Piston Engine Medium"; 
                    };
                    case "0piston": {
                        // An action to remove the wheel is required
                        private _name = format ["Remove_%1_%2", _forEachIndex, _hitpoint];
                        private _text = localize LSTRING(RemoveEnginepistonsmall);
                        private _condition = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveEnginepistonsmall"] call ace_repair_fnc_canRepair};
                        private _statement = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveEnginepistonsmall"] call ace_repair_fnc_repair};
                        private _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3, nil, ace_repair_fnc_modifySelectionInteraction] call ace_interact_menu_fnc_createAction;
                        [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;

                        // An action to replace the wheel is required
                        _name = format ["Replace_%1_%2", _forEachIndex, _hitpoint];
                        _text = localize LSTRING(ReplaceEnginepistonsmall);
                        _condition = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceEnginepistonsmall"] call ace_repair_fnc_canRepair};
                        _statement = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceEnginepistonsmall"] call ace_repair_fnc_repair};
                        _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3] call ace_interact_menu_fnc_createAction;
                        [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;
                        
                        _hitpointsMajor pushBack _hitpoint;
                        _hitpointsMajorPart pushBack "Piston Engine Small"; 
                    };
                    case "1piston": {
                        // An action to remove the wheel is required
                        private _name = format ["Remove_%1_%2", _forEachIndex, _hitpoint];
                        private _text = localize LSTRING(RemoveEnginepistonmedium);
                        private _condition = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveEnginepistonmedium"] call ace_repair_fnc_canRepair};
                        private _statement = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveEnginepistonmedium"] call ace_repair_fnc_repair};
                        private _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3, nil, ace_repair_fnc_modifySelectionInteraction] call ace_interact_menu_fnc_createAction;
                        [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;

                        // An action to replace the wheel is required
                        _name = format ["Replace_%1_%2", _forEachIndex, _hitpoint];
                        _text = localize LSTRING(ReplaceEnginepistonmedium);
                        _condition = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceEnginepistonmedium"] call ace_repair_fnc_canRepair};
                        _statement = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceEnginepistonmedium"] call ace_repair_fnc_repair};
                        _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3] call ace_interact_menu_fnc_createAction;
                        [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;
                        
                        _hitpointsMajor pushBack _hitpoint;
                        _hitpointsMajorPart pushBack "Piston Engine Medium"; 
                    };
                    case "2piston": {
                        // An action to remove the wheel is required
                        private _name = format ["Remove_%1_%2", _forEachIndex, _hitpoint];
                        private _text = localize LSTRING(RemoveEnginepistonlarge);
                        private _condition = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveEnginepistonlarge"] call ace_repair_fnc_canRepair};
                        private _statement = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveEnginepistonlarge"] call ace_repair_fnc_repair};
                        private _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3, nil, ace_repair_fnc_modifySelectionInteraction] call ace_interact_menu_fnc_createAction;
                        [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;

                        // An action to replace the wheel is required
                        _name = format ["Replace_%1_%2", _forEachIndex, _hitpoint];
                        _text = localize LSTRING(ReplaceEnginepistonlarge);
                        _condition = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceEnginepistonlarge"] call ace_repair_fnc_canRepair};
                        _statement = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceEnginepistonlarge"] call ace_repair_fnc_repair};
                        _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3] call ace_interact_menu_fnc_createAction;
                        [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;

                        
                        _hitpointsMajor pushBack _hitpoint;
                        _hitpointsMajorPart pushBack "Piston Engine Large"; 
                    };
                    case "1turbine":{
                        // An action to remove the wheel is required
                        private _name = format ["Remove_%1_%2", _forEachIndex, _hitpoint];
                        private _text = localize LSTRING(RemoveEngineturbinesmall);
                        private _condition = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveEngineturbinesmall"] call ace_repair_fnc_canRepair};
                        private _statement = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveEngineturbinesmall"] call ace_repair_fnc_repair};
                        private _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3, nil, ace_repair_fnc_modifySelectionInteraction] call ace_interact_menu_fnc_createAction;
                        [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;

                        // An action to replace the wheel is required
                        _name = format ["Replace_%1_%2", _forEachIndex, _hitpoint];
                        _text = localize LSTRING(ReplaceEngineturbinesmall);
                        _condition = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceEngineturbinesmall"] call ace_repair_fnc_canRepair};
                        _statement = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceEngineturbinesmall"] call ace_repair_fnc_repair};
                        _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3] call ace_interact_menu_fnc_createAction;
                        [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;

                        
                        _hitpointsMajor pushBack _hitpoint;
                        _hitpointsMajorPart pushBack "Turbine Engine Small"; 
                    };
                    case "2turbine":{
                        // An action to remove the wheel is required
                        private _name = format ["Remove_%1_%2", _forEachIndex, _hitpoint];
                        private _text = localize LSTRING(RemoveEngineturbinelarge);
                        private _condition = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveEngineturbinelarge"] call ace_repair_fnc_canRepair};
                        private _statement = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveEngineturbinelarge"] call ace_repair_fnc_repair};
                        private _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3, nil, ace_repair_fnc_modifySelectionInteraction] call ace_interact_menu_fnc_createAction;
                        [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;

                        // An action to replace the wheel is required
                        _name = format ["Replace_%1_%2", _forEachIndex, _hitpoint];
                        _text = localize LSTRING(ReplaceEngineturbinelarge);
                        _condition = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceEngineturbinelarge"] call ace_repair_fnc_canRepair};
                        _statement = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceEngineturbinelarge"] call ace_repair_fnc_repair};
                        _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3] call ace_interact_menu_fnc_createAction;
                        [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;
                        
                        _hitpointsMajor pushBack _hitpoint;
                        _hitpointsMajorPart pushBack "Turbine Engine Large"; 
                    };
                };
                _processedSelections pushBack _selection;
            };
        };
        if (_vehicle isKindOf "Plane") exitWith {
		    if (_hitpoint == "hitavionics") exitWith {
                if (_selection in _processedSelections) exitWith {TRACE_3("Duplicate Avionics",_hitpoint,_forEachIndex,_selection);};
                

                private _position = compile format ["_target selectionPosition ['%1', 'HitPoints'];", _selection];

                TRACE_3("Adding avionics Actions",_hitpoint,_forEachIndex,_selection);

                // An action to remove the wheel is required
                private _name = format ["Remove_%1_%2", _forEachIndex, _hitpoint];
                _text = localize LSTRING(RemoveAvionics);
                private _condition = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveAvionics"] call ace_repair_fnc_canRepair};
                private _statement = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveAvionics"] call ace_repair_fnc_repair};
                private _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3, nil, ace_repair_fnc_modifySelectionInteraction] call ace_interact_menu_fnc_createAction;
                [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;

                // An action to replace the wheel is required
                _name = format ["Replace_%1_%2", _forEachIndex, _hitpoint];
                _text = localize LSTRING(ReplaceAvionics);
                _condition = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceAvionics"] call ace_repair_fnc_canRepair};
                _statement = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceAvionics"] call ace_repair_fnc_repair};
                _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3] call ace_interact_menu_fnc_createAction;
                [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;


                _hitpointsMajor pushBack _hitpoint;
                _hitpointsMajorPart pushBack "Avionics"; 
                _processedSelections pushBack _selection;
            };
            if (_hitpoint == "hitengine" || _hitpoint == "hitengine2") exitWith { 
                if (_selection in _processedSelections) exitWith {TRACE_3("Duplicate Avionics",_hitpoint,_forEachIndex,_selection);};
                

                private _position = compile format ["_target selectionPosition ['%1', 'HitPoints'];", _selection];

                TRACE_3("Adding engine Actions",_hitpoint,_forEachIndex,_selection);

                private _engineselect = [_vehenginesize,_vehengine] joinString "";
                switch (_engineselect) do {
                    default {
                        // An action to remove the wheel is required
                        private _name = format ["Remove_%1_%2", _forEachIndex, _hitpoint];
                        private _text = localize LSTRING(RemoveEnginepistonmedium);
                        private _condition = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveEnginepistonmedium"] call ace_repair_fnc_canRepair};
                        private _statement = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveEnginepistonmedium"] call ace_repair_fnc_repair};
                        private _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3, nil, ace_repair_fnc_modifySelectionInteraction] call ace_interact_menu_fnc_createAction;
                        [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;

                        // An action to replace the wheel is required
                        _name = format ["Replace_%1_%2", _forEachIndex, _hitpoint];
                        _text = localize LSTRING(ReplaceEnginepistonmedium);
                        _condition = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceEnginepistonmedium"] call ace_repair_fnc_canRepair};
                        _statement = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceEnginepistonmedium"] call ace_repair_fnc_repair};
                        _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3] call ace_interact_menu_fnc_createAction;
                        [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;

                        _hitpointsMajor pushBack _hitpoint;
                        _hitpointsMajorPart pushBack "Piston Engine Medium"; 
                    };
                    case "0piston": {
                        // An action to remove the wheel is required
                        private _name = format ["Remove_%1_%2", _forEachIndex, _hitpoint];
                        private _text = localize LSTRING(RemoveEnginepistonsmall);
                        private _condition = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveEnginepistonsmall"] call ace_repair_fnc_canRepair};
                        private _statement = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveEnginepistonsmall"] call ace_repair_fnc_repair};
                        private _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3, nil, ace_repair_fnc_modifySelectionInteraction] call ace_interact_menu_fnc_createAction;
                        [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;

                        // An action to replace the wheel is required
                        _name = format ["Replace_%1_%2", _forEachIndex, _hitpoint];
                        _text = localize LSTRING(ReplaceEnginepistonsmall);
                        _condition = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceEnginepistonsmall"] call ace_repair_fnc_canRepair};
                        _statement = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceEnginepistonsmall"] call ace_repair_fnc_repair};
                        _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3] call ace_interact_menu_fnc_createAction;
                        [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;
                        
                        _hitpointsMajor pushBack _hitpoint;
                        _hitpointsMajorPart pushBack "Piston Engine Small"; 
                    };
                    case "1piston": {
                        // An action to remove the wheel is required
                        private _name = format ["Remove_%1_%2", _forEachIndex, _hitpoint];
                        private _text = localize LSTRING(RemoveEnginepistonmedium);
                        private _condition = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveEnginepistonmedium"] call ace_repair_fnc_canRepair};
                        private _statement = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveEnginepistonmedium"] call ace_repair_fnc_repair};
                        private _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3, nil, ace_repair_fnc_modifySelectionInteraction] call ace_interact_menu_fnc_createAction;
                        [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;

                        // An action to replace the wheel is required
                        _name = format ["Replace_%1_%2", _forEachIndex, _hitpoint];
                        _text = localize LSTRING(ReplaceEnginepistonmedium);
                        _condition = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceEnginepistonmedium"] call ace_repair_fnc_canRepair};
                        _statement = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceEnginepistonmedium"] call ace_repair_fnc_repair};
                        _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3] call ace_interact_menu_fnc_createAction;
                        [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;
                        
                        _hitpointsMajor pushBack _hitpoint;
                        _hitpointsMajorPart pushBack "Piston Engine Medium"; 
                    };
                    case "2piston": {
                        // An action to remove the wheel is required
                        private _name = format ["Remove_%1_%2", _forEachIndex, _hitpoint];
                        private _text = localize LSTRING(RemoveEnginepistonlarge);
                        private _condition = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveEnginepistonlarge"] call ace_repair_fnc_canRepair};
                        private _statement = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveEnginepistonlarge"] call ace_repair_fnc_repair};
                        private _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3, nil, ace_repair_fnc_modifySelectionInteraction] call ace_interact_menu_fnc_createAction;
                        [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;

                        // An action to replace the wheel is required
                        _name = format ["Replace_%1_%2", _forEachIndex, _hitpoint];
                        _text = localize LSTRING(ReplaceEnginepistonlarge);
                        _condition = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceEnginepistonlarge"] call ace_repair_fnc_canRepair};
                        _statement = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceEnginepistonlarge"] call ace_repair_fnc_repair};
                        _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3] call ace_interact_menu_fnc_createAction;
                        [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;

                        
                        _hitpointsMajor pushBack _hitpoint;
                        _hitpointsMajorPart pushBack "Piston Engine Large"; 
                    };
                    case "1turbine":{
                        // An action to remove the wheel is required
                        private _name = format ["Remove_%1_%2", _forEachIndex, _hitpoint];
                        private _text = localize LSTRING(RemoveEngineturbinesmall);
                        private _condition = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveEngineturbinesmall"] call ace_repair_fnc_canRepair};
                        private _statement = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveEngineturbinesmall"] call ace_repair_fnc_repair};
                        private _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3, nil, ace_repair_fnc_modifySelectionInteraction] call ace_interact_menu_fnc_createAction;
                        [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;

                        // An action to replace the wheel is required
                        _name = format ["Replace_%1_%2", _forEachIndex, _hitpoint];
                        _text = localize LSTRING(ReplaceEngineturbinesmall);
                        _condition = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceEngineturbinesmall"] call ace_repair_fnc_canRepair};
                        _statement = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceEngineturbinesmall"] call ace_repair_fnc_repair};
                        _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3] call ace_interact_menu_fnc_createAction;
                        [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;

                        
                        _hitpointsMajor pushBack _hitpoint;
                        _hitpointsMajorPart pushBack "Turbine Engine Small"; 
                    };
                    case "2turbine":{
                        // An action to remove the wheel is required
                        private _name = format ["Remove_%1_%2", _forEachIndex, _hitpoint];
                        private _text = localize LSTRING(RemoveEngineturbinelarge);
                        private _condition = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveEngineturbinelarge"] call ace_repair_fnc_canRepair};
                        private _statement = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveEngineturbinelarge"] call ace_repair_fnc_repair};
                        private _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3, nil, ace_repair_fnc_modifySelectionInteraction] call ace_interact_menu_fnc_createAction;
                        [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;

                        // An action to replace the wheel is required
                        _name = format ["Replace_%1_%2", _forEachIndex, _hitpoint];
                        _text = localize LSTRING(ReplaceEngineturbinelarge);
                        _condition = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceEngineturbinelarge"] call ace_repair_fnc_canRepair};
                        _statement = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceEngineturbinelarge"] call ace_repair_fnc_repair};
                        _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3] call ace_interact_menu_fnc_createAction;
                        [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;
                        
                        _hitpointsMajor pushBack _hitpoint;
                        _hitpointsMajorPart pushBack "Turbine Engine Large"; 
                    };
                };
                _processedSelections pushBack _selection;
            };
            if (_hitpoint in CONTROLSURFACES_HITPOINTS) exitWith {
                if (_selection in _processedSelections) exitWith {TRACE_3("Duplicate Avionics",_hitpoint,_forEachIndex,_selection);};
                

                private _position = compile format ["_target selectionPosition ['%1', 'HitPoints'];", _selection];

                TRACE_3("Adding control surface Actions",_hitpoint,_forEachIndex,_selection);

                // An action to remove the wheel is required
                private _name = format ["Remove_%1_%2", _forEachIndex, _hitpoint];
                private _text = localize LSTRING(RemoveControlsurfaces);
                private _condition = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveControlsurfaces"] call ace_repair_fnc_canRepair};
                private _statement = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveControlsurfaces"] call ace_repair_fnc_repair};
                private _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3, nil, ace_repair_fnc_modifySelectionInteraction] call ace_interact_menu_fnc_createAction;
                [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;

                // An action to replace the wheel is required
                _name = format ["Replace_%1_%2", _forEachIndex, _hitpoint];
                _text = localize LSTRING(ReplaceControlsurfaces);
                _condition = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceControlsurfaces"] call ace_repair_fnc_canRepair};
                _statement = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceControlsurfaces"] call ace_repair_fnc_repair};
                _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3] call ace_interact_menu_fnc_createAction;
                [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;
                
                
                _hitpointsMajor pushBack _hitpoint;
                _hitpointsMajorPart pushBack "Control Surfaces"; 
                _processedSelections pushBack _selection;
            };
        };
        if (_hitpoint == "hitengine") exitWith { 
            if (_selection in _processedSelections) exitWith {TRACE_3("Duplicate Avionics",_hitpoint,_forEachIndex,_selection);};
            

            private _position = compile format ["_target selectionPosition ['%1', 'HitPoints'];", _selection];

            TRACE_3("Adding engine Actions",_hitpoint,_forEachIndex,_selection);

            private _engineselect = [_vehenginesize,_vehengine] joinString "";
            switch (_engineselect) do {
                default {
                    // An action to remove the wheel is required
                    private _name = format ["Remove_%1_%2", _forEachIndex, _hitpoint];
                    private _text = localize LSTRING(RemoveEnginepistonmedium);
                    private _condition = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveEnginepistonmedium"] call ace_repair_fnc_canRepair};
                    private _statement = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveEnginepistonmedium"] call ace_repair_fnc_repair};
                    private _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3, nil, ace_repair_fnc_modifySelectionInteraction] call ace_interact_menu_fnc_createAction;
                    [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;

                    // An action to replace the wheel is required
                    _name = format ["Replace_%1_%2", _forEachIndex, _hitpoint];
                    _text = localize LSTRING(ReplaceEnginepistonmedium);
                    _condition = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceEnginepistonmedium"] call ace_repair_fnc_canRepair};
                    _statement = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceEnginepistonmedium"] call ace_repair_fnc_repair};
                    _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3] call ace_interact_menu_fnc_createAction;
                    [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;

                    _hitpointsMajor pushBack _hitpoint;
                    _hitpointsMajorPart pushBack "Piston Engine Medium"; 
                };
                case "0piston": {
                    // An action to remove the wheel is required
                    private _name = format ["Remove_%1_%2", _forEachIndex, _hitpoint];
                    private _text = localize LSTRING(RemoveEnginepistonsmall);
                    private _condition = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveEnginepistonsmall"] call ace_repair_fnc_canRepair};
                    private _statement = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveEnginepistonsmall"] call ace_repair_fnc_repair};
                    private _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3, nil, ace_repair_fnc_modifySelectionInteraction] call ace_interact_menu_fnc_createAction;
                    [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;

                    // An action to replace the wheel is required
                    _name = format ["Replace_%1_%2", _forEachIndex, _hitpoint];
                    _text = localize LSTRING(ReplaceEnginepistonsmall);
                    _condition = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceEnginepistonsmall"] call ace_repair_fnc_canRepair};
                    _statement = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceEnginepistonsmall"] call ace_repair_fnc_repair};
                    _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3] call ace_interact_menu_fnc_createAction;
                    [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;
                    
                    _hitpointsMajor pushBack _hitpoint;
                    _hitpointsMajorPart pushBack "Piston Engine Small"; 
                };
                case "1piston": {
                    // An action to remove the wheel is required
                    private _name = format ["Remove_%1_%2", _forEachIndex, _hitpoint];
                    private _text = localize LSTRING(RemoveEnginepistonmedium);
                    private _condition = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveEnginepistonmedium"] call ace_repair_fnc_canRepair};
                    private _statement = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveEnginepistonmedium"] call ace_repair_fnc_repair};
                    private _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3, nil, ace_repair_fnc_modifySelectionInteraction] call ace_interact_menu_fnc_createAction;
                    [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;

                    // An action to replace the wheel is required
                    _name = format ["Replace_%1_%2", _forEachIndex, _hitpoint];
                    _text = localize LSTRING(ReplaceEnginepistonmedium);
                    _condition = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceEnginepistonmedium"] call ace_repair_fnc_canRepair};
                    _statement = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceEnginepistonmedium"] call ace_repair_fnc_repair};
                    _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3] call ace_interact_menu_fnc_createAction;
                    [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;
                    
                    _hitpointsMajor pushBack _hitpoint;
                    _hitpointsMajorPart pushBack "Piston Engine Medium"; 
                };
                case "2piston": {
                    // An action to remove the wheel is required
                    private _name = format ["Remove_%1_%2", _forEachIndex, _hitpoint];
                    private _text = localize LSTRING(RemoveEnginepistonlarge);
                    private _condition = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveEnginepistonlarge"] call ace_repair_fnc_canRepair};
                    private _statement = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveEnginepistonlarge"] call ace_repair_fnc_repair};
                    private _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3, nil, ace_repair_fnc_modifySelectionInteraction] call ace_interact_menu_fnc_createAction;
                    [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;

                    // An action to replace the wheel is required
                    _name = format ["Replace_%1_%2", _forEachIndex, _hitpoint];
                    _text = localize LSTRING(ReplaceEnginepistonlarge);
                    _condition = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceEnginepistonlarge"] call ace_repair_fnc_canRepair};
                    _statement = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceEnginepistonlarge"] call ace_repair_fnc_repair};
                    _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3] call ace_interact_menu_fnc_createAction;
                    [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;

                    _hitpointsMajor pushBack _hitpoint;
                    _hitpointsMajorPart pushBack "Piston Engine Large"; 
                };
                case "1turbine":{
                    // An action to remove the wheel is required
                    private _name = format ["Remove_%1_%2", _forEachIndex, _hitpoint];
                    private _text = localize LSTRING(RemoveEngineturbinesmall);
                    private _condition = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveEngineturbinesmall"] call ace_repair_fnc_canRepair};
                    private _statement = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveEngineturbinesmall"] call ace_repair_fnc_repair};
                    private _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3, nil, ace_repair_fnc_modifySelectionInteraction] call ace_interact_menu_fnc_createAction;
                    [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;

                    // An action to replace the wheel is required
                    _name = format ["Replace_%1_%2", _forEachIndex, _hitpoint];
                    _text = localize LSTRING(ReplaceEngineturbinesmall);
                    _condition = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceEngineturbinesmall"] call ace_repair_fnc_canRepair};
                    _statement = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceEngineturbinesmall"] call ace_repair_fnc_repair};
                    _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3] call ace_interact_menu_fnc_createAction;
                    [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;

                    
                    _hitpointsMajor pushBack _hitpoint;
                    _hitpointsMajorPart pushBack "Turbine Engine Small"; 
                };
                case "2turbine":{
                    // An action to remove the wheel is required
                    private _name = format ["Remove_%1_%2", _forEachIndex, _hitpoint];
                    private _text = localize LSTRING(RemoveEngineturbinelarge);
                    private _condition = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveEngineturbinelarge"] call ace_repair_fnc_canRepair};
                    private _statement = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveEngineturbinelarge"] call ace_repair_fnc_repair};
                    private _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3, nil, ace_repair_fnc_modifySelectionInteraction] call ace_interact_menu_fnc_createAction;
                    [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;

                    // An action to replace the wheel is required
                    _name = format ["Replace_%1_%2", _forEachIndex, _hitpoint];
                    _text = localize LSTRING(ReplaceEngineturbinelarge);
                    _condition = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceEngineturbinelarge"] call ace_repair_fnc_canRepair};
                    _statement = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceEngineturbinelarge"] call ace_repair_fnc_repair};
                    _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 3] call ace_interact_menu_fnc_createAction;
                    [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;
                    
                    _hitpointsMajor pushBack _hitpoint;
                    _hitpointsMajorPart pushBack "Turbine Engine Large"; 
                };
            };
            _processedSelections pushBack _selection;
        };
        if (_hitpoint in TRACK_HITPOINTS) exitWith {
            private _position = compile format ["_target selectionPosition ['%1', 'HitPoints', 'AveragePoint'];", _selection];
            

            TRACE_3("Adding Track Actions",_hitpoint,_forEachIndex,_selection);

            // An action to replace the Track is required
            private _name = format ["Replace_%1_%2", _forEachIndex, _hitpoint];
            private _text = localize ACESTRING(ReplaceTrack);
            private _condition = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceTrack"] call ace_repair_fnc_canRepair};
            private _statement = {[_this select 1, _this select 0, _this select 2 select 0, "ReplaceTrack"] call ace_repair_fnc_repair};
            private _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 2] call ace_interact_menu_fnc_createAction;
            [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;

            // Create a Track interaction
            private _root = format ["Track_%1_%2", _forEachIndex, _hitpoint];
            private _action = [_root, localize LSTRING(Track), ["","#FFFFFF"], {}, {true}, {}, [_hitpoint], _position, 2, nil, { call ace_repair_fnc_modifySelectionInteraction }] call ace_interact_menu_fnc_createAction;
            [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;

            // An action to remove the Track is required
            private _name = format ["Remove_%1_%2", _forEachIndex, _hitpoint];
            private _text = localize ACESTRING(RemoveTrack);
            private _condition = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveTrack"] call ace_repair_fnc_canRepair};
            private _statement = {[_this select 1, _this select 0, _this select 2 select 0, "RemoveTrack"] call ace_repair_fnc_repair};
            private _action = [_name, _text, _icon, _statement, _condition, {}, [_hitpoint], _position, 2] call ace_interact_menu_fnc_createAction;
            [_type, 0, [_root], _action] call ace_interact_menu_fnc_addActionToClass;
            
            _hitpointsMajor pushBack _hitpoint;
            _hitpointsMajorPart pushBack "Spare Track"; 
        };/* else {
            TRACE_4("Adding MiscRepair",_hitpoint,_forEachIndex,_selection,_text);
            private _condition = {[_this select 1, _this select 0, _this select 2 select 0, "MiscRepair"] call ace_repair_fnc_canRepair};
            private _statement = {[_this select 1, _this select 0, _this select 2 select 0, "MiscRepair"] call ace_repair_fnc_repair};
            private _action = [_name, _text, _icon, _statement, _condition, {}, [_forEachIndex], _position, 5] call ace_interact_menu_fnc_createAction;
            // Put inside main actions if no other position was found above
            if (_position isEqualTo [0,0,0]) then {
                [_type, 0, ["ACE_MainActions", QGVAR(Repair)], _action] call ace_interact_menu_fnc_addActionToClass;
            } else {
                [_type, 0, [], _action] call ace_interact_menu_fnc_addActionToClass;
            };
        };*/
    };
} forEach _hitSelections;

private _text = localize LSTRING(OpenRepairGUI);
private _condition = {[_this select 1, _this select 0, "", "OpenRepairGUI"] call ace_repair_fnc_canRepair};
private _statement = {[_this select 1, _this select 0, "", "OpenRepairGUI"] call ace_repair_fnc_repair};
private _action = ["OpenRepairGUI", _text, _icon, _statement, _condition, {}, [], "", 4] call ace_interact_menu_fnc_createAction;
[_type, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToClass;

_hitpointsvehiclevar = [_hitpointsMajor,_hitpointsMajorPart];
_vehicle setVariable ["HitpointsMajorVar",_hitpointsvehiclevar];
// set class as initialized
_initializedClasses pushBack _type;

missionNamespace setVariable [QACEVAR(repair,initializedClasses),_initializedClasses];
