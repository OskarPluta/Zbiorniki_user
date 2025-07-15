ACTION ObslugaAuto:
	IF before_MANUAL AND NOT MANUAL THEN
		krok := 0;
		timer_mieszania.IN := FALSE;
		timer_uruchomiony := FALSE;
		UstawieniaDomyslne;
	END_IF;
    
	aktywny := NOT PAUSE;
	Mieszanie := MIESZANIE;
	timer_mieszania();
    
	ResetWyjsc;
    
	CASE krok OF
		0: KrokStop;
		1: KrokNapelnianie12;
		2: KrokNapelnianie3;
		3: KrokMieszanie;
		4: KrokOprozniane;
		5: KrokWyrownywanie;
	END_CASE;
    
	IF PAUSE THEN
		ResetWyjsc;
	END_IF;
END_ACTION