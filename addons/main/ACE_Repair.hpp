class ACE_Repair
{
	class Actions
	{
		class ReplaceWheel;
		class RemoveWheel: ReplaceWheel
		{
			condition="ace_repair_fnc_canRemove";
			callbackSuccess="advrepair_main_fnc_doRemoveWheel";
			claimObjects[]={};
		};
		class MiscRepair: ReplaceWheel {
			condition="ace_repair_fnc_canMiscRepair";
			callbackSuccess="ace_repair_fnc_doRepair";
			claimObjects[]={};
			repairingTime=10;
		};
		class AdvMajorRepair: MiscRepair
		{
			displayName="$STR_advrepair_main_RepairMajorPart";
			displayNameProgress="$STR_advrepair_main_RepairingMajorPart";
			condition="advrepair_main_fnc_canAdvMajorRepair";
			callbackSuccess="advrepair_main_fnc_doAdvMajorRepair";
			requiredEngineer="ace_advrepair_MajorRepairPermissions";
			repairLocations[]=
			{
				"ace_advrepair_MajorRepairLocations"
			};
			itemConsumed=0;
			repairingTime=5;
		};
		class OpenRepairGUI: MiscRepair
		{
			displayName="$STR_advrepair_main_OpenRepairGUI";
			displayNameProgress="$STR_advrepair_main_OpenningRepairGUI";
			condition="advrepair_main_fnc_canOpenGUI";
			callbackSuccess="advrepair_main_fnc_openDialogMain";
			requiredEngineer="ace_repair_engineerSetting_Wheel";
			itemConsumed=0;
			repairingTime=5;
		};
		class RemoveTrack: MiscRepair
		{
			condition="advrepair_main_fnc_canRemoveTrack";
			callbackSuccess="advrepair_main_fnc_doRemoveTrack";
			claimObjects[]={};
		};
		class ReplaceTrack: RemoveTrack
		{
			condition="advrepair_main_fnc_canReplaceTrack";
		};
		class RemoveRotorAssembly: MiscRepair
		{
			displayName="$STR_advrepair_main_RemoveRotorAssembly";
			displayNameProgress="$STR_advrepair_main_RemovingRotorAssembly";
			requiredEngineer="ace_advrepair_MajorRepairPermissions";
			repairLocations[]=
			{
				"ace_advrepair_MajorRepairLocations"
			};
			condition="advrepair_main_fnc_canRemoveLocked";
			callbackSuccess="advrepair_main_fnc_doRemoveRotorAssembly";
			claimObjects[]={};
			itemConsumed=0;
		};
		class ReplaceRotorAssembly: RemoveRotorAssembly
		{
			displayName="$STR_advrepair_main_ReplaceRotorAssembly";
			displayNameProgress="$STR_advrepair_main_ReplacingRotorAssembly";
			requiredEngineer="ace_advrepair_MajorRepairPermissions";
			repairLocations[]=
			{
				"ace_advrepair_MajorRepairLocations"
			};
			condition="advrepair_main_fnc_canReplaceLocked";
			callbackSuccess="advrepair_main_fnc_doReplaceRotorAssembly";
			claimObjects[]=
			{
				
				{
					"FL_parts_rotorassembly"
				}
			};
		};
		class RemoveAvionics: MiscRepair
		{
			displayName="$STR_advrepair_main_RemoveAvionics";
			displayNameProgress="$STR_advrepair_main_RemovingAvionics";
			requiredEngineer="ace_advrepair_MajorRepairPermissions";
			repairLocations[]=
			{
				"ace_advrepair_MajorRepairLocations"
			};
			condition="advrepair_main_fnc_canRemoveLocked";
			callbackSuccess="advrepair_main_fnc_doRemoveAvionics";
			claimObjects[]={};
			itemConsumed=0;
		};
		class ReplaceAvionics: RemoveAvionics
		{
			displayName="$STR_advrepair_main_ReplaceAvionics";
			displayNameProgress="$STR_advrepair_main_ReplacingAvionics";
			requiredEngineer="ace_advrepair_MajorRepairPermissions";
			repairLocations[]=
			{
				"ace_advrepair_MajorRepairLocations"
			};
			condition="advrepair_main_fnc_canReplaceLocked";
			callbackSuccess="advrepair_main_fnc_doReplaceAvionics";
			claimObjects[]=
			{
				
				{
					"FL_parts_avionics"
				}
			};
		};
		//Engines
		class RemoveEnginepistonsmall: MiscRepair
		{
			displayName="$STR_advrepair_main_RemoveEnginepistonsmall";
			displayNameProgress="$STR_advrepair_main_RemovingEnginepistonsmall";
			requiredEngineer="ace_advrepair_MajorRepairPermissions";
			repairLocations[]=
			{
				"ace_advrepair_MajorRepairLocations"
			};
			condition="advrepair_main_fnc_canRemoveLocked";
			callbackSuccess="advrepair_main_fnc_doRemoveEnginepistonsmall";
			claimObjects[]={};
			itemConsumed=0;
		};
		class ReplaceEnginepistonsmall: RemoveEnginepistonsmall
		{
			displayName="$STR_advrepair_main_ReplaceEnginepistonsmall";
			displayNameProgress="$STR_advrepair_main_ReplacingEnginepistonsmall";
			requiredEngineer="ace_advrepair_MajorRepairPermissions";
			repairLocations[]=
			{
				"ace_advrepair_MajorRepairLocations"
			};
			condition="advrepair_main_fnc_canReplaceLocked";
			callbackSuccess="advrepair_main_fnc_doReplaceEnginepistonsmall";
			claimObjects[]=
			{
				
				{
					"FL_parts_enginepistonsmall"
				}
			};
		};
		class RemoveEnginepistonmedium: MiscRepair
		{
			displayName="$STR_advrepair_main_RemoveEnginepistonmedium";
			displayNameProgress="$STR_advrepair_main_RemovingEnginepistonmedium";
			requiredEngineer="ace_advrepair_MajorRepairPermissions";
			repairLocations[]=
			{
				"ace_advrepair_MajorRepairLocations"
			};
			condition="advrepair_main_fnc_canRemoveLocked";
			callbackSuccess="advrepair_main_fnc_doRemoveEnginepistonmedium";
			claimObjects[]={};
			itemConsumed=0;
		};
		class ReplaceEnginepistonmedium: RemoveEnginepistonmedium
		{
			displayName="$STR_advrepair_main_ReplaceEnginepistonmedium";
			displayNameProgress="$STR_advrepair_main_ReplacingEnginepistonmedium";
			requiredEngineer="ace_advrepair_MajorRepairPermissions";
			repairLocations[]=
			{
				"ace_advrepair_MajorRepairLocations"
			};
			condition="advrepair_main_fnc_canReplaceLocked";
			callbackSuccess="advrepair_main_fnc_doReplaceEnginepistonmedium";
			claimObjects[]=
			{
				
				{
					"FL_parts_enginepistonmedium"
				}
			};
		};
		class RemoveEnginepistonlarge: MiscRepair
		{
			displayName="$STR_advrepair_main_RemoveEnginepistonlarge";
			displayNameProgress="$STR_advrepair_main_RemovingEnginepistonlarge";
			requiredEngineer="ace_advrepair_MajorRepairPermissions";
			repairLocations[]=
			{
				"ace_advrepair_MajorRepairLocations"
			};
			condition="advrepair_main_fnc_canRemoveLocked";
			callbackSuccess="advrepair_main_fnc_doRemoveEnginepistonlarge";
			claimObjects[]={};
			itemConsumed=0;
		};
		class ReplaceEnginepistonlarge: RemoveEnginepistonlarge
		{
			displayName="$STR_advrepair_main_ReplaceEnginepistonlarge";
			displayNameProgress="$STR_advrepair_main_ReplacingEnginepistonlarge";
			requiredEngineer="ace_advrepair_MajorRepairPermissions";
			repairLocations[]=
			{
				"ace_advrepair_MajorRepairLocations"
			};
			condition="advrepair_main_fnc_canReplaceLocked";
			callbackSuccess="advrepair_main_fnc_doReplaceEnginepistonlarge";
			claimObjects[]=
			{
				
				{
					"FL_parts_enginepistonlarge"
				}
			};
		};
		class RemoveEngineturbinesmall: MiscRepair
		{
			displayName="$STR_advrepair_main_RemoveEngineturbinesmall";
			displayNameProgress="$STR_advrepair_main_RemovingEngineturbinesmall";
			requiredEngineer="ace_advrepair_MajorRepairPermissions";
			repairLocations[]=
			{
				"ace_advrepair_MajorRepairLocations"
			};
			condition="advrepair_main_fnc_canRemoveLocked";
			callbackSuccess="advrepair_main_fnc_doRemoveEngineturbinesmall";
			claimObjects[]={};
			itemConsumed=0;
		};
		class ReplaceEngineturbinesmall: RemoveEngineturbinesmall
		{
			displayName="$STR_advrepair_main_ReplaceEngineturbinesmall";
			displayNameProgress="$STR_advrepair_main_ReplacingEngineturbinesmall";
			requiredEngineer="ace_advrepair_MajorRepairPermissions";
			repairLocations[]=
			{
				"ace_advrepair_MajorRepairLocations"
			};
			condition="advrepair_main_fnc_canReplaceLocked";
			callbackSuccess="advrepair_main_fnc_doReplaceEngineturbinesmall";
			claimObjects[]=
			{
				
				{
					"FL_parts_engineturbinesmall"
				}
			};
		};
		class RemoveEngineturbinelarge: MiscRepair
		{
			displayName="$STR_advrepair_main_RemoveEngineturbinelarge";
			displayNameProgress="$STR_advrepair_main_RemovingEngineturbinelarge";
			requiredEngineer="ace_advrepair_MajorRepairPermissions";
			repairLocations[]=
			{
				"ace_advrepair_MajorRepairLocations"
			};
			condition="advrepair_main_fnc_canRemoveLocked";
			callbackSuccess="advrepair_main_fnc_doRemoveEngineturbinelarge";
			claimObjects[]={};
			itemConsumed=0;
		};
		class ReplaceEngineturbinelarge: RemoveEngineturbinelarge
		{
			displayName="$STR_advrepair_main_ReplaceEngineturbinelarge";
			displayNameProgress="$STR_advrepair_main_ReplacingEngineturbinelarge";
			requiredEngineer="ace_advrepair_MajorRepairPermissions";
			repairLocations[]=
			{
				"ace_advrepair_MajorRepairLocations"
			};
			condition="advrepair_main_fnc_canReplaceLocked";
			callbackSuccess="advrepair_main_fnc_doReplaceEngineturbinelarge";
			claimObjects[]=
			{
				
				{
					"FL_parts_engineturbinelarge"
				}
			};
		};
		//Fueltanks
		class RemoveFueltanksmall: MiscRepair
		{
			displayName="$STR_advrepair_main_RemoveFueltanksmall";
			displayNameProgress="$STR_advrepair_main_RemovingFueltanksmall";
			requiredEngineer="ace_advrepair_MajorRepairPermissions";
			repairLocations[]=
			{
				"ace_advrepair_MajorRepairLocations"
			};
			condition="advrepair_main_fnc_canRemoveLocked";
			callbackSuccess="advrepair_main_fnc_doRemoveFueltanksmall";
			claimObjects[]={};
			itemConsumed=0;
		};
		class ReplaceFueltanksmall: RemoveFueltanksmall
		{
			displayName="$STR_advrepair_main_ReplaceFueltanksmall";
			displayNameProgress="$STR_advrepair_main_ReplacingFueltanksmall";
			requiredEngineer="ace_advrepair_MajorRepairPermissions";
			repairLocations[]=
			{
				"ace_advrepair_MajorRepairLocations"
			};
			condition="advrepair_main_fnc_canReplaceLocked";
			callbackSuccess="advrepair_main_fnc_doReplaceFueltanksmall";
			claimObjects[]=
			{
				
				{
					"FL_parts_Fueltanksmall"
				}
			};
		};
		class RemoveFueltanklarge: MiscRepair
		{
			displayName="$STR_advrepair_main_RemoveFueltanklarge";
			displayNameProgress="$STR_advrepair_main_RemovingFueltanklarge";
			requiredEngineer="ace_advrepair_MajorRepairPermissions";
			repairLocations[]=
			{
				"ace_advrepair_MajorRepairLocations"
			};
			condition="advrepair_main_fnc_canRemoveLocked";
			callbackSuccess="advrepair_main_fnc_doRemoveFueltanklarge";
			claimObjects[]={};
			itemConsumed=0;
		};
		class ReplaceFueltanklarge: RemoveFueltanklarge
		{
			displayName="$STR_advrepair_main_ReplaceFueltanklarge";
			displayNameProgress="$STR_advrepair_main_ReplacingFueltanklarge";
			requiredEngineer="ace_advrepair_MajorRepairPermissions";
			repairLocations[]=
			{
				"ace_advrepair_MajorRepairLocations"
			};
			condition="advrepair_main_fnc_canReplaceLocked";
			callbackSuccess="advrepair_main_fnc_doReplaceFueltanklarge";
			claimObjects[]=
			{
				
				{
					"FL_parts_Fueltanklarge"
				}
			};
		};
		class RemoveControlsurfaces: MiscRepair
		{
			displayName="$STR_advrepair_main_RemoveControlsurfaces";
			displayNameProgress="$STR_advrepair_main_RemovingControlsurfaces";
			requiredEngineer="ace_advrepair_MajorRepairPermissions";
			repairLocations[]=
			{
				"ace_advrepair_MajorRepairLocations"
			};
			condition="advrepair_main_fnc_canRemoveLocked";
			callbackSuccess="advrepair_main_fnc_doRemoveControlsurfaces";
			claimObjects[]={};
			itemConsumed=0;
		};
		class ReplaceControlsurfaces: RemoveControlsurfaces
		{
			displayName="$STR_advrepair_main_ReplaceControlsurfaces";
			displayNameProgress="$STR_advrepair_main_ReplacingControlsurfaces";
			requiredEngineer="ace_advrepair_MajorRepairPermissions";
			repairLocations[]=
			{
				"ace_advrepair_MajorRepairLocations"
			};
			condition="advrepair_main_fnc_canReplaceLocked";
			callbackSuccess="advrepair_main_fnc_doReplaceControlsurfaces";
			claimObjects[]=
			{
				
				{
					"FL_parts_Controlsurfaces"
				}
			};
		};
		class RemoveGunFCS: MiscRepair
		{
			displayName="$STR_advrepair_main_RemoveGunFCS";
			displayNameProgress="$STR_advrepair_main_RemovingGunFCS";
			requiredEngineer="ace_advrepair_MajorRepairPermissions";
			repairLocations[]=
			{
				"ace_advrepair_MajorRepairLocations"
			};
			condition="advrepair_main_fnc_canRemoveLocked";
			callbackSuccess="advrepair_main_fnc_doRemoveGunFCS";
			claimObjects[]={};
			itemConsumed=0;
		};
		class ReplaceGunFCS: RemoveGunFCS
		{
			displayName="$STR_advrepair_main_ReplaceGunFCS";
			displayNameProgress="$STR_advrepair_main_ReplacingGunFCS";
			requiredEngineer="ace_advrepair_MajorRepairPermissions";
			repairLocations[]=
			{
				"ace_advrepair_MajorRepairLocations"
			};
			condition="advrepair_main_fnc_canReplaceLocked";
			callbackSuccess="advrepair_main_fnc_doReplaceGunFCS";
			claimObjects[]=
			{
				
				{
					"FL_parts_gunfcs"
				}
			};
		};
		class RemoveTurretdrive: MiscRepair
		{
			displayName="$STR_advrepair_main_RemoveTurretdrive";
			displayNameProgress="$STR_advrepair_main_RemovingTurretdrive";
			requiredEngineer="ace_advrepair_MajorRepairPermissions";
			repairLocations[]=
			{
				"ace_advrepair_MajorRepairLocations"
			};
			condition="advrepair_main_fnc_canRemoveLocked";
			callbackSuccess="advrepair_main_fnc_doRemoveTurretdrive";
			claimObjects[]={};
			itemConsumed=0;
		};
		class ReplaceTurretdrive: RemoveTurretdrive
		{
			displayName="$STR_advrepair_main_ReplaceTurretdrive";
			displayNameProgress="$STR_advrepair_main_ReplacingTurretdrive";
			requiredEngineer="ace_advrepair_MajorRepairPermissions";
			repairLocations[]=
			{
				"ace_advrepair_MajorRepairLocations"
			};
			condition="advrepair_main_fnc_canReplaceLocked";
			callbackSuccess="advrepair_main_fnc_doReplaceTurretdrive";
			claimObjects[]=
			{
				
				{
					"FL_parts_turretdrive"
				}
			};
		};
	};
};
