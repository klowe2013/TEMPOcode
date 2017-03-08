declare A_LOCS();

process A_LOCS()
{
	//declare hide int randVal;
	//declare hide float cumProbs[ntDifficulties];
	//declare hide int it;
	//declare hide int lastVal;
	//declare hide int sumProbs;
	
	// Refresh angles/eccentricities
	spawnwait SET_LOCS();
	nexttick;
	
	/* Acually.... the below section should be used for target difficulty,
	// not target location index....
	//
	//
	
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
	targInd = 0;
	// If our random value is past the range of the "targInd"th CDF value, check the next one
	// Thought... should the below be >= or just >? I put >= because if there
	// are two alternatives, and should have 0/1 relative probabilities (i.e.,
	// exclusively use alternative 2), then if randVal = 0 then the first option
	// will be spuriously selected...
	while (randVal >= cumProbs[targInd])
	{
		targInd = targInd+1;
	}
	// Loop should have broken when randVal is in the range of values assigned to a particular
	// CDF/difficulty level. When it breaks, get the appropriate angle/eccentricity
	*/
	targInd = random(SetSize);
	targ_angle = Angle_list[targInd];
	targ_ecc = Eccentricity_list[targInd];
}
	

