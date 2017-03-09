//--------------------------------------------------------------------------------------------------
// process ANTI_PGS(int curr_target, 
				// float fixation_size, 
				// int fixation_color, 
				// int sig_color, 
				// float scr_width, 
				// float scr_height, 
				// float pd_left, 
				// float pd_bottom, 
				// float pd_size);
// Figure out all stimuli that will be needed on the next search trial and
// place it all into video memory.
//
// written by joshua.d.cosman@vanderbilt.edu 	July, 2013
// modified by kaleb.a.lowe@vanderbilt.edu February 2017


declare hide float 	Size;   																	// Global output will be sent as stobes...        										
declare hide int   	Color;	
declare hide int  	singColor;
declare hide int 	distColor;							
declare hide float 	Eccentricity; 
declare hide float 	Angle;   

declare hide int id;     																// ...by INFOS.pro at trial end.

declare hide float 	targ_orient; 
declare hide float 	d1_orient; 
declare hide float 	d2_orient; 
declare hide float 	d3_orient; 
declare hide float 	d4_orient; 
declare hide float 	d5_orient; 
declare hide float 	d6_orient; 
declare hide float 	d7_orient; 
declare hide float 	d8_orient; 
declare hide float 	d9_orient; 
declare hide float 	d10_orient; 
declare hide float 	d11_orient; 

declare hide float 	targ_angle;
declare hide float 	d1_angle; 
declare hide float 	d2_angle; 
declare hide float 	d3_angle; 
declare hide float 	d4_angle; 
declare hide float 	d5_angle; 
declare hide float 	d6_angle; 
declare hide float 	d7_angle; 
declare hide float 	d8_angle; 
declare hide float 	d9_angle; 
declare hide float 	d10_angle; 
declare hide float 	d11_angle; 
      																
declare hide float 	targ_ecc;
declare hide float 	d1_ecc; 
declare hide float 	d2_ecc; 
declare hide float 	d3_ecc; 
declare hide float 	d4_ecc; 
declare hide float 	d5_ecc; 
declare hide float 	d6_ecc; 
declare hide float 	d7_ecc; 
declare hide float 	d8_ecc; 
declare hide float 	d9_ecc; 
declare hide float 	d10_ecc; 
declare hide float 	d11_ecc; 


declare ANTI_PGS(int curr_target, 																// set SETC_TRL.pro
				int singDifficulty,
				int isCatch,
				float fixation_size,                    										// see DEFAULT.pro and ALL_VARS.pro
				int fixation_color,                     										// see SET_CLRS.pro
				int sig_color,                          										// see DEFAULT.pro and ALL_VARS.pro
				float scr_width,                        										// see RIGSETUP.pro
				float scr_height,                       										// see RIGSETUP.pro
				float pd_left,                          										// see RIGSETUP.pro
				float pd_bottom,                        										// see RIGSETUP.pro
				float pd_size,                          										// see RIGSETUP.pro
				float deg2pix_X,                        										// see SET_COOR.pro
				float deg2pix_Y,                        										// see SET_COOR.pro
				float unit2pix_X,                       										// see SET_COOR.pro
				float unit2pix_Y,                       										// see SET_COOR.pro
				int object_targ);                       										// see GRAPHS.pro

