*************************************************************************
* Prepare data
*************************************************************************

*IMR calculation

use "/Users/siddhantpandit/Desktop/NFHS/nfhs5br.DTA", clear
gen inperiod_birth = b3>1393
gen death_date = b3 + b7
gen inperiod_death5 = death_date>1393 & b7<=12
collapse (mean) inperiod_death5 [aweight=v005], by(sdist)
save nfhs5_district_imr.dta, replace

use "/Users/siddhantpandit/Desktop/NFHS/nfhs4br.DTA", clear
gen inperiod_birth = b3>1321
gen death_date = b3 + b7
gen inperiod_death4 = death_date>1321 & b7<=12
collapse (mean) inperiod_death4 [aweight=v005], by(sdist)
tempfile nfhs4_imr
save nfhs4_district_imr.dta, replace


*Append nfhs-4 and 5 individual recode
clear

if "`c(username)'" == "siddhantpandit" {
	global nfhs4ir "/Users/siddhantpandit/Desktop/NFHS/nfhs4ir.DTA"	
	global nfhs5ir "/Users/siddhantpandit/Desktop/NFHS/nfhs5ir.DTA"
	global nfhs3ir "/Users/siddhantpandit/Desktop/NFHS/nfhs3ir.dta"
}

cap cd $data_dir

if "`c(username)'" == "nmf632" {
    global nfhs4ir "/Users/nmf632/Documents/data/nfhs4/IAIR74DT/IAIR74FL.DTA"
    global nfhs5ir "/Users/nmf632/Documents/data/nfhs5/IAIR7BDT/IAIR7BFL.DTA"
}

use caseid-v458 s45 using "$nfhs3ir"
tempfile nfhs3
save `nfhs3'

use caseid-v458 s116 sdist using "$nfhs5ir"
tempfile nfhs5
save `nfhs5'

