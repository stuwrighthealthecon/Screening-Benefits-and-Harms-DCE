cd "C:\Users\rl423\OneDrive - University of Cambridge\PRU DCE_analysis"
graph set window fontface "Calibri"

use "PRU DCE full dataset.dta", clear


**ranking graph
keep eval_rank_*

drop if eval_rank_deathsprev == . | eval_rank_cancersprev == . | eval_rank_overdd == . | eval_rank_falsepos == . | eval_rank_falseneg == .

preserve
	contract eval_rank_deathsprev, freq(_freq)
	rename eva* rank
	gen attribute="deathsprev"
	save rank1, replace
	restore
	preserve
contract eval_rank_cancersprev, freq(_freq)
	rename eval rank
	gen attribute="cancersprev"
	save rank2, replace
	restore
	preserve
contract eval_rank_overdd, freq(_freq)
	rename eval rank
	gen attribute="overdd"
	save rank3, replace
	restore
	preserve
contract eval_rank_falsepos, freq(_freq)
	rename eval rank
	gen attribute="falsepos"
	save rank4, replace
	restore
	preserve
contract eval_rank_falseneg, freq(_freq)
	rename eval rank
	gen attribute="falseneg"
	save rank5, replace
	restore	

use "rank1", clear
append using "rank2" "rank3" "rank4" "rank5"
sort att
encode attribute, gen(att)
drop attr
sort att rank


* reduced dataset of percents
bysort att : egen total = total(_freq)
gen pc = 100 * _freq / total

* initialise to sum of negative categories and half any neutral category
egen start = total(pc * (rank == 1) + pc * (rank == 2) + 0.5 * pc * (rank == 3)) , by(att)
* negate start
replace start = -start

* bar starts and ends
bysort att : gen end = start + sum(pc)
bysort att : replace start = start + sum(pc[_n-1]) if _n > 1

label variable rank ""
label define att 1 "Cancers prevented" 2 "Deaths prevented" 3 "False negatives" 4 "False positives" 5 "Overdetection and overtreatment", replace

twoway rbar start end att if rank == 1, barw(0.5) bfcolor(red*0.6) blcolor(red) ///
|| rbar start end att if rank == 2, barw(0.5) bfcolor(red*0.3) blcolor(red)     ///
|| rbar start end att if rank == 3, barw(0.5) bfcolor(white) blcolor(gs12)      ///
|| rbar start end att if rank == 4, barw(0.5) bfcolor(blue*0.3) blcolor(blue)   ///
|| rbar start end att if rank == 5, barw(0.5) bfcolor(blue*0.6) blcolor(blue)   ///
legend(order(5 "5 - lowest rank" 4 "4" 3 "3"  2 "2" 1 "1 - highest rank") size(vsmall) col(1) pos(6) rows(1) region(fcolor(none) lcolor(none))) ///
xlabel(1 `""Cancers" "prevented""' 2 `""Deaths" "prevented""' 3 `""False" "negatives""' 4 `""False" "positives""' 5 `""Over-detection" "and -treatment""', labsize(small))   ///
yli(0, lc(gs12) lw(thin)) ytitle(%) ytitle("Participants (%)") ylabel(, nogrid labsize(small)) xtitle(" " "Attribute")	///
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))

//currently highest ranks negative...


**tables
use "PRU DCE full dataset.dta", clear

tab eval_ease, m
tab eval_ease sample, m chi2
tab eval_ease sample, chi2

tab beval_eas, m
tab beval_eas sample, m chi2
tab beval_eas sample, chi2

tab eval_strategy, m
tab eval_strategy sample, m chi2
tab eval_strategy sample, chi2

tab eval_attconsidered_cancerprev, m
tab eval_attconsidered_cancerprev sample, m chi2
tab eval_attconsidered_cancerprev sample, chi2

tab eval_attconsidered_deathprev, m
tab eval_attconsidered_deathprev sample, m chi2
tab eval_attconsidered_deathprev sample, chi2

tab eval_attconsidered_overdiag, m
tab eval_attconsidered_overdiag sample, m chi2
tab eval_attconsidered_overdiag sample, chi2

tab eval_attconsidered_falsepos, m
tab eval_attconsidered_falsepos sample, m chi2
tab eval_attconsidered_falsepos sample, chi2

tab eval_attconsidered_falseneg, m
tab eval_attconsidered_falseneg sample, m chi2
tab eval_attconsidered_falseneg sample, chi2
