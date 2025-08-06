function BCS_KACCheckAlarm()

  local value = tostring(fc.GetPersistent("Global_KACSelectedAlarm"))
  local string = value .. "_Global_Alarm"
  local alarmId = fc.GetPersistent(string)
  local checkAlarm = kac.AlarmExists(alarmId)
  
  if checkAlarm == 1 then
    return 1
  end
  return 0
end

function BCS_KACDeleteAlarm()

  local value = tostring(fc.GetPersistent("Global_KACSelectedAlarm"))
  local string = value .. "_Global_Alarm"
  local alarmId = fc.GetPersistent(string)
  local checkAlarm = kac.AlarmExists(alarmId)
  
  if checkAlarm == 1 then
    kac.DeleteAlarm(alarmId)
  end
end

function BCS_KACAddAlarm()

  local seconds = fc.GetPersistentAsNumber("Global_KACSeconds")
  local minutes = fc.GetPersistentAsNumber("Global_KACMinutes") * 60
  local hours = fc.GetPersistentAsNumber("Global_KACHours") * 3600
  local days = fc.GetPersistentAsNumber("Global_KACDays") * 21600
  local clockToSeconds = seconds + minutes + hours + days

  if kac.AlarmExists(fc.GetPersistent("0_Global_Alarm")) == 0 then
    fc.SetPersistent("0_Global_Alarm", kac.CreateAlarm("0_Alarm", fc.UT() + clockToSeconds))
    return 1
  elseif kac.AlarmExists(fc.GetPersistent("1_Global_Alarm")) == 0 then
    fc.SetPersistent("1_Global_Alarm", kac.CreateAlarm("1_Alarm", fc.UT() + clockToSeconds))
    return 1
  elseif kac.AlarmExists(fc.GetPersistent("2_Global_Alarm")) == 0 then
    fc.SetPersistent("2_Global_Alarm", kac.CreateAlarm("2_Alarm", fc.UT() + clockToSeconds))
    return 1
  elseif kac.AlarmExists(fc.GetPersistent("3_Global_Alarm")) == 0 then
    fc.SetPersistent("3_Global_Alarm", kac.CreateAlarm("3_Alarm", fc.UT() + clockToSeconds))
    return 1
  elseif kac.AlarmExists(fc.GetPersistent("4_Global_Alarm")) == 0 then
    fc.SetPersistent("4_Global_Alarm", kac.CreateAlarm("4_Alarm", fc.UT() + clockToSeconds))
    return 1
  elseif kac.AlarmExists(fc.GetPersistent("5_Global_Alarm")) == 0 then
    fc.SetPersistent("5_Global_Alarm", kac.CreateAlarm("5_Alarm", fc.UT() + clockToSeconds))
    return 1
  elseif kac.AlarmExists(fc.GetPersistent("6_Global_Alarm")) == 0 then
    fc.SetPersistent("6_Global_Alarm", kac.CreateAlarm("6_Alarm", fc.UT() + clockToSeconds))
    return 1
  elseif kac.AlarmExists(fc.GetPersistent("7_Global_Alarm")) == 0 then
    fc.SetPersistent("7_Global_Alarm", kac.CreateAlarm("7_Alarm", fc.UT() + clockToSeconds))
    return 1
  elseif kac.AlarmExists(fc.GetPersistent("8_Global_Alarm")) == 0 then
    fc.SetPersistent("8_Global_Alarm", kac.CreateAlarm("8_Alarm", fc.UT() + clockToSeconds))
    return 1
  elseif kac.AlarmExists(fc.GetPersistent("9_Global_Alarm")) == 0 then
    fc.SetPersistent("9_Global_Alarm", kac.CreateAlarm("9_Alarm", fc.UT() + clockToSeconds))
    return 1
  end
  return 0
end