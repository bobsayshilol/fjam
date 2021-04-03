
local class = {}

local lines = {
	"The back of the Piano broke",
	"But it still needs to be played",
	"You must stretch the springs yourself",
	"Make it sound good or something",
}

function class.load()
end

function class.new()
	local state = {}
	state.line = 1

	state.update = function(self, dt)
		if self.line > #lines then
			return "game"
		else
			return nil
		end
	end
	
	state.keypressed = function(self, key)
		if key == "space" or key == "return" then
			self.line = self.line + 1
		end
	end
	
	state.draw = function(self)
		love.graphics.print(lines[self.line], 10, 10)
	end

	return state
end

return class
