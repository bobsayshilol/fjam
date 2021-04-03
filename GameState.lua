
local class = {}
local Piano

function class.load()
	Piano = assert(require("Piano"))
end

function class.new()
	local state = {}
	
	state.enter = function(self)
	local w,h = love.graphics.getDimensions()
		self.npcPiano = Piano(w/32, h/16, w*14/32, h*14/16)
		self.playerPiano = Piano(w*17/32, h/16, w*14/32, h*14/16)
	end
	
	state.update = function(self, dt)
		self.npcPiano:update(dt)
		self.playerPiano:update(dt)
		return nil
	end
	
	state.draw = function(self)
		love.graphics.setColor(1, 1, 1)
		love.graphics.print("Game goes here", 10, 10)
		
		self.npcPiano:draw(dt)
		self.playerPiano:draw(dt)
	end
	
	state.keypressed = function(self, key)
		local keys = { 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']' }
		for i,k in pairs(keys) do
			if k == key then
				self.playerPiano:playKey(i)
			end
		end
	end
	
	return state
end

return class
