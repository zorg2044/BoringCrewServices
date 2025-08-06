function BCS_CharCounter(input)

  local string = tostring(input)
  
  if string:len() > 0 then
    return string:len() * 0.5
  end
  return 0
end