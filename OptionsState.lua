
local class = {}

function class.load()
end

function class.new()
	local state = {}
	state.next = nil
	state.index = 1
	
	state.options = {
		{
			text = "Song",
			index = 1,
			values = {
				{ text = "FNF", func = function() g_globals.levelString = g_globals.fnf end },
				{ text = "Hexagon", func = function() g_globals.levelString = g_globals.hexagon end },
			},
	    },
	}
	
	state.update = function(self, dt)
		return state.next
	end
	
	state.keypressed = function(self, key)
		local option = self.options[self.index]
		if key == "escape" then
			state.next = "menu"
		elseif key == "up" then
			self.index = self.index - 1
		elseif key == "down" then
			self.index = self.index + 1
		elseif key == "left" then
			option.index = option.index - 1
		elseif key == "right" then
			option.index = option.index + 1
		end
		self.index = ((self.index - 1) % #self.options) + 1
		option.index = ((option.index - 1) % #option.values) + 1
	end
	
	state.draw = function(self)
		local text = ""
		for i,option in pairs(self.options) do
			if i == self.index then
				text = text .. " - "
			else
				text = text .. "   "
			end
			text = text .. option.text .. ": " .. option.values[option.index].text .. "\n"
		end
		love.graphics.print(text, 10, 10)
	end
	
	state.exit = function(self)
		for i,option in pairs(self.options) do
			option.values[option.index].func()
		end
	end

	return state
end

return class
