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
--**                             REATE GLOBAL VARIABLES                               **--
--*************************************************************************************--



--*************************************************************************************--
--**                                  LOCAL VARIABLES                                **--
--*************************************************************************************--



--*************************************************************************************--
--**                               FIND X-PLANE DATAREFS                             **--
--*************************************************************************************--
simDR_battery_on = find_dataref("sim/cockpit/electrical/battery_on")
simDr_landing_lights_switch = find_dataref("sim/cockpit2/switches/landing_lights_switch")
simDr_landing_lights_on = find_dataref("sim/cockpit/electrical/landing_lights_on")


--*************************************************************************************--
--**                                  FIND DATAREFS                                  **--
--*************************************************************************************--



--*************************************************************************************--
--**                              CUSTOM DATAREF HANDLERS                            **--
--*************************************************************************************--


--*************************************************************************************--
--**                              CREATE CUSTOM DATAREFS                             **--
--*************************************************************************************--

C152_circuit_breakers = deferred_dataref("ZLSimulation/C152/electrical/circuit_breakers_position" , "array[11]") -- Dataref to hold circuit breaker position



--*************************************************************************************--
--**                              X-PLANE COMMAND HANDLERS                           **--
--*************************************************************************************--




--*************************************************************************************--
--**                                  X-PLANE COMMANDS                               **--
--*************************************************************************************--




--*************************************************************************************--
--**                                CUSTOM COMMAND HANDLERS                          **--
--*************************************************************************************--
--[[ Circuit Breakers Command Handlers]]

function circuit_breaker_1_CMDhandler()
   C152_circuit_breakers[0] = 1 - C152_circuit_breakers[0]
end

function circuit_breaker_2_CMDhandler()
   C152_circuit_breakers[1] = 1 - C152_circuit_breakers[1]
end

function circuit_breaker_3_CMDhandler()
   C152_circuit_breakers[2] = 1 - C152_circuit_breakers[2]
end

function circuit_breaker_4_CMDhandler()
   C152_circuit_breakers[3] = 1 - C152_circuit_breakers[3]
end

function circuit_breaker_5_CMDhandler()
   C152_circuit_breakers[4] = 1 - C152_circuit_breakers[4]
end

function circuit_breaker_6_CMDhandler()
   C152_circuit_breakers[5] = 1 - C152_circuit_breakers[5]
end

function circuit_breaker_7_CMDhandler()
   C152_circuit_breakers[6] = 1 - C152_circuit_breakers[6]
end

function circuit_breaker_8_CMDhandler()
   C152_circuit_breakers[7] = 1 - C152_circuit_breakers[7]
end

function circuit_breaker_9_CMDhandler()
   C152_circuit_breakers[8] = 1 - C152_circuit_breakers[8]
end

function circuit_breaker_10_CMDhandler()
   C152_circuit_breakers[9] = 1 - C152_circuit_breakers[9]
end

function circuit_breaker_11_CMDhandler()
   C152_circuit_breakers[10] = 1 - C152_circuit_breakers[10]
end

--*************************************************************************************--
--**                              CREATE CUSTOM COMMANDS                             **--
--*************************************************************************************--

--[[Circuit Breakers toggle]]--

C152CMD_CircuitBreaker_1_toggle  = deferred_command("ZLSimulation/C152/electrical/circuit_breaker_1_toggle", "toggle circuit breaker 1", circuit_breaker_1_CMDhandler) 
C152CMD_CircuitBreaker_2_toggle  = deferred_command("ZLSimulation/C152/electrical/circuit_breaker_2_toggle", "toggle circuit breaker 2", circuit_breaker_2_CMDhandler)
C152CMD_CircuitBreaker_3_toggle  = deferred_command("ZLSimulation/C152/electrical/circuit_breaker_3_toggle", "toggle circuit breaker 3", circuit_breaker_3_CMDhandler)
C152CMD_CircuitBreaker_4_toggle  = deferred_command("ZLSimulation/C152/electrical/circuit_breaker_4_toggle", "toggle circuit breaker 4", circuit_breaker_4_CMDhandler)
C152CMD_CircuitBreaker_5_toggle  = deferred_command("ZLSimulation/C152/electrical/circuit_breaker_5_toggle", "toggle circuit breaker 5", circuit_breaker_5_CMDhandler)
C152CMD_CircuitBreaker_6_toggle  = deferred_command("ZLSimulation/C152/electrical/circuit_breaker_6_toggle", "toggle circuit breaker 6", circuit_breaker_6_CMDhandler)
C152CMD_CircuitBreaker_7_toggle  = deferred_command("ZLSimulation/C152/electrical/circuit_breaker_7_toggle", "toggle circuit breaker 7", circuit_breaker_7_CMDhandler)
C152CMD_CircuitBreaker_8_toggle  = deferred_command("ZLSimulation/C152/electrical/circuit_breaker_8_toggle", "toggle circuit breaker 8", circuit_breaker_8_CMDhandler)
C152CMD_CircuitBreaker_9_toggle  = deferred_command("ZLSimulation/C152/electrical/circuit_breaker_9_toggle", "toggle circuit breaker 9", circuit_breaker_9_CMDhandler)
C152CMD_CircuitBreaker_10_toggle = deferred_command("ZLSimulation/C152/electrical/circuit_breaker_10_toggle", "toggle circuit breaker 10", circuit_breaker_10_CMDhandler)
C152CMD_CircuitBreaker_11_toggle = deferred_command("ZLSimulation/C152/electrical/circuit_breaker_11_toggle", "toggle circuit breaker 11", circuit_breaker_11_CMDhandler)

--*************************************************************************************--
--**                                       CODE                                      **--
--*************************************************************************************--

 --*************************************************************************************--
 --**                                    EVENT CALLBACKS                              **--
 --*************************************************************************************--
 
 --function aircraft_load()
 
 function flight_start()
   print("XTLua flight start")
 end
 --function aircraft_unload()
 
 --function flight_crash()
 
 --function before_physics()
 
 --function after_physics()

 --function after_replay()
