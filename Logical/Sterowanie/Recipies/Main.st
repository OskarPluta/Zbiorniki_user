PROGRAM _INIT
    // Inicjalizacja poziomów zbiorników
	gZb1_poziom := 0;
	gZb1_zawor := 0;
	gZb2_poziom := 0;
	gZb2_zawor := 0;
    
	gZb3_poziom := 0;
	gZb3_zawor_glowny := 0;
	gZb3_zawor_lewy := 0;
	gZb3_zawor_prawy := 0;
    
	gMieszadlo := 0;
	
	Mieszanie:= 0;
    
	// Inicjalizacja stanu
	krok := 0;
	timer_mieszania.IN := FALSE;
END_PROGRAM

PROGRAM _CYCLIC
    // Sprawdzenie trybu manualnego
	IF MANUAL THEN
		// W trybie manualnym nie nadpisujemy wyjœæ automatyk¹
		// Wy³¹czenie timera w trybie manualnym
		timer_mieszania.IN := FALSE;
		timer_uruchomiony := FALSE;
        
		// ZABEZPIECZENIE: Automatyczne wy³¹czenie zaworów przy 95% poziomu
		IF gZb1_poziom >= poziom_95_procent THEN
			gZb1_zawor := 0;
		END_IF;
        
		IF gZb2_poziom >= poziom_95_procent THEN
			gZb2_zawor := 0;
		END_IF;
        
	ELSE
		// Tryb automatyczny - sprawdzenie czy wyszliœmy z trybu manualnego
		IF before_MANUAL AND NOT MANUAL THEN
			krok := 0;
			timer_mieszania.IN := FALSE;
			timer_uruchomiony := FALSE;
		END_IF;
        
		aktywny := NOT PAUSE;
		Mieszanie := MIESZANIE;
        
		// Wywo³anie timera zawsze (poza trybem manualnym)
		timer_mieszania();
        
		// Domyœlne ustawienie wyjœæ na 0 (bezpieczne)
		gZb1_zawor := 0;
		gZb2_zawor := 0;
		gZb3_zawor_glowny := 0;
		gZb3_zawor_lewy := 0;
		gZb3_zawor_prawy := 0;
		gMieszadlo := 0;
        
		// Maszyna stanów - zawsze wykonywana, ale akcje warunkowane przez 'aktywny'
		CASE krok OF
			0: // STOP
				// Reset timera przy wejœciu do STOP
				timer_mieszania.IN := FALSE;
				timer_uruchomiony := FALSE;
                
				// Przejœcie do wyrównywania poziomów po START (jeœli potrzebne)
				IF aktywny AND START AND NOT STOP THEN
					IF ABS(gZb1_poziom - gZb2_poziom) > tolerancja_poziom THEN
						krok := 5;
					ELSE
						IF gZb1_poziom >= 8000 AND gZb2_poziom >= 8000 THEN
							krok := 2;
						ELSE
							krok := 1;
						END_IF;
					END_IF;
				END_IF;
                
			1: // NAPE£NIANIE ZBIORNIKÓW 1 i 2
				IF aktywny THEN
					IF gZb1_poziom >= 8000 AND gZb2_poziom >= 8000 THEN
						krok := 2;
					ELSE
						IF zawor1_otwarcie > 0 AND gZb1_poziom < 8000 AND gZb1_poziom < poziom_95_procent THEN
							gZb1_zawor := 1;
						END_IF;
						IF zawor2_otwarcie > 0 AND gZb2_poziom < 8000 AND gZb2_poziom < poziom_95_procent THEN
							gZb2_zawor := 1;
						END_IF;
					END_IF;
                    
					gZb3_zawor_lewy := 0;
					gZb3_zawor_prawy := 0;
				END_IF;
                
			2: // NAPE£NIANIE ZBIORNIKA 3
				IF aktywny THEN
					gZb3_zawor_prawy := zawor3_prawy_otwarcie;
					gZb3_zawor_lewy := zawor3_lewy_otwarcie;
                    
					IF gZb3_poziom >= 8000 AND NOT Mieszanie THEN
						krok := 4;
					END_IF;
                    
					IF gZb3_poziom >= 10000 AND Mieszanie THEN
						krok := 3;
						// Reset flagi timera przy wejœciu do kroku mieszania
						timer_uruchomiony := FALSE;
					END_IF;
				END_IF;
                
			3: // MIESZANIE ZBIORNIKA 3
				IF aktywny THEN
					// W³¹czenie mieszad³a
					gMieszadlo := 1;
                    
					// Uruchomienie timera tylko raz przy wejœciu do kroku
					IF NOT timer_uruchomiony THEN
						timer_mieszania.IN := TRUE;
						timer_mieszania.PT := czas_mieszania;
						timer_uruchomiony := TRUE;
					END_IF;
                    
					// Sprawdzenie koñca mieszania
					IF timer_mieszania.Q THEN
						timer_mieszania.IN := FALSE;
						timer_uruchomiony := FALSE;
						krok := 4;
					END_IF;
                    
				ELSE
					// Podczas pauzy: Wy³¹cz timer ale zachowaj jego stan
					timer_mieszania.IN := FALSE;
				END_IF;
                
			4: // OPRÓ¯NIANIE ZBIORNIKA 3
				IF aktywny THEN
					IF zawor3_glowny_otwarcie > 0 THEN
						gZb3_zawor_glowny := 1;
					END_IF;
                    
					IF gZb3_poziom = 0 THEN
						krok := 0;
					END_IF;
				END_IF;
                
			5: // WYRÓWNYWANIE POZIOMÓW ZBIORNIKÓW 1 i 2
				IF aktywny THEN
					IF gZb1_poziom > gZb2_poziom + tolerancja_poziom THEN
						gZb1_zawor := 0;
						IF zawor2_otwarcie > 0 AND gZb2_poziom < poziom_95_procent THEN
							gZb2_zawor := 1;
						END_IF;
					ELSIF gZb2_poziom > gZb1_poziom + tolerancja_poziom THEN
						gZb2_zawor := 0;
						IF zawor1_otwarcie > 0 AND gZb1_poziom < poziom_95_procent THEN
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
                
		END_CASE;
        
		// Jeœli pauza, nadpisz wszystkie wyjœcia na 0 (dla bezpieczeñstwa)
		IF PAUSE THEN
			gZb1_zawor := 0;
			gZb2_zawor := 0;
			gZb3_zawor_glowny := 0;
			gZb3_zawor_lewy := 0;
			gZb3_zawor_prawy := 0;
			gMieszadlo := 0;
			// Timer pozostaje w stanie pauzy (nie resetujemy go)
		END_IF;
        
	END_IF;
    
	// Zapamiêtanie stanu MANUAL dla wykrycia przejœcia
	before_MANUAL := MANUAL;
    
	// Globalne sprawdzenie STOP - dzia³a zawsze, nawet w trybie manualnym
	IF STOP THEN
		krok := 0;
		timer_mieszania.IN := FALSE;
		timer_uruchomiony := FALSE;
        
		IF MANUAL THEN
			gZb_zawor := 0;
			gZb2_zawor := 0;
			gZb3_zawor_glowny := 0;
			gZb3_zawor_lewy := 0;
			gZb3_zawor_prawy := 0;
			gMieszadlo := 0;
		END_IF;
	END_IF;
    
END_PROGRAM



PROGRAM _EXIT
    // Bezpieczne wy³¹czenie wszystkich urz¹dzeñ
	gZb1_zawor := 0;
	gZb2_zawor := 0;
	gZb3_zawor_glowny := 0;
	gZb3_zawor_lewy := 0;
	gZb3_zawor_prawy := 0;
	gMieszadlo := 0;
END_PROGRAM