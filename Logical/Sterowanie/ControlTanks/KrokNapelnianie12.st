ACTION KrokNapelnianie12:
	IF aktywny THEN
		IF gZb1_poziom >= poziom_80_procent AND gZb2_poziom >= poziom_80_procent THEN
			krok := 2;
		ELSE
			IF zawor1_otwarcie AND gZb1_poziom < poziom_80_procent AND gZb1_poziom < poziom_95_procent THEN
				gZb1_zawor := 1;
			END_IF;
			IF zawor2_otwarcie AND gZb2_poziom < poziom_80_procent AND gZb2_poziom < poziom_95_procent THEN
				gZb2_zawor := 1;
			END_IF;
		END_IF;
        
		gZb3_zawor_lewy := 0;
		gZb3_zawor_prawy := 0;
	END_IF;
END_ACTION