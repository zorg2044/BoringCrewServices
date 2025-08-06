function BCS_KeyPadHandler(keypad, softkey)

  local powerCheck = fc.GetPersistentAsNumber("Global_SMC1_State")

  if powerCheck == 0 then
    return
  end

  if keypad == 0 then

    local checkPowerL = fc.GetPersistentAsNumber("Global_Kypd1")

    if checkPowerL == 0 then
      return 0
    end

    local valueL = fc.GetPersistentAsNumber("Global_KeypadLeftSelection")

    if valueL == 0 then
      fc.SendSoftkey("MFD_UL", softkey)
    elseif valueL == 1 then
      fc.SendSoftkey("MFD_UR", softkey)
    elseif valueL == 2 then
      fc.SendSoftkey("MFD_LL", softkey)
    elseif valueL == 3 then
      fc.SendSoftkey("MFD_LR", softkey)
    end

  elseif keypad == 1 then

    local checkPowerR = fc.GetPersistentAsNumber("Global_Kypd2")

    if checkPowerR == 0 then
      return
    end

    local valueR = fc.GetPersistentAsNumber("Global_KeypadRightSelection")

    if valueR == 0 then
      fc.SendSoftkey("MFD_UL", softkey)
    elseif valueR == 1 then
      fc.SendSoftkey("MFD_UR", softkey)
    elseif valueR == 2 then
      fc.SendSoftkey("MFD_LL", softkey)
    elseif valueR == 3 then
      fc.SendSoftkey("MFD_LR", softkey)
    end
  end
  return 1
end

function BCS_NumericalHandler(char)

  local powerCheck = fc.GetPersistentAsNumber("Global_SMC1_State")

  if powerCheck == 0 then
    return
  end

  if char == 10 then
    fc.AppendPersistent("Global_AscentScratchPad", ".", 38)
  elseif char == 11 then
    fc.SetPersistent("Global_AscentScratchPad", -1 * fc.GetPersistentAsNumber("Global_AscentScratchPad"))
  elseif char == 12 then
    local string = tostring(fc.GetPersistent("Global_AscentScratchPad"))
    if string:len() > 0 then
      string = string:sub(1, -2)
      fc.SetPersistent("Global_AscentScratchPad", string)
    end
  else
    fc.AppendPersistent("Global_AscentScratchPad", char, 38)
  end
end

function BCS_ActionHandler()

  local powerCheck = fc.GetPersistentAsNumber("Global_SMC1_State")

  if powerCheck == 0 then
    return
  end

  local value = fc.GetPersistentAsNumber("Global_MFDLLSelectedAscentAction")

  if value == 0 then
    mechjeb.SetDesiredLaunchAltitude(fc.GetPersistentAsNumber("Global_AscentScratchPad"))
  elseif value == 1 then
    local inc = fc.GetPersistentAsNumber("Global_AscentScratchPad")

    if inc >= 0 and inc <= 360 then
      mechjeb.SetDesiredLaunchInclination(inc)
    end
  elseif value == 2 then
    local roll = fc.GetPersistentAsNumber("Global_AscentScratchPad")

    if roll >= 0 and roll <= 360 then
      mechjeb.SetTurnRoll(roll)
    end
  elseif value == 3 then
    mechjeb.ToggleForceRoll()
  elseif value == 4 then
    mechjeb.ToggleAscentAutopilot()
  end
end

