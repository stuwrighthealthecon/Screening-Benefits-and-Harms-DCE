cd "C:\Users\rl423\OneDrive - University of Cambridge\PRU DCE_analysis"

sysdir set PLUS "C:\Program Files(x86)\Stata15\"
ssc install lclogit2


log using "LCA Thiscovery log.smcl", replace

use "PRU DCE full dataset for DCE analysis.dta", clear
keep if sample==2

***one class model
clogit selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc, group(case)


***number of classes
*2 classes
lclogit2 selection, rand(cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(2)
estat ic
estat ic, n(414)

*3 classes
lclogit2 selection, rand(cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(6)
estat ic
estat ic, n(414)

*4 classes
lclogit2 selection, rand(cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(4)
estat ic
estat ic, n(414)

*5 classes
lclogit2 selection, rand(cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(5)
estat ic, n(414)

*6 classes
lclogit2 selection, rand(cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(6)
estat ic, n(414)


**optimum seed
* 2
lclogit2 selection, rand(cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(2)
estat ic, n(414)

* 11
lclogit2 selection, rand(cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(11)
estat ic, n(414)

* 15
lclogit2 selection, rand(cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(15)
estat ic, n(414)

* 40
lclogit2 selection, rand(cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(40)
estat ic, n(414)

*978
lclogit2 selection, rand(cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(978)
estat ic, n(414)

*6587
lclogit2 selection, rand(cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(6587)
estat ic, n(414)

**3 quite good, 11/14/16/19 best BIC but wrong order



**describe class membership
**individual demographics
* age +- 50 years
lclogit2 selection, rand(cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(3) membership(bdem_ageover50)
estat ic	//n=398
estat ic, n(398)

* sex
lclogit2 selection, rand(cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(3) membership(bdem_sex_female)
estat ic	//n=403
estat ic, n(403)

* ethnicity +-white
lclogit2 selection, rand(cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(3) membership(bdem_eth_white)
estat ic	//n=401
estat ic, n(401)

* education +- degree
lclogit2 selection, rand(cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(3) membership(bdem_educat_degree)
estat ic	//n=398
estat ic, n(398)

* ses +- low
lclogit2 selection, rand(cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(3) membership(bdem_ses_low)
estat ic	//n=389
estat ic, n(389)


**Personal cancer and screening characteristics
* Personal cancer history - yes no
lclogit2 selection, rand(cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(3) membership(bcancer_personalhistory)
estat ic	//n=397
estat ic, n(397)

* Attended screening - yes no
lclogit2 selection, rand(cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(3) membership(bcancer_screened)
estat ic	//n=400
estat ic, n(400)

* Cancer likely - yes no
lclogit2 selection, rand(cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(3) membership(bcancer_likely)
estat ic	//n=389
estat ic, n(389)

* Cancer worried - yes no
lclogit2 selection, rand(cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(3) membership(bcancer_worried)
estat ic	//n=399
estat ic, n(399)


**Cancer and screening views summary
* enthus 1
lclogit2 selection, rand(cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(3) membership(enthus1)
estat ic	//n=388
estat ic, n(388)

* enthus 2
lclogit2 selection, rand(cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(3) membership(enthus2)
estat ic	//n=399
estat ic, n(399)

* enthus 3
lclogit2 selection, rand(cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(3) membership(enthus3)
estat ic	//n=379
estat ic, n(379)

* enthus 4
lclogit2 selection, rand(cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(3) membership(enthus4)
estat ic	//n=397
estat ic, n(397)

* enthus 5
lclogit2 selection, rand(cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(3) membership(enthus5)
estat ic	//n=343
estat ic, n(343)

* enthus 6
lclogit2 selection, rand(cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(3) membership(enthus6)
estat ic	//n=342
estat ic, n(342)

* enthus 7
lclogit2 selection, rand(cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(3) membership(enthus7)
estat ic	//n=342
estat ic, n(342)

* enthus 8
lclogit2 selection, rand(cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(3) membership(enthus8)
estat ic	//n=354
estat ic, n(354)



**membership based on age, SES and cancer likelihood
lclogit2 selection, rand(cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(3) membership(bdem_age bdem_ses bcancer_like)
	estat ic	//n=373
	estat ic, n(373)
	matrix start=e(b)
lclogitml2 selection, rand(cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(3) membership(bdem_age bdem_ses bcancer_like) from(start)


**membership based on SES and cancer likelihood
lclogit2 selection, rand(cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(3) membership( bdem_ses bcancer_like)
	estat ic	//n=377
	estat ic, n(377)
	matrix start=e(b)
lclogitml2 selection, rand(cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(3) membership( bdem_ses bcancer_like) from(start)


**membership based on age and cancer likelihood
lclogit2 selection, rand(cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(3) membership( bdem_age bcancer_like)
	matrix start=e(b)
lclogitml2 selection, rand(cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(3) membership( bdem_age bcancer_like) from(start)
	estat ic	//n=383
	estat ic, n(383)

	
**membership based on sex and cancer likelihood
lclogit2 selection, rand(cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(3) membership( bdem_sex bcancer_like)
	matrix start=e(b)
lclogitml2 selection, rand(cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(3) membership( bdem_sex bcancer_like) from(start)
	estat ic	//n=387
	estat ic, n(387)
	
	
**membership based on eth and cancer likelihood
lclogit2 selection, rand(cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(3) membership( bdem_eth bcancer_like)
	matrix start=e(b)
lclogitml2 selection, rand(cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(3) membership( bdem_eth bcancer_like) from(start)
	estat ic	//n=385
	estat ic, n(385)
	
	
**membership based on ed and cancer likelihood
lclogit2 selection, rand(cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(3) membership( bdem_ed bcancer_like)
	matrix start=e(b)
lclogitml2 selection, rand(cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(3) membership( bdem_ed bcancer_like) from(start)
	estat ic	//n=386
	estat ic, n(386)
	
	
**membership based on likelihood
lclogit2 selection, rand(cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(3) membership(bcancer_like)
	matrix start=e(b)
lclogitml2 selection, rand(cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc) group(case) id(simpleid) nclasses(3) seed(3) membership(bcancer_like) from(start)
	estat ic	//n=389
	estat ic, n(389)
