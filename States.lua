
local states = {}

states["splash"] = assert(require("SplashState"))
states["menu"] = assert(require("MenuState"))
states["options"] = assert(require("OptionsState"))
states["credits"] = assert(require("DummyState"))
states["quit"] = assert(require("QuitState"))
states["intro"] = assert(require("IntroState"))
states["game"] = assert(require("GameState"))

return states
