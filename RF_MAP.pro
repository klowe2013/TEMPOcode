// RF_MAP.pro is the main .pro file called during ALLPROSX for task
// 
// This "task" has a main fixation component during which several stimuli
// (or sets of stimuli) are presented to map RFs.
// 
// Started writing by Kaleb Lowe (kaleb.a.lowe@vanderbilt.edu) and Jake Westerberg (jacob.a.westerberg@vanderbilt.edu)
// on 5/31/18

declare RF_MAP();

process RF_MAP()
{

	// variables for task control
	declare hide int run_rf_map = 12; // Make sure this is consistent with ALLPROSX.pro
	declare hide int run_idle = 0;
	declare hide int on = 1;
	declare hide int off = 0;
	declare hide int pcnt = 0;
	
	// We may have some trial number stuff to deal with here, but let's leave it for now
	
	// Select monkey and defaults
	if (Last_task != State)  //run_anti_sess)			// Only do this if we have gone into another task or if this is first run of day.
	{
		system("dialog Select_Monkey");
		spawnwait DEFAULT(State,				// Set all globals to their default values.
						Monkey,					
						Room);				
		Last_task = State;//run_anti_sess;
	}
		
	dsend("DM RFRSH");                			// This code sets up a vdosync macro definition to wait a specified ...
	if (Room == 23)                   			// ...number of vertical retraces based on the room in which we are    ...
	{                             			// ...recording.  This kluge is necessary because vdosync operates     ...
		dsendf("vw %d:\n",1);         			// ...differently in the different rooms.  In 028 a command to wait    ...
	}                             			// ...2 refresh cycles usually only waits for one and a command to     ...
	else                              			// ...wait for 1 usually only waits for 0.  Room 029 and 023 appear to ...
	{                             			// ...work properly.
		dsendf("vw %d:\n",2);
	}
	dsend("EM RFRSH");
	
	//printf("State=%d\n",State);
	
	while(!OK)									
	{
		nexttick;
		if(Set_monkey)
		{
			spawnwait DEFAULT(State,			// Set all globals to their default values for a particular monkey.
						Monkey,						
						Room);	
			Set_monkey = 0;
			//printf("State = %d, dynamicColor = %d\n",State,dynamicColor);
			/*if (State == run_pop_prime)
				{
					dynamicColor 			= 2;
					nPerRun 				= 5;
					printf("dynamicColor = %d\n",dynamicColor);
				}*/
		}
	}
	
	// Now let's set up the trial parameters
	spawnwait SETRFMAP();
	
	// Set up colors
	spawnwait SET_CLRS(n_targ_pos); // Make sure n_targ_pos is set before calling this function
	
	printf("fixNum = %d\n",object_fixwin);
		
	
	// Send the header for RF mapping
	Event_fifo[Set_event] = RFHeader_; // Declare in EVENTDEF.pro
	Set_event = (Set_event+1) % Event_fifo_N;
	
	Event_fifo[Set_event] = Room;
	Set_event = (Set_event+1) % Event_fifo_N;
	
	nexttick 10;								// to prevent buffer overflows after task reentry.
	Trl_number = 1;
	Comp_Trl_number = 0;
	// Let's get started
	while (State == run_rf_map)
	{
		
		totalPresented = 0;
		// spawn the trial
		spawnwait RFMAP_TR(); // Figure out inputs as necessary when writing RFMAP_TR
		
		spawnwait END_TRL(trl_outcome);
		
		printf("Trial No. %d Complete \n", Comp_Trl_number);
		printf("Total Stimuli Viewed: %d\n", Comp_Trl_number);
		
		nexttick 10; // wait 5 cycles for buffer clearance? Just being consistent with other tasks
		
		while (Pause)
		{
			nexttick;
		}
	}
	State = run_idle;							// If we are out of the while loop the user wanted...
												// ...to stop Search.
	CheckMotion = 0;							// stop watching for motion detector.
												
	oDestroy(object_fixwin);					// destroy all task graph objects
	oDestroy(object_targwin);
	oDestroy(object_fix);
	oDestroy(object_targ);
	oDestroy(object_eye);
	
	oSetGraph(gleft,aCLEAR);					// clear the left graph
	
	oSetGraph(gleft,aCLEAR);					// clear the right graph
	
	spawn IDLE;									// return control to IDLE.pro
    
	
}
	