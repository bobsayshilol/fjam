
local class = {}

function class.load()
end

function class.new()
	local SplashState = {}
	SplashState.t = 0
	SplashState.next = nil

	SplashState.update = function(self, dt)
		self.t = self.t + dt
		return SplashState.next
	end
	
	SplashState.keypressed = function(self, key)
		print("Pressed at " .. self.t)
		SplashState.next = "intro"
	end
	
	SplashState.draw = function(self)
		love.graphics.print("Press any button to start", 10, 10)
	end

	return SplashState
end

return class
