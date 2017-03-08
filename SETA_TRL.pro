//-----------------------------------------------------------------------------------
// process SETS_TRL(int n_targ_pos,
				// float go_weight,
				// float stop_weight,
				// float ignore_weight,
				// int stop_sig_color,
				// int ignore_sig_color,
				// int staircase,
				// int n_SSDs,
				// int min_holdtime,
				// int max_holdtime,
				// int expo_jitter);
// Calculates all variables needed to run a search trial based on user defined
// space.  See DEFAULT.pro and ALL_VARS.pro for an explanation of the global input variables
//
// written by joshua.d.cosman@vanderbilt.edu 	July, 2013

//#include C:/TEMPO/ProcLib/TSCH_PGS.pro						// sets all pgs of video memory up for the impending trial
//#include C:/TEMPO/ProcLib/LSCH_PGS.pro						// sets all pgs of video memory up for the impending trial 
#include C:/TEMPO/ProcLib/ANTI_PGS.pro

declare hide int StimTm;									// Should we stim on this trial?
declare hide int Curr_target;								// OUTPUT: next trial target
declare hide int Sig_color;									// next signal color (could be either stop or ignore)
declare hide int Trl_type;									// stop, go, or ignore
declare hide int Curr_SSD;									// SSD on next stop or ignore trial
declare hide int Curr_holdtime;								// next trial time between fixation and target onset
declare hide int Decide_SSD;

declare hide int TypeCode;
declare hide int DistFix;
declare hide int singDifficulty;
declare hide int saccEnd;
declare SETA_TRL(int n_targ_pos,							// see DEFAULT.pro and ALL_VARS.pro for explanations of these globals
				float go_weight,
				float stop_weight,
				float ignore_weight,
				int staircase,
				int n_SSDs,
				int min_holdtime,
				int max_holdtime,
				int expo_jitter);

