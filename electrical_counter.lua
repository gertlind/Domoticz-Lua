commandArray = {}
-- Scriptname script_device_kwcount.lua
-- v1.0 20140202

-- Factor to calculate actual effect consumption
-- For 800 blinks per kW f=1.25, 1000 blinks per kW f=1, 10000 blinks per kW f=0.1
f=0.1

-- Dummy counter Idx value
kwCounterIndex = 20

-- File functions used to keep track of updated total value
-- The file effect-counter is saved to /
local function readFile(sPath)
  local file = io.open(sPath, "r")
  if file then
        local tLine = file:read()
        file.close()
        return tLine
  end
  return nil
end

local function writeFile(sPath, sLine)
  local file = io.open(sPath, "w")
  if file then
   io.output(file);
    io.write(sLine)
    io.close()
  end
end


-- My temperature device is kW1 and kW2. Where kW1 is the primary and kW2 is secondary
-- I do not use the secondary one (kW2) in this script.
if (devicechanged ['kW1']) then
   -- Get the latest count into a temp variabel
   tString   = otherdevices_svalues['kW1']
   -- Parse out the value I want, the temperature. Turn it to a number and multiply by 10.
   newValue= f*10*tonumber(string.sub(tString,1,string.find(tString,';',1,true)-1))
--   print("Test", newValue)
   
   -- Read the latest total counter into lastValue
   lastValue = 0
   local aLine=readFile("effect-counter-kwh")
   if aLine then
         lastValue=tonumber(aLine)
   end
   -- Add our latest count to lastValue
   lastValue=lastValue+newValue

   -- write the lastValue to disk
   writeFile("effect-counter-kwh",tostring(lastValue))
   
   -- Construct the string to use for updating our dummy counter.
   effectString=tostring(kwCounterIndex) .. "|0|" .. tostring(newValue) .. ";" .. tostring(lastValue)
   print("New Value", newValue, effectString)

   -- now use this counter for our virtual effect sensor
   commandArray = {}
   commandArray['UpdateDevice']=effectString
end
return commandArray
