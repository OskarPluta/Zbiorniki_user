ACTION ZabezpieczeniaPoziomow:
	IF gZb1_poziom >= poziom_95_procent THEN
		gZb1_zawor := 0;
	END_IF;
    
	IF gZb2_poziom >= poziom_95_procent THEN
		gZb2_zawor := 0;
	END_IF;
    
	IF gZb3_poziom >= max_poziom THEN
		gZb3_zawor_prawy := 0;
		gZb3_zawor_lewy := 0;
	END_IF;
END_ACTION