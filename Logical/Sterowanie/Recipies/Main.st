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
		
		aktywny := NOT PAUSE;
	
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
				// Brak akcji wyjœciowych (ju¿ domyœlnie wy³¹czone)
            
				// Przejœcie tylko jeœli aktywny
				IF aktywny AND START AND NOT STOP THEN
					krok := 1;
				END_IF;
            
			1: // NAPE£NIANIE ZBIORNIKÓW 1 i 2
				IF aktywny THEN
					// Akcje wyjœciowe
					gZb1_zawor := 1;
					gZb2_zawor := 1;
                
					// Przejœcie do nastêpnego stanu
					IF gZb1_poziom >= 8000 AND gZb2_poziom >= 8000 THEN
						krok := 2;
					END_IF;
				END_IF;
            
			2: // NAPE£NIANIE ZBIORNIKA 3
				IF aktywny THEN
					// Akcje wyjœciowe
					gZb3_zawor_prawy := 1;
					gZb3_zawor_lewy := 1;
                
					// Przejœcie do nastêpnego stanu
					IF gZb3_poziom >= 8000 THEN
						krok := 3;
					END_IF;
				END_IF;
            
			3: // MIESZANIE ZBIORNIKA 3
				IF aktywny THEN
					// Akcje wyjœciowe
					gMieszadlo := 1;
                
					// Logika mieszania
					IF NOT Mieszanie THEN
						krok := 4;    
					ELSE
						// Uruchomienie i wywo³anie timera tylko jeœli aktywny
						timer_mieszania.IN := TRUE;
						timer_mieszania.PT := czas_mieszania;
						timer_mieszania();  // Wywo³anie timera tutaj, aby wstrzymaæ podczas pauzy
                    
						// Przejœcie po zakoñczeniu
						IF timer_mieszania.Q THEN
							timer_mieszania.IN := FALSE;
							krok := 4;
						END_IF;
					END_IF;
				ELSE
					// Podczas pauzy: Wy³¹cz timer (IN na FALSE, aby nie liczy³ po wznowieniu)
					timer_mieszania.IN := FALSE;
				END_IF;
            
			4: // OPRÓ¯NIANIE ZBIORNIKA 3
				IF aktywny THEN
					// Akcje wyjœciowe
					gZb3_zawor_glowny := 1;
                
					// Przejœcie do nastêpnego stanu (poprawione: powrót do 0, jak w oryginale; jeœli ma byæ do 1, zmieñ)
					IF gZb3_poziom = 0 THEN
						krok := 0;  // Powrót do STOP
					END_IF;
				END_IF;
            
		END_CASE;
    
		// Globalne sprawdzenie STOP - dzia³a zawsze, nawet podczas pauzy
		IF STOP THEN
			krok := 0;
			timer_mieszania.IN := FALSE;  // Bezpieczne wy³¹czenie timera
		END_IF;
    
		// Jeœli pauza, nadpisz wszystkie wyjœcia na 0 (dla bezpieczeñstwa, choæ ju¿ s¹ domyœlnie)
		IF PAUSE THEN
			gZb1_zawor := 0;
			gZb2_zawor := 0;
			gZb3_zawor_glowny := 0;
			gZb3_zawor_lewy := 0;
			gZb3_zawor_prawy := 0;
			gMieszadlo := 0;
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