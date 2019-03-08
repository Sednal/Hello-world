data work.Einmaleinz(Keep=BNR BNNR tarif Budat betrag Kezi Primanota LE_MM);
set Data_k.zr_Tagesums;

LE_MM = ' ';
/* Tarif mit Guthabenszins >= 1% */
/*If  KEZI = '000' and ((Tarif > '11' and Tarif < '30') ! Tarif in ('36' '41'))*/

/* Alle V-Tarife ohne Vario und Riester >= 1% Guthabenszins */
If  KEZI = '000' and (Tarif in ('14' '17' '19' '29' '36' '41')) 
and Budat > '20160101'	then
Do;
	If primanota = '992' then
	DO;
		LE_MM = 'J';
	End;
	Else do;
		LE_MM = 'N';
	End;

	/* Ist der Eingangs-Zahlbetrag > 500€ und Kunde hat keinen LE */
	If betrag > 50000 and LE_MM = 'N' then
	Do;
		put LE_MM;
		output work.einmaleinz;
	End;
End;
run;


%_eg_conditional_dropds(EGTASK.QUERY_FOR_EINMALEINZ);

PROC SQL;
   CREATE TABLE EGTASK.QUERY_FOR_EINMALEINZ AS 
   SELECT t1.Budat, 
          t1.BNR, 
          t1.BNNR, 
          t1.Kezi, 
          t1.Betrag, 
          t1.Primanota, 
          t1.Tarif, 
          t1.LE_MM, 
          t2.SPKZ, 
          t2.SPKH,
		  t2.SPKMB,
		  t2.ADMA
      FROM WORK.EINMALEINZ t1
           LEFT JOIN DATA_R.D_STRUKTUR_AB t2 ON (t1.BNR = t2.BNR) AND (t1.BNNR = t2.BNNR);
QUIT;
