--[[ 
Copyright Alejandro Zuluaga 2021. All rights reserved

This file and its contents are suplied under the terms of the
Creative Commons Attribution 4.0 International Public License (CC BY-NC 4.0)
]]

--replace create_command
function deferred_command(name,desc,realFunc)
    return replace_command(name,realFunc)
 end
 
 --replace create_dataref
 function deferred_dataref(name,nilType,callFunction)
    if callFunction~=nil then
       print("WARN:" .. name .. " is trying to wrap a function to a dataref -> use xlua")
    end
    return find_dataref(name)
 end

 --*************************************************************************************--
--**                            XTLUA GLOBAL VARIABLES                               **--
--*************************************************************************************--

--[[
SIM_PERIOD - this contains the duration of the current frame in seconds (so it is alway a
fraction).  Use this to normalize rates,  e.g. to add 3 units of fuel per second in a
per-frame callback you’d do fuel = fuel + 3 * SIM_PERIOD.
IN_REPLAY - evaluates to 0 if replay is off, 1 if replay mode is on
--]]


--*************************************************************************************--
--**                             CREATE GLOBAL VARIABLES                               **--
--*************************************************************************************--



--*************************************************************************************--
--**                                  LOCAL VARIABLES                                **--
--*************************************************************************************--



--*************************************************************************************--
--**                               FIND X-PLANE DATAREFS                             **--
--*************************************************************************************--
simDR_startup_running      = find_dataref("sim/operation/prefs/startup_running")
simDR_battery_on           = find_dataref("sim/cockpit/electrical/battery_on")
simDR_battery_array_on     = find_dataref("sim/cockpit/electrical/battery_on")
simDR_generator_on         = find_dataref("sim/cockpit/electrical/generator_on")
simDR_pitot_heat_on        = find_dataref("sim/cockpit/switches/pitot_heat_on")
simDR_landing_lights_on    = find_dataref("sim/cockpit/electrical/landing_lights_on")
simDR_nav_lights_on        = find_dataref("sim/cockpit/electrical/nav_lights_on")
simDR_beacon_lights_on     = find_dataref("sim/cockpit/electrical/beacon_lights_on")
simDR_fuel_quantity        = find_dataref("sim/cockpit2/fuel/fuel_quantity")
simDR_flap_lever           = find_dataref("sim/cockpit2/controls/flap_ratio")


--*************************************************************************************--
--**                                  FIND CUSTOM DATAREFS                                  **--
--*************************************************************************************--
C152_alternator_switch    = find_dataref("ZLSimulation/C152/electrical/alternator_switch")
C152_circuit_breakers     = find_dataref("ZLSimulation/C152/electrical/circuit_breakers_position")
C152_landing_light_switch = find_dataref("ZLSimulation/C152/electrical/landing_light_switch")
C152_pitot_heat_switch    = find_dataref("ZLSimulation/C152/electrical/pitot_heat_switch") 
C152_beacon_light_switch  = find_dataref("ZLSimulation/C152/electrical/beacon_light_switch") 
C152_fuel_indicator_left  = find_dataref("ZLSimulation/C152/electrical/fuel_indicator_L") 
C152_fuel_indicator_right = find_dataref("ZLSimulation/C152/electrical/fuel_indicator_R") 
C152_dome_light_sw        = find_dataref("ZLSimulation/C152/electrical/dome_light_sw") 
C152_dome_light           = find_dataref("ZLSimulation/C152/electrical/dome_light") 
C152_flap_lever           = find_dataref("ZLSimulation/C152/electrical/flap_lever")
--*************************************************************************************--
--**                              CUSTOM DATAREF HANDLERS                            **--
--*************************************************************************************--


--*************************************************************************************--
--**                              CREATE CUSTOM DATAREFS                             **--
--*************************************************************************************--


--*************************************************************************************--
--**                              X-PLANE COMMAND HANDLERS                           **--
--*************************************************************************************--



--*************************************************************************************--
--**                                  X-PLANE COMMANDS                               **--
--*************************************************************************************--



--*************************************************************************************--
--**                                CUSTOM COMMAND HANDLERS                          **--
--*************************************************************************************--


--*************************************************************************************--
--**                              CREATE CUSTOM COMMANDS                             **--
--*************************************************************************************--


--*************************************************************************************--
--**                                       CODE                                      **--
--*************************************************************************************--
function circuit_breakers()
    -- Circuit breaker 1 (alternator)
    if C152_circuit_breakers[0] == 1 and C152_alternator_switch == 1 then
        simDR_generator_on[0] = 1
    else
        simDR_generator_on[0] = 0
    end

    --Circuit breaker 2 (fuel indicators)
    if C152_circuit_breakers[1] == 1 and simDR_battery_on == 1 then
        C152_fuel_indicator_left = simDR_fuel_quantity[0]
        C152_fuel_indicator_right = simDR_fuel_quantity[1]
    else
        C152_fuel_indicator_left = 0
        C152_fuel_indicator_right = 0
    end

    --Circuit breaker 3 (BCN PITOT)
    if C152_circuit_breakers[2] == 1 then
        if C152_beacon_light_switch == 1 then
            simDR_beacon_lights_on = 1
        else
            simDR_beacon_lights_on = 0
        end
        if C152_pitot_heat_switch == 1 then
            simDR_pitot_heat_on = 1
        else
            simDR_pitot_heat_on = 0
        end
    else
        simDR_beacon_lights_on = 0
        simDR_pitot_heat_on = 0
    end

    --Circuit breaker 4 (landing light)
    if C152_circuit_breakers[3] == 1 and C152_landing_light_switch == 1 then
        simDR_landing_lights_on = 1
    else 
        simDR_landing_lights_on = 0
    end

    --Circuit breaker 5 (flaps)
    if C152_circuit_breakers[4] == 1 and C152_flap_lever >= 0 then
        simDR_flap_lever = C152_flap_lever
    end
    
    --Circuit breaker 7 (Nav/Dome)
    if C152_circuit_breakers[6] == 1 then
        C152_dome_light = C152_dome_light_sw
    else
        C152_dome_light = 0
    end

end


--*************************************************************************************--
--**                                    EVENT CALLBACKS                              **--
--*************************************************************************************--
 
--function aircraft_load()
 
function flight_start()
    --Allways
    for i = 0, 10, 1 do
        C152_circuit_breakers[i] = 1
    end
    C152_pitot_heat_switch = 0
    C152_flap_lever = 0
      --Startup running == 0
    if startup_running == 0 then
        C152_landing_light_switch = 0
        C152_beacon_light_switch = 0
        C152_alternator_switch = 0
        C152_pitot_heat_switch = 0
      --Startup running == 1
    elseif startup_running == 1 then
        C152_landing_light_switch = 1
        C152_beacon_light_switch = 1
        C152_alternator_switch = 1
        C152_pitot_heat_switch = 1
    end
        

end

--function aircraft_unload()
 
--function flight_crash()
 
--function before_physics()
 
function after_physics()
    circuit_breakers()
end
--function after_replay()
