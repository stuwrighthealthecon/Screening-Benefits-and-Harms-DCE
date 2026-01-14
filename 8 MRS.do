cd "C:\Users\rl423\OneDrive - University of Cambridge\PRU_Screening benefits and harms DCE TEAM\f_DCE study\Analysis"

sysdir set PLUS "C:\Program Files(x86)\Stata15\"
ssc install lclogit2

****** MRS ******
**"For example, the delta method can be computed using the nlcom command in Stata" (from
**https://www.sciencedirect.com/science/article/pii/S1098301520321045)

log using "MRS log.smcl", replace	

*************Prolific sample n=604********************
use "PRU DCE full dataset for DCE analysis.dta", clear
drop if sample==2

**Main analysis
mkspline xcancersdiagnosed_48_1 48 xcancersdiagnosed_48_2 = cancersdiagnosed_ct
tablist cancersdiagnosed_ct xcancersdiagnosed_48_1 xcancersdiagnosed_48_2, sort(v)
clogit selection xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc, group(case)

***denominator = cancer deaths
nlcom  (_b[asc]/_b[cancerdeaths_ct])	///
	(_b[xcancersdiagnosed_48_1]/_b[cancerdeaths_ct]) (_b[xcancersdiagnosed_48_2]/_b[cancerdeaths_ct])	///
	(_b[overdiagnosis_ct]/_b[cancerdeaths_ct])	///
	(_b[falsepositives_ct]/_b[cancerdeaths_ct])	///
	(_b[falsenegatives_ct]/_b[cancerdeaths_ct])


*************Thiscovery sample n=604********************

use "PRU DCE full dataset for DCE analysis.dta", clear
drop if sample==1

**Main analysis
clogit selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc, group(case)

***denominator = cancer deaths
nlcom  (_b[asc]/_b[cancerdeaths_ct])	///
	(_b[cancersdiagnosed_ct]/_b[cancerdeaths_ct])	///
	(_b[overdiagnosis_ct]/_b[cancerdeaths_ct])	///
	(_b[falsepositives_ct]/_b[cancerdeaths_ct])	///
	(_b[falsenegatives_ct]/_b[cancerdeaths_ct])

log close
