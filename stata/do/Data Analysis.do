******************************
*** Data Analysis ***
******************************
*************************************************************************using estudy：shenwan index
use "${OUT}/analysisIndex.dta",clear
	format date %tdNNDDCCYY
	cls
gen time1 = ""
foreach k in 12072018{  //09112018 11152018 12072018
replace time1="-----------------------`k'"
tab time1
*market model: 300 index as Rmt
	estudy rit ,  ///
		   datevar(date) evdate(`k') dateformat(MDY)  ///
		   lb1(0) ub1(1) lb2(0) ub2(3) lb3(0) ub3(5) lb4(0) ub4(7) lb5(0) ub5(9) lb6(0) ub6(11) eswlbound(-200) eswubound(-10) ///
		   indexlist(rmt) decimal(3) showpvalues  
		   
*market model: market factor as Rmt
	estudy rit ,  ///
		   datevar(date) evdate(`k') dateformat(MDY)  ///
		   lb1(0) ub1(1) lb2(0) ub2(3) lb3(0) ub3(5) lb4(0) ub4(7) lb5(0) ub5(9) lb6(0) ub6(11) eswlbound(-200)  eswubound(-10)  ///
		   indexlist(riskpremium1) decimal(3) showpvalues  
		   
*fama-french model
	estudy rit ,  ///
		   datevar(date) evdate(`k') dateformat(MDY)  ///
		   lb1(0) ub1(1) lb2(0) ub2(3) lb3(0) ub3(5) lb4(0) ub4(7) lb5(0) ub5(9) lb6(0) ub6(11) eswlbound(-200)  eswubound(-10) modtype(MFM) ///
		   indexlist(riskpremium1 smb1 hml1) diagnosticsstat(KP) decimal(3)  showpvalues  
}	

***************************************************************************estudy： full sample
use "${OUT}/analysis2018.dta",clear
	format date %tdNNDDCCYY
	cls 
gen time1 = ""
foreach k in  12072018{ //09112018 11152018 12072018
replace time1="-----------------------`k'"
tab time1
*market model: 300 index as Rmt
	estudy $stkcd_list  ,  ///
		   datevar(date) evdate(`k') dateformat(MDY) ///
		   lb1(0) ub1(1) lb2(0) ub2(3) lb3(0) ub3(5) lb4(0) ub4(7) lb5(0) ub5(9) lb6(0) ub6(11) eswlbound(-200) eswubound(-10) ///
		   indexlist(rmt) decimal(3) outputfile(${OUT}/集采市场模型（沪深）) showpvalues 
	
*market model: market factor as Rmt
	estudy $stkcd_list,  ///
		   datevar(date) evdate(`k') dateformat(MDY) ///
		   lb1(0) ub1(1) lb2(0) ub2(3) lb3(0) ub3(5) lb4(0) ub4(7) lb5(0) ub5(9) lb6(0) ub6(11) eswlbound(-200) eswubound(-10) ///
		   indexlist(riskpremium1) decimal(3) outputfile(${OUT}/集采市场模型（市场因子）) showpvalues

*fama-french model
	estudy $stkcd_list , ///
		   datevar(date) evdate(`k') dateformat(MDY) ///
		   lb1(0) ub1(1) lb2(0) ub2(3) lb3(0) ub3(5) lb4(0) ub4(7) lb5(0) ub5(9) lb6(0) ub6(11) eswlbound(-200) eswubound(-10) modtype(MFM)  ///
		   indexlist(riskpremium1 smb1 hml1) diagnosticsstat(KP) decimal(3) outputfile(${OUT}/集采三因子模型) showpvalues 
}

*******************************************************************estudy："4+7" city  subsample
use "${OUT}/analysis2018_47.dta",clear
	format date %tdNNDDCCYY
	cls 
gen time1 = ""
foreach k in  12072018{ //11152018 12072018
replace time1="-----------------------`k'"
tab time1
*market model: 300 index as Rmt
	estudy $stkcd_47list  ,  ///
		   datevar(date) evdate(`k') dateformat(MDY) ///
		   lb1(0) ub1(1) lb2(0) ub2(3) lb3(0) ub3(5) lb4(0) ub4(7) lb5(0) ub5(9) lb6(0) ub6(11) eswlbound(-200) eswubound(-10) ///
		   indexlist(rmt) decimal(3) outputfile(${OUT}/集采市场模型（沪深）47) showpvalues 
	
*market model: market factor as Rmt
	estudy $stkcd_47list,  ///
		   datevar(date) evdate(`k') dateformat(MDY) ///
		   lb1(0) ub1(1) lb2(0) ub2(3) lb3(0) ub3(5) lb4(0) ub4(7) lb5(0) ub5(9) lb6(0) ub6(11) eswlbound(-200) eswubound(-10) ///
		   indexlist(riskpremium1) decimal(3) outputfile(${OUT}/集采市场模型（市场因子）47) showpvalues

*fama-french model
	estudy $stkcd_47list , ///
		   datevar(date) evdate(`k') dateformat(MDY) ///
		   lb1(0) ub1(1) lb2(0) ub2(3) lb3(0) ub3(5) lb4(0) ub4(7) lb5(0) ub5(9) lb6(0) ub6(11) eswlbound(-200) eswubound(-10) modtype(MFM)  ///
		   indexlist(riskpremium1 smb1 hml1) diagnosticsstat(KP) decimal(3) outputfile(${OUT}/集采三因子模型47) showpvalues 
}

*******************************************************************estudy：other city
use "${OUT}/analysis2018_other.dta",clear
	format date %tdNNDDCCYY
	cls  
gen time1 = ""
foreach k in  12072018 { //11152018 12072018 09112018
replace time1="-----------------------`k'"
tab time1

*market model: 300 index as Rmt
	estudy $stkcd_otherlist  ,  ///
		   datevar(date) evdate(`k') dateformat(MDY) ///
		   lb1(0) ub1(1) lb2(0) ub2(3) lb3(0) ub3(5) lb4(0) ub4(7) lb5(0) ub5(9) lb6(0) ub6(11) eswlbound(-200) eswubound(-10) ///
		   indexlist(rmt) decimal(3) outputfile(${OUT}/集采市场模型（沪深）其他) showpvalues 
	
*market model: market factor as Rmt
	estudy $stkcd_otherlist,  ///
		   datevar(date) evdate(`k') dateformat(MDY) ///
		   lb1(0) ub1(1) lb2(0) ub2(3) lb3(0) ub3(5) lb4(0) ub4(7) lb5(0) ub5(9) lb6(0) ub6(11) eswlbound(-200) eswubound(-10) ///
		   indexlist(riskpremium1) decimal(3) outputfile(${OUT}/集采市场模型（市场因子）其他) showpvalues

*fama-french model
	estudy $stkcd_otherlist , ///
		   datevar(date) evdate(`k') dateformat(MDY) ///
		   lb1(0) ub1(1) lb2(0) ub2(3) lb3(0) ub3(5) lb4(0) ub4(7) lb5(0) ub5(9) lb6(0) ub6(11) eswlbound(-200) eswubound(-10) modtype(MFM)  ///
		   indexlist(riskpremium1 smb1 hml1) diagnosticsstat(KP) decimal(3) outputfile(${OUT}/集采三因子模型其他) showpvalues 
}

*******************************************************************estudy： med
use "${OUT}/analysis2018_med.dta",clear
	format date %tdNNDDCCYY
	cls
gen time1 = ""
foreach k in  12072018 { //11152018 12072018 09112018
replace time1="-----------------------`k'"
tab time1

*market model: 300 index as Rmt
	estudy $stkcd_medlist  ,  ///
		   datevar(date) evdate(`k') dateformat(MDY) ///
		   lb1(0) ub1(1) lb2(0) ub2(3) lb3(0) ub3(5) lb4(0) ub4(7) lb5(0) ub5(9) lb6(0) ub6(11) eswlbound(-200) eswubound(-10) ///
		   indexlist(rmt) decimal(3) outputfile(${OUT}/集采市场模型（沪深）药品) showpvalues 
	
*market model: market factor as Rmt
	estudy $stkcd_medlist,  ///
		   datevar(date) evdate(`k') dateformat(MDY) ///
		   lb1(0) ub1(1) lb2(0) ub2(3) lb3(0) ub3(5) lb4(0) ub4(7) lb5(0) ub5(9) lb6(0) ub6(11) eswlbound(-200) eswubound(-10) ///
		   indexlist(riskpremium1) decimal(3) outputfile(${OUT}/集采市场模型（市场因子）药品) showpvalues

*fama-french model
	estudy $stkcd_medlist , ///
		   datevar(date) evdate(`k') dateformat(MDY) ///
		   lb1(0) ub1(1) lb2(0) ub2(3) lb3(0) ub3(5) lb4(0) ub4(7) lb5(0) ub5(9) lb6(0) ub6(11) eswlbound(-200) eswubound(-10) modtype(MFM)  ///
		   indexlist(riskpremium1 smb1 hml1) diagnosticsstat(KP) decimal(3) outputfile(${OUT}/集采三因子模型药品) showpvalues 
}

*******************************************************************estudy：nonmed
use "${OUT}/analysis2018_nonmed.dta",clear
	format date %tdNNDDCCYY
	cls  
gen time1 = ""
foreach k in  12072018 { //11152018 12072018 09112018
replace time1="-----------------------`k'"
tab time1

*market model: 300 index as Rmt
	estudy $stkcd_nonmedlist  ,  ///
		   datevar(date) evdate(`k') dateformat(MDY) ///
		   lb1(0) ub1(1) lb2(0) ub2(3) lb3(0) ub3(5) lb4(0) ub4(7) lb5(0) ub5(9) lb6(0) ub6(11) eswlbound(-200) eswubound(-10) ///
		   indexlist(rmt) decimal(3) outputfile(${OUT}/集采市场模型（沪深）非药品) showpvalues 
	
*market model: market factor as Rmt
	estudy $stkcd_nonmedlist,  ///
		   datevar(date) evdate(`k') dateformat(MDY) ///
		   lb1(0) ub1(1) lb2(0) ub2(3) lb3(0) ub3(5) lb4(0) ub4(7) lb5(0) ub5(9) lb6(0) ub6(11) eswlbound(-200) eswubound(-10) ///
		   indexlist(riskpremium1) decimal(3) outputfile(${OUT}/集采市场模型（市场因子）非药品) showpvalues

*fama-french model
	estudy $stkcd_nonmedlist, ///
		   datevar(date) evdate(`k') dateformat(MDY) ///
		   lb1(0) ub1(1) lb2(0) ub2(3) lb3(0) ub3(5) lb4(0) ub4(7) lb5(0) ub5(9) lb6(0) ub6(11) eswlbound(-200) eswubound(-10) modtype(MFM)  ///
		   indexlist(riskpremium1 smb1 hml1) diagnosticsstat(KP) decimal(3) outputfile(${OUT}/集采三因子模型非药品) showpvalues 
}

*************************************************************************eventstudy2：shenwan index
cd  ${OUT} //eventstudy2 couldn't recognize the path defined by global, have to relocates the path to ${OUT}

*************************************************************************eventstudy2： full sample
*market model: 300 index as Rmt
use  earnings_surprises.dta,clear
eventstudy2 stkcd date using  stkcd_returns.dta, returns(rit) model(MA) marketfile(factor_returns.dta) ///
	marketreturns(rmt) riskfreerate(nrrdaydt) evwlb(-15) evwub(15) eswlb(-200) eswub(-10)  ///
	aarfile(mkt300_AAR) carfile(mkt300_CAR) arfile(mkt300_AR) crossfile(mkt300_cross) diagnosticsfile(mkt300_diag)  graphfile(mkt300_graph) replace  ///
	car1LB(0) car1UB(1) car2LB(0) car2UB(3) car3LB(0) car3UB(5) car4LB(0)  car4UB(7) car5LB(0) car5UB(9) car6LB(0)  car6UB(11) car7LB(0)  car7UB(13) car8LB(0)  car8UB(15) 

*market model: market factor as Rmt
use  earnings_surprises.dta,clear
eventstudy2 stkcd date using  stkcd_returns, returns(rit) model(MA) marketfile(factor_returns.dta) ///
	marketreturns(riskpremium1) riskfreerate(nrrdaydt) evwlb(-15) evwub(15) eswlb(-200) eswub(-10)  ///
	aarfile(mkt_AAR) carfile(mkt_CAR) arfile(mkt_AR) crossfile(mkt_cross) diagnosticsfile(mkt_diag)  graphfile(mkt_graph) replace  ///
	car1LB(0) car1UB(1) car2LB(0) car2UB(3) car3LB(0) car3UB(5) car4LB(0)  car4UB(7) car5LB(0) car5UB(9) car6LB(0)  car6UB(11) car7LB(0)  car7UB(13) car8LB(0)  car8UB(15) 

*fama-french model
use  earnings_surprises.dta,clear  
eventstudy2 stkcd date using stkcd_returns, returns(rit) model(FM) marketfile(factor_returns.dta) ///
	marketreturns(riskpremium1) factor1(smb1) factor2(hml1)  ///
	riskfreerate(nrrdaydt) evwlb(-15) evwub(15) eswlb(-200) eswub(-10)  ///
	aarfile(fama_AAR) carfile(fama_CAR) arfile(fama_AR) crossfile(fama_cross) diagnosticsfile(fama_diag)  graphfile(fama_graph) replace  ///
	car1LB(0) car1UB(1) car2LB(0) car2UB(3) car3LB(0) car3UB(5) car4LB(0)  car4UB(7) car5LB(0) car5UB(9) car6LB(0)  car6UB(11) car7LB(0)  car7UB(13) car8LB(0)  car8UB(15) 
   
*************************************************************************eventstudy2： 4+7 city
*market model: 300 index as Rmt
use  earnings_surprises47.dta,clear
eventstudy2 stkcd date using  stkcd_returns47.dta, returns(rit) model(MA) marketfile(factor_returns.dta) ///
	marketreturns(rmt) riskfreerate(nrrdaydt) evwlb(-15) evwub(15) eswlb(-200) eswub(-10)  ///
	aarfile(47_mkt300_AAR) carfile(47_mkt300_CAR) arfile(47_mkt300_AR) crossfile(47_mkt300_cross) diagnosticsfile(47_mkt300_diag)  graphfile(47_mkt300_graph) replace  ///
	car1LB(0) car1UB(1) car2LB(0) car2UB(3) car3LB(0) car3UB(5) car4LB(0)  car4UB(7) car5LB(0) car5UB(9) car6LB(0)  car6UB(11) car7LB(0)  car7UB(13) car8LB(0)  car8UB(15) 


*market model: market factor as Rmt
use  earnings_surprises47.dta,clear
eventstudy2 stkcd date using  stkcd_returns47.dta, returns(rit) model(MA) marketfile(factor_returns.dta) ///
	marketreturns(riskpremium1) riskfreerate(nrrdaydt) evwlb(-15) evwub(15) eswlb(-200) eswub(-10)  ///
	aarfile(47_mkt_AAR) carfile(47_mkt_CAR) arfile(47_mkt_AR) crossfile(47_mkt_cross) diagnosticsfile(47_mkt_diag)  graphfile(47_mkt_graph) replace  ///
	car1LB(0) car1UB(1) car2LB(0) car2UB(3) car3LB(0) car3UB(5) car4LB(0)  car4UB(7) car5LB(0) car5UB(9) car6LB(0)  car6UB(11) car7LB(0)  car7UB(13) car8LB(0)  car8UB(15) 

*fama-french model
use  earnings_surprises47.dta,clear  
eventstudy2 stkcd date using stkcd_returns47.dta, returns(rit) model(FM) marketfile(factor_returns.dta) ///
	marketreturns(riskpremium1) factor1(smb1) factor2(hml1)  ///
	riskfreerate(nrrdaydt) evwlb(-15) evwub(15) eswlb(-200) eswub(-10)  ///
	aarfile(47_fama_AAR) carfile(47_fama_CAR) arfile(47_fama_AR) crossfile(47_fama_cross) diagnosticsfile(47_fama_diag)  graphfile(47_fama_graph) replace  ///
	car1LB(0) car1UB(1) car2LB(0) car2UB(3) car3LB(0) car3UB(5) car4LB(0)  car4UB(7) car5LB(0) car5UB(9) car6LB(0)  car6UB(11) car7LB(0)  car7UB(13) car8LB(0)  car8UB(15) 

*************************************************************************eventstudy2： other
*market model: 300 index as Rmt
use  earnings_surprisesother.dta,clear
eventstudy2 stkcd date using stkcd_returnsother.dta, returns(rit) model(MA) marketfile(factor_returns.dta) ///
	marketreturns(rmt) riskfreerate(nrrdaydt) evwlb(-15) evwub(15) eswlb(-200) eswub(-10)  ///
	aarfile(other_mkt300_AAR) carfile(other_mkt300_CAR) arfile(other_mkt300_AR) crossfile(other_mkt300_cross) diagnosticsfile(other_mkt300_diag)  graphfile(other_mkt300_graph) replace  ///
	car1LB(0) car1UB(1) car2LB(0) car2UB(3) car3LB(0) car3UB(5) car4LB(0)  car4UB(7) car5LB(0) car5UB(9) car6LB(0)  car6UB(11) car7LB(0)  car7UB(13) car8LB(0)  car8UB(15) 

*market model: market factor as Rmt
use  earnings_surprisesother.dta,clear
eventstudy2 stkcd date using  stkcd_returnsother.dta, returns(rit) model(MA) marketfile(factor_returns.dta) ///
	marketreturns(riskpremium1) riskfreerate(nrrdaydt) evwlb(-15) evwub(15) eswlb(-200) eswub(-10)  ///
	aarfile(other_mkt_AAR) carfile(other_mkt_CAR) arfile(other_mkt_AR) crossfile(other_mkt_cross) diagnosticsfile(other_mkt_diag)  graphfile(other_mkt_graph) replace  ///
	car1LB(0) car1UB(1) car2LB(0) car2UB(3) car3LB(0) car3UB(5) car4LB(0)  car4UB(7) car5LB(0) car5UB(9) car6LB(0)  car6UB(11) car7LB(0)  car7UB(13) car8LB(0)  car8UB(15) 

*fama-french model
use earnings_surprisesother.dta,clear  
eventstudy2 stkcd date using stkcd_returnsother.dta, returns(rit) model(FM) marketfile(factor_returns.dta) ///
	marketreturns(riskpremium1) factor1(smb1) factor2(hml1)  ///
	riskfreerate(nrrdaydt) evwlb(-15) evwub(15) eswlb(-200) eswub(-10)  ///
	aarfile(other_fama_AAR) carfile(other_fama_CAR) arfile(other_fama_AR) crossfile(other_fama_cross) diagnosticsfile(other_fama_diag)  graphfile(other_fama_graph) replace  ///
	car1LB(0) car1UB(1) car2LB(0) car2UB(3) car3LB(0) car3UB(5) car4LB(0)  car4UB(7) car5LB(0) car5UB(9) car6LB(0)  car6UB(11) car7LB(0)  car7UB(13) car8LB(0)  car8UB(15) 

*************************************************************************eventstudy2： med
*market model: 300 index as Rmt
use  earnings_surprisesmed.dta,clear
eventstudy2 stkcd date using  stkcd_returnsmed.dta, returns(rit) model(MA) marketfile(factor_returns.dta) ///
	marketreturns(rmt) riskfreerate(nrrdaydt) evwlb(-15) evwub(15) eswlb(-200) eswub(-10)  ///
	aarfile(med_mkt300_AAR) carfile(med_mkt300_CAR) arfile(med_mkt300_AR) crossfile(med_mkt300_cross) diagnosticsfile(med_mkt300_diag)  graphfile(med_mkt300_graph) replace  ///
	car1LB(0) car1UB(1) car2LB(0) car2UB(3) car3LB(0) car3UB(5) car4LB(0)  car4UB(7) car5LB(0) car5UB(9) car6LB(0)  car6UB(11) car7LB(0)  car7UB(13) car8LB(0)  car8UB(15) 

*market model: market factor as Rmt
use  earnings_surprisesmed.dta,clear
eventstudy2 stkcd date using  stkcd_returnsmed.dta, returns(rit) model(MA) marketfile(factor_returns.dta) ///
	marketreturns(riskpremium1) riskfreerate(nrrdaydt) evwlb(-15) evwub(15) eswlb(-200) eswub(-10)  ///
	aarfile(med_mkt_AAR) carfile(med_mkt_CAR) arfile(med_mkt_AR) crossfile(med_mkt_cross) diagnosticsfile(med_mkt_diag)  graphfile(med_mkt_graph) replace  ///
	car1LB(0) car1UB(1) car2LB(0) car2UB(3) car3LB(0) car3UB(5) car4LB(0)  car4UB(7) car5LB(0) car5UB(9) car6LB(0)  car6UB(11) car7LB(0)  car7UB(13) car8LB(0)  car8UB(15) 

*fama-french model
use  earnings_surprisesmed.dta,clear  
eventstudy2 stkcd date using stkcd_returnsmed.dta, returns(rit) model(FM) marketfile(factor_returns.dta) ///
	marketreturns(riskpremium1) factor1(smb1) factor2(hml1)  ///
	riskfreerate(nrrdaydt) evwlb(-15) evwub(15) eswlb(-200) eswub(-10)  ///
	aarfile(med_fama_AAR) carfile(med_fama_CAR) arfile(med_fama_AR) crossfile(med_fama_cross) diagnosticsfile(med_fama_diag)  graphfile(med_fama_graph) replace  ///
	car1LB(0) car1UB(1) car2LB(0) car2UB(3) car3LB(0) car3UB(5) car4LB(0)  car4UB(7) car5LB(0) car5UB(9) car6LB(0)  car6UB(11) car7LB(0)  car7UB(13) car8LB(0)  car8UB(15) 

*************************************************************************eventstudy2： nonmed
*market model: 300 index as Rmt
use  earnings_surprisesnonmed.dta,clear
eventstudy2 stkcd date using  stkcd_returnsnonmed.dta, returns(rit) model(MA) marketfile(factor_returns.dta) ///
	marketreturns(rmt) riskfreerate(nrrdaydt) evwlb(-15) evwub(15) eswlb(-200) eswub(-10)  ///
	aarfile(nonmed_mkt300_AAR) carfile(nonmed_mkt300_CAR) arfile(nonmed_mkt300_AR) crossfile(nonmed_mkt300_cross) diagnosticsfile(nonmed_mkt300_diag)  graphfile(nonmed_mkt300_graph) replace  ///
	car1LB(0) car1UB(1) car2LB(0) car2UB(3) car3LB(0) car3UB(5) car4LB(0)  car4UB(7) car5LB(0) car5UB(9) car6LB(0)  car6UB(11) car7LB(0)  car7UB(13) car8LB(0)  car8UB(15) 

*market model: market factor as Rmt
use  earnings_surprisesnonmed.dta,clear
eventstudy2 stkcd date using  stkcd_returnsnonmed.dta, returns(rit) model(MA) marketfile(factor_returns.dta) ///
	marketreturns(riskpremium1) riskfreerate(nrrdaydt) evwlb(-15) evwub(15) eswlb(-200) eswub(-10)  ///
	aarfile(nonmed_mkt_AAR) carfile(nonmed_mkt_CAR) arfile(nonmed_mkt_AR) crossfile(nonmed_mkt_cross) diagnosticsfile(nonmed_mkt_diag)  graphfile(nonmed_mkt_graph) replace  ///
	car1LB(0) car1UB(1) car2LB(0) car2UB(3) car3LB(0) car3UB(5) car4LB(0)  car4UB(7) car5LB(0) car5UB(9) car6LB(0)  car6UB(11) car7LB(0)  car7UB(13) car8LB(0)  car8UB(15) 

*fama-french model
use  earnings_surprisesnonmed.dta,clear  
eventstudy2 stkcd date using stkcd_returnsnonmed.dta, returns(rit) model(FM) marketfile(factor_returns.dta) ///
	marketreturns(riskpremium1) factor1(smb1) factor2(hml1)  ///
	riskfreerate(nrrdaydt) evwlb(-15) evwub(15) eswlb(-200) eswub(-10)  ///
	aarfile(nonmed_fama_AAR) carfile(nonmed_fama_CAR) arfile(nonmed_fama_AR) crossfile(nonmed_fama_cross) diagnosticsfile(nonmed_fama_diag)  graphfile(nonmed_fama_graph) replace  ///
	car1LB(0) car1UB(1) car2LB(0) car2UB(3) car3LB(0) car3UB(5) car4LB(0)  car4UB(7) car5LB(0) car5UB(9) car6LB(0)  car6UB(11) car7LB(0)  car7UB(13) car8LB(0)  car8UB(15) 

******************************
*** Graphing ***
******************************
*****************************************market model
*append CAAR data
tempfile 47 other med nonmed
	foreach k in 47 other med nonmed {
	use `k'_mkt300_CAR,clear
	keep t CAARE NCAAREt_test PCAAREt_test
	drop if t=="[-15;15]"
	gen date=_n
	recode date (2=3) (3=5) (4=7) (5=9) (6=11) (7=13) (8=15)
	ren (CAARE NCAAREt_test PCAAREt_test) (C_`k' tt_`k' P_`k') 
	label var C_`k' "CAAR_`k'" 
	
	save ``k''
	}
	merge 1:1 t using `47'
	drop _m
	merge 1:1 t using `other'
	drop _m
	merge 1:1 t using `med'
	drop _m
	sort date

*compare
	twoway line C_nonmed C_med date
graph save Graph mednonmed_300_CAAR.gph,replace
	twoway line C_other C_47 date
graph save Graph  47other_300_CAAR.gph,replace

*combine AAR data
tempfile 47 other med nonmed
	foreach k in 47 other med nonmed {
	use `k'_mkt300_AAR,clear
	keep t AARE NAAREt_test PAAREt_test
	ren (AARE NAAREt_test PAAREt_test t) (AAR_`k' tt_`k' P_`k' date) 
	label var AAR_`k' "AAR_`k'" 
	
	save ``k''
	}
	merge 1:1 date using `47'
	drop _m
	merge 1:1 date using `other'
	drop _m
	merge 1:1 date using `med'
	drop _m
	sort date
	drop if inrange(date,-15,-4)
*compare
	twoway line AAR_nonmed AAR_med date
graph save Graph  mednonmed_300_AAR.gph,replace
	twoway line AAR_other AAR_47 date
graph save Graph  47other_300_AAR.gph,replace

******************************************fama-french model
*combine CAAR data
tempfile 47 other med nonmed
	foreach k in 47 other med nonmed {
	use `k'_fama_CAR,clear
	keep t CAARE NCAAREt_test PCAAREt_test
	drop if t=="[-15;15]"
	gen date=_n
	recode date (2=3) (3=5) (4=7) (5=9) (6=11) (7=13) (8=15)
	ren (CAARE NCAAREt_test PCAAREt_test) (C_`k' tt_`k' P_`k') 
	label var C_`k' "CAAR_`k'" 
	
	save ``k''
	}
	merge 1:1 t using `47'
	drop _m
	merge 1:1 t using `other'
	drop _m
	merge 1:1 t using `med'
	drop _m
	sort date

*compare
	twoway line C_nonmed C_med date
graph save Graph mednonmed_fama_CAAR.gph,replace
	twoway line C_other C_47 date
graph save Graph  47other_fama_CAAR.gph,replace

*combine AAR data
tempfile 47 other med nonmed
	foreach k in 47 other med nonmed {
	use `k'_fama_AAR,clear
	keep t AARE NAAREt_test PAAREt_test
	ren (AARE NAAREt_test PAAREt_test t) (AAR_`k' tt_`k' P_`k' date) 
	label var AAR_`k' "AAR_`k'" 
	
	save ``k''
	}
	merge 1:1 date using `47'
	drop _m
	merge 1:1 date using `other'
	drop _m
	merge 1:1 date using `med'
	drop _m
	sort date
	drop if inrange(date,-15,-4)
*compare
	twoway line AAR_nonmed AAR_med date
graph save Graph  mednonmed_fama_AAR.gph,replace
	twoway line AAR_other AAR_47 date
graph save Graph  47other_fama_AAR.gph,replace
