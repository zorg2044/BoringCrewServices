function BCS_SwitchAutopilot(propId)

  local string = propId .. "_Toggle"
  fc.SetPersistent(string, 1)
  mechjeb.Reset()
  fc.SetSAS(false)
  fc.TogglePersistent("Global_OrdCntl_Toggle")

end