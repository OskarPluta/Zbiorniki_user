ACTION KrokMieszanie:
	IF aktywny THEN
		gMieszadlo := 1;
        
		IF NOT timer_uruchomiony THEN
			timer_mieszania.IN := TRUE;
			timer_mieszania.PT := czas_mieszania;
			timer_uruchomiony := TRUE;
		END_IF;
        
		IF timer_mieszania.Q THEN
			timer_mieszania.IN := FALSE;
			timer_uruchomiony := FALSE;
			krok := 4;
		END_IF;
	ELSE
		timer_mieszania.IN := FALSE;
	END_IF;
END_ACTION