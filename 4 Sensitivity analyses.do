cd "C:\Users\rl423\OneDrive - University of Cambridge\PRU DCE_analysis"

sysdir set PLUS "C:\Program Files(x86)\Stata15\"
ssc install lclogit2
ssc install regsave

**________________________________________________________________________________________________________________

log using "Sensitivity analysis log.smcl", replace

*****Sensitivity analysis 1: Thiscovery version 1 vs 2
use "PRU DCE full dataset for DCE analysis.dta", clear
drop if sample==1

**version 1, basic linear clogit model
clogit selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc if version==1, group(case)
estimates store version1
regsave using coefficients_sens1, addlabel(version, version1) replace

**version 2, basic linear clogit model
clogit selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc if version==2, group(case)
estimates store version2
regsave using coefficients_sens1, addlabel(version, version2) append

**compare versions
suest version1 version2
test [version1_selection = version2_selection]
test [version1_selection = version2_selection]: asc
test [version1_selection = version2_selection]: cancersdiagnosed_ct
test [version1_selection = version2_selection]: cancerdeaths_ct
test [version1_selection = version2_selection]: overdiagnosis_ct
test [version1_selection = version2_selection]: falsepositives_ct
test [version1_selection = version2_selection]: falsenegatives_ct

use coefficients_sens1, clear
	encode version, gen(vers)
	encode var, gen(variable)
	drop stderr N version var

	reshape wide coef, i(var) j(vers)
	rename coef1 coef_version1
	rename coef2 coef_version2
	label variable coef_version1 "version 1"
	label variable coef_version2 "version 2"
twoway (scatter coef_version2 coef_version1) (lfit coef_version2 coef_version1), ylabel(-1.4(0.2)0.2) xlabel(-1.4(0.2)0.2) scheme(s1manual) ytitle(version 2) legend(off)
	graph export SwaitLouviereplot_Thiscoveryversions.emf, as(emf) replace
regress coef_version2 coef_version1
	//R-squared = 0.968 => roughly 1 so there is no heterogeneity in preferences between the samples
	//coefficient = 1.45 => slope of the line is NOT roughly equal to 1 so signs of scale heterogeneity (differences in error variance between the samples)
	// => analyse samples separately

**________________________________________________________________________________________________________________

*****Sensitivity analysis 2: drop fastest 10% or always option 1/2
use"PRU DCE full dataset.dta", clear
bysort sample: tab count_option1	//6 participants always selected option 1
bysort sample: tab count_option2	//10 participants always selected option 1
su duration, d						//5% percentile = 443 seconds (approx 7 mins); 10% percentile = 536 seconds

**Sensitivity analysis 2A: Prolific full sample vs sample with poor completers dropped
**Prolific full sample
use "PRU DCE full dataset for DCE analysis.dta", clear
drop if sample==2
gen cancersdiagnosed_ct_SQ = (cancersdiagnosed_ct)^2
clogit selection cancersdiagnosed_ct_SQ cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc, group(case)
estimates store full
regsave using coefficients_sens2a_Prolific, addlabel(subsample, full) replace

**Prolific poor completers dropped
use "PRU DCE full dataset for DCE analysis.dta", clear
drop if sample==2
drop if count_option1==9 | count_option2==9 | duration<=536	//2,403 observations dropped, 89 participants
gen cancersdiagnosed_ct_SQ = (cancersdiagnosed_ct)^2
clogit selection cancersdiagnosed_ct_SQ cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc, group(case)
estimates store poordropped
regsave using coefficients_sens2a_Prolific, addlabel(subsample, poordropped) append

use coefficients_sens2a_Prolific, clear
	encode sub, gen(sample)
	encode var, gen(variable)
	drop stderr N sub var

	reshape wide coef, i(var) j(sam)
	rename coef1 coef_full
	rename coef2 coef_poordropped
	label variable coef_full "full"
	label variable coef_poordropped "poor completers dropped"

twoway (scatter coef_p coef_f) (lfit coef_p coef_f), ylabel(-1.2(0.2)0.2) xlabel(-1.2(0.2)0.2) scheme(s1manual) ytitle("poor completers dropped") legend(off)
	graph export SwaitLouviereplot_2a_Prolificexpoorcompletion.emf, as(emf) replace
regress coef_p coef_f
	//R-squared = 0.996 => roughly 1 so there is no heterogeneity in preferences between the samples
	//coefficient = 0.945 => slope of the line is roughly equal to 1 so no signs of scale heterogeneity (differences in error variance between the samples)

	
