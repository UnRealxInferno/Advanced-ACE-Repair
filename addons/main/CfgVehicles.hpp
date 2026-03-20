class CfgVehicles {
	class ThingX;
	class ACE_RepairItem_Base: ThingX {};
	class FL_RepairItem: ACE_RepairItem_Base {
		accuracy=0.2;
		vehicleClass="FL_Logistics_Items";
		editorCategory="EdCat_Supplies";
		editorSubcategory="FL_parts_subcategory";
	};
	//Parts
    class ReammoBox_F: ThingX {};
    class Slingload_base_F: ReammoBox_F {};
    class CargoNet_01_base_F: Slingload_base_F {};
    class CargoNet_01_box_F: CargoNet_01_base_F {};
    class FL_parts_SparePartsLarge: CargoNet_01_box_F
    {
        author="Fleff";
        displayName = "$STR_advrepair_main_part_SparePartsLarge";
        class TransportItems {
            class _xx_advrepair_SpareParts {
                name="advrepair_SpareParts";
                count=100;
            };
        };
        vehicleClass="FL_Logistics_Items";
        editorCategory="EdCat_Supplies";
        editorSubcategory="FL_parts_subcategory";
    };

    //silver    small
    class FL_parts_SpareParts: FL_RepairItem {
        cargoCompartments[] = {"Compartment1"};
        ace_cargo_size=1;
        ace_cargo_canLoad=1;
        ace_cargo_noRename=1;
        ace_dragging_canDrag = 0;
        ace_dragging_canCarry = 1;
        author="Fleff";
        scope=2;
        model = "\A3\Structures_F_Heli\Items\Luggage\PlasticCase_01_small_F.p3d";
        displayName = "$STR_advrepair_main_part_SpareParts";
        picture = "pictureThing";
        icon = "iconObject_1x2";
        mapSize=0.69999999;
        armor=500;
        armorStructural=1;
        minTotalDamageThreshold=0.0099999998;
        explosionShielding=1;
        hiddenSelections[] = {"Camo","Camo2"};
        hiddenSelectionsTextures[] = {"a3\Props_F_Orange\Humanitarian\Supplies\Data\PlasticCase_01_gray_CO.paa","z\advrepair\addons\main\data\part_SpareParts.paa"};
        maximumLoad = 300;
        transportMaxBackpacks = 12;
        transportMaxMagazines = 64;
        transportMaxWeapons = 12;
        class HitPoints {
            class HitBody {
                armor=1;
                material=-1;
                name="mat_rim";
                visual="mat_rim";
                passThrough=1;
                radius=0.1;
                explosionShielding=1;
                minimalHit=1;
            };
        };
        class Damage {
            tex[]={};
            mat[]= {};
        };
        editorPreview = "\A3\EditorPreviews_F_Orange\Data\CfgVehicles\Land_PlasticCase_01_small_gray_F.jpg";
        class TransportItems {
            class _xx_advrepair_SpareParts {
                name="advrepair_SpareParts";
                count=20;
            };
        };
    };
    /*
    class FL_parts_SparePartsLarge: FL_RepairItem {
        cargoCompartments[] = {"Compartment1"};
        ace_dragging_canDrag = 0;
        ace_dragging_canCarry = 0;
        ace_cargo_noRename=1;
        ace_cargo_size=6;
        ace_cargo_canLoad=1;
        author="Fleff";
        displayName = "$STR_advrepair_main_part_SparePartsLarge";
        scope=2;
        model = "\A3\Supplies_F_Heli\CargoNets\CargoNet_01_box_F.p3d";
        picture = "pictureThing";
        icon = "iconObject_1x1";
        mapSize=0.69999999;
        armor=500;
        armorStructural=1;
        minTotalDamageThreshold=0.0099999998;
        explosionShielding=1;
        hiddenSelections[] = {};	
        maximumLoad = 6000;
        transportMaxBackpacks = 12;
        transportMaxMagazines = 144;
        transportMaxWeapons = 18;
        class HitPoints {
            class HitBody {
                armor=1;
                material=-1;
                name="mat_rim";
                visual="mat_rim";
                passThrough=1;
                radius=0.1;
                explosionShielding=1;
                minimalHit=1;
            };
        };
        class Damage {
            tex[]={};
            mat[]= {};
        };
        editorPreview = "\A3\EditorPreviews_F\Data\CfgVehicles\CargoNet_01_box_F.jpg";
        class TransportItems {
            class _xx_advrepair_SpareParts {
                name="advrepair_SpareParts";
                count=100;
            };
        };
    };
    */

    //black     small
    class FL_parts_gunfcs: FL_RepairItem {
        ace_cargo_size=1;
        ace_cargo_canLoad=1;
        ace_cargo_noRename=1;
        ace_dragging_canDrag = 0;
        ace_dragging_canCarry = 1;
        author="Fleff";
        scope=2;
        model = "\A3\Structures_F_Heli\Items\Luggage\PlasticCase_01_small_F.p3d";
        displayName = "$STR_advrepair_main_part_gunfcs";
        picture = "pictureThing";
        icon = "iconObject_1x2";
        mapSize=0.69999999;
        armor=500;
        armorStructural=1;
        minTotalDamageThreshold=0.0099999998;
        explosionShielding=1;
        hiddenSelections[] = {"Camo","Camo2"};
        hiddenSelectionsTextures[] = {"a3\Props_F_Enoch\Military\Supplies\Data\PlasticCase_01_black_CO.paa","z\advrepair\addons\main\data\part_gunfcs.paa"};
        class HitPoints {
            class HitBody {
                armor=1;
                material=-1;
                name="mat_rim";
                visual="mat_rim";
                passThrough=1;
                radius=0.1;
                explosionShielding=1;
                minimalHit=1;
            };
        };
        class Damage {
            tex[]={};
            mat[]= {};
        };
        editorPreview = "\A3\EditorPreviews_F_Enoch\Data\CfgVehicles\Land_PlasticCase_01_small_black_F.jpg";
    };

    //black     medium
    class FL_parts_engineturbinesmall: FL_RepairItem{
        ace_cargo_size=2;
        ace_cargo_canLoad=1;
        ace_cargo_noRename=1;
        ace_dragging_canDrag = 0;
        ace_dragging_canCarry = 1;
        author="Fleff";
        scope=2;
        model = "\A3\Structures_F_Heli\Items\Luggage\PlasticCase_01_medium_F.p3d";
        displayName = "$STR_advrepair_main_part_engineturbinesmall";
        picture = "pictureThing";
        icon = "iconObject_1x2";
        mapSize=0.69999999;
        armor=500;
        armorStructural=1;
        minTotalDamageThreshold=0.0099999998;
        explosionShielding=1;
        hiddenSelections[] = {"Camo","Camo2"};
        hiddenSelectionsTextures[] = {"a3\Props_F_Enoch\Military\Supplies\Data\PlasticCase_01_black_CO.paa","z\advrepair\addons\main\data\part_engineturbinesmall.paa"};
        class HitPoints {
            class HitBody {
                armor=1;
                material=-1;
                name="mat_rim";
                visual="mat_rim";
                passThrough=1;
                radius=0.1;
                explosionShielding=1;
                minimalHit=1;
            };
        };
        class Damage {
            tex[]={};
            mat[]= {};
        };
        editorPreview = "\A3\EditorPreviews_F_Enoch\Data\CfgVehicles\Land_PlasticCase_01_medium_black_F.jpg";
    };

    //black     large
    class FL_parts_engineturbinelarge: FL_RepairItem {
        ace_cargo_size=4;
        ace_cargo_canLoad=1;
        ace_cargo_noRename=1;
        ace_dragging_canDrag = 1;
        ace_dragging_canCarry = 0;
        author="Fleff";
        scope=2;
        model = "\A3\Structures_F_Heli\Items\Luggage\PlasticCase_01_large_F.p3d";
        displayName = "$STR_advrepair_main_part_engineturbinelarge";
        picture = "pictureThing";
        icon = "iconObject_1x2";
        mapSize=0.69999999;
        armor=500;
        armorStructural=1;
        minTotalDamageThreshold=0.0099999998;
        explosionShielding=1;
        hiddenSelections[] = {"Camo","Camo2"};
        hiddenSelectionsTextures[] = {"a3\Props_F_Enoch\Military\Supplies\Data\PlasticCase_01_black_CO.paa","z\advrepair\addons\main\data\part_engineturbinelarge.paa"};
        class HitPoints {
            class HitBody {
                armor=1;
                material=-1;
                name="mat_rim";
                visual="mat_rim";
                passThrough=1;
                radius=0.1;
                explosionShielding=1;
                minimalHit=1;
            };
        };
        class Damage {
            tex[]={};
            mat[]= {};
        };
        editorPreview = "\A3\EditorPreviews_F_Enoch\Data\CfgVehicles\Land_PlasticCase_01_large_black_F.jpg";
    };

    //silver    large
    class FL_parts_rotorassembly: FL_RepairItem {
        ace_cargo_size=4;
        ace_cargo_canLoad=1;
        ace_cargo_noRename=1;
        ace_dragging_canDrag = 0;
        ace_dragging_canCarry = 1;
        author="Fleff";
        scope=2;
        model = "\A3\Structures_F_Heli\Items\Luggage\PlasticCase_01_large_F.p3d";
        displayName = "$STR_advrepair_main_part_rotorassembly";
        picture = "pictureThing";
        icon = "iconObject_1x2";
        mapSize=0.69999999;
        armor=500;
        armorStructural=1;
        minTotalDamageThreshold=0.0099999998;
        explosionShielding=1;
        hiddenSelections[] = {"Camo","Camo2"};
        hiddenSelectionsTextures[] = {"a3\Props_F_Orange\Humanitarian\Supplies\Data\PlasticCase_01_gray_CO.paa","z\advrepair\addons\main\data\part_rotorassembly.paa"};
        class HitPoints {
            class HitBody {
                armor=1;
                material=-1;
                name="mat_rim";
                visual="mat_rim";
                passThrough=1;
                radius=0.1;
                explosionShielding=1;
                minimalHit=1;
            };
        };
        class Damage {
            tex[]={};
            mat[]= {};
        };
        editorPreview = "\A3\EditorPreviews_F_Orange\Data\CfgVehicles\Land_PlasticCase_01_large_gray_F.jpg";
    };

    //silver    medium
    class FL_parts_controlsurfaces: FL_RepairItem {
        ace_cargo_size=2;
        ace_cargo_canLoad=1;
        ace_cargo_noRename=1;
        ace_dragging_canDrag = 0;
        ace_dragging_canCarry = 1;
        author="Fleff";
        scope=2;
        model = "\A3\Structures_F_Heli\Items\Luggage\PlasticCase_01_medium_F.p3d";
        displayName = "$STR_advrepair_main_part_controlsurfaces";
        picture = "pictureThing";
        icon = "iconObject_1x2";
        mapSize=0.69999999;
        armor=500;
        armorStructural=1;
        minTotalDamageThreshold=0.0099999998;
        explosionShielding=1;
        hiddenSelections[] = {"Camo","Camo2"};
        hiddenSelectionsTextures[] = {"a3\Props_F_Orange\Humanitarian\Supplies\Data\PlasticCase_01_gray_CO.paa","z\advrepair\addons\main\data\part_controlsurfaces.paa"};
        class HitPoints {
            class HitBody {
                armor=1;
                material=-1;
                name="mat_rim";
                visual="mat_rim";
                passThrough=1;
                radius=0.1;
                explosionShielding=1;
                minimalHit=1;
            };
        };
        class Damage {
            tex[]={};
            mat[]= {};
        };
        editorPreview = "\A3\EditorPreviews_F_Orange\Data\CfgVehicles\Land_PlasticCase_01_medium_gray_F.jpg";
    };

    //silver    small
    class FL_parts_avionics: FL_RepairItem {
        ace_cargo_size=1;
        ace_cargo_canLoad=1;
        ace_cargo_noRename=1;
        ace_dragging_canDrag = 0;
        ace_dragging_canCarry = 1;
        author="Fleff";
        scope=2;
        model = "\A3\Structures_F_Heli\Items\Luggage\PlasticCase_01_small_F.p3d";
        displayName = "$STR_advrepair_main_part_avionics";
        picture = "pictureThing";
        icon = "iconObject_1x2";
        mapSize=0.69999999;
        armor=500;
        armorStructural=1;
        minTotalDamageThreshold=0.0099999998;
        explosionShielding=1;
        hiddenSelections[] = {"Camo","Camo2"};
        hiddenSelectionsTextures[] = {"a3\Props_F_Orange\Humanitarian\Supplies\Data\PlasticCase_01_gray_CO.paa","z\advrepair\addons\main\data\part_avionics.paa"};
        class HitPoints {
            class HitBody {
                armor=1;
                material=-1;
                name="mat_rim";
                visual="mat_rim";
                passThrough=1;
                radius=0.1;
                explosionShielding=1;
                minimalHit=1;
            };
        };
        class Damage {
            tex[]={};
            mat[]= {};
        };
        editorPreview = "\A3\EditorPreviews_F_Orange\Data\CfgVehicles\Land_PlasticCase_01_small_gray_F.jpg";
    };

    class FL_parts_enginepistonlarge: FL_RepairItem     //large     green
    {
        ace_cargo_size=4;
        ace_cargo_canLoad=1;
        ace_cargo_noRename=1;
        ace_dragging_canDrag = 1;
        ace_dragging_canCarry = 0;
        author="Fleff";
        scope=2;
        model = "\A3\Structures_F_Heli\Items\Luggage\PlasticCase_01_large_F.p3d";
        displayName = "$STR_advrepair_main_part_enginepistonlarge";
        picture = "pictureThing";
        icon = "iconObject_1x2";
        mapSize=0.69999999;
        armor=500;
        armorStructural=1;
        minTotalDamageThreshold=0.0099999998;
        explosionShielding=1;
        hiddenSelections[] = {"Camo","Camo2"};
        hiddenSelectionsTextures[] = {"a3\Props_F_Enoch\Military\Supplies\Data\PlasticCase_01_olive_CO.paa","z\advrepair\addons\main\data\part_enginepistonlarge.paa"};
        class HitPoints {
            class HitBody {
                armor=1;
                material=-1;
                name="mat_rim";
                visual="mat_rim";
                passThrough=1;
                radius=0.1;
                explosionShielding=1;
                minimalHit=1;
            };
        };
        class Damage {
            tex[]={};
            mat[]= {};
        };
        editorPreview = "\A3\EditorPreviews_F_Enoch\Data\CfgVehicles\Land_PlasticCase_01_large_olive_F.jpg";
    };
    class FL_parts_enginepistonmedium: FL_RepairItem    //medium    green
    {
        ace_cargo_size=2;
        ace_cargo_canLoad=1;
        ace_cargo_noRename=1;
        ace_dragging_canDrag = 0;
        ace_dragging_canCarry = 1;
        author="Fleff";
        scope=2;
        model = "\A3\Structures_F_Heli\Items\Luggage\PlasticCase_01_medium_F.p3d";
        displayName = "$STR_advrepair_main_part_enginepistonmedium";
        picture = "pictureThing";
        icon = "iconObject_1x2";
        mapSize=0.69999999;
        armor=500;
        armorStructural=1;
        minTotalDamageThreshold=0.0099999998;
        explosionShielding=1;
        hiddenSelections[] = {"Camo","Camo2"};
        hiddenSelectionsTextures[] = {"a3\Props_F_Enoch\Military\Supplies\Data\PlasticCase_01_olive_CO.paa","z\advrepair\addons\main\data\part_enginepistonmedium.paa"};
        class HitPoints {
            class HitBody {
                armor=1;
                material=-1;
                name="mat_rim";
                visual="mat_rim";
                passThrough=1;
                radius=0.1;
                explosionShielding=1;
                minimalHit=1;
            };
        };
        class Damage {
            tex[]={};
            mat[]= {};
        };
        editorPreview = "\A3\EditorPreviews_F_Enoch\Data\CfgVehicles\Land_PlasticCase_01_medium_olive_F.jpg";
    };

    //green     small
    class FL_parts_enginepistonsmall: FL_RepairItem {
        ace_cargo_size=1;
        ace_cargo_canLoad=1;
        ace_cargo_noRename=1;
        ace_dragging_canDrag = 0;
        ace_dragging_canCarry = 1;
        author="Fleff";
        scope=2;
        model = "\A3\Structures_F_Heli\Items\Luggage\PlasticCase_01_small_F.p3d";
        displayName = "$STR_advrepair_main_part_enginepistonsmall";
        picture = "pictureThing";
        icon = "iconObject_1x2";
        mapSize=0.69999999;
        armor=500;
        armorStructural=1;
        minTotalDamageThreshold=0.0099999998;
        explosionShielding=1;
        hiddenSelections[] = {"Camo","Camo2"};
        hiddenSelectionsTextures[] = {"a3\Props_F_Enoch\Military\Supplies\Data\PlasticCase_01_olive_CO.paa","z\advrepair\addons\main\data\part_enginepistonsmall.paa"};
        class HitPoints {
            class HitBody {
                armor=1;
                material=-1;
                name="mat_rim";
                visual="mat_rim";
                passThrough=1;
                radius=0.1;
                explosionShielding=1;
                minimalHit=1;
            };
        };
        class Damage {
            tex[]={};
            mat[]= {};
        };
        editorPreview = "\A3\EditorPreviews_F_Enoch\Data\CfgVehicles\Land_PlasticCase_01_small_olive_F.jpg";
    };

    //small     tan
    class FL_parts_turretdrive: FL_RepairItem{
        ace_cargo_size=1;
        ace_cargo_canLoad=1;
        ace_cargo_noRename=1;
        ace_dragging_canDrag = 0;
        ace_dragging_canCarry = 1;
        author="Fleff";
        scope=2;
        model = "\A3\Structures_F_Heli\Items\Luggage\PlasticCase_01_small_F.p3d";
        displayName = "$STR_advrepair_main_part_turretdrive";
        picture = "pictureThing";
        icon = "iconObject_1x2";
        mapSize=0.69999999;
        armor=500;
        armorStructural=1;
        minTotalDamageThreshold=0.0099999998;
        explosionShielding=1;
        hiddenSelections[] = {"Camo","Camo2"};
        hiddenselectionsTextures[] = {"a3\structures_f_heli\items\luggage\data\plasticcase_01_co.paa","z\advrepair\addons\main\data\part_turretdrive.paa"};
        class HitPoints {
            class HitBody {
                armor=1;
                material=-1;
                name="mat_rim";
                visual="mat_rim";
                passThrough=1;
                radius=0.1;
                explosionShielding=1;
                minimalHit=1;
            };
        };
        class Damage {
            tex[]={};
            mat[]= {};
        };
        editorPreview = "\A3\EditorPreviews_F\Data\CfgVehicles\Land_PlasticCase_01_small_F.jpg";
    };

    //medium    tan
    class FL_parts_fueltanksmall: FL_RepairItem {
        ace_cargo_size=2;
        ace_cargo_canLoad=1;
        ace_cargo_noRename=1;
        ace_dragging_canDrag = 0;
        ace_dragging_canCarry = 1;
        author="Fleff";
        scope=2;
        model = "\A3\Structures_F_Heli\Items\Luggage\PlasticCase_01_medium_F.p3d";
        displayName = "$STR_advrepair_main_part_fueltanksmall";
        picture = "pictureThing";
        icon = "iconObject_1x2";
        mapSize=0.69999999;
        armor=500;
        armorStructural=1;
        minTotalDamageThreshold=0.0099999998;
        explosionShielding=1;
        hiddenSelections[] = {"Camo","Camo2"};
        hiddenselectionsTextures[] = {"a3\structures_f_heli\items\luggage\data\plasticcase_01_co.paa","z\advrepair\addons\main\data\part_fueltanksmall.paa"};
        class HitPoints {
            class HitBody {
                armor=1;
                material=-1;
                name="mat_rim";
                visual="mat_rim";
                passThrough=1;
                radius=0.1;
                explosionShielding=1;
                minimalHit=1;
            };
        };
        class Damage {
            tex[]={};
            mat[]= {};
        };
        editorPreview = "\A3\EditorPreviews_F\Data\CfgVehicles\Land_PlasticCase_01_medium_F.jpg";
    };

    //large     tan
    class FL_parts_fueltanklarge: FL_RepairItem {
        ace_cargo_size=4;
        ace_cargo_canLoad=1;
        ace_cargo_noRename=1;
        ace_dragging_canDrag = 1;
        ace_dragging_canCarry = 0;
        author="Fleff";
        scope=2;
        model = "\A3\Structures_F_Heli\Items\Luggage\PlasticCase_01_large_F.p3d";
        displayName = "$STR_advrepair_main_part_fueltanklarge";
        picture = "pictureThing";
        icon = "iconObject_1x2";
        mapSize=0.69999999;
        armor=500;
        armorStructural=1;
        minTotalDamageThreshold=0.0099999998;
        explosionShielding=1;
        hiddenSelections[] = {"Camo","Camo2"};
        hiddenselectionsTextures[] = {"a3\structures_f_heli\items\luggage\data\plasticcase_01_co.paa","z\advrepair\addons\main\data\part_fueltanklarge.paa"};
        class HitPoints {
            class HitBody {
                armor=1;
                material=-1;
                name="mat_rim";
                visual="mat_rim";
                passThrough=1;
                radius=0.1;
                explosionShielding=1;
                minimalHit=1;
            };
        };
        class Damage {
            tex[]={};
            mat[]= {};
        };
        editorPreview = "\A3\EditorPreviews_F\Data\CfgVehicles\Land_PlasticCase_01_large_F.jpg";
    };
    class LandVehicle;
	//Cars
    class Car: LandVehicle {};
    class Car_F: Car {
        class FL_advrepair {
            vehicleenginesize = 0;
            vehiclefueltanksize = 0;
            vehiclearmor = 0;
            vehicleengine = "piston";
        };
    };
	//Trucks
    class Truck_F: Car_F {
        class FL_advrepair {
            vehicleenginesize = 1;
            vehiclefueltanksize = 1;
            vehiclearmor = 0;
            vehicleengine = "piston";
        };
    };
	//Vans
    class Van_01_base_F: Truck_F {
        class FL_advrepair {
            vehicleenginesize = 1;
            vehiclefueltanksize = 0;
            vehiclearmor = 0;
            vehicleengine = "piston";
        };
    };
    class Van_02_base_F: Truck_F {
        class FL_advrepair {
            vehicleenginesize = 1;
            vehiclefueltanksize = 0;
            vehiclearmor = 0;
            vehicleengine = "piston";
        };
    };
	//MRAPs
    class MRAP_01_base_F: Car_F {
        class FL_advrepair {
            vehicleenginesize = 1;
            vehiclefueltanksize = 0;
            vehiclearmor = 1;
            vehicleengine = "piston";
        };
    };
    class MRAP_02_base_F: Car_F {
        class FL_advrepair {
            vehicleenginesize = 1;
            vehiclefueltanksize = 0;
            vehiclearmor = 1;
            vehicleengine = "piston";
        };
    };
    class MRAP_03_base_F: Car_F {
        class FL_advrepair {
            vehicleenginesize = 1;
            vehiclefueltanksize = 0;
            vehiclearmor = 1;
            vehicleengine = "piston";
        };
    };
	//Wheeled APC
    class Wheeled_APC_F: Car_F {
        class FL_advrepair {
            vehicleenginesize = 1;
            vehiclefueltanksize = 1;
            vehiclearmor = 1;
            vehicleengine = "piston";
        };
    };
	//Wheeled AFV
    class AFV_Wheeled_01_base_F: Wheeled_APC_F {
        class FL_advrepair {
            vehicleenginesize = 2;
            vehiclefueltanksize = 1;
            vehiclearmor = 1;
            vehicleengine = "piston";
        };
    };
	//Tracked 
    class Tank: LandVehicle {};
    class Tank_F: Tank {
        class FL_advrepair {
            vehicleenginesize = 2;
            vehiclefueltanksize = 1;
            vehiclearmor = 2;
            vehicleengine = "piston";
        };
    };
    class LT_01_base_F: Tank_F {	//Wiesel
        class FL_advrepair {
            vehicleenginesize = 1;
            vehiclefueltanksize = 0;
            vehiclearmor = 1;
            vehicleengine = "piston";
        };
    };
	//Tracked APC
    class APC_Tracked_01_base_F: Tank_F {
        class FL_advrepair {
            vehicleenginesize = 2;
            vehiclefueltanksize = 1;
            vehiclearmor = 1;
            vehicleengine = "piston";
        };
    };
    class APC_Tracked_02_base_F: Tank_F {
        class FL_advrepair {
            vehicleenginesize = 2;
            vehiclefueltanksize = 1;
            vehiclearmor = 1;
            vehicleengine = "piston";
        };
    };
    class APC_Tracked_03_base_F: Tank_F {
        class FL_advrepair {
            vehicleenginesize = 2;
            vehiclefueltanksize = 1;
            vehiclearmor = 1;
            vehicleengine = "piston";
        };
    };
	//Helicopter
    class Helicopter;
    class Helicopter_Base_F: Helicopter {
        class FL_advrepair {
            vehicleenginesize = 1;
            vehiclefueltanksize = 1;
            vehiclearmor = 0;
            vehicleengine = "turbine";
        };
    };
    class Helicopter_Base_H: Helicopter_Base_F {};
    class Heli_Light_01_base_F: Helicopter_Base_H {
        class FL_advrepair {
            vehicleenginesize = 1;
            vehiclefueltanksize = 0;
            vehiclearmor = 0;
            vehicleengine = "turbine";
        };
    }; 
	//Plane
    class Plane;
    class Plane_Base_F: Plane {
        class FL_advrepair {
            vehicleenginesize = 2;
            vehiclefueltanksize = 1;
            vehiclearmor = 0;
            vehicleengine = "turbine";
        };
    };
	//Ship
    class Ship;
    class Ship_F: Ship {
        class FL_advrepair {
            vehicleenginesize = 0;
            vehiclefueltanksize = 0;
            vehiclearmor = 0;
            vehicleengine = "piston";
        };
    };
};