function BCS_PlannerActionHandler()

  local powerCheck = fc.GetPersistentAsNumber("Global_SMC1_State")

  if powerCheck == 0 then
    return
  end

  local value1 = fc.GetPersistentAsNumber("Global_MFDLLSelectedPlannerAction")
  local value2 = fc.GetPersistentAsNumber("Global_MFDLLSelectedPositionAction")
  local modeCheck = fc.GetPersistentAsNumber("Global_MFDLLPlannerPageMode")

  if modeCheck == 0 then

    if value1 == 0 then
      mechjeb.ChangePeriapsis(fc.Apoapsis()-1)
    elseif value1 == 1 then
      mechjeb.ChangeApoapsis(fc.Periapsis()+1)
    elseif value1 == 2 then
      BCS_HandleTimeString()
    elseif value1 == 3 then
      fc.AddManeuverNode(fc.ManeuverNodeDVPrograde(), fc.ManeuverNodeDVNormal(), fc.ManeuverNodeDVRadial(), fc.UT() + (-1 * fc.SafeDivide(fc.ManeuverNodeTime(), 2)))
    elseif value1 == 4 then
      fc.SetPersistent("Global_MFDLLPlannerPageMode", 1)
    elseif value1 == 5 then
      mechjeb.PlotTransfer()
    elseif value1 == 6 then
      fc.AddManeuverNode(fc.ManeuverNodeDVPrograde() + fc.GetPersistentAsNumber("Global_AscentScratchPad"), fc.ManeuverNodeDVNormal(), fc.ManeuverNodeDVRadial(), fc.UT() + (-1 * fc.ManeuverNodeTime()))
    elseif value1 == 7 then
      fc.AddManeuverNode(fc.ManeuverNodeDVPrograde(), fc.ManeuverNodeDVNormal(), fc.ManeuverNodeDVRadial() + fc.GetPersistentAsNumber("Global_AscentScratchPad"), fc.UT() + (-1 * fc.ManeuverNodeTime()))
    elseif value1 == 8 then
      fc.AddManeuverNode(fc.ManeuverNodeDVPrograde(), fc.ManeuverNodeDVNormal() + fc.GetPersistentAsNumber("Global_AscentScratchPad"), fc.ManeuverNodeDVRadial(), fc.UT() + (-1 * fc.ManeuverNodeTime()))
    elseif value1 == 9 then
      fc.AddManeuverNode(0, 0, 0, fc.UT() + fc.ManeuverNodeTime())
    elseif value1 == 10 then
      fc.WarpTo(fc.UT() + fc.Abs(fc.ManeuverNodeTime()) - 60)
    elseif value1 == 11 then
      fc.AddPersistentWrapped("Global_MFDLLSelectedCelestialIndex", 1, 0, fc.BodyCount())
    elseif value1 == 12 then
      fc.AddPersistentWrapped("Global_MFDLLSelectedVesselIndex", 1, 0, fc.TargetVesselCount())
    elseif value1 == 13 then
      fc.AddPersistentWrapped("Global_MFDLLSelectedWaypointIndex", 1, 0, nav.WaypointCount())
    end

  elseif modeCheck == 1 then

    if value2 == 0 then
      fc.AddManeuverNode(fc.ManeuverNodeDVPrograde(), fc.ManeuverNodeDVNormal(), fc.ManeuverNodeDVRadial(), fc.UT() + fc.TimeToAp())
    elseif value2 == 1 then
      fc.AddManeuverNode(fc.ManeuverNodeDVPrograde(), fc.ManeuverNodeDVNormal(), fc.ManeuverNodeDVRadial(), fc.UT() + fc.TimeToPe())
    elseif value2 == 2 then
      fc.AddManeuverNode(fc.ManeuverNodeDVPrograde(), fc.ManeuverNodeDVNormal(), fc.ManeuverNodeDVRadial(), fc.UT() + fc.TimeToANEq())
    elseif value2 == 3 then
      fc.AddManeuverNode(fc.ManeuverNodeDVPrograde(), fc.ManeuverNodeDVNormal(), fc.ManeuverNodeDVRadial(), fc.UT() + fc.TimeToDNEq())
    elseif value2 == 4 then
      fc.AddManeuverNode(fc.ManeuverNodeDVPrograde(), fc.ManeuverNodeDVNormal(), fc.ManeuverNodeDVRadial(), fc.UT() + fc.TimeToANTarget())
    elseif value2 == 5 then
      fc.AddManeuverNode(fc.ManeuverNodeDVPrograde(), fc.ManeuverNodeDVNormal(), fc.ManeuverNodeDVRadial(), fc.UT() + fc.TimeToDNTarget())
    elseif value2 == 6 then
      fc.AddManeuverNode(fc.ManeuverNodeDVPrograde(), fc.ManeuverNodeDVNormal(), fc.ManeuverNodeDVRadial(), fc.UT() + transfer.TimeUntilPhaseAngle())
    elseif value2 == 7 then
      fc.AddManeuverNode(fc.ManeuverNodeDVPrograde(), fc.ManeuverNodeDVNormal(), fc.ManeuverNodeDVRadial(), fc.UT() + transfer.TimeUntilEjection())
    end
  end
end

