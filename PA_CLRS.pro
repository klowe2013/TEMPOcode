declare PA_CLRS();

process PA_CLRS()
{

declare hide int color_num,r_, g_, b_;
declare hide int run_anti_sess = 9;
declare hide int run_color_pop = 10;
declare hide int run_pop_prime = 11;

declare hide int ic;
declare hide int sumProbs;
declare hide int lastVal;
declare hide int thisVal;
declare hide int cumCProbs[6];
declare hide int clrInd;
declare hide int break;
declare hide int randVal;
declare hide int firstProb;
declare hide int nPresent;
declare hide int distColPick[6];
declare hide int singColPick[6];
declare hide int oldDist;
declare hide int oldSing;

// New section below allows for runs of "nPerRun" with the same color
if ((State==run_anti_sess) || (State==run_color_pop) || (State==run_pop_prime))
{
	if (dynamicColor < 2)
	{
		ic = 0;
		sumProbs = 0;
		firstProb = 0;
		while (ic < nClrs)
		{
			sumProbs = sumProbs+colorProbs[ic];
			distColPick[ic] = distColProbs[ic];
			ic = ic+1;
			//printf("ic = %d\n",ic);
			if (colorProbs[ic-1] > 0 && firstProb == 0)
			{
				firstProb = ic;
			}
		}
		nexttick;
		
		// turn relative probabilities into CDF*100
		ic = 0;
		lastVal = 0;
		thisVal = 0;
		while (ic < nClrs)
		{
			thisVal = colorProbs[ic]*100;
			cumCProbs[ic] = (thisVal/sumProbs)+lastVal;
			//printf("cumCProbs[ic] = %d\n",cumCProbs[ic]);
			lastVal = cumCProbs[ic];
			ic = ic+1;
		}
		nexttick;
		// Select random value
		randVal = random(100);
		if (randVal == 0)
		{
			clrInd = firstProb-1;
		} else
		{
			clrInd = 0;
			break = 0;
			while (randVal >= cumCProbs[clrInd] && break == 0)
			{
				clrInd = clrInd+1;
				if (clrInd == nClrs)
				{
					clrInd = nClrs - 1;
					break = 1;
				}
			}
		}
		SingCol = clrInd;
		//printf("SingCol = %d\n",clrInd);
		
		distColPick[SingCol] = 0;
		ic = 0;
		sumProbs = 0;
		firstProb = 0;
		while (ic < nClrs)
		{
			sumProbs = sumProbs+distColPick[ic];
			//printf("distColPick[%d] = %d\n",ic,distColPick[ic]);
			ic = ic+1;
			if (distColPick[ic-1] > 0 && firstProb == 0)
			{
				firstProb = ic;
			}
		}
		nexttick;
		
		// turn relative probabilities into CDF*100
		ic = 0;
		lastVal = 0;
		thisVal = 0;
		while (ic < nClrs)
		{
			thisVal = distColPick[ic]*100;
			cumCProbs[ic] = (thisVal/sumProbs)+lastVal;
			//printf("cumCProbs[%d] = %d\n",ic,cumCProbs[ic]);
			lastVal = cumCProbs[ic];
			ic = ic+1;
		}
		nexttick;
		// Select random value
		randVal = random(100);
		if (randVal == 0)
		{
			clrInd = firstProb-1;
		} else
		{
			clrInd = 0;
			break = 0;
			while (randVal >= cumCProbs[clrInd] && break == 0)
			{
				clrInd = clrInd+1;
				if (clrInd == nClrs)
				{
					clrInd = nClrs - 1;
					break = 1;
				}
			}
			
		}
		DistCol = clrInd;
		if (enforceColorDifficulty==1)
		{
			randVal = random(100);
			if (randVal <= probSwitchSingleton)
			{
				oldDist = DistCol;
				DistCol = SingCol;
				SingCol = oldDist;
			}
			if (thisTrialColorHard==1)
			{
				DistCol = hardSingDistMap[SingCol];
			} else if (thisTrialColorHard == 0)
			{
				DistCol = easySingDistMap[SingCol];
			}
			
		}
		if (colorCatch==1)
		{
			DistCol = SingCol;
		}
		//SingCol = random(2);
	}
	else if (dynamicColor==2)
	{
		// Determine which thing needs switched
		if (whichSwitch == 1) // Singleton
		{
			//printf("S=%d,D=%d\n",SingCol,DistCol);
			if (nThisRun==0 && lastWasAbort==0 && lastWasWrong==0 && Comp_Trl_number > 0)
		
			{
				// Check how many options we have...
				nPresent = 0;
				ic = 0;
				while (ic < nClrs)
				{
					//singColPick[ic] = colorProbs[ic];
					//if (ic != DistCol && colorProbs[ic] > 0 && distColPick[ic] > 0)
					if (colorProbs[ic] > 0 && distColProbs[ic] > 0)
					{
						nPresent = nPresent+1;
					}
					ic=ic+1;
				}
				//if (Comp_Trl_number == 0)
				//
				// 
				if (nPresent == 2 && Comp_Trl_number > 0)
				{
					if (colorProbs[SingCol] == 0 || colorProbs[DistCol] == 0)
					{
						ic = 0;
						sumProbs = 0;
						firstProb = 0;
						while (ic < nClrs)
						{
							sumProbs = sumProbs+colorProbs[ic];
							distColPick[ic] = distColProbs[ic];
							ic = ic+1;
							//printf("ic = %d\n",ic);
							if (colorProbs[ic-1] > 0 && firstProb == 0)
							{
								firstProb = ic;
							}
						}
						nexttick;
						
						// turn relative probabilities into CDF*100
						ic = 0;
						lastVal = 0;
						thisVal = 0;
						while (ic < nClrs)
						{
							thisVal = colorProbs[ic]*100;
							cumCProbs[ic] = (thisVal/sumProbs)+lastVal;
							//printf("cumCProbs[ic] = %d\n",cumCProbs[ic]);
							lastVal = cumCProbs[ic];
							ic = ic+1;
						}
						nexttick;
						// Select random value
						randVal = random(100);
						if (randVal == 0)
						{
							clrInd = firstProb-1;
						} else
						{
							clrInd = 0;
							break = 0;
							while (randVal >= cumCProbs[clrInd] && break == 0)
							{
								clrInd = clrInd+1;
								if (clrInd == nClrs)
								{
									clrInd = nClrs - 1;
									break = 1;
								}
							}
						}
						SingCol = clrInd;
						//printf("SingCol = %d\n",clrInd);
						
						distColPick[SingCol] = 0;
						ic = 0;
						sumProbs = 0;
						firstProb = 0;
						while (ic < nClrs)
						{
							sumProbs = sumProbs+distColPick[ic];
							//printf("distColPick[%d] = %d\n",ic,distColPick[ic]);
							ic = ic+1;
							if (distColPick[ic-1] > 0 && firstProb == 0)
							{
								firstProb = ic;
							}
						}
						nexttick;
						
						// turn relative probabilities into CDF*100
						ic = 0;
						lastVal = 0;
						thisVal = 0;
						while (ic < nClrs)
						{
							thisVal = distColPick[ic]*100;
							cumCProbs[ic] = (thisVal/sumProbs)+lastVal;
							//printf("cumCProbs[%d] = %d\n",ic,cumCProbs[ic]);
							lastVal = cumCProbs[ic];
							ic = ic+1;
						}
						nexttick;
						// Select random value
						randVal = random(100);
						if (randVal == 0)
						{
							clrInd = firstProb-1;
						} else
						{
							clrInd = 0;
							break = 0;
							while (randVal >= cumCProbs[clrInd] && break == 0)
							{
								clrInd = clrInd+1;
								if (clrInd == nClrs)
								{
									clrInd = nClrs - 1;
									break = 1;
								}
							}
							
						}
						DistCol = clrInd;
					} else
					{
						//printf("Only one option: Switching DistCol and SingCol\n");
						oldDist = DistCol;
						oldSing = SingCol;
						//printf("Current D=%d,S=%d,dTmp=%d\n",DistCol,SingCol,oldDist);
						DistCol = oldSing;
						SingCol = oldDist;
						//printf("New D=%d,S=%d,dTmp=%d,sTmp=%d\n",DistCol,SingCol,oldDist,oldSing);
					}	
					
					
					
					
				} else
				{
			
					// We need to make sure the distractor is not a possible target color...
					// So,
					//printf("DistCol=%d\n",DistCol);
					//printf("colorProbs[DistCol] = %d\n",colorProbs[DistCol]);
					if (colorProbs[DistCol] > 0 && Comp_Trl_number > 0)
					{
						ic = 0;
						while (ic < nClrs)
						{
							distColPick[ic] = distColProbs[ic];
							ic = ic+1;
						}
						distColPick[DistCol] = 0;
						//distColPick[DistCol] = 0;
						
						ic = 0;
						sumProbs = 0;
						firstProb = 0;
						while (ic < nClrs)
						{
							sumProbs = sumProbs+distColPick[ic];
							//printf("distColPick[%d] = %d\n",ic,distColPick[ic]);
							ic = ic+1;
							if (distColPick[ic-1] > 0 && firstProb == 0)
							{
								firstProb = ic;
							}
						}
						nexttick;
						
						// turn relative probabilities into CDF*100
						ic = 0;
						lastVal = 0;
						thisVal = 0;
						while (ic < nClrs)
						{
							thisVal = distColPick[ic]*100;
							cumCProbs[ic] = (thisVal/sumProbs)+lastVal;
							//printf("cumCProbs[%d] = %d\n",ic,cumCProbs[ic]);
							lastVal = cumCProbs[ic];
							ic = ic+1;
						}
						nexttick;
						// Select random value
						randVal = random(100);
						if (randVal == 0)
						{
							clrInd = firstProb-1;
						} else
						{
							clrInd = 0;
							break = 0;
							while (randVal >= cumCProbs[clrInd] && break == 0)
							{
								clrInd = clrInd+1;
								if (clrInd == nClrs)
								{
									clrInd = nClrs - 1;
									break = 1;
								}
							}
							
						}
						DistCol = clrInd;
						// Too many instructions? Let's cut that and just set DistCol=firstProb-1;
						// This will assign the distractor color to be the first one with a non-zero probability (not probabilistically choosing like elsewhere)
						
						//DistCol = firstProb-1;
						
					}
				
					//printf("New DistCol=%d\n",DistCol);
					nexttick;
					
					// Pick new singleton color probabilistically
					ic = 0;
					while (ic < nClrs)
					{

						singColPick[ic] = colorProbs[ic];
						ic = ic+1;
					}
					//printf("Set aside singleton colors...\n");
					//singColPick[SingCol] = 0;
					// Definitely need to cut out DistCol in order to prevent "Catch" trial...
					if (Comp_Trl_number > 0 || lastSwitch == whichSwitch)
					{
						singColPick[DistCol] = 0;
					}
					//if (switchColors == 1) //Not sure what this switchColors does...
					//{
					nexttick;
					// Ensure there is at least one other option...
					//printf("Checking for options...\n");
					ic = 0;
					nPresent = 0;
					while (ic < nClrs)
					{
						if (singColPick[ic] > 0)
						{
							nPresent = nPresent + 1;
						}
						ic = ic + 1;
					}
					if (nPresent == 1)
					{
						//printf("Only one option: Switching DistCol and SingCol\n");
						oldDist = DistCol;
						oldSing = SingCol;
						//printf("Current D=%d,S=%d,dTmp=%d\n",DistCol,SingCol,oldDist);
						DistCol = oldSing;
						SingCol = oldDist;
						//printf("New D=%d,S=%d,dTmp=%d,sTmp=%d\n",DistCol,SingCol,oldDist,oldSing);
						//colorProbs[SingCol] = colorProbs[DistCol];
						//colorProbs[DistCol] = 0;
						//distColProbs[DistCol] = distColProbs[SingCol];
						//distColProbs[SingCol] = 0;
						
					} else
					{
						//printf("Selecting new SingletonColor\n");
						if (Comp_Trl_number > 0 || lastSwitch == whichSwitch)
						{
							singColPick[SingCol] = 0;
						}
						ic = 0;
						sumProbs = 0;
						firstProb = 0;
						while (ic < nClrs)
						{
							sumProbs = sumProbs+singColPick[ic];
							ic = ic+1;
							//printf("\nsingColPick[%d] = %d\n",ic-1,singColPick[ic-1]);
							if (singColPick[ic-1] > 0 && firstProb == 0)
							{
								firstProb = ic;
							}
						}
						nexttick;
						
						// turn relative probabilities into CDF*100
						ic = 0;
						lastVal = 0;
						thisVal = 0;
						while (ic < nClrs)
						{
							thisVal = singColPick[ic]*100;
							cumCProbs[ic] = (thisVal/sumProbs)+lastVal;
							//printf("cumCProbs[ic] = %d\n",cumCProbs[ic]);
							lastVal = cumCProbs[ic];
							ic = ic+1;
						}
						nexttick;
						// Select random value
						randVal = random(100);
						if (randVal == 0)
						{
							clrInd = firstProb-1;
						} else
						{
							clrInd = 0;
							break = 0;
							while (randVal >= cumCProbs[clrInd] && break == 0)
							{
								clrInd = clrInd+1;
								if (clrInd == nClrs)
								{
									clrInd = nClrs - 1;
									break = 1;
								}
							}
						}
						SingCol = clrInd;
					}
				}
					/*if (SingCol == 0)
					{
					SingCol = 1;
					}
					else if (SingCol == 1)
					{
					SingCol = 0;
					}
					*/
				//}
			}
		} else if (whichSwitch == 2) // Distractor
		{
			if (nThisRun == 0 && lastWasAbort == 0 && lastWasWrong==0 && Comp_Trl_number > 0)
			{
				// Pick new distractor color probabilistically
				ic = 0;
				while (ic < nClrs)
				{
					distColPick[ic] = distColProbs[ic];
					ic = ic+1;
				}
				// Definitely need to set SingCol to 0 so they aren't catch...
				if (Comp_Trl_number > 0 || lastSwitch != whichSwitch)
				{
					distColPick[SingCol] = 0;
				}
				
				// Ensure there is at least one other option...
				ic = 0;
				nPresent = 0;
				while (ic < nClrs)
				{
					if (distColPick[ic] > 0)
					{
						nPresent = nPresent + 1;
					}
					ic = ic+1;
				}
				if (nPresent == 1)
				{
					printf("\n\n\n***NOT ENOUGH OPTIONS... KEEPING OLD DISTRACTOR COLOR\n\n\n");
				} else
				{	
					if (Comp_Trl_number > 0 || lastSwitch != whichSwitch)
					{
						distColPick[DistCol] = 0;
					}
					
					//if (switchColors == 1) //Not sure what this switchColors does...
					//
					ic = 0;
					sumProbs = 0;
					firstProb = 0;
					while (ic < nClrs)
					{
						sumProbs = sumProbs+distColPick[ic];
						ic = ic+1;
						if (distColPick[ic-1] > 0 && firstProb == 0)
						{
							firstProb = ic;
						}
					}
					nexttick;
					
					// turn relative probabilities into CDF*100
					ic = 0;
					lastVal = 0;
					thisVal = 0;
					while (ic < nClrs)
					{
						thisVal = distColPick[ic]*100;
						cumCProbs[ic] = (thisVal/sumProbs)+lastVal;
						//printf("cumCProbs[ic] = %d\n",cumCProbs[ic]);
						lastVal = cumCProbs[ic];
						ic = ic+1;
					}
					nexttick;
					// Select random value
					randVal = random(100);
					if (randVal == 0)
					{
						clrInd = firstProb-1;
					} else
					{
						clrInd = 0;
						break = 0;
						while (randVal >= cumCProbs[clrInd] && break == 0)
						{
							clrInd = clrInd+1;
							if (clrInd == nClrs)
							{
								clrInd = nClrs - 1;
								break = 1;
							}
						}
					}
					DistCol = clrInd;
				}
			}
		}
		lastSwitch = whichSwitch;
		/*if (nThisRun==0)
		{
			if (switchColors == 1)
			{
				if (SingCol == 0)
				{
				SingCol = 1;
				}
				else if (SingCol == 1)
				{
				SingCol = 0;
				}
			}
		}
		
		if (SingCol == 0)
		{
			DistCol = 1;
		} else if (SingCol == 1)
		{
			DistCol = 0;
		}
		*/
	}
	
}
}