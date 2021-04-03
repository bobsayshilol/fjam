
local class = {}
local Piano

local function parseLevel(text)
	-- Format: <timestep>(<key><time>)+
	local split = assert(text:find("%a"))
	local ts = tonumber(text:sub(1, split - 1))
	text = text:sub(split)

	-- { time, note }
	local notes = {}
	for note in string.gmatch(text, "%a%d+") do
		local t = note:sub(2)
		local n = note:sub(1, 1):byte() - string.byte('a') + 1
		table.insert(notes, { ts * t, n })
	end
	return notes
end

function class.load()
	Piano = assert(require("Piano"))
end

function class.new()
	local state = {}
	
	state.enter = function(self)
		local w,h = love.graphics.getDimensions()
		self.npcPiano = Piano(w/32, h/16, w*14/32, h*14/16)
		self.playerPiano = Piano(w*17/32, h/16, w*14/32, h*14/16)
		
		self.notes = parseLevel("100a1b2c3d4e5f6g7h8i9j10k11l12m13n14o15p16a16a17")
		self.time = 0
	end
	
	state.update = function(self, dt)
		self.time = self.time + dt * 1000
		
		-- Play the next note
		while #self.notes > 0 and self.notes[1][1] < self.time do
			print(self.notes[1][1], self.notes[1][2])
			self.npcPiano:playKey(self.notes[1][2])
			table.remove(self.notes, 1)
		end
		
		-- Update the instruments
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
