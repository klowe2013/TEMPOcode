// This sets all of the colors up which will be needed for the protocol based on user input
// specified elsewhere
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011

declare SET_CLRS(n_targ_pos);

process SET_CLRS(n_targ_pos)
	{
	declare hide int color_num,r_, g_, b_;
	declare hide int run_anti_sess = 9;
	declare hide int run_color_pop = 10;
	declare hide int run_pop_prime = 11;
	
	declare hide int ic;
	declare hide int sumProbs;
	declare hide int lastVal;
	declare hide int thisVal;
	declare hide int cumCProbs[6];
	declare hide int clrInd;
	declare hide int break;
	declare hide int randVal;
	declare hide int firstProb;
	declare hide int nPresent;
	declare hide int distColPick[6];
	declare hide int singColPick[6];
	declare hide int oldDist;
	declare hide int oldSing;
	
	r_ = 0; g_ = 1; b_ = 2;
	
	color_num = 0;
		
	while (color_num <=  n_targ_pos)				// set each target color to the matching color number 
		{
		dsendf("cm %d %d %d %d;\n",
						color_num + 1,				// 0 remains black
						Color_list[color_num,r_],	// GLOBAL ALERT; Color_list is an array so it cannot be passed
						Color_list[color_num,g_],
						Color_list[color_num,b_]);
		color_num = color_num + 1;
		nexttick;									// if we have a large number of targets we don't want to overflow the buffer
		}
	
		// if (expo_jitter_soa == 0) 
		// {
		// Fixation_color[r_]		= 0;
		// Fixation_color[g_]		= 36;
		// Fixation_color[b_]		= 0;
		// }
		// else if (expo_jitter_soa == 1)
		// {
		// Fixation_color[r_]		= 0;
		// Fixation_color[g_]		= 0;
		// Fixation_color[b_]		= 59;
		// }
	
	// Following code is specific to search task singleton color
	/*if (dynamicColor == 1 && State == run_anti_sess)
	{
		SingCol = random(2);
		if (SingCol == 0)
		{
			DistCol = 1;
		} else if (SingCol == 1)
		{
			DistCol = 0;
		}
	}
	*/
	if ((Catch==1) && ((State==run_color_pop) || (State==run_pop_prime)))
	{
		SingCol = DistCol;
	}
	
	backgroundColor[r_] 	= bgR;
	backgroundColor[g_] 	= bgG;
	backgroundColor[b_] 	= bgB;
	
	if (SingCol == 0) // Red
		{
		//Singleton_color[r_]		= 63;	
		//Singleton_color[g_]		= 0;	
		//Singleton_color[b_]		= 0;
		Singleton_color[r_] 	= redVal;
		Singleton_color[g_] 	= 0;
		Singleton_color[b_] 	= 0;
		
		}
	else if (SingCol == 1) // Green
		{
		//Singleton_color[r_]		= 0;	
		//Singleton_color[g_]		= 36;	
		//Singleton_color[b_]		= 0;
		Singleton_color[r_] 	= 0;
		Singleton_color[g_] 	= greenVal;
		Singleton_color[b_] 	= 0;
		}
	else if (SingCol == 5) // Blue
		{
		//Singleton_color[r_]		= 0;	
		//Singleton_color[g_]		= 0;	
		//Singleton_color[b_]		= 59;
		Singleton_color[r_] 	= 0;
		Singleton_color[g_] 	= 0;
		Singleton_color[b_] 	= blueVal;
		}		
	else if (SingCol == 2) // Yellow
		{
		//Singleton_color[r_]		= 100;	
		//Singleton_color[g_]		= 100;	
		//Singleton_color[b_]		= 0;
		Singleton_color[r_] 	= redVal-yrOff;
		Singleton_color[g_] 	= greenVal-ygOff;
		Singleton_color[b_] 	= 0;
		}	
	else if (SingCol == 3) // Magenta
		{
		//Singleton_color[r_]		= 255;	
		//Singleton_color[g_]		= 33;	
		//Singleton_color[b_]		= 255;
		Singleton_color[r_] 	= redVal-mrOff;
		Singleton_color[g_] 	= 0;
		Singleton_color[b_] 	= blueVal-mbOff;
		}
	else if (SingCol == 4) // Cyan
		{
		Singleton_color[r_]  = 0;
		Singleton_color[g_]  = greenVal-cgOff;
		Singleton_color[b_] = blueVal-cbOff;
		}
	else if (SingCol == 6) // Gray
		{
		Singleton_color[r_] = redVal-wrOff;
		Singleton_color[g_] = greenVal-wgOff;
		Singleton_color[b_] = blueVal-wbOff;
		}
	 else if (SingCol == 7) // Off Magenta
		{
		Singleton_color[r_] = redVal - omrOff;
		Singleton_color[g_] = 0;
		Singleton_color[b_] = blueVal - ombOff;
		}
	else if (SingCol == 8) // Off Cyan
		{
		Singleton_color[r_] = 0;
		Singleton_color[g_] = greenVal - ocgOff;
		Singleton_color[b_] = blueVal - ocbOff;
		}
	else if (SingCol == 9) // Off Green
		{
		Singleton_color[r_] = ogrOff;
		Singleton_color[g_] = greenVal - oggOff;
		Singleton_color[b_] = ogbOff;
		}
		
	 
	// Now set non-singleton
	if ((State == run_anti_sess) || (State == run_color_pop) || (State == run_pop_prime))
	{
		
		if (DistCol == 0) // Red
			{
			NonSingleton_color[r_]		= redVal;	
			NonSingleton_color[g_]		= 0;	
			NonSingleton_color[b_]		= 0;
			}
		else if (DistCol == 1) // Green
			{
			NonSingleton_color[r_]		= 0;	
			NonSingleton_color[g_]		= greenVal;	
			NonSingleton_color[b_]		= 0;
			}
		else if (DistCol == 5) // Blue
			{
			NonSingleton_color[r_]		= 0;	
			NonSingleton_color[g_]		= 0;	
			NonSingleton_color[b_]		= blueVal;
			}		
		else if (DistCol == 2) // Yellow
			{
			NonSingleton_color[r_]		= redVal-yrOff;	
			NonSingleton_color[g_]		= greenVal-ygOff;	
			NonSingleton_color[b_]		= 0;
			}	
		else if (DistCol == 3) // Magenta
			{
			NonSingleton_color[r_]		= redVal-mrOff;	
			NonSingleton_color[g_]		= 0;	
			NonSingleton_color[b_]		= blueVal-mbOff;
			}
		else if (DistCol == 4) // Cyan
			{
			NonSingleton_color[r_]  = 0;
			NonSingleton_color[g_]  = greenVal-cgOff;
			NonSingleton_color[b_] = blueVal-cbOff;
			}
		else if (DistCol == 6) // Gray
			{
			NonSingleton_color[r_] = redVal-wrOff;
			NonSingleton_color[g_] = greenVal-wgOff;
			NonSingleton_color[b_] = blueVal-wbOff;
			}
		else if (DistCol == 7) // Off Magenta
			{
			NonSingleton_color[r_] = redVal - omrOff;
			NonSingleton_color[g_] = 0;
			NonSingleton_color[b_] = blueVal - ombOff;
			}
		else if (DistCol == 8) // Off Cyan
			{
			NonSingleton_color[r_] = 0;
			NonSingleton_color[g_] = greenVal - ocgOff;
			NonSingleton_color[b_] = blueVal - ocbOff;
			}
		else if (DistCol == 9) // Off Green
			{
			NonSingleton_color[r_] = ogrOff;
			NonSingleton_color[g_] = greenVal - oggOff;
			NonSingleton_color[b_] = ogbOff;
			}
			
		oppColor[r_] = NonSingleton_color[r_] + lumOffset;
		oppColor[g_] = NonSingleton_color[g_] + lumOffset;
		oppColor[b_] = NonSingleton_color[b_] + lumOffset;
		
		nexttick;
		// now let's set cue color
		if (cueColors[cueType] == 0) // Red
			{
			Cue_color[r_]		= redVal;	
			Cue_color[g_]		= 0;	
			Cue_color[b_]		= 0;
			}
		else if (cueColors[cueType] == 1) // Green
			{
			Cue_color[r_]		= 0;	
			Cue_color[g_]		= greenVal;	
			Cue_color[b_]		= 0;
			}
		else if (cueColors[cueType] == 5) // Blue
			{
			Cue_color[r_]		= 0;	
			Cue_color[g_]		= 0;	
			Cue_color[b_]		= blueVal;
			}		
		else if (cueColors[cueType] == 2) // Yellow
			{
			Cue_color[r_]		= redVal-yrOff;	
			Cue_color[g_]		= greenVal-ygOff;	
			Cue_color[b_]		= 0;
			}	
		else if (cueColors[cueType] == 3) // Magenta
			{
			Cue_color[r_]		= redVal-mrOff;	
			Cue_color[g_]		= 0;	
			Cue_color[b_]		= blueVal-mbOff;
			}
		else if (cueColors[cueType] == 4) // Fix color
			{
			Cue_color[r_] = redVal-wrOff;
			Cue_color[g_] = greenVal-wgOff;
			Cue_color[b_] = blueVal-wbOff;
			}
		
		// Drop codes for singleton, distractor, and cue colors
		/*
		Event_fifo[Set_event] = 700 + SingCol;										// queue strobe
		Set_event = (Set_event + 1) % Event_fifo_N;
		
		Event_fifo[Set_event] = 710 + DistCol;										// queue strobe
		Set_event = (Set_event + 1) % Event_fifo_N;
		
		Event_fifo[Set_event] = 730 + cueColors[cueType];										// queue strobe
		Set_event = (Set_event + 1) % Event_fifo_N;
		*/		
	}
	nexttick;
	
	dsendf("cm 255 %d %d %d;\n",					// set the color of the fixation point to 255 (leaves room for many target colors)
						Fixation_color[r_],			// GLOBAL ALERT; Fixation_color is an array so it cannot be passed
	                    Fixation_color[g_],
						Fixation_color[b_]);
	
	dsendf("cm 254 %d %d %d;\n",					// set the color of the fixation point to 255 (leaves room for many target colors)
						Stop_sig_color[r_],			// GLOBAL ALERT; Fixation_color is an array so it cannot be passed
	                    Stop_sig_color[g_],
						Stop_sig_color[b_]);					
	
	dsendf("cm 253 %d %d %d;\n",					// set the color of the fixation point to 255 (leaves room for many target colors)
						Ignore_sig_color[r_],		// GLOBAL ALERT; Fixation_color is an array so it cannot be passed
	                    Ignore_sig_color[g_],
						Ignore_sig_color[b_]);
						
	dsendf("cm 252 %d %d %d;\n",					// set the color of the fixation point to 255 (leaves room for many target colors)
						Mask_sig_color[r_],		// GLOBAL ALERT; Fixation_color is an array so it cannot be passed
	                    Mask_sig_color[g_],
						Mask_sig_color[b_]);
	
	dsendf("cm 251 %d %d %d;\n",					// set the color of the fixation point to 255 (leaves room for many target colors)
						Singleton_color[r_],			// GLOBAL ALERT; Fixation_color is an array so it cannot be passed
	                    Singleton_color[g_],
						Singleton_color[b_]);

	dsendf("cm 250 %d %d %d;\n",					// set the color of the fixation point to 255 (leaves room for many target colors)
						NonSingleton_color[r_],			// GLOBAL ALERT; Fixation_color is an array so it cannot be passed
	                    NonSingleton_color[g_],
						NonSingleton_color[b_]);		

	dsendf("cm 249 %d %d %d;\n",					// set the color of the fixation point to 255 (leaves room for many target colors)
						Cue_color[r_],			// GLOBAL ALERT; Fixation_color is an array so it cannot be passed
	                    Cue_color[g_],
						Cue_color[b_]);			

	dsendf("cm 248 %d %d %d;\n",					// set the color of the fixation point to 255 (leaves room for many target colors)
						oppColor[r_],			// GLOBAL ALERT; Fixation_color is an array so it cannot be passed
	                    oppColor[g_],
						oppColor[b_]);

	dsendf("cm 247 %d %d %d;\n",
						backgroundColor[r_],
						backgroundColor[g_],
						backgroundColor[b_]);
	
	dsendf("cm 246 %d %d %d;\n",64,64,64); // Full white
	
	dsendf("cm 245 %d %d %d;\n",0,0,0);  // Full black
				
	dsendf("cm 0 %d %d %d;\n",
						backgroundColor[r_],
						backgroundColor[g_],
						backgroundColor[b_]);
	
	}