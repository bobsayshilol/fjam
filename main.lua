
-- Globals
local g_curState
local g_states


-- Safely call a method
local function callMethod(obj, name, ...)
	local args = {...}
	local func = obj[name]
	if func then
		return func(obj, unpack(args))
	else
		return nil
	end
end

local function changeState(newState)
	print("Changing to state " .. newState)
	if g_curState ~= nil then
		callMethod(g_curState, "exit")
	end
	assert(g_states[newState])
	g_curState = g_states[newState].new()
	callMethod(g_curState, "enter")
end

local function setupStates()
	-- Add available state classes
	g_states = assert(require("States"))
	
	-- Perform any init
	for id,state in pairs(g_states) do
		print("Loading state " .. id)
		if state.load then
			state.load()
		end
	end
	
	-- Start with the splash state
	changeState("splash")
end


function love.load()
	setupStates()
end

function love.update(dt)
	local newState = g_curState:update(dt)
	if newState then
		changeState(newState)
	end
end

function love.draw()
	callMethod(g_curState, "draw")
end

function love.keypressed(key)
	callMethod(g_curState, "keypressed", key)
end