process SETA_TRL(int n_targ_pos,							// see DEFAULT.pro and ALL_VARS.pro for explanations of these globals
				float go_weight,
				float stop_weight,
				float ignore_weight,
				int staircase,
				int n_SSDs,
				int min_holdtime,
				int max_holdtime,
				int expo_jitter)
	{
	
	declare hide float decide_trl_type; 	
	declare hide float CatchNum;	
	declare hide float per_jitter, jitter, decide_jitter, holdtime_diff, plac_diff, plac_jitter;
	declare hide int fixation_color 			= 255;			// see SET_CLRS.pro
	declare hide int constant nogo_correct		= 4;			// code for successfully canceled trial (see CMDTRIAL.pro)
	declare hide int constant go_correct		= 7;			// code for correct saccade on a go trial (see CMDTRIAL.pro)
	declare hide float equalTol 				= .01; 			// allow for floating point errors when asking whether H > V or V > H
	declare hide int randVal;
	declare hide float cumProbs[ntDifficulties];
	declare hide int it;
	declare hide int lastVal;
	declare hide int sumProbs;
	
	declare hide int ii;
		
	// -----------------------------------------------------------------------------------------------
	// Update block; trls per block set in DEFAULT.pro
	if (Comp_Trl_number == Trls_per_block)								// if we have completed the number of correct trials needed per block
		{
		Block_number = Block_number + 1;						// incriment Block_number for strobing in INFOS.pro
		Comp_Trl_number = 0;										// reset the block counter
		}	

	// -----------------------------------------------------------------------------------------------
	// 1) Set up catch trial based on Perc_catch parameter in DEFAULT.pro
	
	// We'll want to update this if we decide that a "catch" should be defined by a square difficulty...
	// I'll put the appropriate line down in the "if" statement below, but keep it commented for now
	CatchNum = random(100);
	if (CatchNum > Perc_catch)
		{
		Catch = 0;
		CatchCode = 500;
		}
	else	
		{
		Catch = 1;
		CatchCode = 501;
		} 
	
	// -----------------------------------------------------------------------------------------------
	// 2) Set up all vdosync pages for the upcoming trial using globals defined by user and sets_trl.pro
	
	spawnwait SET_CLRS(n_targ_pos); //selects distractor/target colors for this trial
	
	spawnwait RAND_ORT;	// sets orientations of random stimuli
	
	spawnwait A_LOCS; // updates angles and eccentricities - assumes we want equal spacing
	
	// Now that locations have been set, figure out Set up a pro or anti trial and saccade endpoint
	
	// Here, let's take the code I wrote in A_LOCS.pro to randomize singleton difficulty
	
	// Get sum of relevant relative probabilities
	it = 0;
	sumProbs = 0;
	while (it < ntDifficulties)
	{
		sumProbs = sumProbs+targDiffProbs[it];
	}
	
	// Turn relative probabilities of t difficulties into CDF*100
	it = 0;
	lastVal = 0; // Counter for CDF
	while (it < ntDifficulties)
	{
		cumProbs[it] = (targDiffProbs[it]/sumProbs)*100+lastVal; // Add this percentage*100
		lastVal = cumProbs[it]; // CDF so far = lastVal
	}
	nexttick;
	
	// Select random value between 1 and 100 (0-99, really)
	randVal = random(100);
	singDifficulty = 0;
	// If our random value is past the range of the "targInd"th CDF value, check the next one
	// Thought... should the below be >= or just >? I put >= because if there
	// are two alternatives, and should have 0/1 relative probabilities (i.e.,
	// exclusively use alternative 2), then if randVal = 0 then the first option
	// will be spuriously selected...
	while (randVal >= cumProbs[singDifficulty])
	{
		singDifficulty = singDifficulty+1;
	}
	// Loop should have broken when randVal is in the range of values assigned to a particular
	// CDF/difficulty level. When it breaks, get the appropriate pro/anti mapping
	nexttick;
	
	// Now, let's test whether this difficulty is a pro or anti trial
	saccEnd = targInd;
	if ((stimVertical[singDifficulty] - stimHorizontal[singDifficulty]) > equalTol)
		{
		Trl_type = 1;
		TypeCode = 600;
		}
	else if ((stimHorizontal[singDifficulty] - stimVertical[singDifficulty]) > equalTol)
		{
		Trl_type = 2;
		TypeCode = 601;
		saccEnd = (targInd+(SetSize/2)) % SetSize;
		}
	/*
	// This if statement should work because it's in an else... a negative value < -equaltol
	// should have been caught by the first if
	else if (((stimHorizontal[singDifficulty] - stimVertical[singDifficulty]) < equalTol) || ((stimVertical[singDifficulty] - stimHorizontal[singDifficulty]) < equalTol))
		{
		catchPro = random(2);
		if (catchPro)
		{
			Trl_type = 1;
			TypeCode = 600;
		}
		else if (!catchPro)
		{
			Trl_type = 2;
			TypeCode = 601;
			saccEnd = (targInd+(SetSize/2))% SetSize;
		}
		}
	*/
	
	spawnwait ANTI_PGS(curr_target,							// set above
			singDifficulty,								// singleton difficulty - H and V set in DEFAULT.pro
			Catch, 										// Is this a catch trial?
			fixation_size, 								// see DEFAULT.pro and ALL_VARS.pro
			fixation_color, 							// see SET_CLRS.pro
			sig_color, 									// see DEFAULT.pro and ALL_VARS.pro
			scr_width, 									// see RIGSETUP.pro
			scr_height, 								// see RIGSETUP.pro
			pd_left, 									// see RIGSETUP.pro
			pd_bottom, 									// see RIGSETUP.pro
			pd_size,									// see RIGSETUP.pro
			deg2pix_X,									// see SET_COOR.pro
			deg2pix_Y,									// see SET_COOR.pro
			unit2pix_X,									// see SET_COOR.pro
			unit2pix_Y,									// see SET_COOR.pro
			object_targ);								// see GRAPHS.pro	
	
	
	// -----------------------------------------------------------------------------------------------
	// 3) Set Up Target and Fixation Windows and plot them on animated graphs
	spawnwait WINDOWS(saccEnd,							// see above
				fix_win_size,								// see DEFAULT.pro and ALL_VARS.pro
				targ_win_size,								// see DEFAULT.pro and ALL_VARS.pro
				object_fixwin,								// animated graph object
				object_targwin,								// animated graph object
				deg2pix_X,									// see SET_COOR.pro
	            deg2pix_Y);                                 // see SET_COOR.pro
		
	// -----------------------------------------------------------------------------------------------
	// 4) Select current holdtime
	
	holdtime_diff 	= max_holdtime - min_holdtime;			// Min and Max holdtime defined in DEFAULT.pro
	per_jitter 		= random(1001) / 1000.0;				// random number 0-100 (percentages)	
	jitter 			= holdtime_diff * per_jitter;			// multiply range of holdtime differences by percentage above
	
	if (FixJitter == 0) 
		{
		Curr_holdtime 	= round(min_holdtime + jitter);			// gives randomly jittered holdtime between min and max holdtime 
		}
	else if(FixJitter == 1)
		{
		Curr_holdtime 	= 500;
		}
	// -----------------------------------------------------------------------------------------------
	// 5) Select current fixation offset SOA
	if (soa_mode==1)
		{
			per_jitter = random(4);  //returns random number between 0 and n-1
			search_fix_time = SOA_list[per_jitter];
		}
	else
		{
		search_fix_time = 0;
		}
	// -----------------------------------------------------------------------------------------------
	// 6) Set placeholder duration
	
	plac_diff 		= max_plactime - min_plactime;			// Min and Max holdtime defined in DEFAULT.pro
	plac_jitter 	= plac_diff * per_jitter;				// multiply range of holdtime differences by percentage above
	
	plac_duration 	= round(min_plactime + plac_jitter);	// gives randomly jittered holdtime between min and max holdtime 

	
	// -----------------------------------------------------------------------------------------------
	// 7) Choose whether to stim
	//StimTm = Random(2); //allows us to randomize the time stim is delivered; see task stages in SCHTRIAL.pro
	//StimTm = 1; //Single stim time
	StimTm = 0; //stim off
	//StimTm = 5; //For prolonged stim protocol
	// -----------------------------------------------------------------------------------------------
	// 8) Choose Eccentricity
	
	SelEcc = Random(3); //choose from four eccentricities randomly; see line 130 LOC_RAND.pro
	
	}
	
	
	