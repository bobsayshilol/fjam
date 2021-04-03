
local class = {}

local lines = {
	"This is the intro",
	"It explains stuff",
	"I still need to write it",
}

function class.load()
end

function class.new()
	local state = {}
	state.line = 1
	state.next = nil

	state.update = function(self, dt)
		if self.line > #lines then
			return "splash"
		else
			return nil
		end
	end
	
	state.keypressed = function(self, key)
		self.line = self.line + 1
	end
	
	state.draw = function(self)
		love.graphics.print(lines[self.line], 10, 10)
	end

	return state
end

return class
