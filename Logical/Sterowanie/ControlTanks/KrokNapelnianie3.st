ACTION KrokNapelnianie3:
	IF aktywny THEN
		UstawZaworyZbiornika3;
        
		IF gZb3_poziom >= 8000 AND NOT Mieszanie THEN
			krok := 4;
		END_IF;
        
		IF gZb3_poziom >= 10000 AND Mieszanie THEN
			krok := 3;
			timer_uruchomiony := FALSE;
		END_IF;
	END_IF;
END_ACTION