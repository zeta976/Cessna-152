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

drawer_value = 0

--*************************************************************************************--
--**                               FIND X-PLANE DATAREFS                             **--
--*************************************************************************************--

simDR_door_open = find_dataref("sim/cockpit2/switches/door_open")

--*************************************************************************************--
--**                                  FIND DATAREFS                                  **--
--*************************************************************************************--



--*************************************************************************************--
--**                              CUSTOM DATAREF HANDLERS                            **--
--*************************************************************************************--


--*************************************************************************************--
--**                              CREATE CUSTOM DATAREFS                             **--
--*************************************************************************************--

C152_alternator_switch    = deferred_dataref("ZLSimulation/C152/electrical/alternator_switch", "number") --Dataref to hold alternator switch position
C152_circuit_breakers     = deferred_dataref("ZLSimulation/C152/electrical/circuit_breakers_position" , "array[11]") -- Dataref to hold circuit breaker position
C152_landing_light_switch = deferred_dataref("ZLSimulation/C152/electrical/landing_light_switch", "number") --Dataref to hold landing light switch position
C152_pitot_heat_switch    = deferred_dataref("ZLSimulation/C152/electrical/pitot_heat_switch", "number") -- Dataref to hold pitot heat switch position
C152_beacon_light_switch  = deferred_dataref("ZLSimulation/C152/electrical/beacon_light_switch", "number") -- Dataref to hold beacon light switch position
C152_fuel_indicator_left  = deferred_dataref("ZLSimulation/C152/electrical/fuel_indicator_L", "number") --Dataref to hold fuel indication
C152_fuel_indicator_right = deferred_dataref("ZLSimulation/C152/electrical/fuel_indicator_R", "number") --Datref to hold fuel indication
C152_flap_lever           = deferred_dataref("ZLSimulation/C152/electrical/flap_lever", "number") --Dataref to hold flap lever position
C152_drawer               = deferred_dataref("ZLSimulation/C152/extras/drawer", "number") --Dataref to hold drawer positions



--*************************************************************************************--
--**                              X-PLANE COMMAND HANDLERS                           **--
--*************************************************************************************--




--*************************************************************************************--
--**                                 FIND X-PLANE COMMANDS                               **--
--*************************************************************************************--

simCMD_open_door_1       = find_command("sim/flight_controls/door_open_1")
simCMD_close_door_1      = find_command("sim/flight_controls/door_close_1")
simCMD_open_door_2       = find_command("sim/flight_controls/door_open_2")
simCMD_close_door_2      = find_command("sim/flight_controls/door_close_2")




--*************************************************************************************--
--**                                CUSTOM COMMAND HANDLERS                          **--
--*************************************************************************************--
--alternator command handlers
function alternator_toggle_CMDhandler(phase, duration)
    if phase == 0 then
        C152_alternator_switch = 1 - C152_alternator_switch
    end
end


function alternator_on_CMDhandler(phase, duration)
    if phase == 0 then
        C152_alternator_switch = 1
    end
end

function alternator_off_CMDhandler(phase, duration)
    if phase == 0 then
        C152_alternator_switch = 0
    end
end

--beacon light command handlers
function beacon_light_toggle_CMDhandler(phase, duration)
    if phase == 0 then
        C152_beacon_light_switch = 1 - C152_beacon_light_switch
    end
end
function beacon_light_on_CMDhandler(phase, duration)
    if phase == 0 then
        C152_beacon_light_switch = 1
    end
end
function beacon_light_off_CMDhandler(phase, duration)
    if phase == 0 then
        C152_beacon_light_switch = 0
    end
end

--landing light command handlers
function landing_light_toggle_CMDhandler(phase, duration)
    if phase == 0 then
        C152_landing_light_switch = 1 - C152_landing_light_switch
    end
end

function landing_light_on_CMDhandler(phase, duration)
    if phase == 0 then
        C152_landing_light_switch = 1
    end
end

function landing_light_off_CMDhandler(phase, duration)
    if phase == 0 then
        C152_landing_light_switch = 0
    end
end

-- Pitot heat command handlers

function pitot_ht_toggle_CMDhandler(phase, duration)
    if phase == 0 then
        C152_pitot_heat_switch = 1 - C152_pitot_heat_switch
    end
end
function pitot_ht_on_CMDhandler(phase, duration)
    if phase == 0 then
        C152_pitot_heat_switch = 1
    end
end
function pitot_ht_off_CMDhandler(phase, duration)
    if phase == 0 then
        C152_pitot_heat_switch = 0 
    end
end

--Flap command handlers

function flaps_up_CMDhandler(phase, duration)
    if phase == 0 and C152_flap_lever > 0 then
        C152_flap_lever = C152_flap_lever - (10/30)
    end
end
function flaps_dn_CMDhandler(phase,duration)
    if phase == 0 and C152_flap_lever ~= 1 then
        C152_flap_lever = C152_flap_lever + (10/30)
    end
end

--Circuit Breakers Command Handlers

function circuit_breaker_1_CMDhandler(phase, duration)
    if phase == 0 then
        C152_circuit_breakers[0] = 1 - C152_circuit_breakers[0]
    end
end

function circuit_breaker_2_CMDhandler(phase, duration)
    if phase == 0 then
        C152_circuit_breakers[1] = 1 - C152_circuit_breakers[1]
    end
end

function circuit_breaker_3_CMDhandler(phase, duration)
    if phase == 0 then
        C152_circuit_breakers[2] = 1 - C152_circuit_breakers[2]
    end
end

function circuit_breaker_4_CMDhandler(phase, duration)
    if phase == 0 then
        C152_circuit_breakers[3] = 1 - C152_circuit_breakers[3]
    end
