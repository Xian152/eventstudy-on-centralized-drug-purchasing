******************************
*** Data Merging & Cleaning ***
******************************
*保留估算窗口内的数据
use "${INT}/shenwan_medical_industry(II).dta",clear
	drop if dateipo>=mdy(12,7,2018)-300
	drop if datesusp>=mdy(12,7,2018)-300 & datesusp<mdy(12,7,2018)+100
	drop if dateresm>=mdy(12,7,2018)-300 & dateresm<mdy(12,7,2018)+100
save "${OUT}/shenwan_medical_industry(II)finallist.dta",replace
	
	keep stkcd stkcd_merge
	gen date = mdy(12,7,2018)
	format date %tdNNDDCCYY
save "${OUT}/shenwan_medical_industry(II)eventlist.dta",replace  

//the code above determined the stock sample 

*set the stock sample list. Note, the lists are based on the ”henwan_medical_industry(II)finallist.dta“. 
do "${DO}/global.do" 

***************************************************** prepare historic stock value
*********************for eventstudy2
*full sample
	foreach k in $stkcd {
		cntrade `k',path(${INPUT})  
		keep stkcd date rit
		append using "${OUT}/stkcd_returns.dta"  
		save "${OUT}/stkcd_returns.dta",replace  
		erase "${INPUT}/`k'.dta"  
	}
	drop if stkcd ==. 
save "${OUT}/stkcd_returns.dta",replace  
*4+7 city sample
	foreach k in $stkcd_47 {    
		cntrade `k',path(${INPUT})    
		keep stkcd date rit
		append using "${OUT}/stkcd_returns47.dta"  
		save "${OUT}/stkcd_returns47.dta",replace
		erase "${INPUT}/`k'.dta"
	}
	drop if stkcd ==. 
save "${OUT}/stkcd_returns47.dta",replace
*other city sample
	foreach k in $stkcd_other {
		cntrade `k',path(${INPUT}) 
		keep stkcd date rit
		append using "${OUT}/stkcd_returnsother.dta"
		save "${OUT}/stkcd_returnsother.dta",replace
		erase "${INPUT}/`k'.dta"
	}
	drop if stkcd ==. 
save "${OUT}/stkcd_returnsother.dta",replace
*medicine industry sample 
	foreach k in $stkcd_med {
		cntrade `k',path(${INPUT}) 
		keep stkcd date rit
		append using "${OUT}/stkcd_returnsmed.dta"
		save "${OUT}/stkcd_returnsmed.dta",replace
		erase "${INPUT}/`k'.dta"
	}
	drop if stkcd ==. 
save "${OUT}/stkcd_returnsmed.dta",replace
*nonmedicine industry sample
	foreach k in $stkcd_nonmed {
		cntrade `k',path(${INPUT}) 
		keep stkcd date rit
		append using "${OUT}/stkcd_returnsnonmed.dta"
		save "${OUT}/stkcd_returnsnonmed.dta",replace
		erase "${INPUT}/`k'.dta"
	}
	drop if stkcd ==. 
save "${OUT}/stkcd_returnsnonmed.dta",replace

*********************prepare datafiles for estudy
*4+7city  sample
	foreach k in $stkcd_47 {
		cntrade `k',path(${INPUT}) 
		keep stkcd date rit
		ren rit stkcd_`k'
		drop stkcd
		merge 1:1 date using "${INT}/stkcd_47.dta"  
		drop _m 
		save "${INT}/stkcd_47.dta",replace
		erase "${INPUT}/`k'.dta"
	}
	sort date
	merge 1:1 date using "${INPUT}/000300.dta"
	tab _m //fully merged 
	drop _m
	merge 1:1 date using "${OUT}/threefactor.dta"
	tab _m
	drop _m
save "${INT}/mergedta2018_47.dta",replace

* other city  sample
	foreach k in $stkcd_other {
		cntrade `k',path(${INPUT}) 
		keep stkcd date rit
		ren rit stkcd_`k'
		drop stkcd
		merge 1:1 date using "${INT}/stkcd_other.dta"  
		drop _m 
		save "${INT}/stkcd_other.dta",replace
		erase "${INPUT}/`k'.dta"
	}
	sort date
	merge 1:1 date using "${INPUT}/000300.dta"
	tab _m //fully merged 
	drop _m
	merge 1:1 date using "${OUT}/threefactor.dta"
	tab _m
	drop _m
save "${INT}/mergedta2018_other.dta",replace
* medicine industry sample
	foreach k in $stkcd_med {
		cntrade `k',path(${INPUT}) 
		keep stkcd date rit
		ren rit stkcd_`k'
		drop stkcd
		merge 1:1 date using "${INT}/stkcd_med.dta"  
		drop _m 
		save "${INT}/stkcd_med.dta",replace
		erase "${INPUT}/`k'.dta"
	}
	sort date
	merge 1:1 date using "${INPUT}/000300.dta"
	tab _m //fully merged 
	drop _m
	merge 1:1 date using "${OUT}/threefactor.dta"
	tab _m
	drop _m
