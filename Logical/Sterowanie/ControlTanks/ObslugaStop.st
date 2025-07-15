ACTION ObslugaStop:
	IF STOP THEN
		krok := 0;
		timer_mieszania.IN := FALSE;
		timer_uruchomiony := FALSE;
        
		IF MANUAL THEN
			ResetWyjsc;
		END_IF;
	END_IF;
END_ACTION