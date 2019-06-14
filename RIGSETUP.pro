//
// written by david.c.godlove@vanderbilt.edu 	January, 2011
// edited by kaleb.a.lowe@vanderbilt.edu to make variables, similar to DEFAULT.pro

declare RIGSETUP(int Room);

// what room is this set up for?
//	Room			= 28;

process RIGSETUP(int Room)
{
	if (Room == 23)
	{
		// viewing measurements used to compute degrees (units need to be the same)
		Scr_width   	= 381.0; // in some units
		Scr_height  	= 291.0; // in some units
		Subj_dist   	= 450.0; // distance from center of subjects eyeball to screen

		// where does your photodiode marker need to be?
		PD_left			= 6;	// distance from left of screen (same units as above)
		PD_bottom		= 7;	// distance from bottom of screen (same units as above)
		PD_size			= 25;	// minimum size for consistant triggering (same units as above)

		// what is your screen resolution?
		  Scr_pixX    	= 640;	// number of pixels across
		  Scr_pixY    	= 400;	// number of pixels in height
		Refresh_rate	= 100;	// in Hz

		// what are your eye variables?
		// In 023, calibration target is 12.8cm horizontal, 12.8 cm vertical. Atan(12.8/58) = 9.74 deg, Atan(12.8/58) = 11.23 deg
		X_Gain = 5.1;//9.74; //50; //3.492;						// x scaling factor to convert eye trace voltage to degrees (must be calculated from calibration)
		Y_Gain = 5.1;//11.23; //50; //3.729;						// y scaling factor to convert eye trace voltage to degrees (must be calculated from calibration)
		
		// what kind of hardware configuration are you using?
		Juice_channel   	= 0; //9 in 029 0 in 023
		Stim_channel		= 1;
		Eye_X_channel   	= 1;
		Eye_Y_channel   	= 2;
		PhotoD_channel  	= 5;
		MaxVoltage    	= 10; 	//look at das_gain and das_polarity in kped (setup tn)
		//AnalogUnits   	= 65536;// use this for a 64 bit AD board
		AnalogUnits   = 4096;// use this for a 12 bit AD board

		// what kind of motion detector hardware are you using?
		CheckMouth			= 1;            // use this if you have a motion detector on the MOUTH going into channel 3
		CheckBody 			= 0;            // use this if you have a motion detector on the BODY going into channel 3
		
		
		redVal = 30;
		greenVal = 19;
		blueVal = 64;
		yrOff = 13;
		ygOff = 6;
		mrOff = 9;
		mbOff = 27;
		cgOff = 1;
		cbOff = 44;
		wrOff = 13;
		wgOff = 6;
		wbOff = 50;
		
	} else if (Room == 28)
	{
		// viewing measurements used to compute degrees (units need to be the same)
		//Scr_width   	= 381.0; // in some units
		//Scr_height  	= 291.0; // in some units
		//Subj_dist   	= 450.0; // distance from center of subjects eyeball to screen
		Scr_width = 404.0;//412.8;
		Scr_height = 300.0;//311.2;
		Subj_dist = 570.0;//570.0;
		
		// where does your photodiode marker need to be?
		PD_left			= 0;//6;	// distance from left of screen (same units as above)
		PD_bottom		= -7;//25;//0;//7;	// distance from bottom of screen (same units as above)
		PD_size			= 30;//35;//25;	// minimum size for consistant triggering (same units as above)

		// what is your screen resolution?
		  Scr_pixX    	= 1280;//640;	// number of pixels across
		  Scr_pixY    	= 1024;//400;	// number of pixels in height
		Refresh_rate	= 70;	// in Hz

		// what are your eye variables?
		X_Gain = 3.492;						// x scaling factor to convert eye trace voltage to degrees (must be calculated from calibration)
		Y_Gain = 3.729;						// y scaling factor to convert eye trace voltage to degrees (must be calculated from calibration)
		
		// what kind of hardware configuration are you using?
		Juice_channel   	= 1;
		Stim_channel		= 5;//2;
		Eye_X_channel   	= 1;
		Eye_Y_channel   	= 2;
		PhotoD_channel  	= 3;
		MaxVoltage    	= 10; 	//look at das_gain and das_polarity in kped (setup tn)
		AnalogUnits   	= 65536;// use this for a 64 bit AD board
		// AnalogUnits   = 4096;// use this for a 12 bit AD board

		// what kind of motion detector hardware are you using?
		CheckMouth			= 1;            // use this if you have a motion detector on the MOUTH going into channel 3
		CheckBody 			= 0;            // use this if you have a motion detector on the BODY going into channel 3
		
		pdThresh = 100;
		pdRefract = 5;
		// Isoluminant With Blue
		/*
		redVal = 46;
		greenVal = 31;
		blueVal = 64;
		yrOff = 12;
		ygOff = 2;
		mrOff = 7;
		mbOff = 20;
		cgOff = -2;
		cbOff = 40;
		wrOff = 20;
		wgOff = 0;
		wbOff = 40;
		*/
		// Isoluminant with Red
		redVal = 64;
		greenVal = 44;
		blueVal = 64;
		mrOff = 7;
		mbOff = 15;
		cgOff = 1;
		cbOff = 30;
		wrOff = 30;
		wgOff = 6;
		wbOff = 40;
		omrOff = 5;
		ombOff = 30;
		ocgOff = 2;
		ocbOff = 20;
		
		// Hard set of off-red and off-green colors
		yrOff = 5; // 190127 change 10; // Changed to orange... was 22 for yellow;
		ygOff = 19; // 190127 change // Changed to orange... 6 for yellow;
		oggOff = 2;
		ogrOff = 23;
		ogbOff = 22;
		
		// Easy set of off-red and off-green colors
		/*
		yrOff = 13;
		ygOff = 11;
		oggOff = 4;
		ogrOff = 37;
		ogbOff = 10;
		*/
		
		bgR = 20;
		bgG = 20;
		bgB = 20;
		
	} else if (Room == 29)
	{
		// viewing measurements used to compute degrees (units need to be the same)
		Scr_width   	= 381.0; // in some units
		Scr_height  	= 291.0; // in some units
		Subj_dist   	= 450.0; // distance from center of subjects eyeball to screen

		// where does your photodiode marker need to be?
		PD_left			= 6;	// distance from left of screen (same units as above)
		PD_bottom		= 7;	// distance from bottom of screen (same units as above)
		PD_size			= 25;	// minimum size for consistant triggering (same units as above)

		// what is your screen resolution?
		  Scr_pixX    	= 1280;//640;	// number of pixels across
		  Scr_pixY    	= 1024;//400;	// number of pixels in height
		Refresh_rate	= 100;	// in Hz

		// what are your eye variables?
		// In 023, calibration target is 12.8cm horizontal, 12.8 cm vertical. Atan(12.8/58) = 9.74 deg, Atan(12.8/58) = 11.23 deg
		X_Gain = 5.1;//9.74; //50; //3.492;						// x scaling factor to convert eye trace voltage to degrees (must be calculated from calibration)
		Y_Gain = 5.1;//11.23; //50; //3.729;						// y scaling factor to convert eye trace voltage to degrees (must be calculated from calibration)
		
		// what kind of hardware configuration are you using?
		Juice_channel   	= 0; //9 in 029 0 in 023
		Stim_channel		= 1;
		Eye_X_channel   	= 1;
		Eye_Y_channel   	= 2;
		PhotoD_channel  	= 5;
		MaxVoltage    	= 10; 	//look at das_gain and das_polarity in kped (setup tn)
		//AnalogUnits   	= 65536;// use this for a 64 bit AD board
		AnalogUnits   = 4096;// use this for a 12 bit AD board

		// what kind of motion detector hardware are you using?
		CheckMouth			= 1;            // use this if you have a motion detector on the MOUTH going into channel 3
		CheckBody 			= 0;            // use this if you have a motion detector on the BODY going into channel 3
	} else if (Room == 30)
	{
		// viewing measurements used to compute degrees (units need to be the same)
		Scr_width   	= 400.0; // in some units
		Scr_height  	= 300.0; // in some units
		Subj_dist   	= 400.0; // distance from center of subjects eyeball to screen

		// where does your photodiode marker need to be?
		PD_left			= -5;//6;	// distance from left of screen (same units as above)
		PD_bottom		= -15;//7;	// distance from bottom of screen (same units as above)
		PD_size			= 25;	// minimum size for consistant triggering (same units as above)

		// what is your screen resolution?
		  Scr_pixX    	= 1024;	// number of pixels across
		  Scr_pixY    	= 768;	// number of pixels in height
		Refresh_rate	= 60;	// in Hz

		// what are your eye variables?
		// In 023, calibration target is 12.8cm horizontal, 12.8 cm vertical. Atan(12.8/58) = 9.74 deg, Atan(12.8/58) = 11.23 deg
		X_Gain = 5.0;//9.74; //50; //3.492;						// x scaling factor to convert eye trace voltage to degrees (must be calculated from calibration)
		Y_Gain = 5.0;//11.23; //50; //3.729;						// y scaling factor to convert eye trace voltage to degrees (must be calculated from calibration)
		
		// what kind of hardware configuration are you using?
		Juice_channel   	= 1; //9 in 029 0 in 023
		Stim_channel		= 5;
		Eye_X_channel   	= 1;
		Eye_Y_channel   	= 2;
		PhotoD_channel  	= 3;
		
		pdThresh = -1000;
		pdRefract = 5;
		
		MaxVoltage    	= 10; 	//look at das_gain and das_polarity in kped (setup tn)
		AnalogUnits   	= 65536;// use this for a 64 bit AD board
		//AnalogUnits   = 4096;// use this for a 12 bit AD board

		// what kind of motion detector hardware are you using?
		CheckMouth			= 1;            // use this if you have a motion detector on the MOUTH going into channel 3
		CheckBody 			= 0;            // use this if you have a motion detector on the BODY going into channel 3
		
		// Isoluminant with Red (NEEDS UPDATE)
		/*
		redVal = 64;
		greenVal = 44;
		blueVal = 64;
		yrOff = 10; // Changed to orange... was 22 for yellow;
		ygOff = 14; // Changed to orange... 6 for yellow;
		mrOff = 7;
		mbOff = 15;
		cgOff = 1;
		cbOff = 30;
		wrOff = 30;
		wgOff = 6;
		wbOff = 40;
		omrOff = 5;
		ombOff = 30;
		ocgOff = 2;
		ocbOff = 20;
		oggOff = 1;
		ogrOff = 25;
		ogbOff = 10;
		bgR = 20;
		bgG = 20;
		bgB = 20;
		*/
		
		// These are 028 values
		redVal = 64;
		greenVal = 44;
		blueVal = 64;
		yrOff = 10; // Changed to orange... was 22 for yellow;
		ygOff = 14; // Changed to orange... 6 for yellow;
		mrOff = 7;
		mbOff = 15;
		cgOff = 1;
		cbOff = 30;
		wrOff = 30;
		wgOff = 6;
		wbOff = 40;
		omrOff = 5;
		ombOff = 30;
		ocgOff = 2;
		ocbOff = 20;
		oggOff = 3;
		ogrOff = 36;
		ogbOff = 18;
		bgR = 20;
		bgG = 20;
		bgB = 20;
	}
}
