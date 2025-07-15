
ACTION KrokWyrownywanie:
	IF aktywny THEN
		IF gZb1_poziom > gZb2_poziom + tolerancja_poziom THEN
			gZb1_zawor := 0;
			IF zawor2_otwarcie AND gZb2_poziom < poziom_95_procent THEN
				gZb2_zawor := 1;
			END_IF;
		ELSIF gZb2_poziom > gZb1_poziom + tolerancja_poziom THEN
			gZb2_zawor := 0;
			IF zawor1_otwarcie AND gZb1_poziom < poziom_95_procent THEN
				gZb1_zawor := 1;
			END_IF;
		ELSE
			gZb1_zawor := 0;
			gZb2_zawor := 0;
            
			IF gZb1_poziom >= 8000 AND gZb2_poziom >= 8000 THEN
				krok := 2;
			ELSE
				krok := 1;
			END_IF;
		END_IF;
	END_IF;
END_ACTION