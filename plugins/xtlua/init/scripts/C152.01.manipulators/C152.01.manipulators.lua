--[[
*****************************************************************************************

Copyright Alejandro Zuluaga 2021. All rights reserved

This file and its contents are suplied under the terms of the
Creative Commons Attribution 4.0 International Public License (CC BY-NC 4.0)

*****************************************************************************************
--]]

--replace create_command
function deferred_command(name,desc,nilFunc)
	c = XLuaCreateCommand(name,desc)
	--print("Deferred command: "..name)
	--XLuaReplaceCommand(c,null_command)
	return nil --make_command_obj(c)
end

--replace create_dataref
function deferred_dataref(name,type,notifier)
	--print("Deffereed dataref: "..name)
	dref=XLuaCreateDataRef(name, type,"yes",notifier)
	return wrap_dref_any(dref,type)
end

--*************************************************************************************--
--**                             CREATE CUSTOM COMMANDS                              **--
--*************************************************************************************--



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
--**                             CREATE CUSTOM DATAREFS                              **--
--*************************************************************************************--
C152_alternator_switch    = deferred_dataref("ZLSimulation/C152/electrical/alternator_switch", "number") --Dataref to hold alternator switch position
C152_circuit_breakers     = deferred_dataref("ZLSimulation/C152/electrical/circuit_breakers_position" , "array[11]")
C152_landing_light_switch = deferred_dataref("ZLSimulation/C152/electrical/landing_light_switch", "number")
C152_pitot_heat_switch    = deferred_dataref("ZLSimulation/C152/electrical/pitot_heat_switch", "number")
C152_beacon_light_switch  = deferred_dataref("ZLSimulation/C152/electrical/beacon_light_switch", "number")
C152_fuel_indicator_left  = deferred_dataref("ZLSimulation/C152/electrical/fuel_indicator_L", "number")
C152_fuel_indicator_right = deferred_dataref("ZLSimulation/C152/electrical/fuel_indicator_R", "number")
C152_flap_lever           = deferred_dataref("ZLSimulation/C152/electrical/flap_lever", "number")
C152_drawer               = deferred_dataref("ZLSimulation/C152/extras/drawer", "number") --Dataref to hold drawer positions
