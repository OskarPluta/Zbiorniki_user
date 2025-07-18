ACTION KrokStop:
	timer_mieszania.IN := FALSE;
	timer_uruchomiony := FALSE;
    
	IF aktywny AND START AND NOT STOP THEN
		IF ABS(gZb1_poziom - gZb2_poziom) > tolerancja_poziom THEN
			krok := 5;
		ELSE
			IF gZb1_poziom >= poziom_80_procent AND gZb2_poziom >= poziom_80_procent THEN
				krok := 2;
			ELSE
				krok := 1;
			END_IF;
		END_IF;
	END_IF;
END_ACTION