end

function circuit_breaker_5_CMDhandler(phase, duration)
    if phase == 0 then
        C152_circuit_breakers[4] = 1 - C152_circuit_breakers[4]
    end  
end

function circuit_breaker_6_CMDhandler(phase, duration)
    if phase == 0 then
        C152_circuit_breakers[5] = 1 - C152_circuit_breakers[5]
    end
end

function circuit_breaker_7_CMDhandler(phase, duration)
    if phase == 0 then
        C152_circuit_breakers[6] = 1 - C152_circuit_breakers[6]
    end
end

function circuit_breaker_8_CMDhandler(phase, duration)
    if phase == 0 then
        C152_circuit_breakers[7] = 1 - C152_circuit_breakers[7]
    end
end

function circuit_breaker_9_CMDhandler(phase, duration)
    if phase == 0 then
    C152_circuit_breakers[8] = 1 - C152_circuit_breakers[8]
    end
end

function circuit_breaker_10_CMDhandler(phase, duration)
    if phase == 0 then
        C152_circuit_breakers[9] = 1 - C152_circuit_breakers[9]
    end
end

function circuit_breaker_11_CMDhandler(phase, duration)
    if phase == 0 then
        C152_circuit_breakers[10] = 1 - C152_circuit_breakers[10]
    end
end

--Drawer toggle
function drawer_toggle_CMDhandler(phase, duration)
    if phase == 0 then 
        drawer_value = 1 - drawer_value
    end
end

function l_door_CMDhandler(phase,duration)
    if phase == 0 then
        simDR_door_open[0] = 1 - simDR_door_open[0]
    end
end

function r_door_CMDhandler(phase, duration)
    if phase == 0 then 
        simDR_door_open[1] = 1 - simDR_door_open[1]
    end
end



--*************************************************************************************--
--**                              CREATE CUSTOM COMMANDS                             **--
--*************************************************************************************--

--Circuit Breakers toggle--
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
C152CMD_drawer_toggle            = deferred_command("ZLSimulation/C152/extras/drawer_toggle", "toggle drawer", drawer_toggle_CMDhandler)
C152CMD_right_door_toggle        = deferred_command("ZLSimulation/C152/extras/door_toggle_r", "toggle door", r_door_CMDhandler)
C152CMD_left_door_toggle         = deferred_command("ZLSimulation/C152/extras/door_toggle_l", "toggle door", l_door_CMDhandler)


--*************************************************************************************--
--**                              REPLACE X-PLANE COMMANDS                           **--
--*************************************************************************************--

--REPLACE ALTERNATOR COMMANDS
simCMD_alternators_toggle          = replace_command("sim/electrical/generators_toggle", alternator_toggle_CMDhandler)
simCMD_alternator_1_toggle         = replace_command("sim/electrical/generator_1_toggle", alternator_toggle_CMDhandler)
simCMD_alternator_1_on             = replace_command("sim/electrical/generator_1_on", alternator_on_CMDhandler)
simCMD_alternator_1_off            = replace_command("sim/electrical/generator_1_off", alternator_off_CMDhandler)

--REPLACE BEACON LIGHTS COMMANDS 
simCMD_beacon_lights_toggle        = replace_command("sim/lights/beacon_lights_toggle", beacon_light_toggle_CMDhandler)
simCMD_beacon_lights_on            = replace_command("sim/lights/beacon_lights_on", beacon_light_on_CMDhandler)
simCMD_beacon_lights_off           = replace_command("sim/lights/beacon_lights_off", beacon_light_off_CMDhandler)

--REPLACE LANDING LIGHTS COMMANDS
simCMD_landing_lights_toggle       = replace_command("sim/lights/landing_lights_toggle", landing_light_toggle_CMDhandler)
simCMD_landing_lights_on           = replace_command("sim/lights/landing_lights_on", landing_light_on_CMDhandler)
simCMD_landing_light_off           = replace_command("sim/lights/landing_lights_off", landing_light_off_CMDhandler)
simCMD_landing_light_01_on         = replace_command("sim/lights/landing_01_light_on", landing_light_on_CMDhandler)
simCMD_landing_light_01_off        = replace_command("sim/lights/landing_01_light_off", landing_light_off_CMDhandler)
simCMD_landing_light_01_toggle     = replace_command("sim/lights/landing_01_light_tog", landing_light_toggle_CMDhandler)

--REPLACE PITOT HEAT COMMANDS
simdCMD_pitot_heat_toggle          = replace_command("sim/ice/pitot_heat0_tog", pitot_ht_toggle_CMDhandler)
simCMD_pitot_heat_on               = replace_command("sim/ice/pitot_heat0_on", pitot_ht_on_CMDhandler)
simCMD_pitot_heat_off              = replace_command("sim/ice/pitot_heat0_off", pitot_ht_off_CMDhandler)

--REPLACE FLAPS COMMANDS
simCMD_flaps_up                    = replace_command("sim/flight_controls/flaps_up", flaps_up_CMDhandler)
simCMD_flaps_down                  = replace_command("sim/flight_controls/flaps_down", flaps_dn_CMDhandler)

--*************************************************************************************--
--**                                       CODE                                      **--
--*************************************************************************************--
function func_animate_slowly(reference_value, animated_VALUE, anim_speed)
    if math.abs(reference_value - animated_VALUE) < 0.1 then return reference_value end
    animated_VALUE = animated_VALUE + ((reference_value - animated_VALUE) * (anim_speed * SIM_PERIOD))
    return animated_VALUE
end
function animate_drawer()
    C152_drawer = func_animate_slowly(drawer_value, C152_drawer, 2)
end


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

function after_physics()
    animate_drawer()
end


--function after_replay()
