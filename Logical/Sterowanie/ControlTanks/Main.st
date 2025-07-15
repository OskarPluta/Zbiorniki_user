PROGRAM _INIT
	gZb1_poziom := 0;
	gZb1_zawor := 0;
	gZb2_poziom := 0;
	gZb2_zawor := 0;
	gZb3_poziom := 0;
	gZb3_zawor_glowny := 0;
	gZb3_zawor_lewy := 0;
	gZb3_zawor_prawy := 0;
	gMieszadlo := 0;
	Mieszanie := 0;
	krok := 0;
	timer_mieszania.IN := FALSE;
	timer_uruchomiony := FALSE;
	before_MANUAL := FALSE;
    
	UstawieniaDomyslne;
END_PROGRAM

PROGRAM _CYCLIC
	IF MANUAL THEN
		ObslugaManual;
	ELSE
		ObslugaAuto;
	END_IF;
    
	before_MANUAL := MANUAL;
	ObslugaStop;
END_PROGRAM

PROGRAM _EXIT
	ResetWyjsc;
END_PROGRAM