save "${INT}/mergedta2018_med.dta",replace
* nonmedicine industry sample
	foreach k in $stkcd_nonmed {
		cntrade `k',path(${INPUT}) 
		keep stkcd date rit
		ren rit stkcd_`k'
		drop stkcd
		merge 1:1 date using "${INT}/stkcd_nonmed.dta"  
		drop _m 
		save "${INT}/stkcd_nonmed.dta",replace
		erase "${INPUT}/`k'.dta"
	}
	sort date
	merge 1:1 date using "${INPUT}/000300.dta"
	tab _m //fully merged 
	drop _m
	merge 1:1 date using "${OUT}/threefactor.dta"
	tab _m
	drop _m
save "${INT}/mergedta2018_nonmed.dta",replace

*full sample
	foreach k in $stkcd {
		cntrade `k',path(${INPUT}) 
		keep stkcd date rit
		ren rit stkcd_`k'
		drop stkcd
		merge 1:1 date using "${INT}/stkcd.dta"  
		drop _m 
		save "${INT}/stkcd.dta",replace
		erase "${INPUT}/`k'.dta"
	}
	sort date
	merge 1:1 date using "${INPUT}/000300.dta"
	tab _m //fully merged 
	drop _m
	merge 1:1 date using "${OUT}/threefactor.dta"
	tab _m
	drop _m
save "${INT}/mergedta2018.dta",replace

*************************************************************estimation windows
*********************prepare datafiles for eventstudy2
foreach k in s s47 sother smed snonmed{  
use "${OUT}/stkcd_return`k'.dta",clear
	keep if date>mdy(12,7,2018)-400 & date<mdy(12,7,2018)+100
save "${OUT}/stkcd_return`k'.dta",replace
}

foreach k in s s47 sother smed snonmed{
use "${OUT}/stkcd_return`k'.dta",clear
	keep if date==mdy(12,7,2018)
	keep date stkcd 
save "${OUT}/earnings_surprise`k'.dta",replace
}

use "${OUT}/threefactor.dta",clear
	keep if date>mdy(12,7,2018)-400 & date<mdy(12,7,2018)+100
	merge 1:1 date using "${INPUT}/000300.dta",keep(1 3)
	drop _m
save "${OUT}/factor_returns.dta",replace	


*********************prepare datafiles for estudy, sort date 
*sub-sample: "4+7"city, other city，medicine industry，nonmedicine industry
foreach k in 47 other med nonmed {
use "${INT}/mergedta2018_`k'.dta",clear 
tempfile after2
	keep if date>mdy(12,7,2018)-400 & date<mdy(12,7,2018)+100
	preserve                          
		keep if date>=mdy(12,7,2018) 
		sort date
		gen time = _n-1
		save `after2', replace   
	restore 
	keep if date<mdy(12,7,2018)   
	gsort -date
	gen time =-_n
	append using `after2'  
	sort time 
save "${OUT}/analysis2018_`k'.dta",replace
}

use "${OUT}/analysis2018_47.dta",clear 	
	foreach g in $stkcd_47list{
		label var `g' "`g'"    
	}
save "${OUT}/analysis2018_47.dta",replace

use "${OUT}/analysis2018_other.dta",clear 	
	foreach g in $stkcd_otherlist{
		label var `g' "`g'"   
	}
save "${OUT}/analysis2018_other.dta",replace

use "${OUT}/analysis2018_med.dta",clear 	
	foreach g in $stkcd_medlist{
		label var `g' "`g'"   
	}
save "${OUT}/analysis2018_med.dta",replace

use "${OUT}/analysis2018_nonmed.dta",clear 	
	foreach g in $stkcd_nonmedlist{
		label var `g' "`g'"   
	}
save "${OUT}/analysis2018_nonmed.dta",replace

*full sample
use "${INT}/mergedta2018.dta",clear
tempfile after2
	keep if date>mdy(12,7,2018)-400 & date<mdy(12,7,2018)+100
	preserve
		keep if date>=mdy(12,7,2018)
		sort date
		gen time = _n-1
		save `after2', replace 
	restore 
	keep if date<mdy(12,7,2018)
	gsort -date
	gen time =-_n
	append using `after2'
	sort time 
	foreach k in $stkcd_list{
		label var `k' "`k'"
	}
save "${OUT}/analysis2018.dta",replace

*****************************************************************shenwan index
use "${OUT}/shenwan_medical_industy_index.dta",clear
	sort date
	merge 1:1 date using "${INPUT}/000300.dta",keep(3)
	drop _m
	merge 1:1 date using "${OUT}/threefactor.dta",keep(3)
	drop _m
save "${INT}/mergeindex.dta",replace

use "${OUT}/shenwan_medical_industy_index.dta",clear
	keep if date ==mdy(12,7,2018)
save "${OUT}/earnings_surprisesindex.dta",replace

* sort the date
use "${INT}/mergeindex.dta",clear
tempfile after1
	keep if date>mdy(12,7,2018)-400 & date<mdy(12,7,2018)+100
	preserve
		keep if date>=mdy(12,7,2018)
		sort date
		gen time = _n-1
		save `after1', replace 
	restore 
	keep if date<mdy(12,7,2018)
	gsort -date
	gen time =-_n
	append using `after1'
	sort time 
save "${OUT}/analysisIndex.dta",replace
