Data EGTASK.Sort_BvNr;
	set EGTASK.QUERY_FOR_DNORM_BRUTTO_0001;

	/* erst mal eine BV_Nummer zusammenbauen. */
	bvnr = bnr !! bnnr;
	output EGTASK.Sort_BvNr;
run;

Data EGTASK.LESUM2016;
	set EGTASK.Sort_BvNr;
	RETAIN LE_Sum2016 0;
	Retain Zaehl 0;

	/* In einer Schleife über die BV-Nummer verarbeiten. */
	by Bvnr;

	/* Bei der Ersten BV-Nummer wird initialisiert */
	If first.bvnr then
		LE_Sum2016 = 0;

	/* Dann die LE_Beträge aufaddieren.. */
	LE_Sum2016 = LE_Sum2016 + Betrag;
	Zaehl = Zaehl + 1;

	/* beim letzen Satz zu einer BV_Nr. Verarbeiten und ausgeben. */
	If last.bvnr then
		do;
			/*	LE_Sum2016 = LE_Sum2016 * 0.01; */
			/* Braucht man nicht wg. Retain! */
			format LE_Sum2016 n2k.;
			put LE_Sum2016 Zaehl;
			output EGTASK.LESUM2016;
			Zaehl = 0;
		End;
run;

data EGTASK.LESUM2016Fin (KEEP=BNR BNNR BAGS TARIF BHSWNUMN
	ADMA BVZ BSTAD BVSLANG HKTSP LEBETR_EINM
	LEBETR_REGELM LE_SUM2016
	rename = (BNR=BV_Nummer bnnr=Nachnummer BAGS=AgSchlüssel TARIF=Tarif 
	BHSWNUMN=SPK_Mitarbeiter ADMA=Aussendienst_MA
	BVZ=Vertragszustand BSTAD=Abschlussdatum BVSLANG=BV_Summe HKTSP=Kontostand_Spar
	LEBETR_EINM=LE_Betr_Einm LEBETR_REGEL=LE_Betr_Regel LE_SUM2016=SummeLE_2016));
	/* Reihenfolge der Spalten festlegen */
	RETAIN  BNR BNNR BAGS Tarif BHSWNUMN 
		ADMA BVZ BSTAD BVSLANG HKTSP LEBETR_EINM LEBETR_REGEL LE_SUM2016;
	Set EGTASK.LESUM2016;
run;