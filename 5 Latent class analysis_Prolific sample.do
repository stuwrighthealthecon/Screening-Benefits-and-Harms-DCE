cd "C:\Users\rl423\OneDrive - University of Cambridge\PRU DCE_analysis"

sysdir set PLUS "C:\Program Files(x86)\Stata15\"
ssc install lclogit2
ssc install regsave

log using "LCA Prolific log.smcl", replace

use "PRU DCE full dataset for DCE analysis.dta", clear
keep if sample==1
mkspline xcancersdiagnosed_48_1 48 xcancersdiagnosed_48_2 = cancersdiagnosed_ct
tablist cancersdiagnosed_ct xcancersdiagnosed_48_1 xcancersdiagnosed_48_2, sort(v)

*1 class
clogit selection xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc, group(case) iter(150)
estat ic, n(604)

***number of classes
*2 classes
lclogit2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(2) iter(150)
estat ic, n(604)

*3 classes
lclogit2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) iter(150)
estat ic, n(604)

*4 classes
lclogit2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(4) iter(150)
estat ic, n(604)

*5 classes
lclogit2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(5) iter(150)
estat ic, n(604)


**optimum seed
* 2
lclogit2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(2) iter(150)
estat ic, n(604)

* 6
lclogit2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(6) iter(150)
estat ic, n(604)

* 40
lclogit2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(40) iter(150)
estat ic, n(604)

*978
lclogit2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(978) iter(150)
estat ic, n(604)

*6587
lclogit2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(6587) iter(150)
estat ic, n(604)

*12345
lclogit2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(12345) iter(150)
estat ic, n(604)

*17
lclogit2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(17) iter(150)
estat ic, n(604)



**describe class membership
**individual demographics
* age +- 50 years
lclogit2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(17) membership(bdem_ageover50) iter(170)
estat ic
estat ic, n(600)

* sex
lclogit2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(17) membership(bdem_sex_female) iter(150)
estat ic
estat ic, n(602)

* ethnicity +-white
lclogit2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(17) membership(bdem_eth_white) iter(150)
estat ic
estat ic, n(599)

* education +- degree
lclogit2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(17) membership(bdem_educat_degree) iter(150)
estat ic
estat ic, n(600)

* ses +- low
lclogit2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(17) membership(bdem_ses_low) ltolerance(0.001) iter(150)
estat ic
estat ic, n(593)


**Personal cancer and screening characteristics
* Personal cancer history - yes no
lclogit2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(17) membership(bcancer_personalhistory) iter(150)
estat ic, n(598)

* Attended screening - yes no
lclogit2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(17) membership(bcancer_screened) iter(150)
estat ic, n(596)

* Cancer likely - yes no
lclogit2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(17) membership(bcancer_likely) iter(150)
estat ic, n(568)

* Cancer worried - yes no
lclogit2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(17) membership(bcancer_worried) iter(150)
estat ic, n(598)


**Cancer and screening views summary
* enthus 1
lclogit2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(978) membership(enthus1) iterate(100)
estat ic, n(577)

* enthus 2
lclogit2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(978) membership(enthus2) iterate(100)
estat ic, n(588)

* enthus 3
lclogit2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(978) membership(enthus3) iterate(100)
estat ic, n(534)

* enthus 4
lclogit2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(978) membership(enthus4) iterate(100)
estat ic, n(541)

* enthus 5
lclogit2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(978) membership(enthus5) iterate(100)
estat ic, n(514)

* enthus 6
lclogit2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(978) membership(enthus6) iterate(100)
estat ic, n(497)

* enthus 7
lclogit2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(978) membership(enthus7) iterate(100)
estat ic, n(376)

* enthus 8
lclogit2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(978) membership(enthus8) iterate(100)
estat ic, n(533)






**membership based on age, SES and cancer likelihood
lclogit2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(17) membership(bdem_age bdem_ses bcancer_like)
	matrix start=e(b)
lclogitml2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(17) membership(bdem_age bdem_ses bcancer_like) from(start)
	estat ic	//n=561
	estat ic, n(561)

	
**membership based on SES and cancer likelihood
lclogit2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(17) membership( bdem_ses bcancer_like)
	matrix start=e(b)
lclogitml2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(17) membership( bdem_ses bcancer_like) from(start)
	estat ic	//n=562
	estat ic, n(562)


**membership based on age and cancer likelihood
lclogit2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(17) membership( bdem_age bcancer_like)
	matrix start=e(b)
lclogitml2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(17) membership( bdem_age bcancer_like) from(start)
	estat ic	//n=567
	estat ic, n(567)

	
**membership based on sex and cancer likelihood
lclogit2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(17) membership( bdem_sex bcancer_like)
	matrix start=e(b)
lclogitml2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(17) membership( bdem_sex bcancer_like) from(start)
	estat ic	//n=568
	estat ic, n(568)
	
	
**membership based on eth and cancer likelihood
lclogit2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(17) membership( bdem_eth bcancer_like)
	matrix start=e(b)
lclogitml2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(17) membership( bdem_eth bcancer_like) from(start)
	estat ic	//n=566
	estat ic, n(566)
	
	
**membership based on ed and cancer likelihood
lclogit2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(17) membership( bdem_ed bcancer_like)
	matrix start=e(b)
lclogitml2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(17) membership( bdem_ed bcancer_like) from(start)
	estat ic	//n=567
	estat ic, n(567)
	
	
**membership based on likelihood
lclogit2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(17) membership(bcancer_like)
	matrix start=e(b)
lclogitml2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(17) membership(bcancer_like) from(start)
	estat ic	//n=568
	estat ic, n(568)
		
	
**membership based on age
lclogit2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(17) membership(bdem_age)
	matrix start=e(b)
lclogitml2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(17) membership(bdem_age) from(start)
	estat ic	//n=600
	estat ic, n(600)
	
	
*membership based on age and sex
lclogit2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(17) membership(bdem_age bdem_sex)
	matrix start=e(b)
lclogitml2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(17) membership(bdem_age bdem_sex) from(start)
	estat ic	//n=600
	estat ic, n(600)	
	
	
*membership based on age and eth
lclogit2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(17) membership(bdem_age bdem_eth)
	matrix start=e(b)
lclogitml2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(17) membership(bdem_age bdem_eth) from(start)
	estat ic	//n=597
	estat ic, n(597)
	
	
*membership based on age and ed
lclogit2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(17) membership(bdem_age bdem_ed)
	matrix start=e(b)
lclogitml2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(17) membership(bdem_age bdem_ed) from(start)
	estat ic	//n=598
	estat ic, n(598)
	
	
*membership based on age and ses
lclogit2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(17) membership(bdem_age bdem_ses)
	matrix start=e(b)
lclogitml2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(17) membership(bdem_age bdem_ses) from(start)
	estat ic	//n=591
	estat ic, n(591)
	
	
	
	
	
**membership based on age
lclogit2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(17) membership(bdem_age)
	matrix start=e(b)
lclogitml2 selection, rand(xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(17) membership(bdem_age) from(start)
	estat ic	//n=600
	estat ic, n(600)
