
local fadeFactor = 4

local sharedSound
local function makeSound()
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
	return sound
end

function ctor(i, x0,y0, x1,y1)
	local Spring = {}
	Spring.x0 = x0
	Spring.y0 = y0
	Spring.x1 = x1
	Spring.y1 = y1
	Spring.amplitude = 0
	Spring.sound = makeSound()
	
	Spring.update = function(self, dt)
		if self.amplitude > 0.01 then
			self:shiftPitch()
			self.sound:setVolume(self.amplitude)
			self.amplitude = self.amplitude * (1 - fadeFactor * dt)
		else
			self.amplitude = 0
			self.sound:stop()
		end
	end
	
	Spring.draw = function(self)
		local amp = 0.2 + 0.8 * self.amplitude
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
	
	Spring.setEndPos = function(self, x,y)
		self.x1 = x
		self.y1 = y
		self:shiftPitch()
	end
	
	Spring.length = function(self)
		return math.sqrt((self.x0 - self.x1) ^ 2 + (self.y0 - self.y1) ^ 2)
	end
	Spring.baseL = Spring:length()
	
	Spring.shiftPitch = function(self)
		-- Fundamental frequency ~ 1/L
		-- ==> 2x length -> 2x Hz
		local shift = self:length() / self.baseL
		
		-- index 10 is A3
		local note = (i - 10) / 12
		self.sound:setPitch(2 ^ note * shift)
	end
	
	return Spring
end

return ctor
