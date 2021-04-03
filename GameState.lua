
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

--[[
	--r--
	  q
	--o--
	  m
	--l--
	  j
	--h--
	  f
	--e--
]]
local function parseLevel(text)
	-- Format: <bps>(<key><time>)+
	local split = assert(text:find("%a"))
	local ts = 1000 / tonumber(text:sub(1, split - 1))
	text = text:sub(split)

	-- { time, note }
	local notes = {}
	local t = 0
	for note in string.gmatch(text, "%a%d+") do
		local n = decodeKey(note:sub(1, 1))
		table.insert(notes, { ts * t, n })
		t = t + tonumber(note:sub(2))
	end
	return notes
end

function class.load()
	Piano = assert(require("Piano"))
end

function class.new()
	local state = {}
	state.next = nil
	
	state.enter = function(self)
		local w,h = love.graphics.getDimensions()
		self.npcPiano = Piano(w/32, h/16, w*14/32, h*14/16)
		self.playerPiano = Piano(w*17/32, h/16, w*14/32, h*14/16)
		
		-- 180bpm, 4b -> 12/s
		self.notes = parseLevel("12" ..
			"c4c4c1e1f1h1j2c4" ..
			"c2c2c2f2c2e2c2" ..
			"c4c4c1e1f1h1j2c4" ..
			"c2c2c2f2c2h1c1a2"
			)
		
		-- 180bpm, 4b -> 12/s
		self.notes = parseLevel("12" ..
			"k2n2m2r2k4k4" ..
			"k2n2m2r2k4k4" ..
			"k2n2m2r2k4k4" ..
			"k2n2m2r2k4k4"
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
		return self.next
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
		
		if key == "escape" then
			state.next = "menu"
		end
	end
	
	state.exit = function(self)
		self.npcPiano:stop()
		self.playerPiano:stop()
	end
	
	return state
end

return class
