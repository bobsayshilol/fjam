
local Spring = assert(require("Spring"))
local Key = assert(require("Key"))

local keyHeight = 0.08
local leftHeight = 0.42

local function backPosition(x)
	local y0 = keyHeight + leftHeight
	return y0 / (1 - x * (1 - y0))
end

local function makeKeys(x, y, width, height, octaves)
	-- TODO: the w/b keys are wrong sizes
	local numKeys = octaves * 12
	local w = width / numKeys
	local h = height * keyHeight

	local keys = {}
	for i = 1,numKeys do
		local px = x + (numKeys - i) * w
		table.insert(keys, Key(i, px, y, w, h))
	end
	return keys
end

local function makeSprings(x, y, width, height, octaves)
	local numKeys = octaves * 12
	local y0 = y + keyHeight * height
	local springs = {}
	for i = 1,numKeys do
		local rx = (numKeys - i + 0.5) / numKeys
		local px = x + rx * width
		local py = y + backPosition(rx) * height
		table.insert(springs, Spring(i, px, y0, px, py))
	end
	return springs
end

local function makeBorder(x, y, width, height, broken)
	local points = { 1,0, 0,0, }
	local steps = 10
	
	if broken then
		-- Only the endpoints when broken
		points = { 1,backPosition(1), 1,0, 0,0, 0,backPosition(0) }
	else
		local dx = 1/steps
		for i = 0,steps do
			local x = dx * i
			local y = backPosition(x)
			table.insert(points, x)
			table.insert(points, y)
		end
	end
	
	local border = {}
	for i = 1,#points/2 do
		table.insert(border, x + points[2*i-1]*width)
		table.insert(border, y + points[2*i-0]*height)
	end
	
	return border
end

function ctor(x, y, width, height, broken)
	local Piano = {}
	local octaves = 3
	Piano.border = makeBorder(x, y, width, height, broken)
	Piano.springs = makeSprings(x, y, width, height, octaves)
	Piano.keys = makeKeys(x, y, width, height, octaves)
	Piano.x = x
	Piano.y = y
	Piano.width = width
	Piano.height = height
	Piano.broken = broken
	
	Piano.update = function(self, dt)
		for u,key in pairs(self.keys) do
			key:update(dt)
		end
		for u,spring in pairs(self.springs) do
			spring:update(dt)
		end
	end
	
	Piano.draw = function(self)
		-- Springs
		for u,spring in pairs(self.springs) do
			spring:draw()
		end
		
		-- Keys
		for u,key in pairs(self.keys) do
			key:draw()
		end
		
		-- Full border
		love.graphics.setColor(1, 1, 1)
		if self.broken then
			-- We don't want a complete polygon since the back must be open
			love.graphics.line(self.border)
		else
			love.graphics.polygon("line", self.border)
		end
	end
	
	Piano.playKey = function(self, key)
		self.keys[key]:press()
		self.springs[key]:twang()
	end
	
	Piano.stop = function(self)
		for u,spring in pairs(self.springs) do
			spring:stop()
		end
	end
	
	Piano.setEndPos = function(self, x,y)
		-- Clamp to bounds
		if x < self.x then x = self.x end
		
		local r = self.x + self.width
		if x > r then x = r end
		
		local y0 = self.y + keyHeight * self.height
		if y < y0 then y = y0 end
		
		local bp
		if self.broken then
			bp = self.height
		else
			bp = backPosition((x - self.x) / width) * self.height
		end
		local y1 = self.y + bp
		if y > y1 then y = y1 end
		
		-- Update springs
		for u,spring in pairs(self.springs) do
			spring:setEndPos(x, y)
		end
	end

	return Piano
end

return ctor
