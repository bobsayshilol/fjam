

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
	Key.note = i * 1 -- TODO
	
	Key.update = function(self, dt)
	end
	
	Key.draw = function(self)
		love.graphics.setColor(self.colour)
		love.graphics.rectangle("fill", self.x,self.y, self.w,self.h)
	end
	
	return Key
end

return ctor
