declare SET_LOCS();

process SET_LOCS();
{
	declare hide int ia;
	declare hide int angDiff;
	//declare hide int targInd;
	
	// First, check that the set size hasn't changed
	angDiff = 360/SetSize;
	ia = 0;
	while (ia < SetSize)
	{
		Angle_list[ia] = (90+angleOffset+(angDiff*ia)) % 360;
		Eccentricity_list[ia] = SearchEcc;
	}
	
	nexttick;	
}