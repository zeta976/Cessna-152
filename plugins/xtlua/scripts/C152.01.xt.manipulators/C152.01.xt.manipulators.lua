--[[ 
Copyright Alejandro Zuluaga 2021-2023. All rights reserved

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

primer_target = 0
drawer_target = 0
window_l_target = 0
window_r_target = 0

--*************************************************************************************--
--**                               FIND X-PLANE DATAREFS                             **--
--*************************************************************************************--

simDR_door_open        = find_dataref("sim/cockpit2/switches/door_open")
simDR_transponder_code = find_dataref("sim/cockpit2/radios/actuators/transponder_code")
simDR_transponder_mode = find_dataref("sim/cockpit2/radios/actuators/transponder_mode")
simDR_volume_com2      = find_dataref("sim/cockpit2/radios/actuators/audio_volume_com2")
simDR_volume_nav2      = find_dataref("sim/cockpit2/radios/actuators/audio_volume_nav2")
simDR_primer_ratio     = find_dataref("sim/cockpit2/engine/actuators/primer_ratio")

--*************************************************************************************--
--**                                  FIND DATAREFS                                  **--
--*************************************************************************************--



--*************************************************************************************--
--**                              CUSTOM DATAREF HANDLERS                            **--
--*************************************************************************************--


--*************************************************************************************--
--**                              CREATE CUSTOM DATAREFS                             **--
--*************************************************************************************--

C152_alternator_switch    = deferred_dataref("ZLSimulation/C152/electrical/alternator_switch", "number") -- Alternator
C152_circuit_breakers     = deferred_dataref("ZLSimulation/C152/electrical/circuit_breakers_position" , "array[11]") --Circuit Breakers

-- Switch Panel

C152_landing_light_switch = deferred_dataref("ZLSimulation/C152/electrical/landing_light_switch", "number") 
C152_pitot_heat_switch    = deferred_dataref("ZLSimulation/C152/electrical/pitot_heat_switch", "number")
C152_beacon_light_switch  = deferred_dataref("ZLSimulation/C152/electrical/beacon_light_switch", "number")
C152_nav_light_switch	  = deferred_dataref("ZLSimulation/C152/electrical/nav_lights_switch", "number")
C152_dome_light_sw        = deferred_dataref("ZLSimulation/C152/electrical/dome_light_sw", "number")

-- Fuel Ind

C152_fuel_indicator_left  = deferred_dataref("ZLSimulation/C152/electrical/fuel_indicator_L", "number")
C152_fuel_indicator_right = deferred_dataref("ZLSimulation/C152/electrical/fuel_indicator_R", "number")
C152_flap_lever           = deferred_dataref("ZLSimulation/C152/electrical/flap_lever", "number")

-- Transponder

C152_transponder_thousands = deferred_dataref("ZLSimulation/C152/radios/transponder_thousands", "number")
C152_transponder_hundreds = deferred_dataref("ZLSimulation/C152/radios/transponder_hundreds", "number")
C152_transponder_tens = deferred_dataref("ZLSimulation/C152/radios/transponder_tens", "number")
C152_transponder_ones = deferred_dataref("ZLSimulation/C152/radios/transponder_ones", "number")

-- Anims

C152_drawer               = deferred_dataref("ZLSimulation/C152/extras/drawer", "number")
C152_window_l_open        = deferred_dataref("ZLSimulation/C152/extras/window_l_open", "number")
C152_window_r_open        = deferred_dataref("ZLSimulation/C152/extras/window_r_open", "number")



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

-- Nav light command handlers
function nav_light_toggle_CMDhandler(phase, duration)
	if phase == 0 then
		C152_nav_light_switch = 1 - C152_nav_light_switch
	end
end
function nav_light_on_CMDhandler(phase, duration)
	if phase == 0 then
		C152_nav_light_switch = 1
	end
end
function nav_light_off_CMDhandler(phase, duration)
	if phase == 0 then
		C152_nav_light_switch = 0
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

--Dome light
function dome_light_tog_CMDhandler(phase, duration)
    if phase == 0 then
        C152_dome_light_sw = 1 - C152_dome_light_sw
    end
end

--Flap command handlers

function flaps_up_CMDhandler(phase, duration)
    if phase == 0 and C152_flap_lever > 0.33 then
        C152_flap_lever = C152_flap_lever - (10/30)
    end
end
function flaps_dn_CMDhandler(phase,duration)
    if phase == 0 and C152_flap_lever < 1.0 then
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

-- Transponder Mode

function transponder_up_CMDhandler(phase, duration)
	if phase == 0 and simDR_transponder_mode <= 3 then
		simDR_transponder_mode = simDR_transponder_mode + 1
	end
end

-- Transponder Thousands

function transponder_thousands_up_CMDhandler(phase, duration)
	if phase == 0 then
		if C152_transponder_thousands <= 6 then
			C152_transponder_thousands = C152_transponder_thousands + 1
		else
			C152_transponder_thousands = 0
		end
	end
end
function transponder_thousands_dn_CMDhandler(phase, duration)
	if phase == 0 then
		if C152_transponder_thousands >= 1 then
			C152_transponder_thousands = C152_transponder_thousands - 1
		else
			C152_transponder_thousands = 7
		end
	end
end

-- Transponder Hundreds

function transponder_hundreds_up_CMDhandler(phase, duration)
	if phase == 0 then
		if C152_transponder_hundreds <= 6 then
			C152_transponder_hundreds = C152_transponder_hundreds + 1
		else
			C152_transponder_hundreds = 0
		end
	end
end
function transponder_hundreds_dn_CMDhandler(phase, duration)
	if phase == 0 then
		if C152_transponder_hundreds >= 1 then
			C152_transponder_hundreds = C152_transponder_hundreds - 1
		else
			C152_transponder_hundreds = 7
		end
	end
end

-- Transponder Tens

function transponder_tens_up_CMDhandler(phase, duration)
	if phase == 0 then
		if C152_transponder_tens <= 6 then
			C152_transponder_tens = C152_transponder_tens + 1
		else
			C152_transponder_tens = 0
		end
	end
end
function transponder_tens_dn_CMDhandler(phase, duration)
	if phase == 0 then
		if C152_transponder_tens >= 1 then
			C152_transponder_tens = C152_transponder_tens - 1
		else
			C152_transponder_tens = 7
		end
	end
end

-- Transponder Ones

function transponder_ones_up_CMDhandler(phase, duration)
	if phase == 0 then
		if C152_transponder_ones <= 6 then
			C152_transponder_ones = C152_transponder_ones + 1
		else
			C152_transponder_ones = 0
		end
	end
end
function transponder_ones_dn_CMDhandler(phase, duration)
	if phase == 0 then
		if C152_transponder_ones >= 1 then
			C152_transponder_ones = C152_transponder_ones - 1
		else
			C152_transponder_ones = 7
		end
	end
end

-- COM2 Volume

function com2_volume_up_CMDhandler(phase, duration)
	if phase == 0 and simDR_volume_com2 < 1 then
		simDR_volume_com2 = simDR_volume_com2 + 0.1
	end
end
function com2_volume_dn_CMDhandler(phase, duration)
	if phase == 0 and simDR_volume_com2 >= 0.05 then
		simDR_volume_com2 = simDR_volume_com2 - 0.1
	end
end

-- NAV2 Volume

function nav2_volume_up_CMDhandler(phase, duration)
	if phase == 0 and simDR_volume_nav2 < 1 then
		simDR_volume_nav2 = simDR_volume_nav2 + 0.1
	end
end
function nav2_volume_dn_CMDhandler(phase, duration)
	if phase == 0 and simDR_volume_nav2 >= 0.05 then
		simDR_volume_nav2 = simDR_volume_nav2 - 0.1
	end
end

-- Primer

function toggle_primer_CMDhandler(phase, duration)
	if phase == 0 then
		primer_target = 1 - primer_target
	end
end

--Drawer toggle
function drawer_toggle_CMDhandler(phase, duration)
    if phase == 0 then 
        drawer_target = 1 - drawer_target
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

--Windows toggle
function window_l_toggle_CMDhandler(phase, duration)
    if phase == 0 then
        window_l_target = 1 - window_l_target
    end
end

function window_r_toggle_CMDhandler(phase, duration)
    if phase == 0 then
        window_r_target = 1 - window_r_target
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
C152CMD_dome_light_toggle        = deferred_command("ZLSimulation/C152/electrical/dome_light_toggle", "toggle dome light", dome_light_tog_CMDhandler)
C152CMD_com2_volume_up           = deferred_command("ZLSimulation/C152/radios/com2_volume_up", "com2 volume up", com2_volume_up_CMDhandler)
C152CMD_com2_volume_dn           = deferred_command("ZLSimulation/C152/radios/com2_volume_dn", "com2 volume down", com2_volume_dn_CMDhandler)
C152CMD_nav2_volume_up           = deferred_command("ZLSimulation/C152/radios/nav2_volume_up", "nav2 volume up", nav2_volume_up_CMDhandler)
C152CMD_nav2_volume_dn           = deferred_command("ZLSimulation/C152/radios/nav2_volume_dn", "com2 volume down", nav2_volume_dn_CMDhandler)
C152CMD_primer_toggle            = deferred_command("ZLSimulation/C152/engine/primer_toggle", "toggle primer", toggle_primer_CMDhandler)
C152CMD_drawer_toggle            = deferred_command("ZLSimulation/C152/extras/drawer_toggle", "toggle drawer", drawer_toggle_CMDhandler)
C152CMD_right_door_toggle        = deferred_command("ZLSimulation/C152/extras/door_toggle_r", "toggle door", r_door_CMDhandler)
C152CMD_left_door_toggle         = deferred_command("ZLSimulation/C152/extras/door_toggle_l", "toggle door", l_door_CMDhandler)
C152CMD_window_l_toggle          = deferred_command("ZLSimulation/C152/extras/window_l_toggle", "toggle left window", window_l_toggle_CMDhandler)
C152CMD_window_r_toggle          = deferred_command("ZLSimulation/C152/extras/window_r_toggle", "toggle right window", window_r_toggle_CMDhandler)


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

--REPLACE NAV LIGHT COMMANDS
simCMD_nav_lights_tog              = replace_command("sim/lights/nav_lights_toggle", nav_light_toggle_CMDhandler)
simCMD_nav_lights_on               = replace_command("sim/lights/nav_lights_on", nav_light_on_CMDhandler)
simCMD_nav_lights_off              = replace_command("sim/lights/nav_lights_off", nav_light_off_CMDhandler)

--REPLACE FLAPS COMMANDS
simCMD_flaps_up                    = replace_command("sim/flight_controls/flaps_up", flaps_up_CMDhandler)
simCMD_flaps_down                  = replace_command("sim/flight_controls/flaps_down", flaps_dn_CMDhandler)

--REPLACE TRANSPONDER COMMANDS
simCMD_transponder_up              = replace_command("sim/transponder/transponder_up", transponder_up_CMDhandler)
simCMD_transponder_thousands_up    = replace_command("sim/transponder/transponder_thousands_up", transponder_thousands_up_CMDhandler)
simCMD_transponder_thousands_dn    = replace_command("sim/transponder/transponder_thousands_down", transponder_thousands_dn_CMDhandler)
simCMD_transponder_hundreds_up     = replace_command("sim/transponder/transponder_hundreds_up", transponder_hundreds_up_CMDhandler)
simCMD_transponder_hundreds_dn     = replace_command("sim/transponder/transponder_hundreds_down", transponder_hundreds_dn_CMDhandler)
simCMD_transponder_tens_up         = replace_command("sim/transponder/transponder_tens_up", transponder_tens_up_CMDhandler)
simCMD_transponder_tens_dn         = replace_command("sim/transponder/transponder_tens_down", transponder_tens_dn_CMDhandler)
simCMD_transponder_ones_up         = replace_command("sim/transponder/transponder_ones_up", transponder_ones_up_CMDhandler)
simCMD_transponder_ones_dn         = replace_command("sim/transponder/transponder_ones_down", transponder_ones_dn_CMDhandler)

--*************************************************************************************--
--**                                       CODE                                      **--
--*************************************************************************************--
function C152_set_animation_position(current_value, target, min, max, speed)

    local fps_factor = math.min(1.0, speed * SIM_PERIOD)

    if target >= (max - 0.001) and current_value >= (max - 0.01) then
        return max
    elseif target <= (min + 0.001) and current_value <= (min + 0.01) then
       return min
    else
        return current_value + ((target - current_value) * fps_factor)
    end

end

function func_animate_slowly(reference_value, animated_VALUE, anim_speed)
    if math.abs(reference_value - animated_VALUE) < 0.005 then return reference_value end
    animated_VALUE = animated_VALUE + ((reference_value - animated_VALUE) * (anim_speed * SIM_PERIOD))
    return animated_VALUE
end

function animate_drawer()
    C152_drawer = C152_set_animation_position(C152_drawer, drawer_target, 0.0, 1.0, 4)
end
function animate_windows()
    C152_window_l_open = C152_set_animation_position(C152_window_l_open, window_l_target, 0.0, 1.0, 3.5)
    C152_window_r_open = C152_set_animation_position(C152_window_r_open, window_r_target, 0.0, 1.0, 3.5)
end
function animate_primer()
	simDR_primer_ratio[0] = C152_set_animation_position(simDR_primer_ratio[0], primer_target, 0.0, 1.0, 4)
end

--*************************************************************************************--
--**                                    EVENT CALLBACKS                              **--
--*************************************************************************************--

--function aircraft_load()

function flight_start()
    print("XTLua flight start")
    C152_dome_light_sw = 0
end
--function aircraft_unload()

--function flight_crash()

--function before_physics()

function after_physics()
    animate_drawer()
    animate_windows()
	animate_primer()
	simDR_transponder_code = tonumber(C152_transponder_thousands..C152_transponder_hundreds..C152_transponder_tens..C152_transponder_ones)
end


--function after_replay()
