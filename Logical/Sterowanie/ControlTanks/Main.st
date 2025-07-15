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
	zawor1_otwarcie := TRUE;
	zawor2_otwarcie := TRUE;
	zawor3_glowny_otwarcie := TRUE;
	zawor3_lewy_aktywny := TRUE;
	zawor3_prawy_aktywny := TRUE;
	zawor3_lewy_otwarcie := default_lewy_procent;
	zawor3_prawy_otwarcie := default_prawy_procent;
END_PROGRAM

PROGRAM _CYCLIC
	IF MANUAL THEN
		
		timer_mieszania.IN := FALSE;
		timer_uruchomiony := FALSE;
        
		// Zabezpieczenie przed przepe³nieniem zbiorników
		IF gZb1_poziom >= poziom_95_procent THEN
			gZb1_zawor := 0;
		END_IF;
        
		IF gZb2_poziom >= poziom_95_procent THEN
			gZb2_zawor := 0;
		END_IF;
        
		IF gZb3_poziom >= max_poziom THEN
			gZb3_zawor_prawy := 0;
			gZb3_zawor_lewy := 0;
		END_IF;
		
	ELSE
		// Przywrócenie domyœlnych ustawieñ po wyjœciu z trybu manualnego
		IF before_MANUAL AND NOT MANUAL THEN
			krok := 0;
			timer_mieszania.IN := FALSE;
			timer_uruchomiony := FALSE;
			zawor1_otwarcie := TRUE;
			zawor2_otwarcie := TRUE;
			zawor3_glowny_otwarcie := TRUE;
			zawor3_lewy_aktywny := TRUE;
			zawor3_prawy_aktywny := TRUE;
			zawor3_lewy_otwarcie := default_lewy_procent;
			zawor3_prawy_otwarcie := default_prawy_procent;
		END_IF;
        
		aktywny := NOT PAUSE;
		Mieszanie := MIESZANIE;
		timer_mieszania();
        
		// Domyœlne wy³¹czenie dla bezpieczeñstwa
		gZb1_zawor := 0;
		gZb2_zawor := 0;
		gZb3_zawor_glowny := 0;
		gZb3_zawor_lewy := 0;
		gZb3_zawor_prawy := 0;
		gMieszadlo := 0;
        	
		CASE krok OF
			0: // STOP
				timer_mieszania.IN := FALSE;
				timer_uruchomiony := FALSE;
				
				IF aktywny AND START AND NOT STOP THEN
					 // Sprawdzenie czy poziomy wymagaj¹ wyrównania przed startem
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
						IF zawor1_otwarcie AND gZb1_poziom < 8000 AND gZb1_poziom < poziom_95_procent THEN
							gZb1_zawor := 1;
						END_IF;
						IF zawor2_otwarcie AND gZb2_poziom < 8000 AND gZb2_poziom < poziom_95_procent THEN
							gZb2_zawor := 1;
						END_IF;
					END_IF;
                    
					gZb3_zawor_lewy := 0;
					gZb3_zawor_prawy := 0;
				END_IF;
                
			2: // NAPE£NIANIE ZBIORNIKA 3
				IF aktywny THEN	
					IF zawor3_prawy_aktywny AND zawor3_prawy_otwarcie > 0 THEN
						gZb3_zawor_prawy := zawor3_prawy_otwarcie;
					ELSE
						gZb3_zawor_prawy := 0;
					END_IF;
                    
					IF zawor3_lewy_aktywny AND zawor3_lewy_otwarcie > 0 THEN
						gZb3_zawor_lewy := zawor3_lewy_otwarcie;
					ELSE
						gZb3_zawor_lewy := 0;
					END_IF;
                    
					IF gZb3_poziom >= 8000 AND NOT Mieszanie THEN
						krok := 4;
					END_IF;
                    
					IF gZb3_poziom >= 10000 AND Mieszanie THEN
						krok := 3;
						timer_uruchomiony := FALSE;
					END_IF;
				END_IF;
                
			3: // MIESZANIE ZBIORNIKA 3
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
					// Zatrzymanie timera podczas pauzy bez resetowania
					timer_mieszania.IN := FALSE;
				END_IF;
                
			4: // OPRÓ¯NIANIE ZBIORNIKA 3
				IF aktywny THEN
					IF zawor3_glowny_otwarcie THEN
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
                
		END_CASE;
		
		IF PAUSE THEN
			gZb1_zawor := 0;
			gZb2_zawor := 0;
			gZb3_zawor_glowny := 0;
			gZb3_zawor_lewy := 0;
			gZb3_zawor_prawy := 0;
			gMieszadlo := 0;
		END_IF;
        
	END_IF;
   
	before_MANUAL := MANUAL;
   	IF STOP THEN
		krok := 0;
		timer_mieszania.IN := FALSE;
		timer_uruchomiony := FALSE;
        
		IF MANUAL THEN
			gZb1_zawor := 0;
			gZb2_zawor := 0;
			gZb3_zawor_glowny := 0;
			gZb3_zawor_lewy := 0;
			gZb3_zawor_prawy := 0;
			gMieszadlo := 0;
		END_IF;
	END_IF;
    
END_PROGRAM

PROGRAM _EXIT
	gZb1_zawor := 0;
	gZb2_zawor := 0;
	gZb3_zawor_glowny := 0;
	gZb3_zawor_lewy := 0;
	gZb3_zawor_prawy := 0;
	gMieszadlo := 0;
END_PROGRAM