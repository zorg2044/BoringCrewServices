function BCS_ResourceMonitorHandler(mode)
  
  local value = fc.GetPersistentAsNumber("Global_MFDLLSelectedResourceBox")
  local amount
  
  if mode == 0 then
    amount = 1
  elseif mode == 1 then
    amount = -1
  end

  if value == 0 then
    fc.AddPersistentWrapped("Global_MFDLLSelectedLeftResource", amount, 0, fc.ResourceCount())
  elseif value == 1 then
    fc.AddPersistentWrapped("Global_MFDLLSelectedMiddleResource", amount, 0, fc.ResourceCount())
  elseif value == 2 then
    fc.AddPersistentWrapped("Global_MFDLLSelectedRightResource", amount, 0, fc.ResourceCount())
  elseif value == 3 then
    fc.AddPersistentWrapped("Global_MFDLLSelectedExtraResource", amount, 0, fc.ResourceCount())
  end
end