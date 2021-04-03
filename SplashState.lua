
local class = {}

function class.load()
end

function class.new()
	local state = {}
	state.next = nil

	state.update = function(self, dt)
		return state.next
	end
	
	state.keypressed = function(self, key)
		if key == "space" or key == "return" then
			state.next = "menu"
		end
	end
	
	state.draw = function(self)
		love.graphics.print("Press space to start", 10, 10)
	end

	return state
end

return class
