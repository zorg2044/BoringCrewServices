function BCS_ESSHandler()
  
  local check1 = fc.AssemblyLoaded("TacLifeSupport")
  local check2 = fc.AssemblyLoaded("Kerbalism")
  
  if check1 + check2 == 2 then
    fc.PlayAudio("ASET/ASET_Props/Sounds/beep_F_short_x2", 1.0, false)
    return
  elseif check1 == 1 then
    fc.SetPersistent("MFD_LL", "MAS_BCS_ESSTacPageLL")
  elseif check2 == 1 then
    fc.SetPersistent("MFD_LL", "MAS_BCS_ESSKerbalismPageLL")
  end
end