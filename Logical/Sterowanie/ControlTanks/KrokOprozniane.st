ACTION KrokOprozniane:
	IF aktywny THEN
		IF zawor3_glowny_otwarcie THEN
			gZb3_zawor_glowny := 1;
		END_IF;
        
		IF gZb3_poziom = 0 THEN
			krok := 0;
		END_IF;
	END_IF;
END_ACTION