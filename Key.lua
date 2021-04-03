
function ctor(i, x, y, w, h)
	local Key = {}
	Key.x = x
	Key.y = y
	Key.w = w
	Key.h = h
	
	local im = (i - 1) % 12
	local colour
	if im > 4 then
		colour = (im % 2)
	else
		colour = 1 - (im % 2)
	end
	Key.colour = { colour, colour, colour }
	Key.baseColour = colour
	
	Key.update = function(self, dt)
		for u,c in pairs(self.colour) do
			self.colour[u] = c * (1 - dt) + self.baseColour * dt
		end
	end
	
	Key.draw = function(self)
		love.graphics.setColor(self.colour, self.colour, self.colour)
		love.graphics.rectangle("fill", self.x,self.y, self.w,self.h)
	end
	
	Key.press = function(self)
		self.colour = { 1, 0, 0 }
	end
	
	return Key
end

return ctor
