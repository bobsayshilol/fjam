
local class = {}

function class.load()
end

function class.new()
	local state = {}
	state.next = nil
	state.nameText = nil
	state.bottomText = nil
	
	state.enter = function(self)
		local text = {
			{1, 0, 0}, "GAME",
			{0, 0, 0}, " ",
			{0, 1, 0}, "JAME",
			{0, 0, 0}, " ",
			{0, 0, 1}, "GAME",
		}
		local font = love.graphics.getFont()
		font:setFilter("nearest")
		state.nameText = love.graphics.newText(font, text)
		state.bottomText = love.graphics.newText(font, "Press space to start")
	end

	state.update = function(self, dt)
		return state.next
	end
	
	state.keypressed = function(self, key)
		if key == "space" or key == "return" then
			state.next = "menu"
		end
	end
	
	state.draw = function(self)
		local sw,sh = love.graphics.getDimensions()
		local ns = 10
		local bs = 4
		
		local nw,nh = state.nameText:getDimensions()
		love.graphics.draw(state.nameText, (sw - ns * nw)/2, (sh - ns * nh)*1/3, 0, ns, ns)
		
		local bw,bh = state.bottomText:getDimensions()
		love.graphics.draw(state.bottomText, (sw - bs * bw)/2, (sh - bs * bh)*2/3, 0, bs, bs)
	end
	
	state.exit = function(self)
		state.nameText = nil
		state.bottomText = nil
	end

	return state
end

return class
