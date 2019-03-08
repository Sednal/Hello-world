Data work.zr_tagesums_Bv (keep = yyyymm Bvnr bnr bnnr tarif Kontoart Wert_einl budat kezi Primanota betrag Betrag_unverz Saldo_unverz);
set Data_k.zr_Tagesums;
/* erst mal eine BV_Nummer zusammenbauen. */
bvnr = bnr !! bnnr;
output work.zr_tagesums_Bv;
run;
/* Nach der BV-Nummer sortieren und nur Sätze von 2016 und PN 992 behalten. */
PROC SORT DATA=work.zr_tagesums_Bv OUT =work.zr_tagesums_BvSort;
BY Bvnr budat;
where Primanota = '992' and yyyymm < '201701' and bnnr < '005';
RUN; 

Data work.zr_tagesums_BvSumme (keep = yyyymm Bvnr bnr bnnr tarif Kontoart Wert_einl budat kezi Primanota betrag LE_Sum2016 Betrag_unverz Saldo_unverz Zaehl);
set work.zr_tagesums_BvSort;
RETAIN LE_Sum2016 0;
Retain Zaehl 0;
/* In einer Schleife über die BV-Nummer verarbeiten. */
by Bvnr;
/* Bei der Ersten BV-Nummer wird initialisiert */
If first.bvnr then 
	LE_Sum2016 = 0;
/* Dann die LE_Beträge aufaddieren.. */
LE_Sum2016 = LE_Sum2016 + betrag;
Zaehl = Zaehl + 1;
/* beim letzen Satz zu einer BV_Nr. Verarbeiten und ausgeben. */
If last.bvnr then do;
	/*	LE_Sum2016 = LE_Sum2016 * 0.01; */   /* Braucht man nicht wg. Retain! */
	format LE_Sum2016 n2k.; 
	put LE_Sum2016 Zaehl;
	output work.zr_tagesums_BVSumme;
	Zaehl = 0;
End;
/* Stoppen nach 100 eingelesenen Datensätzen wg. Proc Print */
If _N_ = 100 then stop;
run; 
QUIT;
/* Nur ausführen mit wenig Datensätzen wg. der Laufzeit */
PROC PRINT DATA=work.zr_tagesums_BVSumme  Blankline=3;
	Title 'Anfang LE-Summe 2016';
	Var yyyymm Bvnr tarif Wert_einl kezi Primanota LE_Sum2016 Zaehl;
    ID Bvnr;
	Footnote 'Ende LE-Summe 2016';
RUN;