// This is the actual trial control file for RF mapping. 
// Variables are set up in SETRFMAP.pro
//
// Started writing by Kaleb Lowe (kaleb.a.lowe@vanderbilt.edu) and Jake Westerberg (jacob.a.westerberg@vanderbilt.edu)
// on 5/31/18
#include C:/TEMPO/ProcLib/SETRFMAP.pro

declare RFMAP_TR();

process RFMAP_TR()
{
	// Number trial stages
	declare hide int send_fix_pd = 0;
	declare hide int need_fix = 1;
	declare hide int fixation_wait = 2;
	declare hide int stim_presentation = 3;
	declare hide int interstim_int = 4;
	declare hide int wait_saccade = 5;
	declare hide int in_flight = 6;
	declare hide int on_target = 7;
	declare hide int fix_break_test = 8;
	declare hide int targ_break_test = 9;
	// And maybe a saccade stage or two later?
	declare hide int stage;
	
	
	// Number stimuli pages to make reading easier
	declare hide int blank = 0;
	declare hide int fixation_pd = 1;
	declare hide int fixation = 2;
	declare hide int stims_1 = 3;
	declare hide int stims_2 = 4;
	declare hide int stims_3 = 5;
	declare hide int stims_4 = 6;
	declare hide int stims_5 = 7;
	declare hide int stims_saccade = 8;
	
	// Assign values to success and failure
	declare hide int success = 1;
	declare hide int failure = 0;
	
	// Code all possible outcomes (Do these interact with END_TRL in any meaningful way?)
	declare hide int constant no_fix = 1;
	declare hide int constant broke_fix = 2;
	declare hide int constant stim_break = 6; // See END_TRL
	declare hide int constant isi_break = 6;
	declare hide int constant sacc_out = 5;
	declare hide int constant hold_correct = 4;
	declare hide int constant sacc_correct = 11;
	declare hide int constant no_saccade = 3;
	declare hide int constant broke_targ = 6;

	
	// Timing variable declaration
	declare hide float fix_spot_time;
	declare hide float stim_on_time;
	declare hide float isi_start_time;
	declare hide float acquire_fix_time;
	declare hide float saccade_cue_time;
	declare hide float saccade_time;
	declare hide float acquire_targ_time;
	declare hide float fix_break_time;
	
	// Make the trial loop work
	declare hide int trl_running;
	
	// Start a stimulus presentaiton number counter
	declare hide int thisPresentation;
	declare int incPage;
	
	// Open up trl_running
	trl_running = 1;
	
	stage = send_fix_pd;
	
	Event_fifo[Set_event] = RFHeader_;									// queue TrialStart_ strobe
	Set_event = (Set_event + 1) % Event_fifo_N;	
	
	Event_fifo[Set_event] = TrialStart_;									// queue TrialStart_ strobe
	Set_event = (Set_event + 1) % Event_fifo_N;								// incriment event queue
	
	// Set up the new trial
		
	spawnwait SETRFMAP(); // Figure out inputs later
	
	spawnwait RF_PGS();
	
	oSetAttribute(object_fix, aVISIBLE); 									// turn on the fixation point in animated graph
	oSetAttribute(object_targ, aINVISIBLE); 									// turn on the fixation point in animated graph
	
	// Let's go!
	nexttick;
	thisPresentation = 0;
	while (trl_running)
	{
		
		if (stage == send_fix_pd)
		{
			// Send fix pd
			dsendf("vp %d\n",fixation_pd);
			// Drop event code
			
			while (pdIsOn == 0)
			{
				nexttick;
			}
			
			Event_fifo[Set_event] = FixSpotOn_;
			Set_event = (Set_event+1) % Event_fifo_N;
			fix_spot_time = time();
			// Send fix without pd
			dsendf("vp %d\n",fixation);
			stage = need_fix;
		}
		
		
		
		else if (stage == need_fix)
		{
			if (In_FixWin)
			{
				acquire_fix_time = time();
				Trl_Start_Time = acquire_fix_time;
				Event_fifo[Set_event] = Fixate_;
				Set_event = (Set_event + 1) % Event_fifo_N;
				stage = fixation_wait;
			}
			else if (!In_FixWin && time() > fix_spot_time + allowed_fix_time)
			{
				Event_fifo[Set_event] = Abort_;
				Set_event = (Set_event + 1) % Event_fifo_N;
				Trl_Outcome = no_fix;
				dsendf("vp %d\n",blank);
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				lastsearchoutcome = failure; // Figure out what this variable is supposed to be called
				printf("Aborted (no fixation)\n");							// ...tell the user whats up...
				trl_running = 0;											// ...and terminate the trial.
			}	
		}
			
		else if (stage == fixation_wait)
		{
			if (!In_FixWin)
			{
				Event_fifo[Set_event] = FixError_;
				Set_event = (Set_event + 1) % Event_fifo_N;
				Trl_Outcome = broke_fix;									// TRIAL OUTCOME ERROR (broke fixation)
				dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				lastsearchoutcome = failure;
				printf("Aborted (broke fixation)\n");						// ...tell the user whats up...
				trl_running = 0;											// ...and terminate the trial.
			}
			else if (In_FixWin && time() > acquire_fix_time + curr_holdtime)
			{
				printf("Showing Page %d, presentation %d of %d\n",Map_Page_Inds[thisPresentation],thisPresentation, pgsThisTrial);
				dsendf("vp %d\n",Map_Page_Inds[thisPresentation]);
				
								
				while (!pdIsOn && trl_running==1)
				{
					if (!In_FixWin)													// If the eyes stray out of the fixation window...
					{
						fix_break_time = time();
						stage = fix_break_test;
															// ...and terminate the trial.
					}
					nexttick;
				}
				
				if (trl_running == 1)
				{
					Event_fifo[Set_event] = Target_;
					Set_event = (Set_event + 1) % Event_fifo_N;
					stim_on_time = time();
					stage = stim_presentation;
				}
			}
		}
		
		else if (stage == fix_break_test)
		{
			if (!In_FixWin && time() > fix_break_time + fix_tolerance)
			{
				Event_fifo[Set_event] = FixError_;
				Set_event = (Set_event + 1) % Event_fifo_N;
				Trl_Outcome = broke_fix;									// TRIAL OUTCOME ERROR (broke fixation)
				dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				lastsearchoutcome = failure;
				printf("Aborted (broke fixation)\n");						// ...tell the user whats up...
				trl_running = 0;										// ...and terminate the trial.
			} else if (In_FixWin)
			{
				stage = fixation_wait;
				acquire_fix_time = time();
			}
		}
		
		else if (stage == stim_presentation)
		{
			
				
			if (In_FixWin && time() > stim_on_time + stim_duration[thisPresentation])
			{
				
				stage = interstim_int;
				incPage = 1;
				// Should drop an event code here?
				
				
			}
			
			else if (!In_FixWin)
			{
				Event_fifo[Set_event] = FixError_;
				Set_event = (Set_event + 1) % Event_fifo_N;
				Trl_Outcome = stim_break;									// TRIAL OUTCOME ERROR (broke fixation)
				dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				lastsearchoutcome = failure;
				printf("Failure (broke fixation during presentation)\n");						// ...tell the user whats up...
				trl_running = 0;
			}
			
			nexttick;
		}
		
		else if (stage == interstim_int)
		{
			
			if (incPage)
			{
				thisPresentation = thisPresentation+1;
				totalPresented = thisPresentation; ///////////////////////
				//printf("thisPresentation = %d\n",thisPresentation);
				dsendf("vp %d\n",fixation);
				isi_start_time = time();
				incPage = 0;
			}
			
			if ((thisPresentation+1) == pgsThisTrial && doSaccade == 1)
			{
				if (!In_FixWin)
				{
					Event_fifo[Set_event] = FixError_;
					Set_event = (Set_event + 1) % Event_fifo_N;
					Trl_Outcome = isi_break;									// TRIAL OUTCOME ERROR (broke fixation)
					dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
					oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
					oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
					lastsearchoutcome = failure;
					printf("Failure (broke fixation during ISI)\n");						// ...tell the user whats up...
					trl_running = 0;
				} else if (In_FixWin && time() > isi_start_time + isi_duration[thisPresentation])
				{
					printf("Sending to stims_saccade\n");
					dsendf("vp %d\n",stims_saccade);
					oSetAttribute(object_targ, aVISIBLE); 					// ...show target in animated graph...
					oSetAttribute(object_fix, aINVISIBLE); 					// ...remove fixation point from animated graph.
					while (!pdIsOn && trl_running==1)
					{
						if (!In_FixWin)													// If the eyes stray out of the fixation window...
						{
							Event_fifo[Set_event] = FixError_;
							Set_event = (Set_event + 1) % Event_fifo_N;
							Trl_Outcome = broke_fix;									// TRIAL OUTCOME ERROR (broke fixation)
							dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
							oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
							oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
							lastsearchoutcome = failure;
							printf("Aborted here (broke fixation)\n");						// ...tell the user whats up...
							trl_running = 0;											// ...and terminate the trial.
						}
						nexttick;
					}
					
					if (trl_running == 1)
					{
						Event_fifo[Set_event] = Target_;
						Set_event = (Set_event + 1) % Event_fifo_N;
						Event_fifo[Set_event] = FixSpotOff_;					// Queue strobe...
						Set_event = (Set_event + 1) % Event_fifo_N;				// ...incriment event queue...
						stage = wait_saccade;
						saccade_cue_time = time();
					}
					
				}
				
			} else if (In_FixWin)
			{
				//dsendf("vp %d\n",fixation);
				//isi_start_time = time();
				if (time() > isi_start_time + isi_duration[thisPresentation])
				{
					
					if (thisPresentation == pgsThisTrial && doSaccade == 0)
					{
						// This is a correct outcome
						Event_fifo[Set_event] = CatchCorrect_;										// queue strobe
						Set_event = (Set_event + 1) % Event_fifo_N;
						Trl_Outcome = hold_correct;
						totalPresented = thisPresentation; //////////////////////
						dsendf("vp %d\n",blank);
						oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
						oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
						lastsearchoutcome = success;
						printf("Successfully held for %d presentations\n",pgsThisTrial);
						trl_running = 0;
					} 
					else
					{
						printf("Showing Page %d\n",Map_Page_Inds[thisPresentation]);
						dsendf("vp %d\n",Map_Page_Inds[thisPresentation]);
						
						while (!pdIsOn && trl_running==1)
						{
							if (!In_FixWin)													// If the eyes stray out of the fixation window...
							{
								Event_fifo[Set_event] = FixError_;
								Set_event = (Set_event + 1) % Event_fifo_N;
								Trl_Outcome = broke_fix;									// TRIAL OUTCOME ERROR (broke fixation)
								dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
								oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
								oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
								lastsearchoutcome = failure;
								printf("Aborted here (broke fixation)\n");						// ...tell the user whats up...
								trl_running = 0;											// ...and terminate the trial.
							}
							nexttick;
						}
						
						if (trl_running == 1)
						{
							Event_fifo[Set_event] = Target_;
							Set_event = (Set_event + 1) % Event_fifo_N;
							stim_on_time = time();
							stage = stim_presentation;
						}
					}
					
				}
				
			}
			
			else if (!In_FixWin)
			{
				Event_fifo[Set_event] = FixError_;
				Set_event = (Set_event + 1) % Event_fifo_N;
				Trl_Outcome = isi_break;									// TRIAL OUTCOME ERROR (broke fixation)
				dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				lastsearchoutcome = failure;
				printf("Failure (broke fixation during ISI)\n");						// ...tell the user whats up...
				trl_running = 0;
			}
		}
		
		
		else if (stage == wait_saccade)
		{
			if (In_FixWin && time() > saccade_cue_time + max_saccade_time)
			{
				Trl_Outcome = no_saccade;
				dsendf("XM RFRSH:\n");
				dsendf("vp %d\n",blank);
				Event_fifo[Set_event] = CatchIncorrectNG_; //Check this code
				Set_event = (Set_event + 1) % Event_fifo_N;
				lastsearchoutcome = failure;
				printf("Error (no saccade)\n");								// ...tell the user whats up...
				spawn SVR_BELL();
				trl_running = 0;											// ...and terminate the trial.
			}
			else if (!In_FixWin)
			{
				printf("This Presentation = %d\n",thisPresentation);
				saccade_time = time();
				Event_fifo[Set_event] = Saccade_;							// ...queue strobe...
				Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
				stage = in_flight;
			}
		}
		
		else if (stage == in_flight)
		{
			if (!In_TargWin && time() > saccade_time + max_sacc_duration)
			{
				Trl_Outcome = sacc_out;
				dsendf("vp %d\n",blank);
				Event_fifo[Set_event] = Error_sacc;					// ...queue strobe for Neuro Explorer
				Set_event = (Set_event + 1) % Event_fifo_N;				// ...incriment event queue.				
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				printf("Error (inaccurate saccade)\n");						// ...tell the user whats up...
				trl_running = 0; 											// ...and terminate the trial.
			}
			else if (In_TargWin)
			{
				acquire_targ_time = time();
				stage = on_target;
				Event_fifo[Set_event] = Correct_sacc;					// ...queue strobe for Neuro Explorer
				Set_event = (Set_event + 1) % Event_fifo_N;				// ...incriment event queue.					
			}
		}
		
		else if (stage == on_target)
		{
			if (In_TargWin && time() > acquire_targ_time + targ_hold_time)
			{
				Trl_Outcome = sacc_correct;
				Event_fifo[Set_event] = Correct_;						// ...queue strobe...
				Set_event = (Set_event + 1) % Event_fifo_N;				// ...incriment event queue...
				lastsearchoutcome = success;
				printf("Correct (saccade)\n");							// ...tell the user whats up...
				dsendf("vp %d\n",blank);
				trl_running = 0;
			}
			else if (!In_TargWin)
			{
				/*
				Trl_Outcome = broke_targ;
				dsendf("vp %d\n",blank);
				Event_fifo[Set_event] = BreakTFix_;					// ...queue strobe for Neuro Explorer
				Set_event = (Set_event + 1) % Event_fifo_N;				// ...incriment event queue.				// Flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				printf("Error (broke target fixation)\n");					// ...tell the user whats up...
				trl_running = 0;											// ...and terminate the trial.
				*/
				fix_break_time = time();
				stage = targ_break_test;
			}
		}
		else if (stage == targ_break_test)
		{
			if (!In_TargWin && time() > fix_break_time + fix_break_tol)
			{
				Trl_Outcome = broke_targ;
				dsendf("vp %d\n",blank);
				Event_fifo[Set_event] = BreakTFix_;					// ...queue strobe for Neuro Explorer
				Set_event = (Set_event + 1) % Event_fifo_N;				// ...incriment event queue.				// Flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				printf("Error (broke target fixation)\n");					// ...tell the user whats up...
				trl_running = 0;											// ...and terminate the trial.
			} else if (In_TargWin)
			{
				stage = on_target;
			}
		
		nexttick;
			
	}
	
}