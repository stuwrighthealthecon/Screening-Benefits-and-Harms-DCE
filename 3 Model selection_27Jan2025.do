cd "C:\Users\rl423\OneDrive - University of Cambridge\PRU DCE_analysis"

sysdir set PLUS "C:\Program Files(x86)\Stata15\"
ssc install lclogit2
ssc install clogithet
ssc install regsave


*************Full sample -analyse as one or two samples********************
log using "Sample comparison log.smcl", replace

use "PRU DCE full dataset for DCE analysis.dta", clear


**1 Basic linear clogit model (continuous attributes, asc)
clogit selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc, group(case)
estat ic

**Prolific sample
clogit selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc if sample==1, group(case)
estimates store prolific
regsave using coefficients, addlabel(subsample, prolific) replace

estat ic

**Thiscovery sample
clogit selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc if sample==2, group(case)
estimates store thiscovery

regsave using coefficients, addlabel(subsample, thiscovery) append


estat ic

suest prolific thiscovery
estimates restore prolific 
estimates restore thiscovery 



use coefficients, clear
	encode sub, gen(sample)
	encode var, gen(variable)
	drop stderr N sub var

	reshape wide coef, i(var) j(sam)
	rename coef1 coef_Prolific
	rename coef2 coef_Thiscovery
	label variable coef_Prolific "Prolific"
	label variable coef_Thiscovery "Thiscovery"

twoway (scatter coef_T coef_P) (lfit coef_T coef_P), ylabel(-1.2(0.2)0.2) xlabel(-1.2(0.2)0.2) scheme(s1manual) ytitle(Thiscovery) legend(off)
	graph export SwaitLouviereplot_samples.emf, as(emf) replace
regress coef_T coef_P
	//R-squared = 0.958 => roughly 1 so there is no heterogeneity in preferences between the samples
	//coefficient = 1.801 => slope of the line is NOT roughly equal to 1 so signs of scale heterogeneity (differences in error variance between the samples)
	// => analyse samples separately


log close
	
	
*************Prolific sample n=604********************
log using "Model selection Prolific log.smcl", replace

use "PRU DCE full dataset for DCE analysis.dta", clear
drop if sample==2

**1 Basic linear clogit model (continuous attributes, asc)
clogit selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc, group(case)
estat ic
estat ic, n(604)

**________________________________________________________________________________________________________________


**2 Including constant for option 1 as well as asc, then including constant for option 2 as well as asc
clogit selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc opt1, group(case)
estat ic
estat ic, n(604)

clogit selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc opt2, group(case)
estat ic
estat ic, n(604)

**________________________________________________________________________________________________________________


**3 Effects coding each variable in turn
**a cancers diagnosed
clogit selection cancer_49 cancer_48 cancer_44 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc, group(case)
estat ic
estat ic, n(604)

**b cancer deaths
clogit selection cancersdiagnosed_ct deaths_7 deaths_5 deaths_3 overdiagnosis_ct falsepositives_ct falsenegatives_ct asc, group(case)
estat ic
estat ic, n(604)

**c overdiagnosis
clogit selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_2 overdiagnosis_10 overdiagnosis_15 overdiagnosis_30 falsepositives_ct falsenegatives_ct asc, group(case)
estat ic
estat ic, n(604)

**d false positives
clogit selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepos_200 falsepos_300 falsepos_400 falsepos_500 falsenegatives_ct asc, group(case)
estat ic
estat ic, n(604)

**e false negatives
clogit selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falseneg_1 falseneg_10 falseneg_20 falseneg_50 asc, group(case)
estat ic
estat ic, n(604)

**________________________________________________________________________________________________________________


**4 Transform each variable that was better effects coded

** cancers diagnosed
**a cancers diagnosed transformed (quadratic)
gen cancersdiagnosed_ct_SQ = (cancersdiagnosed_ct)^2
clogit selection cancersdiagnosed_ct_SQ cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc, group(case)
estat ic
estat ic, n(604)

**b cancers diagnosed transformed (log)
gen cancersdiagnosed_ct_LOG = ln(cancersdiagnosed_ct)
clogit selection cancersdiagnosed_ct_LOG cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc, group(case)
estat ic
estat ic, n(604)