process ANTI_PGS(int curr_target, 																// set SETC_TRL.pro
				int singDifficulty,
				int isCatch,
				float fixation_size,                    										// see DEFAULT.pro and ALL_VARS.pro
				int fixation_color,                     										// see SET_CLRS.pro
				int sig_color,                          										// see DEFAULT.pro and ALL_VARS.pro
				float scr_width,                        										// see RIGSETUP.pro
				float scr_height,                       										// see RIGSETUP.pro
				float pd_left,                          										// see RIGSETUP.pro
				float pd_bottom,                        										// see RIGSETUP.pro
				float pd_size,                          										// see RIGSETUP.pro
				float deg2pix_X,                        										// see SET_COOR.pro
				float deg2pix_Y,                        										// see SET_COOR.pro
				float unit2pix_X,                       										// see SET_COOR.pro
				float unit2pix_Y,                       										// see SET_COOR.pro
				int object_targ)                        										// see GRAPHS.pro
	{										
											
	declare hide float 	pd_eccentricity;										
	declare hide float	pd_angle;										
	declare hide float 	opposite;										
	declare hide float	adjacent;										
	declare hide float	stim_ecc_x;										
	declare hide float	stim_ecc_y;										
	declare hide int   	open        = 0;										
	declare hide int   	fill        = 1;										
	declare hide float 	targH;
	declare hide float	targV;
	declare hide int 	distDifficulty[12];
	declare hide int 	distCode;
	declare hide int randVal;
	declare hide float cumProbs[ndDifficulties];
	declare hide int it;
	declare hide int ic;
	declare hide int lastVal;
	declare hide int sumProbs;
	declare hide int sumCong;
	declare hide int cumCong[ndDifficulties];
	declare hide int isCong;
	declare hide int nRel;
	declare hide int relInds[ndDifficulties];
	declare hide int relProbs[ndDifficulties];
	declare hide int myInd;
	
	// number the pgs that need to be drawn
	declare hide int   	blank       = 0;										
	declare hide int	fixation_pd = 1;										
	declare hide int	fixation    = 2;
	declare hide int	plac_pd   	= 3;										
	declare hide int	plac      	= 4;	
	declare hide int	target_f_pd = 5;										
	declare hide int	target_f  	= 6;
	declare hide int	target      = 7;										
	
	
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Calculate screen coordinates for stimuli on this trial								
	size         = llength;   
	color        = 250;//curr_target + 1;	// Figure out the attributes of the current target 
	singColor 	= 251;
	distColor  = 250;
	
	angle			= targ_angle; 			
	eccentricity	= targ_ecc;	
										
	stim_ecc_x		= cos(angle) * eccentricity;
	stim_ecc_y		= sin(angle) * eccentricity * -1;

	oSetAttribute(object_targ, aSIZE, size*deg2pix_X, size*deg2pix_Y);							// while we are at it, resize fixation object on animated graph
	oSetAttribute(object_fix, aSIZE, 1*deg2pix_X, 1*deg2pix_Y);									
	
	opposite = ((scr_height/2)-pd_bottom);														// Figure out angle and eccentricity of photodiode marker in pixels
	adjacent = ((scr_width/2)-pd_left);                                                         // NOTE: I am assuming your pd is in the lower left quadrant of your screen
	pd_eccentricity = sqrt((opposite * opposite) + (adjacent * adjacent));
	pd_angle = rad2deg(atan (opposite / adjacent));
	pd_angle = pd_angle + 180; 																//change this for different quadrent or write some code for flexibility
	
	// Get distractor and target sizes
	// The below should be eliminated if we put the "catch"
	//    in the singleton difficulties, but kept for now
	if (isCatch)
	{
		targH = catchH;
		targV = catchV;
	}
	else if (!isCatch)
	{
		targH = stimHorizontal[singDifficulty];
		targV = stimVertical[singDifficulty];
	}
	
	id = 0;
	while (id < SetSize)
		{
		//if (isCatch)
		//{
		//	distDifficulty[id] = catchDifficulty;
		//} else
		//{
		//	distDifficulty[id] = random(ndDifficulties); // This line commented back out because we want to also probabilistically assign distDifficulty
		//}
		
		// OK, let's think about this. We don't want to do too many processes,
		// but we also don't want to drop irrelevant distractor codes. Where does
		// an "if" regarding congruency want to live? And how do we do it while declaring
		// the fewest number of variables? I suppose the relevant variables will be
		// sumProbs and cumProbs... a long version could declare "relInds" and "relProbs"?
		
		if (id == ((targInd + (SetSize/2)) % SetSize)) //&& (tIsCatch[targInd] == 0) // If we're discussing the anti- location...
		// the above if statement also passes the below section if the singleton is a catch (no move)
		//    that is, if the singleton is a no-move, don't bother with congruency of the anti-distractor
		{
			// First we should check if we want a congruent or incongruent distractor
			// Shoot... this requires a more involved loop for flexibility than intended... 
			//    but I suppose it's necessary
			// Get sum of relevant relative probabilities
			ic = 0;
			sumCong = 0;
			while (ic < 3) // I don't like that this is hard coded... but I suppose cong/incong/square are all we need?
			{
				sumCong = sumCong+congProb[ic];
			}
			
			// Turn relative probabilities of t difficulties into CDF*100
			ic = 0;
			lastVal = 0; // Counter for CDF
			while (it < ntDifficulties)
			{
				cumCong[it] = (congProb[it]/sumCong)*100+lastVal; // Add this percentage*100
				lastVal = cumProbs[it]; // CDF so far = lastVal
			}
			nexttick;
			
			// Select random value between 1 and 100 (0-99, really)
			randVal = random(100);
			isCong = 0;
			// If our random value is past the range of the "targInd"th CDF value, check the next one
			// Thought... should the below be >= or just >? I put >= because if there
			// are two alternatives, and should have 0/1 relative probabilities (i.e.,
			// exclusively use alternative 2), then if randVal = 0 then the first option
			// will be spuriously selected...
			while (randVal >= cumCong[isCong])
			{
				isCong = isCong+1;
			}
			//isCong = random(3); // This line would be if we're randomly picking congruency
			
			// OK, so we've picked our congruency. Now, we should go ahead and assign the "difficulty" if 
			//    the anti- distractor should be square
			if (isCong==2)
			{
				distDifficulty[id] = catchDistDiff; // Will be changed if we add catch as a "difficulty" level... commented out below
				
			}
			else if (isCong == 1) // If incongruent...
			{
				// We need to do this differently depending on whether target is pro or anti
				// If the target is pro, incongruent is also pro
				it = 0;
				nRel = 0;
				if (tIsPro[targInd]) // if target is pro, pick a pro distractor
				{
					while (it < ndDifficulties)
					{
						if (dIsPro[it]) // Only pick pro-distractors
						{
							relInds[nRel] = it;
							relProbs[nRel] = distDiffProbs[it];
							nRel = nRel+1;
						}
					}
					
					// Get CDF
					it = 0;
					sumProbs = 0;
					while (it < nRel)
					{
						sumProbs = sumProbs + distDiffProbs[relInds[it]];
					}
					
					// Turn relative relevant probs into CDF
					it = 0;
					lastVal = 0;
					while (it < nRel)
					{
						cumProbs[it] = (distDiffProbs[relInds[it]]/sumProbs)*100+lastVal; // Add this percentage*100
						lastVal = cumProbs[it]; // CDF so far = lastVal
					}
					// Do we need to pick it here? Or can we save operations (potentially)
					//    and put that part outside this loop?
				}
				else if (tIsAnti[targInd]) // if target is anti, pick an anti distractor
				{
					while (it < ndDifficulties)
					{
						if (dIsAnti[it]) // Only pick anti-distractors
						{
							relInds[nRel] = it;
							relProbs[nRel] = distDiffProbs[it];
							nRel = nRel+1;
						}
					}
					
					// Get CDF
					it = 0;
					sumProbs = 0;
					while (it < nRel)
					{
						sumProbs = sumProbs + distDiffProbs[relInds[it]];
					}
					
					// Turn relative relevant probs into CDF
					it = 0;
					lastVal = 0;
					while (it < nRel)
					{
						cumProbs[it] = (distDiffProbs[relInds[it]]/sumProbs)*100+lastVal; // Add this percentage*100
						lastVal = cumProbs[it]; // CDF so far = lastVal
					}
					// Do we need to pick it here? Or can we save operations (potentially)
					//    and put that part outside this loop?
				}
				
				// Cool. Now that we've gotten the relevant indices for either pro or anti trials,
				//    let's randomly select one of them
				randVal = random(100);
				myInd = 0;
				while (randVal >= cumProbs[myInd])
				{
					myInd = myInd+1;
				}
				// We've now picked the appropriate index INTO THE RELEVANT INDICES. So let's assign the Distractor ID
				distDifficulty[id] = relInds[id];
			}
			else if (isCong == 0) // If congruent...
			{
				// We need to do this differently depending on whether target is pro or anti
				// If the target is pro, incongruent is also pro
				it = 0;
				nRel = 0;
				if (tIsPro[targInd]) // if target is pro, pick an anti distractor
				{
					while (it < ndDifficulties)
					{
						if (dIsAnti[it]) // Only pick pro-distractors
						{
							relInds[nRel] = it;
							relProbs[nRel] = distDiffProbs[it];
							nRel = nRel+1;
						}
					}
					
					// Get CDF
					it = 0;
					sumProbs = 0;
					while (it < nRel)
					{
						sumProbs = sumProbs + distDiffProbs[relInds[it]];
					}
					
					// Turn relative relevant probs into CDF
					it = 0;
					lastVal = 0;
					while (it < nRel)
					{
						cumProbs[it] = (distDiffProbs[relInds[it]]/sumProbs)*100+lastVal; // Add this percentage*100
						lastVal = cumProbs[it]; // CDF so far = lastVal
					}
					// Do we need to pick it here? Or can we save operations (potentially)
					//    and put that part outside this loop?
				}
				else if (tIsAnti[targInd]) // if target is anti, pick a pro distractor
				{
					while (it < ndDifficulties)
					{
						if (dIsPro[it]) // Only pick anti-distractors
						{
							relInds[nRel] = it;
							relProbs[nRel] = distDiffProbs[it];
							nRel = nRel+1;
						}
					}
					
					// Get CDF
					it = 0;
					sumProbs = 0;
					while (it < nRel)
					{
						sumProbs = sumProbs + distDiffProbs[relInds[it]];
					}
					
					// Turn relative relevant probs into CDF
					it = 0;
					lastVal = 0;
					while (it < nRel)
					{
						cumProbs[it] = (distDiffProbs[relInds[it]]/sumProbs)*100+lastVal; // Add this percentage*100
						lastVal = cumProbs[it]; // CDF so far = lastVal
					}
					// Do we need to pick it here? Or can we save operations (potentially)
					//    and put that part outside this loop?
				}
				
				// Cool. Now that we've gotten the relevant indices for either pro or anti trials,
				//    let's randomly select one of them
				randVal = random(100);
				myInd = 0;
				while (randVal >= cumProbs[myInd])
				{
					myInd = myInd+1;
				}
				// We've now picked the appropriate index INTO THE RELEVANT INDICES. So let's assign the Distractor ID
				distDifficulty[id] = relInds[id];
			}
			nexttick;
					
		}			
		else // if the distractor in question is not opposite the singleton, don't bother with congruency
		{
			// Get sum of relevant relative probabilities
			it = 0;
			sumProbs = 0;
			while (it < ndDifficulties)
			{
				sumProbs = sumProbs+distDiffProbs[it];
			}
			
			// Turn relative probabilities of t difficulties into CDF*100
			it = 0;
			lastVal = 0; // Counter for CDF
			while (it < ndDifficulties)
			{
				cumProbs[it] = (distDiffProbs[it]/sumProbs)*100+lastVal; // Add this percentage*100
				lastVal = cumProbs[it]; // CDF so far = lastVal
			}
			nexttick;
			
			
			
			// Select random value between 1 and 100 (0-99, really)
			randVal = random(100);
			distDifficulty[id] = 0;
			// If our random value is past the range of the "targInd"th CDF value, check the next one
			// Thought... should the below be >= or just >? I put >= because if there
			// are two alternatives, and should have 0/1 relative probabilities (i.e.,
			// exclusively use alternative 2), then if randVal = 0 then the first option
			// will be spuriously selected...
			while (randVal >= cumProbs[distDifficulty[id]])
			{
				distDifficulty[id] = distDifficulty[id]+1;
			}
			// Loop should have broken when randVal is in the range of values assigned to a particular
			// CDF/difficulty level. When it breaks, get the appropriate difficulty level		
			
		}
		distCode = 700 + (10*id)+distDifficulty[id];
		// Drop Distractor Code
		Event_fifo[Set_event] = distCode;		// Set a strobe to identify this file as a Search session and...	
		Set_event = (Set_event + 1) % Event_fifo_N;	// ...incriment event queue.
		id = id+1;
		nexttick;
		}
	
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 1
	// print("fixation with photodiode");
	dsendf("rw %d,%d;\n",fixation_pd,fixation_pd); 												// draw first pg of video memory
	dsendf("cl:\n");																			// clear screen
	spawnwait DRW_SQR(fixation_size, 0.0, 0.0, fixation_color, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point
	spawnwait DRW_SQR(pd_size,pd_angle,pd_eccentricity,15,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
    
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 2	  
	// print("fixation");
	dsendf("rw %d,%d;\n",fixation,fixation);   													// draw second pg of video memory                                       
	dsendf("cl:\n");																			// clear screen
	spawnwait DRW_SQR(fixation_size, 0.0, 0.0, fixation_color, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point
    nexttick;
	
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 3	 
	// print("placeholders with photodiode");
	

	dsendf("rw %d,%d;\n",plac_pd,plac_pd);  												// draw pg 3                                        
	dsendf("cl:\n");																			// clear screen
	spawnwait DRW_SQR(fixation_size, 0.0, 0.0, fixation_color, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point
	
	if (SetSize > 0)
		{
		spawnwait DRW_PLAC(targ_angle, targ_ecc, color, fill, deg2pix_X, deg2pix_Y);          	// draw target
		}
	if (SetSize > 1)
		{
		id = 0;
		while (id < SetSize)
			{
			if (Angle_list[id] != targ_angle)
				{
				spawnwait DRW_PLAC(Angle_list[id], Eccentricity_list[id], color, fill, deg2pix_X, deg2pix_Y);          	// draw target
				}
			id = id+1;
			nexttick;
			}
		}
		
		
	spawnwait DRW_SQR(pd_size,pd_angle,pd_eccentricity,15,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
	nexttick;
		
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 4	 
	// print("placeholders");
	dsendf("rw %d,%d;\n",plac,plac);  												// draw pg 3                                        
	dsendf("cl:\n");

	spawnwait DRW_SQR(fixation_size, 0.0, 0.0, fixation_color, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point

	if (SetSize > 0)
		{
		spawnwait DRW_PLAC(targ_angle, targ_ecc, color, fill, deg2pix_X, deg2pix_Y);          	// draw target
		}
	
	if (SetSize > 1)
		{
		id = 0;
		while (id < SetSize)
			{
			if (Angle_list[id] != targ_angle)
				{
				spawnwait DRW_PLAC(Angle_list[id], Eccentricity_list[id], color, fill, deg2pix_X, deg2pix_Y);          	// draw target
				}
			id = id+1;
			nexttick;
			}
			
		}
		
	
	
	nexttick;
	
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 5	 
	// print("target, fixation, and distractors with photodiode");
	dsendf("rw %d,%d;\n",target_f_pd,target_f_pd);  												// draw pg 3                                        
	dsendf("cl:\n");																			// clear screen

	if (SetSize > 0)
		{
		spawnwait DRW_RECT(targH,targV,targ_angle, targ_ecc, singColor, fill, deg2pix_X, deg2pix_Y);          	// draw target
		}
	if (SetSize > 1)
		{
		id = 0;
		while (id < SetSize)
			{
			if (Angle_list[id] != targ_angle)
				{
				spawnwait DRW_RECT(distH[distDifficulty[id]],distV[distDifficulty[id]],Angle_list[id], Eccentricity_list[id], distColor, fill, deg2pix_X, deg2pix_Y);          	// draw target
				}
			
			id = id+1;
			nexttick;
			}
		}
	spawnwait DRW_SQR(fixation_size, 0.0, 0.0, fixation_color, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point

	spawnwait DRW_SQR(pd_size,pd_angle,pd_eccentricity,15,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
    nexttick;
	
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 6	 
	// print("target, fixation, and distractors");
	dsendf("rw %d,%d;\n",target_f,target_f);  												// draw pg 3                                        
	dsendf("cl:\n");																			// clear screen

	if (SetSize > 0)
		{
		spawnwait DRW_RECT(targH,targV,targ_angle, targ_ecc, singColor, fill, deg2pix_X, deg2pix_Y);          	// draw target
		}
	
	if (SetSize > 1)
		{
		id = 0;
		while (id < SetSize)
			{
			if (Angle_list[id] != targ_angle)
				{
				spawnwait DRW_RECT(distH[distDifficulty[id]],distV[distDifficulty[id]],Angle_list[id], Eccentricity_list[id], color, fill, deg2pix_X, deg2pix_Y);          	// draw target
				}
			
			id = id+1;
			nexttick;
			}
		}
		
	spawnwait DRW_SQR(fixation_size, 0.0, 0.0, fixation_color, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point

	
	spawnwait DRW_SQR(fixation_size, 0.0, 0.0, fixation_color, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point

    nexttick;
    //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 7	  
	// print("target and distractors");
	dsendf("rw %d,%d;\n",target,target);  														// draw pg 4                                        
	dsendf("cl:\n");																			// clear screen

	if (SetSize > 0)
		{
		spawnwait DRW_RECT(targH,targV,targ_angle, targ_ecc, singColor, fill, deg2pix_X, deg2pix_Y);          	// draw target
		}
	
	if (SetSize > 1)
		{
		id = 0;
		while (id < SetSize)
			{
			if (Angle_list[id] != targ_angle)
			{
				{
				spawnwait DRW_RECT(distH[distDifficulty[id]],distV[distDifficulty[id]],Angle_list[id], Eccentricity_list[id], color, fill, deg2pix_X, deg2pix_Y);          	// draw target
				}
			}
			id = id+1;
			nexttick;
			}
		}
		
	
	if (soa_mode==1)
		{
		spawnwait DRW_SQR(fixation_size, 0.0, 0.0, fixation_color, open, deg2pix_X, deg2pix_Y);
		}
	else
		{
		spawnwait DRW_SQR(fixation_size, 0.0, 0.0, fixation_color, fill, deg2pix_X, deg2pix_Y);		
		}
	nexttick; 
	
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 0 (last is displayed first)	
	// print("blank"); 																			
	dsendf("rw %d,%d;\n",blank,blank);                                          				// draw the blank screen last so that it shows up first
	dsendf("cl:\n");                                                                            // clear screen (that's all)
	
	
	}