**Sensitivity analysis 2B: Thiscovery full sample vs sample with poor completers dropped
**Prolific full sample
use "PRU DCE full dataset for DCE analysis.dta", clear
drop if sample==1
clogit selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc, group(case)
estimates store full
regsave using coefficients_sens2b_Thiscovery, addlabel(subsample, full) replace

**Prolific poor completers dropped
use "PRU DCE full dataset for DCE analysis.dta", clear
drop if sample==1
drop if count_option1==9 | count_option2==9 | duration<=536	//729 observations dropped, 27 participants
clogit selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc, group(case)
estimates store poordropped
regsave using coefficients_sens2b_Thiscovery, addlabel(subsample, poordropped) append

use coefficients_sens2b_Thiscovery, clear
	encode sub, gen(sample)
	encode var, gen(variable)
	drop stderr N sub var

	reshape wide coef, i(var) j(sam)
	rename coef1 coef_full
	rename coef2 coef_poordropped
	label variable coef_full "full"
	label variable coef_poordropped "poor completers dropped"

twoway (scatter coef_p coef_f) (lfit coef_p coef_f), ylabel(-1.2(0.2)0.2) xlabel(-1.2(0.2)0.2) scheme(s1manual) ytitle("poor completers dropped") legend(off)
	graph export SwaitLouviereplot_2b_Thiscoveryexpoorcompletion.emf, as(emf) replace
regress coef_p coef_f
	//R-squared = 0.999 => roughly 1 so there is no heterogeneity in preferences between the samples
	//coefficient = 0.952 => slope of the line is roughly equal to 1 so no signs of scale heterogeneity (differences in error variance between the samples)
	

**________________________________________________________________________________________________________________

****EXTRAS****
*****Sensitivity analysis 3: version 1 vs 3
use "PRU DCE full dataset for DCE analysis.dta", clear
drop if version==2

**version 1, basic linear clogit model
clogit selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc if version==1, group(case)
estimates store version1
regsave using coefficients_sens3, addlabel(version, version1) replace

**version 3, basic linear clogit model
clogit selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc if version==3, group(case)
estimates store version3
regsave using coefficients_sens3, addlabel(version, version3) append

use coefficients_sens3, clear
	encode version, gen(vers)
	encode var, gen(variable)
	drop stderr N version var

	reshape wide coef, i(var) j(vers)
	rename coef1 coef_version1
	rename coef2 coef_version3
	label variable coef_version1 "version 1"
	label variable coef_version3 "version 3"
twoway (scatter coef_version3 coef_version1) (lfit coef_version3 coef_version1), ylabel(-1.4(0.2)0.2) xlabel(-1.4(0.2)0.2) scheme(s1manual) ytitle(version 3) legend(off)
regress coef_version3 coef_version1
	//R-squared = 0.980 => roughly 1 so there is no heterogeneity in preferences between these versions
	//coefficient = 0.616 => slope of the line is NOT roughly equal to 1 so signs of scale heterogeneity (differences in error variance between the samples)
	// => samples are heterogenous

**________________________________________________________________________________________________________________

*****Sensitivity analysis 4: version 2 vs 3
use "PRU DCE full dataset for DCE analysis.dta", clear
drop if version==1

**version 2, basic linear clogit model
clogit selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc if version==2, group(case)
estimates store version2
regsave using coefficients_sens4, addlabel(version, version2) replace

**version 3, basic linear clogit model
clogit selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc if version==3, group(case)
estimates store version3
regsave using coefficients_sens4, addlabel(version, version3) append

use coefficients_sens4, clear
	encode version, gen(vers)
	encode var, gen(variable)
	drop stderr N version var

	reshape wide coef, i(var) j(vers)
	rename coef1 coef_version2
	rename coef2 coef_version3
	label variable coef_version2 "version 2"
	label variable coef_version3 "version 3"
twoway (scatter coef_version3 coef_version2) (lfit coef_version3 coef_version2), ylabel(-1.4(0.2)0.2) xlabel(-1.4(0.2)0.2) scheme(s1manual) ytitle(version 2) legend(off)
regress coef_version3 coef_version2
	//R-squared = 0.915 => roughly 1 so there is no heterogeneity in preferences between these versions
	//coefficient = 0.405 => slope of the line is NOT roughly equal to 1 so signs of scale heterogeneity (differences in error variance between the samples)
	// => samples are heterogenous

log close
