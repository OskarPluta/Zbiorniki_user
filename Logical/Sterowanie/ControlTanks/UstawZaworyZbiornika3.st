
ACTION UstawZaworyZbiornika3:
	IF zawor3_prawy_aktywny AND zawor3_prawy_otwarcie > 0 THEN
		gZb3_zawor_prawy := zawor3_prawy_otwarcie;
	ELSE
		gZb3_zawor_prawy := 0;
	END_IF;
    
	IF zawor3_lewy_aktywny AND zawor3_lewy_otwarcie > 0 THEN
		gZb3_zawor_lewy := zawor3_lewy_otwarcie;
	ELSE
		gZb3_zawor_lewy := 0;
	END_IF;
END_ACTION