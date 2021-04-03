
local Spring = assert(require("Spring"))
local Key = assert(require("Key"))

local keyHeight = 0.08
local leftHeight = 0.42

local function makeKeys(x, y, width, height, octaves)
	-- TODO: the w/b keys are all wrong
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

local function makeBorder(x, y, width, height)
	local points = { 1,0, 0,0, }
	local y0 = keyHeight + leftHeight
	local steps = 10
	
	local dx = 1/steps
	for i = 0,steps do
		local x = dx * i
		local y = y0 / (1 - x * (1 - y0))
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
	Piano.springs = {}
	Piano.border = makeBorder(x, y, width, height)
	Piano.keys = makeKeys(x, y, width, height, 2)

	Piano.update = function(self, dt)
		for u,spring in pairs(self.springs) do
			spring:update(dt)
		end
	end
	
	Piano.draw = function(self)
		-- Full border
		love.graphics.setColor(1, 1, 1)
		love.graphics.polygon("line", self.border)
		
		-- Keys
		for u,key in pairs(self.keys) do
			key:draw()
		end
		
		-- Springs
		for u,spring in pairs(self.springs) do
			spring:draw()
		end
	end

	return Piano
end

return ctor
