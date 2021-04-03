
local fadeFactor = 4

local sharedSound
local function makeSound(i)
	if not sharedSound then
		-- 1s of audio @ A3
		local rate = 16000
		local soundData = love.sound.newSoundData(rate, rate, 16, 1)
		local hz = 220
		local w = hz * 2 * 3.14159 / rate
		for t = 1,rate do
			local s = math.sin(w * t) / 10
			soundData:setSample(t-1, s)
		end
		sharedSound = love.audio.newSource(soundData)
	end
	
	local sound = sharedSound:clone()
	sound:setLooping(true)
	-- index 10 is A3
	local note = (i - 10) / 12
	sound:setPitch(2 ^ note)
	return sound
end

function ctor(i, x0,y0, x1,y1)
	local Spring = {}
	Spring.x0 = x0
	Spring.y0 = y0
	Spring.x1 = x1
	Spring.y1 = y1
	Spring.amplitude = 0
	Spring.sound = makeSound(i)
	
	Spring.update = function(self, dt)
		if self.amplitude > 0.01 then
			self.sound:setVolume(self.amplitude)
			self.amplitude = self.amplitude * (1 - fadeFactor * dt)
		else
			self.amplitude = 0
			self.sound:stop()
		end
	end
	
	Spring.draw = function(self)
		local amp = self.amplitude
		love.graphics.setColor(amp, amp, 0)
		local oldWidth = love.graphics.getLineWidth()
		love.graphics.setLineWidth(6)
		love.graphics.line(self.x0,self.y0, self.x1,self.y1)
		love.graphics.setLineWidth(oldWidth)
	end
	
	Spring.twang = function(self)
		self.amplitude = 1
		self.sound:play()
	end
	
	Spring.stop = function(self)
		self.sound:stop()
	end
	
	return Spring
end

return ctor