function BCS_PlannerAckHandler()

  local value = fc.GetPersistentAsNumber("Global_MFDLLSelectedPlannerAction")
  local modeCheck = fc.GetPersistentAsNumber("Global_MFDLLPlannerPageMode")

  if modeCheck == 0 then
    if value == 11 then
      fc.SetBodyTarget(fc.GetPersistentAsNumber("Global_MFDLLSelectedCelestialIndex"))
    elseif value == 12 then
      fc.SetTargetVessel(fc.GetPersistentAsNumber("Global_MFDLLSelectedVesselIndex"))
    elseif value == 13 then
      nav.SetWaypoint(fc.GetPersistentAsNumber("Global_MFDLLSelectedWaypointIndex"))
    end
  end
end

function BCS_PlannerCancelHandler()

  local powerCheck = fc.GetPersistentAsNumber("Global_SMC1_State")

  if powerCheck == 0 then
    return
  end

  local modeCheck = fc.GetPersistentAsNumber("Global_MFDLLPlannerPageMode")
  local actionCheck = fc.GetPersistentAsNumber("Global_MFDLLSelectedPlannerAction")

  if modeCheck == 0 and actionCheck == 11 then
    fc.AddPersistentWrapped("Global_MFDLLSelectedCelestialIndex", -1, 0, fc.BodyCount())
  elseif modeCheck == 0 and actionCheck == 12 then
    fc.AddPersistentWrapped("Global_MFDLLSelectedVesselIndex", -1, 0, fc.TargetVesselCount())
  elseif modeCheck == 0 and actionCheck == 13 then
    fc.AddPersistentWrapped("Global_MFDLLSelectedWaypointIndex", -1, 0, nav.WaypointCount())
  elseif modeCheck == 1 then
    fc.SetPersistent("Global_MFDLLPlannerPageMode", 0)
  end
end

function BCS_PlannerArrowHandler(key)

  local powerCheck = fc.GetPersistentAsNumber("Global_SMC1_State")

  if powerCheck == 0 then
    return
  end

  local modeCheck = fc.GetPersistentAsNumber("Global_MFDLLPlannerPageMode")

  if modeCheck == 0 then

    if key == 0 then
      fc.AddPersistentWrapped("Global_MFDLLSelectedPlannerAction", 1, 0, 14)
    elseif key == 1 then
      fc.AddPersistentWrapped("Global_MFDLLSelectedPlannerAction", -1, 0, 14)
    end

  elseif modeCheck == 1 then

    if key == 0 then
      fc.AddPersistentWrapped("Global_MFDLLSelectedPositionAction", 1, 0, 8)
    elseif key == 1 then
      fc.AddPersistentWrapped("Global_MFDLLSelectedPositionAction", -1, 0, 8)
    end
  end
end

function BCS_DockingActionHandler()

  local powerCheck = fc.GetPersistentAsNumber("Global_SMC1_State")

  if powerCheck == 0 then
    return
  end

  local actionValue = fc.GetPersistentAsNumber("Global_MFDULSelectedDockingAction")

  if actionValue == 1 then
    fc.SetPodToReference()
  elseif actionValue == 2 then
    fc.SetDockToReference()
  elseif actionValue == 3 then
    fc.AddPersistentClamped("Global_DockCamGain", 0.1, 0.1, 3)
  elseif actionValue == 4 then
    fc.AddPersistentClamped("Global_DockCamGain", -0.1, 0.1, 3)
  elseif actionValue == 5 then
    local checkState = mechjeb.GetSASSModeActive(15)
    if checkState ~= 1 then
      mechjeb.SetSASSMode(15)
      mechjeb.ToggleForceRoll()
    else
      mechjeb.Reset()
    end
  elseif actionValue == 6 then
    fc.TogglePersistent("Global_MFDULInvertCrosshair")
  elseif actionValue == 7 then
    mechjeb.ToggleRendezvousAutopilot()
  elseif actionValue == 8 then
    mechjeb.ToggleDockingAutopilot()
  end
end

