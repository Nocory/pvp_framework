#define GUI_GRID_X	(safezoneX)
#define GUI_GRID_Y	(safezoneY)
#define GUI_GRID_W	(safezoneW / 40)
#define GUI_GRID_H	(safezoneH / 25)
#define GUI_GRID_WAbs	(safezoneW)
#define GUI_GRID_HAbs	(safezoneH)

class pvpfw_constr_dialog {

	idd = 19201;
	movingEnable = true;
	onLoad = "";
	////////////////////////////////////////////////////////
	// GUI EDITOR OUTPUT START (by Conroy, v1.062, #Lavabe)
	////////////////////////////////////////////////////////

	class controlsBackground {
		class IGUIBack_2200: IGUIBack
		{
			idc = 2200;
			x = 12 * GUI_GRID_W + GUI_GRID_X;
			y = 6 * GUI_GRID_H + GUI_GRID_Y;
			w = 16 * GUI_GRID_W;
			h = 13 * GUI_GRID_H;
		};
	};
	class controls {
		class RscText_1000: RscText
		{
			idc = 1000;
			text = "Fortifications"; //--- ToDo: Localize;
			x = 12 * GUI_GRID_W + GUI_GRID_X;
			y = 4 * GUI_GRID_H + GUI_GRID_Y;
			w = 15 * GUI_GRID_W;
			h = 2 * GUI_GRID_H;
			sizeEx = 2 * GUI_GRID_H;
		};
		class RscButton_1600: RscButton
		{
			idc = 1600;
			text = "X"; //--- ToDo: Localize;
			x = 27 * GUI_GRID_W + GUI_GRID_X;
			y = 5 * GUI_GRID_H + GUI_GRID_Y;
			w = 1 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1601: RscButton
		{
			idc = 1601;
			text = "Acquire"; //--- ToDo: Localize;
			x = 13 * GUI_GRID_W + GUI_GRID_X;
			y = 17 * GUI_GRID_H + GUI_GRID_Y;
			w = 3 * GUI_GRID_W;
			h = 1.5 * GUI_GRID_H;
		};
		class RscButton_1602: RscButton
		{
			idc = 1602;
			text = "Reclaim"; //--- ToDo: Localize;
			x = 17 * GUI_GRID_W + GUI_GRID_X;
			y = 17 * GUI_GRID_H + GUI_GRID_Y;
			w = 1.5 * GUI_GRID_W;
			h = 1.5 * GUI_GRID_H;
		};
		// cat
		class RscListbox_1500: RscListbox
		{
			idc = 1500;
			x = 13 * GUI_GRID_W + GUI_GRID_X;
			y = 7.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 3 * GUI_GRID_W;
			h = 6.5 * GUI_GRID_H;
		};
		// obj
		class RscListbox_1501: RscListbox
		{
			idc = 1501;
			x = 17 * GUI_GRID_W + GUI_GRID_X;
			y = 7.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 3 * GUI_GRID_W;
			h = 8 * GUI_GRID_H;
		};
		class RscText_1001: RscText
		{
			idc = 1001;
			text = "Categories"; //--- ToDo: Localize;
			x = 13 * GUI_GRID_W + GUI_GRID_X;
			y = 6.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 3 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscText_1002: RscText
		{
			idc = 1002;
			text = "Objects"; //--- ToDo: Localize;
			x = 17 * GUI_GRID_W + GUI_GRID_X;
			y = 6.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 3 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscText_1003: RscText
		{
			idc = 1003;
			text = "Unit-Funds: 99999"; //--- ToDo: Localize;
			x = 13 * GUI_GRID_W + GUI_GRID_X;
			y = 14.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 3 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscText_1004: RscText
		{
			idc = 1004;
			text = "Cost: 99999"; //--- ToDo: Localize;
			x = 13 * GUI_GRID_W + GUI_GRID_X;
			y = 15.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 3 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscText_1005: RscText
		{
			idc = 1005;
			text = "-"; //--- ToDo: Localize;
			x = 22.5 * GUI_GRID_W + GUI_GRID_X;
			y = 17 * GUI_GRID_H + GUI_GRID_Y;
			w = 3 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
	};
	class Objects
	{
		/*
		class RscPicture_1200: RscPicture
		{
			idc = 1200;
			text = "#(argb,8,8,3)color(1,1,1,1)";
			x = 20.5 * GUI_GRID_W + GUI_GRID_X;
			y = 7.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 8 * GUI_GRID_H;
		};
		*/
		class RscObject_1337
		{
			onObjectMoved = "";

			idc = 1337;
			type = 82;
			model = "\A3\Structures_F\Items\Food\Can_V3_F.p3d";
			scale = 1;

			direction[] = {0, -0.35, -0.65};
			up[] = {0, 0.65, -0.35};

			//position[] = {0,0,0.2}; optional

			x = (20.5 * GUI_GRID_W + GUI_GRID_X) + ((7.5 * GUI_GRID_W) / 2);
			y = (7.5 * GUI_GRID_H + GUI_GRID_Y) + ((8 * GUI_GRID_H) / 2);
			z = 0.5;

			//positionBack[] = {0,0,1.2}; optional

			xBack = 0.5;
			yBack = 0.5;
			zBack = 1.2;

			inBack = 0;
			enableZoom = 0;
			zoomDuration = 0.001;
		};
	};
};
