//----------------------------------------------------------------------
// LOCATE_I - Updates the global variables In_FixWin and In_TargWin 
// which tell where the eyes are.  This is called by WATCHEYE.pro every
// time the eye position changes.
//
// IN
//      No args
//      eye_x
// 		eye_y                   Mouse/eye position
//      fix_win_left		    Target and Fixation window positions
// 		fix_win_right
// 		fix_win_down
// 		fix_win_up
// 		targ_win_left
// 		targ_win_right
// 		targ_win_down
// 		targ_win_up
//
// OUT
//      In_FixWin                1 for yes, 0 for no
//		In_TargWin
//
// NOTE:  The logic of this function does not preclude the eyes being
// both at fixaion and at the target simultaneously.  This could 
// happen if the user accidentally made two overlapping windows in the
// setup.  It is up to the user to handle this with input or in the 
// protocol.
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011
//
//
// 190618 - Added circWin to use a circle equation to enforce a circular, rather than rectangular, target window. The window won't render
// as a circle in the graphs, but the underlying logic will be that of a circle inscribed in the graphed box. - KAL


declare int In_FixWin, In_TargWin; 
declare float reportTime;
declare float eccentricity, eccX, eccY;

declare LOCATE_I(float eye_x,
				float eye_y,
				float fix_win_left,
				float fix_win_right,
                float fix_win_down, 
				float fix_win_up,
				float targ_win_left, 
				float targ_win_right,
				float targ_win_down, 
				float targ_win_up);
				
process LOCATE_I(float eye_x,
                float eye_y,
                float fix_win_left,
                float fix_win_right,
                float fix_win_down, 
                float fix_win_up,
                float targ_win_left, 
                float targ_win_right,
                float targ_win_down, 
                float targ_win_up)
	{

	// See if subject is in the fixation window
	if (eye_x >= fix_win_left  &&
		eye_x <= fix_win_right &&
		eye_y <= fix_win_down  &&
		eye_y >= fix_win_up)
		{
		In_FixWin = 1;               // Subject is inside fixation window
		}
	else
		In_FixWin = 0;               // Subject is not inside fixation window
		
	
	
	// See if subject is in the target window
	if (circWin)
	{	
		eccX = ((targ_win_right+targ_win_left)/2);
		eccY = ((targ_win_up+targ_win_down)/2);
		eccentricity = sqrt(eccX*eccX + eccY*eccY);
		if (sqrt((eye_x-eccX)*(eye_x-eccX)+((eye_y-eccY)*(eye_y-eccY))) <= ((targ_win_size*(1+((eccentricity-referenceEcc)*scaleFactor)))/2))
		{
			In_TargWin = 1;
		} else
		{
			In_TargWin = 0;
		}
	} else
	{
		if (eye_x >= targ_win_left  &&
			eye_x <= targ_win_right &&
			eye_y <= targ_win_down  &&
			eye_y >= targ_win_up)
			{
			In_TargWin = 1;               // Subject is inside target window
			}
		else
			In_TargWin = 0;               // Subject is not inside taraget window		
	}
	}