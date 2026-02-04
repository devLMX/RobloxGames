-- Variables

local image = script.parent.ImageLabel
local speed = 15

-- Functions


local function whenTweenCompleted(state) 
	if state == Enum.TweenStatus.Completed then 
		image.Position = UDim2.new(0,0,0,0) 
		image:TweenPosition(UDim2.new(-1,0,0,0), 
			"Out", 
			"Linear", 
			speed, 
			false, 
			whenTweenCompleted 
		) 
	end 
end 

-- Start

image:TweenPosition(UDim2.new(-1,0,0,0), 
	"Out", 
	"Linear", 
	speed, 
	false, 
	whenTweenCompleted 
)