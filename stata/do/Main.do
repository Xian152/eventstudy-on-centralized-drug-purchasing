////////////////////////////////////////////////////////////////////////////////////////////////////
*** The effect of centralized drug-purchasing on stock value, using event study 
////////////////////////////////////////////////////////////////////////////////////////////////////
/*
Date: 12/11
Author: Xian Zhang
*/

clear all
set matsize 3956, permanent
set more off, permanent
set maxvar 32767, permanent
capture log close
sca drop _all
matrix drop _all
macro drop _all

******************************
*** Define main root paths ***
******************************
global root ""  

* Define path for data sources
global INPUT "${root}/raw data"

* Define path for do file
global INT "${root}/stata/intermediate"

* Define path for do file
global OUT "${root}/stata/output"

* Define path for output data
global DO "${root}/stata/do"

*install packages for event study：//cntrade cnindex estudy eventstudy2  psmatch2 moremata nearmrg distinct _gprod rmse parallel
foreach k in cntrade cnindex estudy eventstudy2  psmatch2 moremata nearmrg distinct _gprod rmse parallel{
	capture which `k'  
	if _rc!=0{
		ssc install `k',replace  
	}
}

******************************
*** Run do files ***
******************************
do "${DO}/Data Importing"
do "${DO}/Data Merging & Cleaning"
do "${DO}/Data Analysis" 
