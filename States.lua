
local states = {}

states["splash"] = assert(require("SplashState"))
states["intro"] = assert(require("IntroState"))
states["game"] = assert(require("GameState"))

return states
