******************************
*** Data Import ***
******************************
* make empty datafiles to store histpric stock market value  
clear
input date   
.			 
end
save "${INT}/stkcd_47.dta",replace    
save "${INT}/stkcd.dta",replace  
save "${INT}/stkcd_other.dta",replace  
save "${INT}/stkcd_med.dta",replace
save "${INT}/stkcd_nonmed.dta",replace

clear	
input date stkcd rit   
. . .					
end
save "${OUT}/stkcd_returns.dta",replace 
save "${OUT}/stkcd_returns47.dta",replace  
save "${OUT}/stkcd_returnsother.dta",replace 
save "${OUT}/stkcd_returnsmed.dta",replace  
save "${OUT}/stkcd_returnsnonmed.dta",replace  

*import suspension date and resumption date 
import delimited "${INPUT}/TSR_Stkstat.csv",encoding(utf8) clear  
	duplicates drop		 
	ren stkcd stkcd_merge   
	gen datesusp=date(suspdate,"YMD",2019)    
	gen dateresm=date(resmdate,"YMD",2019)
	format datesusp dateresm  %tdNNDDCCYY  
	drop if datesusp>mdy(12,17,2018)+100   
	drop if timeperd<0  
	
	*keep the latest suspension/resumption date if a stock experience multiple suspensions/resumption during the estimation window
	bysort stkcd_merge: egen datesusp_last = max(datesusp)  
	format datesusp_last  %tdNNDDCCYY
	keep if datesusp_last ==datesusp  
	duplicates drop stkcd_merge datesusp dateresm datesusp_last,force  
	keep stkcd_merge datesusp dateresm timeperd stknme  
	sort stkcd_merge 
save "${INT}/susresdate.dta",replace

*import IPO data, mainly the IPO date
import delimited "${INPUT}/EVA_Co.csv",encoding(utf8) clear 
	gen dateipo=date(ipodate,"YMD",2019)
	format dateipo %tdNNDDCCYY
	keep symbol dateipo	
	ren symbol stkcd_merge 
	drop if stkcd_merge==600018 & dateipo==mdy(7,19,2000) 
	sort stkcd_merge 
save "${INT}/ipodate.dta",replace

*import IPO data, mainly the IPO address and province data
tempfile t1 t2   
import delimited "${INPUT}/STK_LISTEDCOINFOANL.csv", encoding(utf8) clear 
	ren (symbol shortname) (stkcd_merge stknme) 
	drop enddate  
	duplicates drop 
	sort stkcd_merge
save "${INT}/ipoadd.dta",replace

import delimited "${INPUT}/PRI_Basic.csv", encoding(utf8) clear 
	drop if stkcd==.     
	gen date = date(reptdt,"YMD",2019)
	format date %tdNNDDCCYY
	keep stkcd stknme province date city
	ren stkcd stkcd_merge
	duplicates drop
	sort stkcd_merge
save `t1',replace    

import delimited "${INPUT}/IPO_Bcobasic.csv",encoding(utf8) clear 
	gen date = date(listdt,"YMD",2019)
	format date %tdNNDDCCYY
	keep stkcd regplc stknme date
	ren (stkcd regplc) (stkcd_merge province)
	split province, parse("省")  
	ren province2 city
	append using `t1'  
	sort stkcd_merge stknme
	split stknme, parse(" ")  
	egen stknme3 = concat(stknme1  stknme2)   
	keep stkcd_merge province city stknme3 date 
	ren stknme3 stknme
save "${INT}/ipoprovince.dta",replace

