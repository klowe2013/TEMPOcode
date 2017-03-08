declare A_LOCS();

process A_LOCS()
{
	
	declare hide int ia;
	declare hide int angDiff;
	//declare hide int targInd;
	
	// First, check that the set size hasn't changed
	if (SetSize != Last_SetSize)
	{
		angDiff = 360/SetSize;
		ia = 0;
		while (ia < SetSize)
		{
			distAngles[ia+1] = (90+angleOffset+(angDiff*ia)) % 360;
		}
		Last_SetSize = SetSize;
	}
	nexttick;
	
	
	// Now, check eccentricity
	if (SearchEcc != Last_SearchEcc)
	{
		ia = 0;
		while (ia < SetSize)
			{
				distEccs[ia] = SearchEcc;
			}
		Last_SearchEcc = SearchEcc;
	}
	
	targInd = random(SetSize);
	targ_angle = distAngles[targInd];
	targ_ecc = distEccs[targInd];
}
	

