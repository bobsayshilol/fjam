
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
	if ch == 'Z' then
		-- Magic value
		return -1
	elseif ch:find('%l') then
		return ch:byte() - string.byte('a') + 1
	elseif ch:find('%u') then
		return ch:byte() - string.byte('A') + 27
	else
		assert(false)
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
		self.npcPiano = Piano(w/32, h/16, w*14/32, h*14/16, false)
		self.playerPiano = Piano(w*17/32, h/16, w*14/32, h*14/16, true)
		
		local level = g_globals.levelString
		print("Loading level '" .. level .. "'")
		self.npcTurn = true
		self.npcState = { time = 0, piano = self.npcPiano, notes = parseLevel(level), score = 0 }
		self.playerState = { time = 0, piano = self.playerPiano, notes = parseLevel(level), score = 0 }
	end
	
	state.updateNotes = function(self, dt, info)
		info.time = info.time + dt * 1000
		
		-- Play the next note
		while #info.notes > 0 and info.notes[1][1] < info.time do
			local note = info.notes[1][2]
			if note ~= -1 then
				local score = info.piano:playKey(note, not self.npcTurn)
				info.score = info.score + score
			end
			table.remove(info.notes, 1)
			if note == -1 then
				self.npcTurn = not self.npcTurn
				break
			end
		end
	end
	
	state.update = function(self, dt)
		if self.npcTurn then
			self:updateNotes(dt, self.npcState)
		else
			local oldScore = self.playerState.score
			self:updateNotes(dt, self.playerState)
			local deltaScore = self.playerState.score - oldScore
			if deltaScore > 0 then
				-- TODO: anything here?
			end
		end
		
		-- Update positions of the springs
		self.playerPiano:setEndPos(love.mouse.getPosition())
		
		-- Update the instruments
		self.npcPiano:update(dt)
		self.playerPiano:update(dt)
		return self.next
	end
	
	state.draw = function(self)
		love.graphics.setColor(1, 1, 1)
		love.graphics.print("Press escape to return to the menu", 10, 10)
		
		self.npcPiano:draw(dt)
		self.playerPiano:draw(dt)
		
		-- Draw our score
		love.graphics.setColor(1, 1, 1)
		local w,h = love.graphics.getDimensions()
		love.graphics.print("Score: " .. math.floor(self.playerState.score * 100), w/2, 10)
	end
	
	state.keypressed = function(self, key)
		local keys = {
			'1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=',
			'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']',
			'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', '\'', '#',
		}
		for i,k in pairs(keys) do
			if k == key then
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
