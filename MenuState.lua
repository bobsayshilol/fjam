
local class = {}

local buttons = {
	{ state = "intro", text = "Start" },
	{ state = "options", text = "Options" },
	{ state = "credits", text = "Credits" },
	{ state = "quit", text = "Quit" },
}

function class.load()
end

function class.new()
	local state = {}
	state.next = nil
	state.index = 1

	state.update = function(self, dt)
		return state.next
	end
	
	state.keypressed = function(self, key)
		if key == "return" then
			state.next = buttons[self.index].state
		elseif key == "up" then
			self.index = self.index - 1
		elseif key == "down" then
			self.index = self.index + 1
		end
		self.index = ((self.index - 1) % #buttons) + 1
	end
	
	state.draw = function(self)
		local text = ""
		for i,button in pairs(buttons) do
			if i == self.index then
				text = text .. " - "
			else
				text = text .. "   "
			end
			text = text .. button.text .. "\n"
		end
		love.graphics.print(text, 10, 10)
	end

	return state
end

return class
