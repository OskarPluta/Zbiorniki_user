
PROGRAM _INIT
	(* Insert code here *)
	 MpAlarmXCore_0(MpLink := ADR(MpLinkTankAlarmXCore) , Enable := TRUE);
END_PROGRAM

PROGRAM _CYCLIC
	MpAlarmXCore_0(MpLink := ADR(MpLinkTankAlarmXCore) , Enable := TRUE);
	IF gZb1_poziom > ALARM_TANK_HIGH OR gZb2_poziom > ALARM_TANK_HIGH THEN
		MpAlarmXSet(MpLinkTankAlarmXCore, 'TankLevelHigh');
	ELSE
		MpAlarmXReset(MpLinkTankAlarmXCore, 'TankLevelHigh');
	END_IF
	
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	MpAlarmXCore_0(Enable := FALSE);
END_PROGRAM