*import medical stock lists 
import excel "${INPUT}/shenwan_medical_industry(II).xlsx", sheet("Sheet1") firstrow  clear
	ren (代码 名称) (stkcd stknme)
	drop D
	destring stkcd,gen(stkcd_merge)   
	merge 1:m stkcd_merge stknme using "${INT}/ipoprovince.dta", keep(1 3) 
	drop if stkcd_merge==.
	drop _m date 
	duplicates drop stknme stkcd_merge,force 
	merge 1:m stkcd_merge stknme using "${INT}/ipoadd.dta", keep(1 3)
	
	* collect province info. from IPO address data
	split registeraddress, parse("市")
	replace city = registeraddress1+"市" if city ==""
	replace city = ""  if city =="市"
	drop registeraddress1 registeraddress2 registeraddress3 _m
	split city, parse("省")
	replace city1 = "" if city2 == ""
	replace city1 = city1+"省" if city2 != ""
	replace city1 = "山东省" if city1 == "东省"
	replace province = city1 if province=="" & city1!="" 
	replace city = city2 if city2!=""
	replace city = "" if inlist(city, "东阿县阿胶街 78 号市","东阿县阿胶街78号市","仙居县仙药路1号市","沂南县县城振兴路6号市","沂源县城二郎山路八号市")
	drop city1 city2 registeraddress officeaddress zipcode
	duplicates drop
	duplicates tag stkcd_merge stknme,gen(dup)
	drop if (province =="" | city =="")  & dup>0
	drop dup
	isid stkcd_merge 
	
	merge 1:1 stkcd_merge using "${INT}/susresdate.dta"
	drop if stkcd==""
	drop _m
	merge 1:1 stkcd_merge using "${INT}/ipodate.dta",keep(3)
	drop _m
	gen stkcd_list = "stkcd_"+stkcd 
	gen if47city = (inlist(province,"上海市","北京市","天津市","重庆市") | inlist(city,"上海市","北京市","天津市","重庆市")| inlist(city,"广州市","深圳市","沈阳市","西安市","成都市","厦门市","大连市")) 
	replace if47city = . if province=="" & city ==""
	gen ifmedicine = inlist(申万二级,"化学制药","中药") if 申万二级!=""
save "${INT}/shenwan_medical_industry(II).dta",replace

*import acquisition and reorganization data
import delimited "${INPUT}/VAM_PERFORMMAIN.csv",encoding(utf8) clear 
	ren (symbol buyer) (stkcd_merge stknme) 
	gen startdate = date(performcommitstart,"YMD",2019)
	gen enddate = date(performcommitend,"YMD",2019)
	format startdate enddate %tdNNDDCCYY
	drop v* eventid commitmentparty performcommitstart performcommitend 
	keep if (startdate>=mdy(12,7,2018)-200 & startdate<=mdy(12,7,2018)+20) |(enddate>=mdy(12,7,2018)-200 & enddate<=mdy(12,7,2018)+20) 
	merge m:1 stkcd_merge stknme using "${INT}/shenwan_medical_industry(II).dta" ,keep(2) 
	drop _m
	drop if inlist(stkcd_merge,688366,688505)
save "${INT}/shenwan_medical_industry(II).dta",replace 

*import medical index historic data 
import excel "${INPUT}/shenwan_medical_industy_index.xlsx", sheet("Sheet1") firstrow clear
	ren (指数代码 收盘指数 发布日期) (stkcd cloprice date)
	sort date 	 
	gen a = _n   
	tsset a  
	gen rit = (cloprice-l.cloprice)/l.cloprice  
	format date %tdNNDDCCYY
	keep stkcd rit date
save "${OUT}/shenwan_medical_industy_index.dta",replace

*import three factors data for fama-french model
tempfile syz
import delimited "${INPUT}/STK_MKT_THRFACDAY.csv",encoding(utf8) clear 
	keep if markettypeid=="P9710"  
	gen date=date(tradingdate,"YMD",2019)
	order date 
	format date %tdNNDDCCYY
	drop tradingdate
save `syz',replace

import delimited "${INPUT}/TRD_Nrrate.csv",encoding(utf8) clear  
	keep clsdt nrrdata nrrdaydt // Nrrdaydt [日度化无风险利率(%)]; Nrrdata [无风险利率(%)]
	gen date=date(clsdt,"YMD",2019)
	format date %tdNNDDCCYY
	merge 1:1 date using `syz',keep(3)
	drop _m clsdt
save "${OUT}/threefactor.dta",replace	

* prepare 300 index
	cntrade 300,index path(${INPUT})  
use "${INPUT}/000300.dta",clear
	keep date rmt 
	sort date
save,replace   
