// Object Categories
// displayName, className, cost, dist, dir, buildFlat, previewSize

pvpfw_wg_assets_fortifications = [
	["Barriers",[
		["HBarrier (x1)","Land_HBarrier_1_F",2,4,0,false,-1],
		["HBarrier (x3)","Land_HBarrier_3_F",5,4,0,false,-1],
		["HBarrier (x5)","Land_HBarrier_5_F",8,4,0,false,-1],
		["HBarrier (big)","Land_HBarrierBig_F",12,5.5,0,false,-1],
		["Sandbag (long)","Land_BagFence_Long_F",3,2,0,false,-1],
		["Sandbag (short)","Land_BagFence_Short_F",2,2,0,false,-1],
		["Sandbag (round)","Land_BagFence_Round_F",3,2,180,false,-1],
		["Low Barrier","Land_Mil_ConcreteWall_F",3,4,0,false,-1],
		["Medium barrier","Land_CncBarrierMedium_F",4,4,0,false,-1],
		["Medium barrier x4","Land_CncBarrierMedium4_F",14,4,0,false,-1],
		["High Wall","Land_CncWall1_F",15,4,180,true,-1],
		["High Wall x4","Land_CncWall4_F",45,4,180,true,-1],
		["Razorwire","Land_Razorwire_F",5,5,0,false,-1]
	]],
	["Utility",[
		["Burning Barrel","MetalBarrel_burning_F",10,5,0,false,0.16],
		["Open net INDP","CamoNet_INDP_open_F",8,6,0,false,0.014],
		["Open net OPFOR","CamoNet_OPFOR_open_F",8,6,0,false,0.014],
		["Open net BLUFOR","CamoNet_BLUFOR_open_F",8,6,0,false,0.014]
	]],
	["Bunkers",[
		["Bagbunker (small)","Land_BagBunker_Small_F",10,3.5,180,false,-1],
		["Bagbunker (big)","Land_BagBunker_Large_F",25,8,180,false,-1],
		["Cargo Patrol V1","Land_Cargo_Patrol_V1_F",25,5,180,true,-1],
		["Cargo HQ V1","Land_Cargo_HQ_V1_F",45,10,-90,true,-1],
		["Tower Bunker","Land_Cargo_Tower_V1_F",75,7,-90,true,-1]
	]],
	["Flags",[
		["Blue","Flag_Blue_F",20,3,0,true,-1],
		["NATO","Flag_NATO_F",20,3,0,true,-1],
		["Red","Flag_Red_F",20,3,0,true,-1],
		["CSAT","Flag_CSAT_F",20,3,0,true,-1],
		["Independent","Flag_Green_F",20,3,0,true,-1],
		["UNO","Flag_UNO_F",20,3,0,true,-1],
		["Red Crystal","Flag_RedCrystal_F",20,3,0,true,-1]
	]]
];

pvpfw_constr_catUntargetable = [
	"Land_Razorwire_F",
	"CamoNet_INDP_F",
	"CamoNet_OPFOR_F",
	"CamoNet_BLUFOR_F",
	"CamoNet_INDP_open_F",
	"CamoNet_OPFOR_open_F",
	"CamoNet_BLUFOR_open_F",
	"CamoNet_INDP_big_F",
	"CamoNet_OPFOR_big_F",
	"CamoNet_BLUFOR_big_F"
];

pvpfw_constr_ConstructFrom = [
	"B_Truck_01_Repair_F","O_Truck_03_repair_F"
];
