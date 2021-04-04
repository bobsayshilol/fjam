
local g_levelString = { text = "3" ..
	"a1b1c1d1Z0" .. "e1f1g1h1Z0" .. "i1j1k1l1Z0" ..
	"m1n1o1p1Z0" .. "q1r1s1t1Z0" .. "u1v1w1x1Z0" ..
	"y1z1A1B1Z0" .. "C1D1E1F1Z0" .. "G1H1I1J1Z0"
}

local options = {
	{
		text = "Song",
		index = 1,
		input = false,
		values = {
			{ text = "Hexagon", func = function() g_globals.levelString = g_globals.hexagon end },
			{ text = "FNF", func = function() g_globals.levelString = g_globals.fnf end },
			{ text = "Custom", func = function() g_globals.levelString = g_levelString.text end },
		},
	},
	{
		text = "Custom song",
		index = 1,
		input = true,
		values = {
			g_levelString,
		},
	},
}

local class = {}

function class.load()
end

function class.new()
	local state = {}
	state.next = nil
	state.index = 1
	
	state.enter = function(self)
		-- We want repeats for backspace
		love.keyboard.setKeyRepeat(true)
		
		-- UI text
		local font = love.graphics.getFont()
		font:setFilter("nearest")
		state.allText = love.graphics.newText(font, "")
	end
	
	state.update = function(self, dt)
		return state.next
	end
	
	state.keypressed = function(self, key)
		local option = options[self.index]
		if key == "return" then
			state.next = "menu"
		elseif key == "up" then
			self.index = self.index - 1
		elseif key == "down" then
			self.index = self.index + 1
		elseif key == "left" then
			option.index = option.index - 1
		elseif key == "right" then
			option.index = option.index + 1
		elseif option.input then
			local val = option.values[1]
			if key == "backspace" then
				val.text = val.text:sub(1, -2)
			end
		end
		self.index = ((self.index - 1) % #options) + 1
		option.index = ((option.index - 1) % #option.values) + 1
	end
	
	state.textinput = function(self, text)
		local option = options[self.index]
		if option.input then
			local val = option.values[1]
			val.text = val.text .. text
		end
	end
	
	state.draw = function(self)
		local function wrap(t, i)
			if t:len() > i then
				local output = ""
				local spacer = "\n    "
				while t:len() > i do
					output = output .. "\n    " .. t:sub(1, i)
					t = t:sub(i + 1)
				end
				return output .. spacer .. t
			else
				return t
			end
		end
		
		local text = ""
		for i,option in pairs(options) do
			if i == self.index then
				text = text .. " - "
			else
				text = text .. "   "
			end
			text = text .. option.text .. ": " .. wrap(option.values[option.index].text, 64) .. "\n"
		end
		
		-- Update the text
		state.allText:set(text)
		
		-- Draw it
		local sw,sh = love.graphics.getDimensions()
		local scale = 2
		local w,h = state.allText:getDimensions()
		love.graphics.draw(state.allText, (sw - scale * w)/2, (sh - scale * h)/2, 0, scale, scale)
	end
	
	state.exit = function(self)
		for i,option in pairs(options) do
			local func = option.values[option.index].func
			if func then
				func()
			end
		end
		
		-- Remove reference to text
		state.allText = nil
		
		-- Reset the repeat state
		love.keyboard.setKeyRepeat(false)
	end

	return state
end

return class
