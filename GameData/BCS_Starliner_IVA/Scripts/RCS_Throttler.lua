function MAS_BCS_RCSThrottler(switch)

  local value1 = fc.GetPersistentAsNumber("Global_CMRCS1")
  local value2 = fc.GetPersistentAsNumber("Global_CMRCS2")

  if switch == 0 then
    if value1 == 0 then
      fc.SetPersistent("Global_CMRCS1", 1)
    else
      fc.SetPersistent("Global_CMRCS1", 0)
    end
  else
    if value2 == 0 then
      fc.SetPersistent("Global_CMRCS2", 1)
    else
      fc.SetPersistent("Global_CMRCS2", 0)
    end
  end

  local value1 = fc.GetPersistentAsNumber("Global_CMRCS1")
  local value2 = fc.GetPersistentAsNumber("Global_CMRCS2")

  if value1 == 0 and value2 == 0 then
    fc.SetRCSThrustLimit(0)
  elseif value1 == 1 and value2 == 1 then
    fc.SetRCSThrustLimit(1)
  else
    fc.SetRCSThrustLimit(0.5)
  end
end