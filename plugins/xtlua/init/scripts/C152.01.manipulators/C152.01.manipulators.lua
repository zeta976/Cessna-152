--[[
*****************************************************************************************
* Script Name:
* Author Name:
* Script Description:
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


--*************************************************************************************--
--**                             CREATE CUSTOM DATAREFS                              **--
--*************************************************************************************--

C152_circuit_breakers = deferred_dataref("ZLSimulation/C152/electrical/circuit_breakers_position" , "array[11]") -- Dataref to hold circuit breaker position

