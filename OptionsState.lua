

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
		
		-- All the available options
		local g_levelString = g_globals.levels[0]
		state.options = {
			{
				text = "Song: " .. g_globals.levels[g_globals.levelID].name,
				inc = function(o, s)
						g_globals.levelID = (g_globals.levelID + 1) % (#g_globals.levels + 1)
						o.text = "Song: " .. g_globals.levels[g_globals.levelID].name
					end,
				dec = function(o, s)
						g_globals.levelID = (g_globals.levelID - 1) % (#g_globals.levels + 1)
						o.text = "Song: " .. g_globals.levels[g_globals.levelID].name
					end,
			},
			{
				text = "Custom song",
				input = true,
				value = g_levelString,
			},
			{
				text = "Copy custom from clipboard",
				change = function(o, s) g_levelString.data = love.system.getClipboardText() end,
			},
			{
				text = "Copy custom to clipboard",
				change = function(o, s) love.system.setClipboardText(g_levelString.data) end,
			},
			{
				text = "Ready",
				change = function(o, s) s.next = "menu" end,
			},
		}
	end
	
	state.update = function(self, dt)
		return state.next
	end
	
	state.keypressed = function(self, key)
		local option = self.options[self.index]
		if key == "return" then
			if option.change then
				option:change(self)
			end
		elseif key == "up" then
			self.index = self.index - 1
		elseif key == "down" then
			self.index = self.index + 1
		elseif key == "left" then
			if option.dec then
				option:dec(self)
			end
		elseif key == "right" then
			if option.inc then
				option:inc(self)
			end
		elseif key == "backspace" then
			if option.input then
				local val = option.value
				val.data = val.data:sub(1, -2)
			end
		end
		self.index = ((self.index - 1) % #self.options) + 1
	end
	
	state.textinput = function(self, text)
		local option = self.options[self.index]
		if option.input then
			local val = option.value
			val.data = val.data .. text
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
		for i,option in pairs(self.options) do
			if i == self.index then
				text = text .. " - "
			else
				text = text .. "   "
			end
			text = text .. option.text
			if option.value then
				text = text .. ": " .. wrap(option.value.data, 64)
			end
			text = text .. "\n"
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
		-- Remove reference to text
		state.allText = nil
		state.options = nil
		
		-- Reset the repeat state
		love.keyboard.setKeyRepeat(false)
	end

	return state
end

return class
