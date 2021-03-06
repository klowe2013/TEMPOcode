

declare WATCHPD(int PhotoD_channel);

process WATCHPD(int PhotoD_channel)
{
	
	declare int lasttime;
	
	declare int pdOn;
	declare int lastWasOn;
	declare int ip;
	declare int pdCount;
	declare int pdSum;
	
	while (1)
	{
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
		
		/*
		if (time() > lasttime + 1000)
		{
			printf("pd_val = %d\n",pd_val);
			lasttime = time();
		}
		*/
		if ((pd_val < pdThresh)) // && (time() < (lastWasOn+pdRefract)))
		{
			//Event_fifo[Set_event] = 8888;
			//Set_event = (Set_event + 1) % Event_fifo_N;
			pdIsOn = 1;
			lastWasOn = time();
		} else if ((pd_val > pdThresh) && (time() > (lastWasOn+pdRefract)))
		{
			pdIsOn = 0;
		}
		
		nexttick;
	}
}