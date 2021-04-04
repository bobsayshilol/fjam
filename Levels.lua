

local hexagon4b =
	"k2n2m2r2k4k4" ..
	"k2n2m2r2k4k4" ..
	"k2n2m2r2k4k4" ..
	"k2n2m2r2k4k4Z0" ..
	
	"k4m4n4k4" ..
	"k4m4n4k4" ..
	"k4m4n4k4" ..
	"k4m4n4k4Z0" ..
	
	"k4r4u4p4" ..
	"k4r4u4p4" ..
	"p4r4u4y4" ..
	"z2y2u2r2w4p4Z0"


local fnf4b =
	"l4l4l1n1o1q1s2l4" ..
	"l2l2l2o2l2n2l2" ..
	"l4l4l1n1o1q1s2l4" ..
	"l2l2l2o2l2q1l1j2Z0"


local mega2b =
	"o1o1A2v2v1u2t2r2o1r1t1" ..
	"m1m1A2v2v1u2t2r2o1r1t1" ..
	"l1l1A2v2v1u2t2r2o1r1t1" ..
	"k1k1A2v2u1u2t2r2o1r1t1Z0"


local levels = {
	-- Custom must come first
	[0] = {
		name = "Custom",
		data = "3" ..
			"a1b1c1d1Z0" .. "e1f1g1h1Z0" .. "i1j1k1l1Z0" ..
			"m1n1o1p1Z0" .. "q1r1s1t1Z0" .. "u1v1w1x1Z0" ..
			"y1z1A1B1Z0" .. "C1D1E1F1Z0" .. "G1H1I1J1Z0",
	},
	
	-- 120bpm, 4b -> 8/s
	{
		name = "Hexagon (easy)",
		data = "8" .. hexagon4b,
	},
	
	-- 120bpm, 4b -> 8/s
	{
		name = "FNF (medium)",
		data = "8" .. fnf4b,
	},
	
	-- 120bpm, 2b -> 4/s
	{
		name = "Mega (medium)",
		data = "4" .. mega2b,
	},
	
	-- 180bpm, 4b -> 12/s
	{
		name = "Hexagon (hard)",
		data = "12" .. hexagon4b,
	},
	
	-- 180bpm, 2b -> 6/s
	{
		name = "Mega (hard)",
		data = "6" .. mega2b,
	},
	
	-- 180bpm, 4b -> 12/s
	{
		name = "FNF (hard)",
		data = "12" .. fnf4b,
	},
}

return levels
