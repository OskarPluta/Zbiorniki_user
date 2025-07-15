
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
	
	IF gZb1_poziom > ALARM_TANK_CRITICAL OR gZb2_poziom > ALARM_TANK_CRITICAL THEN
		MpAlarmXSet(MpLinkTankAlarmXCore, 'TankLevelCritical');
	ELSE
		MpAlarmXReset(MpLinkTankAlarmXCore, 'TankLevelCritical');
	END_IF

	IF gZb1_poziom < ALARM_TANK_LOW OR gZb2_poziom > ALARM_TANK_LOW THEN
		MpAlarmXSet(MpLinkTankAlarmXCore, 'TankLevelLow');
	ELSE
		MpAlarmXReset(MpLinkTankAlarmXCore, 'TankLevelLow');
	END_IF

	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	MpAlarmXCore_0(Enable := FALSE);
END_PROGRAM

