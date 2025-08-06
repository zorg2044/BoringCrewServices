function BCS_HandleTimeString()

  local string = fc.GetPersistent("Global_AscentScratchPad")
  local counter = 0
  local value = 0

  for str in string.gmatch(string, "([^"..".".."]+)") do
    if counter == 0 then
      value = str
    elseif counter == 1 then
      value = value + (str * 60)
    elseif counter == 2 then
      value = value + (str * 3600)
    elseif counter == 3 then
      value = value + (str * 21600)
    end
    counter = counter + 1
  end

  fc.AddManeuverNode(fc.ManeuverNodeDVPrograde(), fc.ManeuverNodeDVNormal(), fc.ManeuverNodeDVRadial(), fc.UT() + (-1 * fc.ManeuverNodeTime()) + value)

end