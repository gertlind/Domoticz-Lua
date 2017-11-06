function libs.GroupState(sArray)
        -- v1.0. 2016-01-18
        -- Checks the state of a group of swithces.
        -- USAGE   : GroupState({'Switch1','Switch2','Switch3','Switch4','Switch5',more switches})
        -- RETURNS : 'On'       if all switches are on.
        --         : 'Off'      if all switches are off.
        --         : 'Mixed"    if one or more, but not all switches are on.
        --
        local iState = 0
        local iCount = 0
        local sState = ''
        for i,light in pairs(sArray) do
                if (otherdevices[light] == 'On') then
                        iState = iState + 1
                end
        iCount = iCount + 1
        end
        if(iState == 0) then sState = "Off" end
        if(iState > 0) then sState = 'Mixed' end
        if(iState == iCount) then sState = 'On' end
--      print("iCount   : " .. iCount)
--      print("iState   : " .. iState)
--      print("sState   : " .. sState)
        return sState
end
