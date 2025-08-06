function BCS_NarwhalCounter(propId)

  local string1 = "Global_StartNarwhalAnimation"
  local string2 = propId .. "_Mode"
  local value = fc.GetPersistentAsNumber(string2)
  
  if value == 0 then
    fc.SetPersistent(string1, 1)
  elseif value == 1 then
    fc.SetPersistent(string1, 2)
  end

  fc.AddPersistentWrapped(string2, 1, 0, 2)

end
