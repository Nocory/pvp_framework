
// The whole script is still work-in-progress
// For the configuration of what prefixes will change the markers see the "client\change.sqf"

/****************************************************************************************************
**  In the "client\change.sqf", properties for a 3D marker can be selected.						   **
**  The 3D marker is either shown to everyone ("") or only to certain classes ("pilots","medics")  **
**  You can extend this array with any additional classes.										   **
**  ["identifier",["class1","class2","classN"]]													   **
*****************************************************************************************************/
pvpfw_mi_3DClasses = [
	["pilots",["B_Helipilot_F","O_helipilot_F"]],
	["medics",["B_medic_F","O_medic_F"]]
];