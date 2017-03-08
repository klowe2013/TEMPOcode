declare A_LOCS();

process A_LOCS()
{
	
	spawnwait SET_LOCS();
	
	targInd = random(SetSize);
	targ_angle = Angle_list[targInd];
	targ_ecc = Eccentricity_list[targInd];
}
	

