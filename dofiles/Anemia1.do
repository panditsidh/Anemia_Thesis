* append 
clear
global directory "/Users/siddhantpandit/Desktop/NFHS"
cd $directory

use caseid-v458 s116 using individual5.DTA
tempfile nfhs5
save `nfhs5'

use caseid-v458 s116 using individual4.DTA
append using `nfhs5'

* weights

egen strata = group(v000 v024 v025) 
egen psu = group(v000 v001 v024 v025)

bysort v000: egen totalwt = total(v005)
gen wt = v005/totalwt
drop v005 totalwt

svyset psu [pweight = wt], strata(strata) 


* match states

recode v024 (1=28)(2=28)(3=12)(4=18)(5=10)(6=4)(7=22)(8=25)(9=25)(10=30)(11=24)(12=6)(13=2)(14=1)(15=20)(16=29)(17=32)(18=31)(19=23)(20=27)(21=14)(22=17)(23=15)(24=13)(25=7)(26=21)(27=34)(28=3)(29=8)(30=11)(31=33)(32=16)(33=9)(34=5)(35=19)(36=36) if v000=="IA6", gen(state)

replace state = v024 if v000=="IA7"

* variables

gen hg = v456/10 if v455==0
gen anemic = (v457!=4 & v457!=.)
gen round5 = (v000=="IA7")


* anemia from 4 to 5

bysort v000: tab anemic [aweight=wt] if v213==0 // not pregnant

bysort v000: tab anemic [aweight=wt] if v213==1 // pregnant


* scatter graphs

*states: state
*wealth: v190
*age: v013
*education: v106
*urban/rural: v102

preserve
gen candidate = s116
gen ones = 1
// keep if v102==1 // rural only


collapse (mean) hg (sum) ones [aweight=wt], by(candidate round5)
reshape wide hg ones, i(candidate) j(round5)

twoway (lfit hg0 hg0) (scatter hg1 hg0 [aweight=ones1],  ms(Oh)), graphr(c(white) lc(white)) aspect(1) xsize(5) ysize(5) legend(off) xtitle("hemoglobin in NFHS-4") ytitle("hemoglobin in NFHS-5")
restore





* lpoly graph

* generalize variable names
gen group = round5
gen outcomevariable = hg 
gen full = outcomevariable != . & group != . // This will be useful to define our maximum sample
gen group1 = group == 1 & full == 1
gen group0 = group == 0 & full == 1


* for figure 1
gen runningvariable = v445
twoway (lpoly outcomevariable runningvariable if group == 1 [aweight=wt],  lc(navy) lw(medthick) ) (lpoly outcomevariable runningvariable if group == 0 [aweight=wt],  lc(forest_green) lw(medthick) lp(longdash)) if full == 1, legend(col(2) order(1 "nfhs-5" 0 "nfhs-4")) xtitle("BMI") ytitle("hemoglobin measurement g/dl") graphr(c(white) lc(white)) name(puzzlegraph2)


graph save puzzlegraph1 "Graphfilename.gph", replace
graph export "Graphfilename.pdf", as(pdf) replace


