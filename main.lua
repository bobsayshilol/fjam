
-- Globals
g_globals = {}

g_globals.levels = {
	-- Custom must come first
	[1] = {
		name = "Custom",
		data = "3" ..
			"a1b1c1d1Z0" .. "e1f1g1h1Z0" .. "i1j1k1l1Z0" ..
			"m1n1o1p1Z0" .. "q1r1s1t1Z0" .. "u1v1w1x1Z0" ..
			"y1z1A1B1Z0" .. "C1D1E1F1Z0" .. "G1H1I1J1Z0",
	},
	
	-- 180bpm, 4b -> 12/s
	[2] = {
		name = "FNF",
		data = "12" ..
			"l4l4l1n1o1q1s2l4" ..
			"l2l2l2o2l2n2l2" ..
			"l4l4l1n1o1q1s2l4" ..
			"l2l2l2o2l2q1l1j2Z0",
	},
	
	-- 180bpm, 4b -> 12/s
	[3] = {
		name = "Hexagon",
		data = "12" ..
			"k2n2m2r2k4k4" ..
			"k2n2m2r2k4k4" ..
			"k2n2m2r2k4k4" ..
			"k2n2m2r2k4k4Z0" ..
			
			"k4m4n4k4" ..
			"k4m4n4k4" ..
			"k4m4n4k4" ..
			"k4m4n4k4Z0" ..
			
			"k4r4u4p4" ..
			"k4r4u4p4" ..
			"p4r4u4y4" ..
			"z2y2u2r2w4p4Z0",
	},
}

g_globals.levelID = 3


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
	
	love.window.setTitle("GAME JAME GAME")
	
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

function love.textinput(text)
	callMethod(g_curState, "textinput", text)
end
