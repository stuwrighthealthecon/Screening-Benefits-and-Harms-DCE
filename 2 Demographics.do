cd "C:\Users\rl423\OneDrive - University of Cambridge\PRU DCE_analysis"


use "PRU DCE full dataset.dta", clear

gen dem_agegroup = ., after(dem_age)
	replace dem_agegroup = 1 if dem_age<=24
	replace dem_agegroup = 2 if dem_age>24 & dem_age<=39
	replace dem_agegroup = 3 if dem_age>39 & dem_age<=59
	replace dem_agegroup = 4 if dem_age>59 & dem_age<=79
	replace dem_agegroup = 5 if dem_age>79 & dem_age<=100
		label define agegroup 1 "<=24" 2 "25-39" 3 "40-59" 4 "60-79" 5 "80+"
		label values dem_agegroup agegroup

gen dem_sesgroup = ., after(dem_ses)
	replace dem_sesgroup = 1 if dem_ses<=3
	replace dem_sesgroup = 2 if dem_ses>3 & dem_ses<=6
	replace dem_sesgroup = 3 if dem_ses>6 & dem_ses<=8
	replace dem_sesgroup = 4 if dem_ses>8 & dem_ses<=10
		label define sesgroup 1 "1-3" 2 "4-6" 3 "7-8" 4 "9-10"
		label values dem_sesgroup sesgroup

log using "Demographics log.smcl", replace

table dem_agegroup sample, contents(freq ) col missing
table dem_sex sample, contents(freq ) col missing
table dem_gendersame sample, contents(freq ) col missing
table dem_ethnicity sample, contents(freq ) col missing
table dem_educat sample, contents(freq ) col missing
table dem_sesgroup sample, contents(freq ) col missing

table cancer_personalhistory sample, contents(freq ) col missing
table cancer_screened sample, contents(freq ) col missing
table cancer_likelihood sample, contents(freq ) col missing
table cancer_worry sample, contents(freq ) col missing

table enthus1 sample, contents(freq ) col missing
table enthus2 sample, contents(freq ) col missing
table enthus3 sample, contents(freq ) col missing
table enthus4 sample, contents(freq ) col missing
table enthus5 sample, contents(freq ) col missing
table enthus6 sample, contents(freq ) col missing
table enthus7 sample, contents(freq ) col missing
table enthus8 sample, contents(freq ) col missing




tab dem_agegroup sample, chi2
tab dem_sex sample, chi2
tab dem_gendersame sample, chi2
tab dem_ethnicity sample, chi2
tab dem_educat sample, chi2
tab dem_sesgroup sample, chi2

tab cancer_personalhistory sample, chi2
tab cancer_screened sample, chi2
tab cancer_likelihood sample, chi2
tab cancer_worry sample, chi2

tab enthus1 sample, chi2
tab enthus2 sample, chi2
tab enthus3 sample, chi2
tab enthus4 sample, chi2
tab enthus5 sample, chi2
tab enthus6 sample, chi2
tab enthus7 sample, chi2
tab enthus8 sample, chi2

**replace duration=. if  duration >=3600
hist duration, by(sample)
ttest duration, by(sample)
ranksum duration, by(sample)

log close