**c cancers diagnosed transformed (piecewise) [values 44, 48, 49, 50] [https://stats.oarc.ucla.edu/stata/faq/how-can-i-run-a-piecewise-regression-in-stata]
***48
mkspline xcancersdiagnosed_48_1 48 xcancersdiagnosed_48_2 = cancersdiagnosed_ct
tablist cancersdiagnosed_ct xcancersdiagnosed_48_1 xcancersdiagnosed_48_2, sort(v)
clogit selection xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc, group(case)
estat ic
estat ic, n(604)

***49
mkspline xcancersdiagnosed_49_1 49 xcancersdiagnosed_49_2 = cancersdiagnosed_ct
tablist cancersdiagnosed_ct xcancersdiagnosed_49_1 xcancersdiagnosed_49_2, sort(v)
clogit selection xcancersdiagnosed_49_1 xcancersdiagnosed_49_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc, group(case)
estat ic
estat ic, n(604)
	
drop cancersdiagnosed_ct_SQ cancersdiagnosed_ct_LOG xcancersdiagnosed_49_1 xcancersdiagnosed_49_2


** false positives
**a false positives transformed (quadratic)
gen falsepositives_ct_SQ = (falsepositives_ct)^2
clogit selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct_SQ falsenegatives_ct asc, group(case)
estat ic
estat ic, n(604)

**b false positives transformed (log)
gen falsepositives_ct_LOG = ln(falsepositives_ct)
clogit selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct_LOG falsenegatives_ct asc, group(case)
estat ic
estat ic, n(328)

**c false positives transformed (piecewise) [values 0, 200, 300, 400, 500]
***300
mkspline xfalsepositives_300_1 300 xfalsepositives_300_2 = falsepositives_ct
tablist falsepositives_ct xfalsepositives_300_1 xfalsepositives_300_2, sort(v)
clogit selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct xfalsepositives_300_1 xfalsepositives_300_2 falsenegatives_ct asc, group(case)
estat ic
estat ic, n(604)

***400
mkspline xfalsepositives_400_1 400 xfalsepositives_400_2 = falsepositives_ct
tablist falsepositives_ct xfalsepositives_400_1 xfalsepositives_400_2, sort(v)
clogit selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct xfalsepositives_400_1 xfalsepositives_400_2 falsenegatives_ct asc, group(case)
estat ic
estat ic, n(604)
	
drop falsepositives_ct_* xfalsepositives*


** false negatives
**a false negatives transformed (quadratic)
gen falsenegatives_ct_SQ = (falsenegatives_ct)^2
clogit selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsenegatives_ct_SQ falsenegatives_ct asc, group(case)
estat ic
estat ic, n(604)

**b false negatives transformed (log)
gen falsenegatives_ct_LOG = ln(falsenegatives_ct)
clogit selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsenegatives_ct_LOG falsenegatives_ct asc, group(case)
estat ic
estat ic, n(328)

**c false negatives transformed (piecewise) [values 0, 1, 10, 20, 50]
***10
mkspline xfalsenegatives_10_1 10 xfalsenegatives_10_2 = falsenegatives_ct
tablist falsenegatives_ct xfalsenegatives_10_1 xfalsenegatives_10_2, sort(v)
clogit selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct xfalsenegatives_10_1 xfalsenegatives_10_2 falsenegatives_ct asc, group(case)
estat ic
estat ic, n(604)

***20
mkspline xfalsenegatives_20_1 20 xfalsenegatives_20_2 = falsenegatives_ct
tablist falsenegatives_ct xfalsenegatives_20_1 xfalsenegatives_20_2, sort(v)
clogit selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct xfalsenegatives_20_1 xfalsenegatives_20_2 falsenegatives_ct asc, group(case)
estat ic
estat ic, n(604)
	
drop falsenegatives_ct_* xfalsenegatives*



**________________________________________________________________________________________________________________


//**5 uncorrelated random parameter logit model
//mixlogit selection, group(case) rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) id(simpleid) 
//estat ic
//estat ic, n(604)


**________________________________________________________________________________________________________________


//**6 correlated random parameter logit model 
//mixlogit selection, group(case) rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) id(simpleid) corr
//estat ic
//estat ic, n(604)



**________________________________________________________________________________________________________________

**FINAL MODEL
mkspline xcancersdiagnosed_48_1 48 xcancersdiagnosed_48_2 = cancersdiagnosed_ct
clogit selection xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc, group(case)

log close


*************Thiscovery sample n=604********************
log using "Model selection Thiscovery log HET.smcl", replace

use "PRU DCE full dataset for DCE analysis.dta", clear
drop if sample==1

**1 Basic linear clogit model (continuous attributes, asc) WITH HET
clogithet selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc, group(case) het(version)
estat ic
estat ic, n(414)


**________________________________________________________________________________________________________________

**2 Including constant for option 1 as well as asc, then including constant for option 2 as well as asc
clogithet selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc opt1, group(case) het(version)
estat ic
estat ic, n(414)


clogithet selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc opt2, group(case) het(version)
estat ic
estat ic, n(414)



**________________________________________________________________________________________________________________

**3 Effects coding each variable in turn
**a cancers diagnosed
clogithet selection cancer_49 cancer_48 cancer_44 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc, group(case) het(version)
estat ic
estat ic, n(414)


**b cancer deaths
clogithet selection cancersdiagnosed_ct deaths_7 deaths_5 deaths_3 overdiagnosis_ct falsepositives_ct falsenegatives_ct asc, group(case) het(version)
estat ic
estat ic, n(414)


**c overdiagnosis
clogithet selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_2 overdiagnosis_10 overdiagnosis_15 overdiagnosis_30 falsepositives_ct falsenegatives_ct asc, group(case) het(version)
estat ic
estat ic, n(414)


**d false positives
clogithet selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepos_200 falsepos_300 falsepos_400 falsepos_500 falsenegatives_ct asc, group(case) het(version) 
estat ic
estat ic, n(414)


**e false negatives
clogithet selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falseneg_1 falseneg_10 falseneg_20 falseneg_50 asc, group(case) het(version)
estat ic
estat ic, n(414)



**________________________________________________________________________________________________________________

**4 Transform each variable that was better effects coded - none


**________________________________________________________________________________________________________________


//**5 uncorrelated random parameter logit model
//mixlogit selection, rand(cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) 

//estat ic
//estat ic, n(414)

//matrix b = e(b)

**________________________________________________________________________________________________________________


//**6 correlated random parameter logit model 
//mixlogit selection , group(case) rand(cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) corr 
//estat ic
//estat ic, n(414)

//mixlcov


**________________________________________________________________________________________________________________

**FINAL MODEL
clogithet selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc, group(case) het(version)

log close
