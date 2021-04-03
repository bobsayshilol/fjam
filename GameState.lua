
local class = {}
local Piano

local function encodeKey(key)
	if key <= 26 then
		return string.char(string.byte('a') + key - 1)
	else
		return string.char(string.byte('A') + key - 27)
	end
end

local function decodeKey(ch)
	if ch:find('%l') then
		return ch:byte() - string.byte('a') + 1
	else
		return ch:byte() - string.byte('A') + 27
	end
end

local function parseLevel(text)
	-- Format: <bps>(<key><time>)+
	local split = assert(text:find("%a"))
	local ts = 1000 / tonumber(text:sub(1, split - 1))
	text = text:sub(split)

	-- { time, note }
	local notes = {}
	for note in string.gmatch(text, "%a%d+") do
		local t = note:sub(2)
		local n = decodeKey(note:sub(1, 1))
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
		
		-- 180bpm, 4b -> 12/s
		self.notes = parseLevel("12" ..
			"c0c4c8e9f10h11j12c14" ..
			"c16c18c22f24c26e28c30" ..
			"c32c36c40e41f42h43j44c46" ..
			"c48c50c54f56c58h60c61a62"
			)
		
		--[[
		local notes = "10"
		for i = 1,3*12 do
			notes = notes .. encodeKey(i) .. i
		end
		print(notes)
		self.notes = parseLevel(notes)
		--]]
		self.time = 0
	end
	
	state.update = function(self, dt)
		self.time = self.time + dt * 1000
		
		-- Play the next note
		while #self.notes > 0 and self.notes[1][1] < self.time do
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
				print(encodeKey(i) .. math.floor(self.time / 120 + 0.5))
				self.playerPiano:playKey(i)
			end
		end
	end
	
	return state
end

return class
