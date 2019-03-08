/* Selektionen der Verträge die sich in der Sparphase (Honoriert) */
/* und die die sich in der Darlehensphase befinden */
PROC SQL;
	CREATE VIEW WORK.HonoriertAndDarl AS
   SELECT t1.'Schlüssel'n, 
          t1.Abgeber, 
          t1.NachnameAG, 
          t1.VornameAG, 
          t1.'AG-VD'n, 
          t1.'AG-BD'n, 
          t1.'AG-HV'n, 
          t1.Empfaenger, 
          t1.NachnameEM, 
          t1.VornameEM, 
          t1.'EM-VD'n, 
          t1.'EM-BD'n, 
          t1.'EM-HV'n, 
          t1.'angenommen am'n, 
          t1.Bnr, 
		  t1.bnnr,
          t1.Honorierungsdatum, 
          t1.BausparSumHonoriert, 
          t1.Entstehungsdatum, 
          t1.Vorgangsart
/*	      t1.ErstauszahlDatum, 
          t1.LBSFinanzSumme, 
          t1.bdl_art, 
          t1.VORGANGSART_DARL, 
          t1.BudatVgDarl, 
          t1.UmsatzDarlehen, 
          t1.BSV_DOBEXIST
 */     FROM EGTASK.SELECT_SPAR_ALLE_VERTRAEGE t1
   UNION ALL
	SELECT t2.'Schlüssel'n, 
          t2.Abgeber, 
          t2.NachnameAG, 
          t2.VornameAG, 
          t2.'AG-VD'n, 
          t2.'AG-BD'n, 
          t2.'AG-HV'n, 
          t2.Empfaenger, 
          t2.NachnameEM, 
          t2.VornameEM, 
          t2.'EM-VD'n, 
          t2.'EM-BD'n, 
          t2.'EM-HV'n, 
          t2.'angenommen am'n, 
		  t2.Bnr, 
 	 	  t2.bnnr,
		  t2.Honorierungsdatum, 
          t2.BausparSumHonoriert,
	      t2.Entstehungsdatum, 
          t2.Vorgangsart, 
	      t2.BuDatFinWertung, 
          t2.HAVAUS, 
          t2.ArtDarlehen, 
          t2.VORGANGSART, 
          t2.FinDatVgDarl, 
          t2.UmsatzDarl, 
          t2.BSV_DOBEXIST
      FROM EGTASK.SELECT_NUR_DARLEHEN t2
ORDER BY BNR ASC
;
QUIT;

/* Alle Honorierten Verträge und alle Darlehensverträge in einer Tabelle zusammenführen */
proc sql;
   CREATE VIEW WORK.HonoriertAndDarl AS
   select * from EGTASK.SELECT_SPAR_ALLE_VERTRAEGE t1
   outer union corr
    select * from EGTASK.SELECT_NUR_DARLEHEN t2;
  /* select * from EGTASK.SELECT_NUR_DARLEHEN t2; */
   Quit;
	
