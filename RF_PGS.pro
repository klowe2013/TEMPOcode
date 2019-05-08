// This is the file that draws the RF mapping stimulus pages
//
// Started writing by Kaleb Lowe (kaleb.a.lowe@vanderbilt.edu) and Jake Westerberg (jacob.a.westerberg@vanderbilt.edu)
// on 6/6/18
//

declare RF_PGS();

process RF_PGS()
{
	
	// Declare things
	declare int ip;
	declare int is;
	declare int offset;
	
	
	// Page numbers
	declare int blank = 0;
	declare int fix_pd = 1;
	declare int fix_only = 2;
	
	// Filled or open
	declare int fill = 1;
	declare int open = 0;
	
	// Color declarations
	// declare int bg_color = 247; // Make this isoluminant gray later
	declare int fix_col = 255; 
	declare int black_pd = 247;
	
	// PD variables
	declare hide float 	pd_eccentricity;										
	declare hide float	pd_angle;
	declare hide float 	pd_angle2;
	declare hide float 	opposite;										
	declare hide float	adjacent;	

	declare hide float waitTime;
	
	declare hide int stims_saccade = 8;
	
	
	nexttick;
	
	
	// Calculate screen coordinates for stimuli on this trial								
	oSetAttribute(object_fix, aSIZE, 1*deg2pix_X, 1*deg2pix_Y);									
	oSetAttribute(object_targ, aSIZE, 1*deg2pix_X, 1*deg2pix_Y);							// while we are at it, resize fixation object on animated graph
	
	adjacent = ((scr_height/2)-((pd_bottom/2)*unit2pix_Y));///deg2pix_Y;														// Figure out angle and eccentricity of photodiode marker in pixels
	opposite = ((scr_width/2)-pd_left);///deg2pix_X;                                                         // NOTE: I am assuming your pd is in the lower left quadrant of your screen
	//printf("adj=%d,opp=%d,size=%d\n",adjacent,opposite,PD_size);
	pd_eccentricity = sqrt(((opposite-(PD_size/2)) * (opposite-(PD_size/2))) + ((adjacent-(PD_size/2)) * (adjacent-(PD_size/2))));
	pd_angle = 90 + rad2deg(atan (opposite / adjacent));
	pd_angle2 = pd_angle + 180; 																	//change this for different quadrent or write some code for flexibility
	
	
	// Color IDs (see SET_CLRS.pro)
	bgColor = 247; // Fix this when we update SET_CLRS
	
	// Draw pg 1: fixation with photodiode
	dsendf("rw %d, %d;\n",fix_pd,fix_pd);
	dsendf("cl:\n");
	// Background color
	spawnwait DRW_SQR(40.0, 0.0, 0.0, bgColor, fill, deg2pix_X, deg2pix_Y);   						// draw fixation point
	nexttick;
	// Fix point
	spawnwait DRW_SQR(fixation_size, 0.0, 0.0, fix_col, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point
	nexttick;
	// Photodiodes
	//spawnwait DRW_SQR(pd_size,pd_angle,pd_eccentricity,15,fill,deg2pix_X,deg2pix_Y);			// draw photodiode marker
	//spawnwait DRW_SQR(pd_size,pd_angle2,pd_eccentricity,15,fill,deg2pix_X,deg2pix_Y);			// draw photodiode marker
	spawnwait DRW_SQR(pd_size,pd_angle,pd_eccentricity,246,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
    spawnwait DRW_SQR(pd_size,pd_angle2,pd_eccentricity,246,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
    
	
	// Draw pg 1: fixation without photodiode
	dsendf("rw %d, %d;\n",fix_only,fix_only);
	dsendf("cl:\n");
	// Background color
	spawnwait DRW_SQR(40.0, 0.0, 0.0, bgColor, fill, deg2pix_X, deg2pix_Y);   						// draw fixation point
	nexttick;
	// Fix point
	spawnwait DRW_SQR(fixation_size, 0.0, 0.0, fix_col, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point
	//printf("Fix alone drawn, color = %d\n",fix_col);
	//spawnwait DRW_SQR(pd_size,pd_angle,pd_eccentricity,black_pd,fill,deg2pix_X,deg2pix_Y);			// draw photodiode marker
	//spawnwait DRW_SQR(pd_size,pd_angle2,pd_eccentricity,black_pd,fill,deg2pix_X,deg2pix_Y);			// draw photodiode marker
	spawnwait DRW_SQR(pd_size,pd_angle,pd_eccentricity,black_pd,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
    spawnwait DRW_SQR(pd_size,pd_angle2,pd_eccentricity,black_pd,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
    
	offset = 3;
	ip = 0;
	thisTotalStim = 0;
	
	while (ip < maxIndivPgs)
	{
		dsendf("rw %d,%d;\n",ip+offset,ip+offset); 															// draw first pg of video memory
		dsendf("cl:\n");																			// clear screen
		//spawnwait DRW_SQR(40.0, 0.0, 0.0, 15, fill, deg2pix_X, deg2pix_Y);   						// draw fixation point
		//spawnwait DRW_SQR(pd_size,pd_angle,pd_eccentricity,15,fill,deg2pix_X,deg2pix_Y);			// draw photodiode marker
		// Background color
		spawnwait DRW_SQR(40.0, 0.0, 0.0, bgColor, fill, deg2pix_X, deg2pix_Y);   						// draw fixation point
		// Fix point
		spawnwait DRW_SQR(fixation_size, 0.0, 0.0, fix_col, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point
		//spawnwait DRW_SQR(pd_size,pd_angle,pd_eccentricity,15,fill,deg2pix_X,deg2pix_Y);			// draw photodiode marker
		//spawnwait DRW_SQR(pd_size,pd_angle2,pd_eccentricity,15,fill,deg2pix_X,deg2pix_Y);			// draw photodiode marker
		//nexttick;
		spawnwait DRW_SQR(pd_size,pd_angle,pd_eccentricity,246,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
		spawnwait DRW_SQR(pd_size,pd_angle2,pd_eccentricity,246,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
    
		is = 0;
		while (is < numStims[ip])
		{
			spawnwait DRW_GAB(stimSizeVal[thisTotalStim],stimSizeVal[thisTotalStim], stimAngVal[thisTotalStim], stimEccVal[thisTotalStim],stimRingsVal[thisTotalStim],deg2pix_X,deg2pix_Y);
			is = is+1;
			thisTotalStim = thisTotalStim + 1;
			//printf("Stim num %d: a=%d,e=%d,s=%d\n",is,stimAngVal[thisTotalStim-1],stimEccVal[thisTotalStim-1],stimSizeVal[thisTotalStim-1]);
			nexttick;
		}
		//printf("thisTotalStim (at ip=%d) = %d\n",ip,thisTotalStim);
		
		ip = ip + 1;		
	}
	
	
	
	dsendf("rw %d,%d;\n",ip+offset,ip+offset); 															// draw first pg of video memory
	dsendf("cl:\n");																			// clear screen
	//spawnwait DRW_SQR(40.0, 0.0, 0.0, 15, fill, deg2pix_X, deg2pix_Y);   						// draw fixation point
	//spawnwait DRW_SQR(pd_size,pd_angle,pd_eccentricity,15,fill,deg2pix_X,deg2pix_Y);			// draw photodiode marker
	// Background color
	spawnwait DRW_SQR(40.0, 0.0, 0.0, bgColor, fill, deg2pix_X, deg2pix_Y);   						// draw fixation point
	// Fix point
	spawnwait DRW_SQR(fixation_size, 0.0, 0.0, fix_col, open, deg2pix_X, deg2pix_Y);   	// draw fixation point
	spawnwait DRW_SQR(pd_size,pd_angle,pd_eccentricity,246,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
	spawnwait DRW_SQR(pd_size,pd_angle2,pd_eccentricity,246,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker

	is = 0;
	thisTotalStim = thisTotalStim - numStims[ip-1];
	while (is < numStims[ip-1])
	{
		spawnwait DRW_GAB(stimSizeVal[thisTotalStim],stimSizeVal[thisTotalStim], stimAngVal[thisTotalStim], stimEccVal[thisTotalStim],stimRingsVal[thisTotalStim],deg2pix_X,deg2pix_Y);
		is = is+1;
		thisTotalStim = thisTotalStim + 1;
		//printf("Stim num %d: a=%d,e=%d,s=%d\n",is,stimAngVal[thisTotalStim-1],stimEccVal[thisTotalStim-1],stimSizeVal[thisTotalStim-1]);
		nexttick;
	}
	
	ip = ip + 1;
	
	// Draw pg 0 (last is displayed first)	
	// print("blank"); 																			
	dsendf("rw %d,%d;\n",blank,blank);                                          				// draw the blank screen last so that it shows up first
	//dsendf("cl:\n");                                                                            // clear screen (that's all)
	// Background color
	spawnwait DRW_SQR(40.0, 0.0, 0.0, bgColor, fill, deg2pix_X, deg2pix_Y);   						// draw fixation point
	//spawnwait DRW_SQR(pd_size,pd_angle,pd_eccentricity,black_pd,fill,deg2pix_X,deg2pix_Y);			// draw photodiode marker
	//spawnwait DRW_SQR(pd_size,pd_angle2,pd_eccentricity,black_pd,fill,deg2pix_X,deg2pix_Y);			// draw photodiode marker
	spawnwait DRW_SQR(pd_size,pd_angle,pd_eccentricity,black_pd,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
    spawnwait DRW_SQR(pd_size,pd_angle2,pd_eccentricity,black_pd,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
    
}