
PROGRAM _INIT
END_PROGRAM

PROGRAM _CYCLIC
	CASE ClockStatus OF
		0:
			TON_1.IN:=TRUE;
			Clock:=TRUE;
			IF TON_1.Q THEN
				ClockStatus:=1;
				TON_1.IN:=FALSE;
			END_IF
		1:
			Clock:=FALSE;
			TON_1.IN:=TRUE;
			IF TON_1.Q THEN
				TON_1.IN:=FALSE;
				ClockStatus:=0;
			END_IF;
	END_CASE
		
	CASE MixerStatus OF
		0:
			TON_0.IN:=TRUE;
			Mixer:=TRUE;
			IF TON_0.Q THEN
				MixerStatus:=1;
				TON_0.IN:=FALSE;
			END_IF
		1:
			Mixer:=FALSE;
			TON_0.IN:=TRUE;
			IF TON_0.Q THEN
				TON_0.IN:=FALSE;
				MixerStatus:=0;
			END_IF;
	END_CASE
	
	TON_1(PT:=T#150ms);
	TON_0 (PT:=T#500ms);
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

