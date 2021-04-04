
local Spring = assert(require("Spring"))
local Key = assert(require("Key"))

local keyHeight = 0.08
local leftHeight = 0.42

local hitTolerance = 10
local showArcFor = 0.7
local arcWidth = math.pi / 16

local holes = {
	{ x = 0.18, y = keyHeight + leftHeight + 0.12, r = math.sqrt(0.18^2 + 0.12^2) },
	--{ x = 0.8, y = (keyHeight + leftHeight + 1) / 2, r = 0.07 },
}

local function applyCollisions(x,y, sx,sy, width,height)
	for u,hole in pairs(holes) do
		local hx,hy = sx + hole.x * width, sy + hole.y * height
		local dx,dy = (x - hx)/width, (y - hy)/height
		local l2 = dx^2 + dy^2
		if l2 < hole.r * hole.r then
			local l = math.sqrt(l2)
			dx,dy = dx/l, dy/l
			x = hx + dx * hole.r * width
			y = hy + dy * hole.r * height
		end
	end
	return x,y
end

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
	Piano.arcs = {}
	
	Piano.update = function(self, dt)
		for u,key in pairs(self.keys) do
			key:update(dt)
		end
		for u,spring in pairs(self.springs) do
			spring:update(dt)
		end
		
		-- Tick down visible arcs
		for u,arc in pairs(self.arcs) do
			arc.t = arc.t - dt
			-- Scale colour
			arc.colour[4] = arc.t / arc.t0
			-- Remove if done
			if arc.t < 0 then
				self.arcs[u] = nil
			end
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
		
		-- Holes
		if self.broken then
			for u,hole in pairs(holes) do
				local hx,hy = self.x + hole.x * self.width, self.y + hole.y * self.height
				local rx = self.width * hole.r
				local ry = self.height * hole.r
				love.graphics.ellipse("line", hx, hy, rx, ry)
			end
		end
		
		-- Hitboxes
		local oldWidth = love.graphics.getLineWidth()
		love.graphics.setLineWidth(hitTolerance)
		for u,arc in pairs(self.arcs) do
			love.graphics.setColor(arc.colour)
			love.graphics.arc("line", "open", arc.x,arc.y, arc.l, arc.a0,arc.a1)
		end
		love.graphics.setLineWidth(oldWidth)
	end
	
	Piano.playKey = function(self, key, show)
		self.keys[key]:press()
		local spring = self.springs[key]
		spring:twang()
		
		-- Calculate how close this was
		local sx,sy = spring.x0, spring.y0
		local baseL = spring.baseL
		local x,y = spring.x1, spring.y1
		local length = math.sqrt((x - sx) ^ 2 + (y - sy) ^ 2)
		local distance = math.abs(length - baseL)
		local closeness = 1 - math.min(math.max(distance - hitTolerance/2, 0) / hitTolerance, 1)
		
		-- Display it if requested
		if show then
			-- Calculate the angle to the player
			local angle = math.atan2(y - sy, x - sx)
			
			-- Pick a colour to show how close this was
			local colour = { 1 - closeness, closeness, 0 }
			
			-- Add the arc
			local arc = {
				x = sx, y = sy, l = baseL,
				a0 = angle + arcWidth, a1 = angle - arcWidth,
				t0 = showArcFor, t = showArcFor,
				colour = colour,
			}
			table.insert(self.arcs, arc)
		end
		
		return closeness
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
		
		-- Fixup any collisions
		x,y = applyCollisions(x,y, self.x,self.y, self.width,self.height)
		
		-- Update springs
		for u,spring in pairs(self.springs) do
			spring:setEndPos(x, y)
		end
	end

	return Piano
end

return ctor