use caseid-v458 s116 sdistri using  "$nfhs4ir"
append using `nfhs5'


*Calculate weights

egen strata = group(v000 v024 v025) 
egen psu = group(v000 v001 v024 v025)

bysort v000: egen totalwt = total(v005)
gen wt = v005/totalwt
drop v005 totalwt

svyset psu [pweight = wt], strata(strata) 


*Match states across surveys
gen state = .  
replace state = 28 if v024 == 1 & v000 == "IA6"
replace state = 28 if v024 == 2 & v000 == "IA6"
replace state = 12 if v024 == 3 & v000 == "IA6"
replace state = 18 if v024 == 4 & v000 == "IA6"
replace state = 10 if v024 == 5 & v000 == "IA6"
replace state = 4  if v024 == 6 & v000 == "IA6"
replace state = 22 if v024 == 7 & v000 == "IA6"
replace state = 25 if v024 == 8 & v000 == "IA6"
replace state = 25 if v024 == 9 & v000 == "IA6"
replace state = 30 if v024 == 10 & v000 == "IA6"
replace state = 24 if v024 == 11 & v000 == "IA6"
replace state = 6  if v024 == 12 & v000 == "IA6"
replace state = 2  if v024 == 13 & v000 == "IA6"
replace state = 1  if v024 == 14 & v000 == "IA6"
replace state = 20 if v024 == 15 & v000 == "IA6"
replace state = 29 if v024 == 16 & v000 == "IA6"
replace state = 32 if v024 == 17 & v000 == "IA6"
replace state = 31 if v024 == 18 & v000 == "IA6"
replace state = 23 if v024 == 19 & v000 == "IA6"
replace state = 27 if v024 == 20 & v000 == "IA6"
replace state = 14 if v024 == 21 & v000 == "IA6"
replace state = 17 if v024 == 22 & v000 == "IA6"
replace state = 15 if v024 == 23 & v000 == "IA6"
replace state = 13 if v024 == 24 & v000 == "IA6"
replace state = 7  if v024 == 25 & v000 == "IA6"
replace state = 21 if v024 == 26 & v000 == "IA6"
replace state = 34 if v024 == 27 & v000 == "IA6"
replace state = 3  if v024 == 28 & v000 == "IA6"
replace state = 8  if v024 == 29 & v000 == "IA6"
replace state = 11 if v024 == 30 & v000 == "IA6"
replace state = 33 if v024 == 31 & v000 == "IA6"
replace state = 16 if v024 == 32 & v000 == "IA6"
replace state = 9  if v024 == 33 & v000 == "IA6"
replace state = 5  if v024 == 34 & v000 == "IA6"
replace state = 19 if v024 == 35 & v000 == "IA6"
replace state = 36 if v024 == 36 & v000 == "IA6"

replace state = v024 if v000=="IA7"


*Match districts across surveys 

gen district = .
replace district = sdist if v000=="IA7"
replace district = sdistri if v000=="IA6"
replace district = 2000 if inlist(sdist,879,880) | inlist(sdistri,43) 
replace district = 2001 if inlist(sdist,881,882) | inlist(sdistri,35)
replace district = 2002 if inlist(sdist,865,866) | inlist(sdistri,81)
replace district = 2003 if inlist(sdist,837,838,839,840,841,842,843,844,845,846,847) | inlist(sdistri,90,91,92,93,94,95,96,97,98)
replace district = 2004 if inlist(sdist,921,927,930) | inlist(sdistri,158,179)
replace district = 2005 if inlist(sdist,923,924) | inlist(sdistri,140)
replace district = 2006 if inlist(sdist,922,925,928) | inlist(sdistri,135,149)
replace district = 2007 if inlist(sdist,926,929) | inlist(sdistri,133)
replace district = 2008 if inlist(sdist,802,803) | inlist(sdistri,256)
replace district = 2009 if inlist(sdist,804,806) | inlist(sdistri,259)
replace district = 2010 if inlist(sdist,805,808) | inlist(sdistri,254)
replace district = 2011 if inlist(sdist,801,807,809) | inlist(sdistri,250,251)
replace district = 2012 if inlist(sdist,915,917,920) | inlist(sdistri,289)
replace district = 2013 if inlist(sdist,914,918) | inlist(sdistri,290)
replace district = 2014 if inlist(sdist,916,919) | inlist(sdistri,292)
replace district = 2015 if inlist(sdist,871,873) | inlist(sdistri,294)
replace district = 2016 if inlist(sdist,872,877) | inlist(sdistri,299)
replace district = 2017 if inlist(sdist,875,878) | inlist(sdistri,296)
replace district = 2018 if inlist(sdist,874,876) | inlist(sdistri,293)
replace district = 2019 if inlist(sdist,810,819) | inlist(sdistri,306)
replace district = 2020 if inlist(sdist,811,818) | inlist(sdistri,311)
replace district = 2021 if inlist(sdist,813,817) | inlist(sdistri,305)
replace district = 2022 if inlist(sdist,812,820) | inlist(sdistri,301)
replace district = 2023 if inlist(sdist,815,821) | inlist(sdistri,314)
replace district = 2024 if inlist(sdist,814,816) | inlist(sdistri,312)
replace district = 2025 if inlist(sdist,931,932) | inlist(sdistri,335)
replace district = 2026 if inlist(sdist,822,826,829) | inlist(sdistri,409)
replace district = 2027 if inlist(sdist,823,830,833) | inlist(sdistri,410)
replace district = 2028 if inlist(sdist,824,835,836) | inlist(sdistri,401)
replace district = 2029 if inlist(sdist,825,831) | inlist(sdistri,414)
replace district = 2030 if inlist(sdist,827,832) | inlist(sdistri,406)
replace district = 2031 if inlist(sdist,828,834) | inlist(sdistri,416)
replace district = 2032 if inlist(sdist,867,868) | inlist(sdistri,436)
replace district = 2033 if inlist(sdist,849,862) | inlist(sdistri,472)
replace district = 2034 if inlist(sdist,848,850,851) | inlist(sdistri,474,481)
replace district = 2035 if inlist(sdist,852,864) | inlist(sdistri,486)
replace district = 2036 if inlist(sdist,857,858,860) | inlist(sdistri,483,484)
replace district = 2037 if inlist(sdist,853,855,859,861,863) | inlist(sdistri,475,476,477)
replace district = 2038 if inlist(sdist,854,856) | inlist(sdistri,479)
replace district = 2039 if inlist(sdist,869,870) | inlist(sdistri,517)
replace district = 2040 if inlist(sdist,883,893,896,901) | inlist(sdistri,532)
replace district = 2041 if inlist(sdist,884,886,887,888,891,892,894,897) | inlist(sdist,900,903,904,906,907,908,911,912,913) | inlist(sdistri,534,535,539,540,541)
replace district = 2042 if inlist(sdist,885) | inlist(sdistri,536)
replace district = 2043 if inlist(sdist,898,905,909) | inlist(sdistri,537)
replace district = 2044 if inlist(sdist,889,895,899,910) | inlist(sdistri,538)
replace district = 2045 if inlist(sdist,890,902) | inlist(sdistri,533)



*Generate variables

gen hg = v456/10 if v455==0
gen round5 = (v000=="IA7")
gen bmi = v445


*Matched cohorts
gen hg4 = hg if v000=="IA6"
gen hg5 = hg if v000=="IA7"

gen cohort_no = .
replace cohort_no = 1 if v013 == 1 & v000=="IA6" // 15-19
replace cohort_no = 1 if v013 == 2 & v000=="IA7" // 20-24

replace cohort_no = 2 if v013 == 2 & v000=="IA6" // 20-24
replace cohort_no = 2 if v013 == 3 & v000=="IA7" // 25-29

replace cohort_no = 3 if v013 == 3 & v000=="IA6" // 25-29
replace cohort_no = 3 if v013 == 4 & v000=="IA7" // 30-34

replace cohort_no = 4 if v013 == 4 & v000=="IA6" // 30-34
replace cohort_no = 4 if v013 == 5 & v000=="IA7" // 35-39

replace cohort_no = 5 if v013 == 5 & v000=="IA6" // 35-39
replace cohort_no = 5 if v013 == 6 & v000=="IA7" // 40-44

replace cohort_no = 6 if v013 == 6 & v000=="IA6" // 40-44
replace cohort_no = 6 if v013 == 7 & v000=="IA7" // 45-49


*Merge district level infant mortality
merge m:1 sdist using "/Users/siddhantpandit/Desktop/NFHS/nfhs5_district_imr.dta"

merge m:1 sdistri using "/Users/siddhantpandit/Desktop/NFHS/nfhs4_district_imr.dta", nogen

gen imr = .
replace imr = inperiod_death4 if v000=="IA6"
replace imr = inperiod_death5 if v000=="IA7"

