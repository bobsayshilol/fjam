
-- Globals
g_globals = {}

-- 180bpm, 4b -> 12/s
g_globals.fnf = "12" ..
	"c4c4c1e1f1h1j2c4" ..
	"c2c2c2f2c2e2c2" ..
	"c4c4c1e1f1h1j2c4" ..
	"c2c2c2f2c2h1c1a2"

-- 180bpm, 4b -> 12/s
g_globals.hexagon = "12" ..
	"k2n2m2r2k4k4" ..
	"k2n2m2r2k4k4" ..
	"k2n2m2r2k4k4" ..
	"k2n2m2r2k4k4"

g_globals.levelString = g_globals.fnf


-- Locals
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
	-- TODO have this as minimum or something
	love.window.setMode(1366, 768, {minwidth=1280, minheight=720})
	
	love.window.setTitle("Jame Game")
	
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
