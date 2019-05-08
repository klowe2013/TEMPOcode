// This is the RF mapping variable setup file. 
//
// Started writing by Kaleb Lowe (kaleb.a.lowe@vanderbilt.edu) and Jake Westerberg (jacob.a.westerberg@vanderbilt.edu)
// on 6/6/18
//
// What things need to be set up?
// 1) Initial fix hold time
// 2) How many total pages (incl. repeats) and their order
// 3) How many stimuli on each page? (and their locations)
// 4) ISI and Stimulus durations
// 5) Probability of repeating stimuli

declare SETRFMAP();

process SETRFMAP()
{
	
	// Declare useful variables
	declare int pgRange;
	declare int ip;
	declare int stimsThisPg;
	declare int pgStimsRange;
	declare float is;
	//declare int numStims;
	declare int doRepeat;
	
	declare float holdtime_diff;
	declare float isiDiff;
	declare float stimDurDiff;
	declare float decide_jitter;
	declare float per_jitter;
	declare float jitter;
	
    // declare counters
	declare hide int ctr_ecc = 0;
	declare hide int ctr_ang = 0;
	declare hide int ctr_size = 0;
	
	
	// Current hold time:
	holdtime_diff 	= max_holdtime - min_holdtime;			// Min and Max holdtime defined in DEFAULT.pro
	if (expo_jitter)
	{
		decide_jitter = (random(1001))/1000.0;
		per_jitter = exp(-1.0*(decide_jitter/nonAgeVal));
	}
	else
	{
		per_jitter 		= random(1001) / 1000.0;				// random number 0-100 (percentages)	
	}
	jitter 			= holdtime_diff * per_jitter;			// multiply range of holdtime differences by percentage above
	
	if (FixJitter == 0) 
		{
		Curr_holdtime 	= round(min_holdtime + jitter);			// gives randomly jittered holdtime between min and max holdtime 
		}
	else if(FixJitter == 1)
		{
		Curr_holdtime 	= 500;
		}
	
	
	ctr_ecc = 0;
	ctr_ang = 0;
	ctr_size = 0;
	
	is = min_ecc - gap_ecc;
	while (is < max_ecc)
	{
		Eccentricity_list[ctr_ecc] = is + gap_ecc;
		is = is + gap_ecc;
		ctr_ecc = ctr_ecc + 1;
	}
	nexttick;
	
	is = min_ang - gap_ang;
	while (is < max_ang)
	{
		Angle_list[ctr_ang] = is + gap_ang;
		is = is + gap_ang;
		ctr_ang = ctr_ang + 1;
	}
	nexttick;
	
	is = min_size - gap_size;
	while (is < max_size)
	{
		Size_list[ctr_size] = is + gap_size;
		is = is + gap_size;
		ctr_size = ctr_size + 1;
	}
	nexttick;
			
	nEccs = ctr_ecc;
	nAngs = ctr_ang;
	nSizes = ctr_size;
	
	nexttick;
	
	// Select variables for individual pages
	ip = 0;
	thisTotalStim = 0;
	while (ip < maxIndivPgs) // Declare this in ALL_VARS
	{
		is = 0;
		pgStimsRange = maxTrStims-minTrStims; // Declare these in ALL_VARS
		numStims[ip] = minTrStims + random(pgStimsRange);
		if (ip == (maxIndivPgs-1))
		{
			numStims[ip] = 1;
		}
		while (is < numStims[ip])
		{
			
			stimEccVal[thisTotalStim] = Eccentricity_list[random(nEccs)];
			stimEccPg[thisTotalStim] = ip;
			stimEccStim[thisTotalStim] = is;
			stimAngVal[thisTotalStim] = Angle_list[random(nAngs)];
			stimAngPg[thisTotalStim] = ip;
			stimAngStim[thisTotalStim] = is;
			stimSizeVal[thisTotalStim] = Size_list[random(nSizes)];
			stimSizePg[thisTotalStim] = ip;
			stimSizeStim[thisTotalStim] = is;
			stimRingsVal[thisTotalStim] = nParts;
			stimRingsPg[thisTotalStim] = ip;
			stimRingsStim[thisTotalStim] = is;

			is = is + 1;
			thisTotalStim = thisTotalStim+1;
		
		}
		if (ip == (maxIndivPgs-1))
		{
			Angle_list[0] = stimAngVal[thisTotalStim-1];
			Eccentricity_list[0] = stimEccVal[thisTotalStim-1];
		}
		
		ip = ip + 1;
		nexttick;
	}	
	
	
	// How many total pages?
	pgRange = maxTrPgs - minTrPgs; // Declare these in ALL_VARS
	pgsThisTrial = random(pgRange)+minTrPgs;
	
	ip = 0;
	while (ip < pgsThisTrial)
	{
		if ((ip+1) == pgsThisTrial)
		{
			Map_Page_Inds[ip] = (maxIndivPgs-1);
		} else
		{
			if (enforceRepeat == 1)
			{
				doRepeat = random(1000);
				if (doRepeat < (percRepeat*10) && ip > 0)
				{
					Map_Page_Inds[ip] = Map_Page_Inds[ip-1];
				} else
				{
					Map_Page_Inds[ip] = random(maxIndivPgs);
					if (ip > 0)
					{
						while (Map_Page_Inds[ip] == Map_Page_Inds[ip-1])
						{
							Map_Page_Inds[ip] = random(maxIndivPgs)+3;
						}
					}
				}
			} else
			{
				Map_Page_Inds[ip] = random(maxIndivPgs)+3;
			}
		}
		
		isiDiff = max_isi - min_isi;
		if (expo_jitter)
		{
			decide_jitter = (random(1001))/1000.0;
			per_jitter = exp(-1.0*(decide_jitter/nonAgeVal));
		} else
		{
			per_jitter = random(1001)/1000.0;
		}
		jitter = isiDiff * per_jitter;
		isi_duration[ip] = min_isi+jitter;
		
		stimDurDiff = max_stimDur - min_stimDur;
		if (expo_jitter)
		{
			decide_jitter = (random(1001))/1000.0;
			per_jitter = exp(-1.0*(decide_jitter/nonAgeVal));
		} else
		{
			per_jitter = random(1001)/1000.0;
		}
		jitter = stimDurDiff * per_jitter;
		stim_duration[ip] = min_stimDur+jitter;
		nexttick;
		ip = ip+1;
	} 
	// 3) Set Up Target and Fixation Windows and plot them on animated graphs
	spawnwait WINDOWS(0,							// see above
				fix_win_size,								// see DEFAULT.pro and ALL_VARS.pro
				targ_win_size,								// see DEFAULT.pro and ALL_VARS.pro
				object_fixwin,								// animated graph object
				object_targwin,								// animated graph object
				deg2pix_X,									// see SET_COOR.pro
	            deg2pix_Y);                                 // see SET_COOR.pro
		
	nexttick;
	
}
	
	