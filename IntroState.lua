
local class = {}

local lines = {
	"This is the intro",
	"It explains stuff",
	"I still need to write it",
}

function class.load()
end

function class.new()
	local SplashState = {}
	SplashState.line = 1
	SplashState.next = nil

	SplashState.update = function(self, dt)
		if self.line > #lines then
			return "splash"
		else
			return nil
		end
	end
	
	SplashState.keypressed = function(self, key)
		self.line = self.line + 1
	end
	
	SplashState.draw = function(self)
		love.graphics.print(lines[self.line], 10, 10)
	end

	return SplashState
end

return class
