
* append nfhs-4 and 5


if "`c(username)'" == "siddhantpandit" {
	global nfhs4br "/Users/siddhantpandit/Desktop/NFHS/nfhs4br.DTA"
	global nfhs5br "/Users/siddhantpandit/Desktop/NFHS/nfhs5br.DTA"
}

use "$nfhs4br", clear
append using "$nfhs5br"


* generate weights

egen strata = group(v000 v024 v025) 
egen psu = group(v000 v001 v024 v025)

bysort v000: egen totalwt = total(v005)
gen wt = v005/totalwt
drop v005 totalwt

svyset psu [pweight = wt], strata(strata)


* generate variables

gen child_hg = hw53/10 if hw55==0
gen round5 = (v000=="IA7")


* save

compress 
save "/Users/siddhantpandit/Desktop/Anemia/Anemia_Thesis/data/br_prepared.DTA", replace




