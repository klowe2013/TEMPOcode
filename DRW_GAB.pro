// This file allows the drawing of square wave elliptical gabor patches
//
// Started writing by Kaleb Lowe (kaleb.a.lowe@vanderbilt.edu) and Jake Westerberg (jacob.a.westerberg@vanderbilt.edu)
// on 6/7/18
//

declare DRW_GAB(float horizLn, float vertLn, float angle, float eccentricity, int nRings, float conversion_X, float conversion_Y);

process DRW_GAB(float horizLn, float vertLn, float angle, float eccentricity, int nRings, float conversion_X, float conversion_Y)
{
	
	declare hide float stim_ecc_x;
	declare hide float stim_ecc_y;
	declare hide float half_sizeH;
	declare hide float half_sizeV;
	declare hide int ulx;
	declare hide int uly;
	declare hide int lrx;
	declare hide int lry;
	declare hide int ir;
	declare hide int blackCol = 247;
	declare hide int whiteCol = 246;
	
	nexttick;
	
	if (referenceEcc > 0)
	{
		horizLn = horizLn*(1+((eccentricity-referenceEcc)*scaleFactor));
		vertLn = vertLn*(1+((eccentricity-referenceEcc)*scaleFactor));
	}
	// find the center of the box in x and y space based on the angle and eccentricity
	stim_ecc_x = cos(angle) * eccentricity;
	stim_ecc_y = sin(angle) * eccentricity;

	// find locations of upper left and lower right corners based on location of center and size
	half_sizeH = (horizLn/2);
	half_sizeV = (vertLn/2);
	if (scaleFactor != 0.0)
	/*
	{
		half_sizeH = half_sizeH*(scaleFactor*eccentricity);
		half_sizeV = half_sizeV*(scaleFactor*eccentricity);
	}
	*/
	ulx       = round((stim_ecc_x - half_sizeH)*conversion_X);
	uly       = round((stim_ecc_y + half_sizeV)*conversion_Y);
	lrx       = round((stim_ecc_x + half_sizeH)*conversion_X);
	lry       = round((stim_ecc_y - half_sizeV)*conversion_Y);
	
	ir = 0;
	while (ir < nRings)
	{
		// send video sync command to draw desired circle
		if ((ir % 2)==1)
		{
			dsendf("co %d;\n",blackCol);
		} else
		{
			dsendf("co %d;\n",whiteCol);
		}
		dsendf("ef %d,%d,%d,%d;\n",stim_ecc_x*conversion_X,stim_ecc_y*conversion_Y,(half_sizeH - ((half_sizeH/nRings)*ir))*conversion_X,(half_sizeH - ((half_sizeV/nRings)*ir))*conversion_Y);
		ir = ir+1;
	}
	
	
}
	