
local class = {}
local Piano

function class.load()
	Piano = assert(require("Piano"))
end

function class.new()
	local state = {}
	
	state.enter = function(self)
	local w,h = love.graphics.getDimensions()
		self.piano = Piano(w/32, h/16, w*14/32, h*14/16)
	end
	
	state.update = function(self, dt)
		self.piano:update(dt)
		return nil
	end
	
	state.draw = function(self)
		love.graphics.setColor(1, 1, 1)
		love.graphics.print("Game goes here", 10, 10)
		
		self.piano:draw(dt)
	end

	return state
end

return class
