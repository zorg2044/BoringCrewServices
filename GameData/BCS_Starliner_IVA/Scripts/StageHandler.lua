function BCS_StageHandler(propId)
  
  fc.SetPersistent(propId .. "_StringReady", 0)
  fc.Stage()
  local currentStage = fc.CurrentStage()
  local audioString = "BCS_Starliner_IVA/Sounds/annunciator/Sequence" .. currentStage
  fc.SetPersistent("Global_StageString", audioString)
  fc.SetPersistent(propId .. "_StringReady", 1)

end