


if "`c(username)'" == "siddhantpandit" {
	global br "/Users/siddhantpandit/Desktop/Anemia/Anemia_Thesis/data/br_prepared.DTA"
	global ir "/Users/siddhantpandit/Desktop/Anemia/Anemia_Thesis/data/ir_prepared.DTA"
}





use "$br"


estpost tabstat child_hg if hw55==0 [aw=wt], by(round5) statistics(mean sd count)
eststo children_hg




use "$ir"

estpost tabstat hg if v213==0 [aw=wt], by(round5) statistics(mean sd count)
eststo non_pregnant

estpost tabstat hg if v213==1 [aw=wt], by(round5) statistics(mean sd count)
eststo pregnant





#delimit ; 
esttab children_hg non_pregnant pregnant,
	main(mean 3) aux(sd 3)
	collabels("hello");

	
	

	
	