function BCS_ScienceActionHandler()

  local powerCheck = fc.GetPersistentAsNumber("Global_SMC1_State")

  if powerCheck == 0 then
    return
  end

  local actionCheck = fc.GetPersistentAsNumber("Global_MFDLLSelectedScienceAction")

  if actionCheck == 0 then
    fc.AddPersistentWrapped("Global_MFDLLSelectedScienceTypeIdIndex", 1, 0, fc.ScienceTypeTotal())
    fc.SetPersistent("Global_MFDLLSelectedExperimentIndex", 0)
  elseif actionCheck == 1 then
    fc.AddPersistentWrapped("Global_MFDLLSelectedExperimentIndex", 1, 0, fc.ExperimentCount(fc.GetPersistentAsNumber("Global_MFDLLSelectedScienceTypeIdIndex")))
  elseif actionCheck == 2 then
    fc.RunExperiment(fc.ExperimentId(fc.GetPersistentAsNumber("Global_MFDLLSelectedScienceTypeIdIndex"), fc.GetPersistentAsNumber("Global_MFDLLSelectedExperimentIndex")))
  elseif actionCheck == 3 then
    fc.ResetExperiment(fc.ExperimentId(fc.GetPersistentAsNumber("Global_MFDLLSelectedScienceTypeIdIndex"), fc.GetPersistentAsNumber("Global_MFDLLSelectedExperimentIndex")))
  elseif actionCheck == 4 then
    fc.CollectExperiments(fc.GetPersistentAsNumber("Global_MFDLLSelectedContainerIndex"))
  elseif actionCheck == 5 then
    fc.TransmitExperiment(fc.GetPersistentAsNumber("Global_MFDLLSelectedTransmitterIndex"), fc.ExperimentId(fc.GetPersistentAsNumber("Global_MFDLLSelectedScienceTypeIdIndex"), fc.GetPersistentAsNumber("Global_MFDLLSelectedExperimentIndex")))
  elseif actionCheck == 6 then
    fc.AddPersistentWrapped("Global_MFDLLSelectedContainerIndex", 1, 0, fc.ScienceContainerCount())
  elseif actionCheck == 7 then
    fc.DumpScienceContainer(fc.GetPersistentAsNumber("Global_MFDLLSelectedContainerIndex"))
  elseif actionCheck == 8 then
    fc.TransmitScienceContainer(fc.GetPersistentAsNumber("Global_MFDLLSelectedTransmitterIndex"), fc.GetPersistentAsNumber("Global_MFDLLSelectedContainerIndex"))
  elseif actionCheck == 9 then
    fc.AddPersistentWrapped("Global_MFDLLSelectedTransmitterIndex", 1, 0, fc.DataTransmitterCount())
  end
end

function BCS_ScienceClearHandler()

  local powerCheck = fc.GetPersistentAsNumber("Global_SMC1_State")

  if powerCheck == 0 then
    return
  end

  local actionCheck = fc.GetPersistentAsNumber("Global_MFDLLSelectedScienceAction")

  if actionCheck == 0 then
    fc.AddPersistentWrapped("Global_MFDLLSelectedScienceTypeIdIndex", -1, 0, fc.ScienceTypeTotal())
    fc.SetPersistent("Global_MFDLLSelectedExperimentIndex", 0)
  elseif actionCheck == 1 then
    fc.AddPersistentWrapped("Global_MFDLLSelectedExperimentIndex", -1, 0, fc.ExperimentCount(fc.GetPersistentAsNumber("Global_MFDLLSelectedScienceTypeIdIndex")))
  elseif actionCheck == 6 then
    fc.AddPersistentWrapped("Global_MFDLLSelectedContainerIndex", -1, 0, fc.ScienceContainerCount())
  elseif actionCheck == 9 then
    fc.AddPersistentWrapped("Global_MFDLLSelectedTransmitterIndex", -1, 0, fc.DataTransmitterCount())
  end
end

function BCS_CamerasActionHandler()

  local powerCheck = fc.GetPersistentAsNumber("Global_SMC1_State")

  if powerCheck == 0 then
    return
  end

  local actionCheck = fc.GetPersistentAsNumber("Global_MFDULSelectedCameraOption")

  if actionCheck == 0 then
    fc.AddPersistentWrapped("Global_MFDULSelectedCamera", 1, 0, fc.CameraCount())
  elseif actionCheck == 1 then
    fc.SetPersistent("Global_MFDULCameraGain", fc.Clamp(fc.GetPersistentAsNumber("Global_AscentScratchPad"), 0, 3))
  elseif actionCheck == 2 then
    fc.SetFoV(fc.GetPersistentAsNumber("Global_MFDULSelectedCamera"), fc.GetPersistentAsNumber("Global_AscentScratchPad"))
  elseif actionCheck == 3 then
    fc.SetPan(fc.GetPersistentAsNumber("Global_MFDULSelectedCamera"), fc.GetPersistentAsNumber("Global_AscentScratchPad"))
  elseif actionCheck == 4 then
    fc.SetTilt(fc.GetPersistentAsNumber("Global_MFDULSelectedCamera"), fc.GetPersistentAsNumber("Global_AscentScratchPad"))
  elseif actionCheck == 5 then
    fc.SetFoV(fc.GetPersistentAsNumber("Global_MFDULSelectedCamera"), 90)
  elseif actionCheck == 6 then
    fc.SetPan(fc.GetPersistentAsNumber("Global_MFDULSelectedCamera"), 0)
    fc.SetTilt(fc.GetPersistentAsNumber("Global_MFDULSelectedCamera"), 0)
  end
