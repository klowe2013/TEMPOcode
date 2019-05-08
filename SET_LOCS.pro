// Edit on 181119: Adding loop "id < SetSize" to independently assign eccentricities
//     This edit removes "SearchEcc" as a meaningful variable
//
// Edit 181220
// SearchEcc is now a meaningful variable that sets the centerpoint of a jittering of eccentricities.
// This edit also allows for the jittering of eccentricities to the tenth of a degree but within +/- eccJitter/2 of SearchEcc

declare SET_LOCS();

process SET_LOCS()
{
	declare hide int ia;
	declare hide int angDiff;
	//declare hide int targInd;
	declare hide int ie;
	declare hide int id;
	declare hide int sumProbs;
	declare hide int lastVal;
	declare hide int thisVal;
	declare hide int cumEProbs[8];
	declare hide int SearchInd;
	declare hide int break;
	declare hide int randVal;
	declare hide int perJitter;
	declare hide float jitterOff;
	// eventCodes     put that word in files where I drop event codes for pro/anti so it's searchable
	
	// Start loop for eccentricities
	id = 0;
	while (id < SetSize)
	{
		if (id == 0)
		{
			ie = 0;
			sumProbs = 0;
			while (ie < nEccs)
			{
				sumProbs = sumProbs+eccProbs[ie];
				ie = ie+1;
			}
			nexttick;
			
			//turn relative probabilities into CDF*100
			ie = 0;
			lastVal = 0;
			thisVal = 0;
			while (ie < nEccs)
			{
				thisVal = eccProbs[ie]*100;
				cumEProbs[ie] = (thisVal/sumProbs)+lastVal;
				lastVal = cumEProbs[ie];
				ie = ie+1;
			}
			nexttick;
			
			// Select random value
			randVal = random(100);
			SearchInd = 0;
			break = 0;
			while (randVal >= cumEProbs[SearchInd] && break == 0)
			{
				SearchInd = SearchInd+1;
				if (SearchInd == nEccs)
				{
					SearchInd = nEccs-1;
					break = 1;
				}
			}
			SearchEcc = eccList[SearchInd];
			stimEccs[id] = float(eccList[SearchInd]);
		} else if (independentEcc==1)
		{
			// Get jitter value
			perJitter = random(100)*eccJitter;
			jitterOff = round(perJitter/10);
			stimEccs[id] = float(SearchEcc) - (eccJitter/2) + (jitterOff/10);
		} else
		{
			stimEccs[id] = SearchEcc;
			nexttick;
		}
		id = id+1;
	}
	
	// First, check that the set size hasn't changed
	if (SetSize > 2)
	{
		angDiff = 360/SetSize;
		ia = 0;
		
		if (randAngle == 1)
		{
			angleOffset = random(angDiff);
		} else if (randAngle == 2)
		{
			randVal = random(2);
			if (randVal == 0)
			{
				nexttick;
			} else
			{
				angleOffset = (angleOffset + (angDiff/2)) % 360;
			}
		}
		
		while (ia < SetSize)
		{
			if (angleOffset < 0)
			{
				angleOffset = angDiff + angleOffset;
			}
			Angle_list[ia] = (90+angleOffset+(angDiff*ia)) % 360;
			Eccentricity_list[ia] = stimEccs[ia]; //SearchEcc;
			
			//Event_fifo[Set_event] = 5000 + Angle_list[ia];		// Set a strobe to identify this file as a Search session and...	
			//Set_event = (Set_event + 1) % Event_fifo_N;	// ...incriment event queue.
			
			
			ia = ia+1;
		}
	} else
	{
		if (randAngle == 0)
		{
			ia = random(superSetSize)*(360/superSetSize)+angleOffset;
		}
		else
		{
			ia = random(360);
		}
		Angle_list[0] = (90 + ia) % 360;
		Angle_list[1] = (Angle_list[0] + 180) % 360;
		Eccentricity_list[0] = SearchEcc;
		Eccentricity_list[1] = SearchEcc;
		//printf("In SET_LOCS Angle_list[1] = %d, [2] = %d\n",Angle_list[1],Angle_list[2]);
	}
	
	/*Event_fifo[Set_event] = 900 + SearchEcc;		// Set a strobe to identify this file as a Search session and...	
	Set_event = (Set_event + 1) % Event_fifo_N;	// ...incriment event queue.
	
	Event_fifo[Set_event] = 300 + angleOffset;		// Set a strobe to identify this file as a Search session and...	
	Set_event = (Set_event + 1) % Event_fifo_N;	// ...incriment event queue.
	*/
	nexttick;	
}