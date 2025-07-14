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
    // Wywo³anie timera
	timer_mieszania();
    
	// Maszyna stanów
	CASE krok OF
		0: // STOP
			// Wy³¹czenie wszystkich urz¹dzeñ
			gZb1_zawor := 0;
			gZb2_zawor := 0;
			gZb3_zawor_glowny := 0;
			gZb3_zawor_lewy := 0;
			gZb3_zawor_prawy := 0;
			gMieszadlo := 0;
            
			// Sprawdzenie startu
			IF Start AND NOT stop THEN
				krok := 1;
			END_IF;
            
		1: // NAPE£NIANIE ZBIORNIKÓW 1 i 2
			// W³¹czenie zaworów zbiorników 1 i 2
			gZb1_zawor := 1;
			gZb2_zawor := 1;
            
			// Sprawdzenie poziomu
			IF gZb1_poziom >= 8000 AND gZb2_poziom >= 8000 THEN
				krok := 2;
			END_IF;
            
		2: // NAPE£NIANIE ZBIORNIKA 3
			// Wy³¹czenie zaworów zbiorników 1 i 2
			gZb1_zawor := 0;
			gZb2_zawor := 0;
            
			// W³¹czenie zaworów zbiornika 3
			gZb3_zawor_prawy := 1;
			gZb3_zawor_lewy := 1;
            
			// Sprawdzenie poziomu zbiornika 3
			IF gZb3_poziom >= 8000 THEN
				krok := 3;
			END_IF;
            
		3: // MIESZANIE ZBIORNIKA 3
			// Wy³¹czenie zaworów nape³niaj¹cych
			gZb3_zawor_prawy := 0;
			gZb3_zawor_lewy := 0;
            
			// Przechodzimy do kroku 4 jesli mieszanie 
			IF NOT Mieszanie THEN
				krok := 4;	
			END_IF;
			
			// W³¹czenie mieszad³a
			gMieszadlo := 1;
            
			// Uruchomienie timera
			timer_mieszania.IN := TRUE;
			timer_mieszania.PT := czas_mieszania;
            
			// Sprawdzenie koñca mieszania
			IF timer_mieszania.Q THEN
				timer_mieszania.IN := FALSE;
				krok := 4;
			END_IF;
            
		4: // OPRÓ¯NIANIE ZBIORNIKA 3
			// Wy³¹czenie mieszad³a
			gMieszadlo := 0;
            
			// W³¹czenie zaworu g³ównego (wywlewnego)
			gZb3_zawor_glowny := 1;
            
			// Sprawdzenie opró¿nienia (za³o¿enie: poziom = 0)
			IF gZb3_poziom = 0 THEN
				gZb3_zawor_glowny := 0;
				krok := 0; // Powrót do nape³niania
			END_IF;
            
	END_CASE;
    
	// Sprawdzenie stopu - zatrzymanie w dowolnym momencie
	IF stop THEN
		krok := 0;
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