end

function BCS_CamerasClearHandler()

  local powerCheck = fc.GetPersistentAsNumber("Global_SMC1_State")

  if powerCheck == 0 then
    return
  end

  local actionCheck = fc.GetPersistentAsNumber("Global_MFDULSelectedCameraOption")

  if actionCheck == 0 then
    fc.AddPersistentWrapped("Global_MFDULSelectedCamera", -1, 0, fc.CameraCount())
  elseif actionCheck == 1 then
    fc.AddPersistentWrapped("Global_MFDULCameraGain", -0.2, 0, 3)
  elseif actionCheck == 2 then
    fc.AddFoV(fc.GetPersistentAsNumber("Global_MFDULSelectedCamera"), -1)
  elseif actionCheck == 3 then
    fc.AddPan(fc.GetPersistentAsNumber("Global_MFDULSelectedCamera"), -1)
  elseif actionCheck == 4 then
    fc.AddTilt(fc.GetPersistentAsNumber("Global_MFDULSelectedCamera"), -1)
  end
end

function BCS_LandingActionHandler()

  local powerCheck = fc.GetPersistentAsNumber("Global_SMC1_State")

  if powerCheck == 0 then
    return
  end

  local actionCheck = fc.GetPersistentAsNumber("Global_MFDULSelectedLandingOption")

  if actionCheck == 1 then
    fc.AddPersistentClamped("Global_MFDULAftCameraGain", 0.2, 0, 3)
  elseif actionCheck == 2 then
    mechjeb.ToggleLandingAutopilot()
  end
end

function BCS_LandingClearHandler()

  local powerCheck = fc.GetPersistentAsNumber("Global_SMC1_State")

  if powerCheck == 0 then
    return
  end

  local actionCheck = fc.GetPersistentAsNumber("Global_MFDULSelectedLandingOption")

  if actionCheck == 1 then
    fc.AddPersistentClamped("Global_MFDULAftCameraGain", -0.2, 0, 3)
  end
end

function BCS_ISRUActionHandler()

  local powerCheck = fc.GetPersistentAsNumber("Global_SMC1_State")

  if powerCheck == 0 then
    return
  end

  local actionCheck = fc.GetPersistentAsNumber("Global_MFDLLSelectedISRUAction")

  if actionCheck == 0 then
    local toggleCheck = fc.GetPersistentAsNumber("Global_MFDLLDrillPosition")
    if toggleCheck == 0 then
      fc.ToggleActionGroup(18)
      fc.SetPersistent("Global_MFDLLDrillPosition", 1)
    else
      fc.ToggleActionGroup(19)
      fc.SetPersistent("Global_MFDLLDrillPosition", 0)
    end
  elseif actionCheck == 1 then
    local stateCheck = fc.DrillActiveCount()
    if stateCheck == 0 then
      fc.ToggleActionGroup(20)
    else
      fc.ToggleActionGroup(21)
    end
  elseif actionCheck == 2 then
    fc.AddPersistentWrapped("Global_ISRUSelectedResource", 1, 0, fc.ResourceCount())
  elseif actionCheck == 3 then
    fc.ToggleResourceConverterActive(1)
  elseif actionCheck == 4 then
    fc.ToggleResourceConverterActive(2)
  elseif actionCheck == 5 then
    fc.ToggleResourceConverterActive(3)
  end
end

function BCS_ISRUClearHandler()

  local powerCheck = fc.GetPersistentAsNumber("Global_SMC1_State")

  if powerCheck == 0 then
    return
  end

  local actionCheck = fc.GetPersistentAsNumber("Global_MFDLLSelectedISRUAction")

  if actionCheck == 2 then
    fc.AddPersistentWrapped("Global_ISRUSelectedResource", -1, 0, fc.ResourceCount())
  end
end