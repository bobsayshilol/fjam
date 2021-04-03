
local class = {}

function class.load()
end

function class.new()
	local SplashState = {}
	SplashState.step = 0
	SplashState.next = nil

	SplashState.update = function(self, dt)
		return SplashState.next
	end
	
	SplashState.keypressed = function(self, key)
		SplashState.next = "splash"
	end
	
	SplashState.draw = function(self)
		love.graphics.print("This is the intro", 10, 10)
	end

	return SplashState
end

return class
