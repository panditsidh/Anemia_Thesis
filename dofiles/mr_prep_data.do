
* append nfhs-4 and 5


if "`c(username)'" == "siddhantpandit" {
	global nfhs4mr "/Users/siddhantpandit/Desktop/NFHS/nfhs5mr.DTA"
	global nfhs5mr "/Users/siddhantpandit/Desktop/NFHS/nfhs4mr.DTA"
}

use "$nfhs4mr", clear
append using "$nfhs5mr"



* generate weights

egen strata = group(mv000 mv024 mv025) 
egen psu = group(mv000 mv001 mv024 mv025)

bysort mv000: egen totalwt = total(mv005)
gen wt = mv005/totalwt
drop mv005 totalwt

svyset psu [pweight = wt], strata(strata)


