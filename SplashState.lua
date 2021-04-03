
local class = {}

function class.load()
end

function class.new()
	local state = {}
	state.t = 0
	state.next = nil

	state.update = function(self, dt)
		self.t = self.t + dt
		return state.next
	end
	
	state.keypressed = function(self, key)
		print("Pressed at " .. self.t)
		state.next = "intro"
	end
	
	state.draw = function(self)
		love.graphics.print("Press any button to start", 10, 10)
	end

	return state
end

return class
