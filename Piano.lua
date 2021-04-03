
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
		local px = x + (i-1) * w
		table.insert(keys, Key(i, px, y, w, h))
	end
	return keys
end

local function makeSprings(x, y, width, height, octaves)
	local numKeys = octaves * 12
	local y0 = y + keyHeight * height
	local springs = {}
	for i = 1,numKeys do
		local rx = (i - 0.5) / numKeys
		local px = x + rx * width
		local py = y + backPosition(rx) * height
		table.insert(springs, Spring(px, y0, px, py))
	end
	return springs
end

local function makeBorder(x, y, width, height)
	local points = { 1,0, 0,0, }
	local steps = 10
	
	local dx = 1/steps
	for i = 0,steps do
		local x = dx * i
		local y = backPosition(x)
		table.insert(points, x)
		table.insert(points, y)
	end
	
	local border = {}
	for i = 1,#points/2 do
		table.insert(border, x + points[2*i-1]*width)
		table.insert(border, y + points[2*i-0]*height)
	end
	
	return border
end

function ctor(x, y, width, height)
	local Piano = {}
	local octaves = 3
	Piano.border = makeBorder(x, y, width, height)
	Piano.keys = makeKeys(x, y, width, height, octaves)
	Piano.springs = makeSprings(x, y, width, height, octaves)

	Piano.update = function(self, dt)
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
		love.graphics.polygon("line", self.border)
	end

	return Piano
end

return ctor
