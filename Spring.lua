
local sound

function ctor(x0,y0, x1,y1)
	local Spring = {}
	Spring.x0 = x0
	Spring.y0 = y0
	Spring.x1 = x1
	Spring.y1 = y1
	Spring.amplitude = 1
	
	Spring.update = function(self, dt)
		self.amplitude = self.amplitude * (1 - dt)
	end
	
	Spring.draw = function(self)
		local amp = self.amplitude
		love.graphics.setColor(amp, amp, 0)
		local oldWidth = love.graphics.getLineWidth()
		love.graphics.setLineWidth(6)
		love.graphics.line(self.x0,self.y0, self.x1,self.y1)
		love.graphics.setLineWidth(oldWidth)
	end
	
	Spring.twang = function(self)
		self.amplitude = 1
	end
	
	return Spring
end

return ctor
