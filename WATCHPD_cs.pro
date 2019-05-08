// 2018-08-06 Base code by Kaleb
// 2018-08-06 Chenchal - Changed the following:
//            1. Trigger only of pdIsOn is zero and pdVal crosses pdThresh
//            2. Reset pdIsOn to Zero only when
//               (a) pdIsOn is 1 and
//               (b) pdVal is below pdThresh and
//               (c) timeElapsed from lastTriggerOn is > nextRefreshIn
//                   where nextRefreshIn is set to 16 ms assuming monitor
//                   refresh to be 60Hz monitor
//            3. WAIT for 1 ms before continuing while(1) loop
//

declare WATCHPD(int PhotoD_channel);

process WATCHPD(int PhotoD_channel)
{

	declare int pdIsOn;
	declare int lastTriggerOn;
	declare int ip;
	declare int pdCount;
	declare int pdSum;
	// next screen refresh approx. in ms
	// should be floor(1000/refreshRateInHz)
	declare int nextRefreshIn = 16;
	declare int PDtrigger_ = 8888;

	while (1)
	{
		nextRefreshIn = Int(floor(1000.0/Refresh_rate));
		pdVect[pdCount] = atable(PhotoD_channel);
		pdCount = (pdCount+1) % pdN;

		
		
		pdSum = 0;
		ip = 0;
		while (ip < pdN)
		{
			pdSum = pdSum + pdVect[ip];
			ip = ip + 1;
		}
		pd_val = pdSum/pdN;
    //set pdTrigger flag
		
		
		if (pdIsOn == 0 && (pd_val > pdThresh))
		{
			pdIsOn = 1;
			lastTriggerOn = time();

			Event_fifo[Set_event] = PDtrigger_;
			Set_event = (Set_event + 1) % Event_fifo_N;
		}
		// Unset pdTrigger flag
		else if (pdIsOn == 1 && (pd_val < pdThresh) && ((time() - lastTriggerOn) > nextRefreshIn))
		{
			pdIsOn = 0;
		}
		
    // Wait for 1 ms
		WAIT 1;
		
		//nexttick;
	}
}
