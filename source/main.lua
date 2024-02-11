import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import 'CoreLibs/frameTimer'
import 'CoreLibs/easing'
import 'CoreLibs/animation'

import "player"

local pd <const> = playdate
local gfx <const> = pd.graphics

Player(60,120)

function pd.update()
	gfx.sprite.update()
	pd.timer.updateTimers()
	playdate.frameTimer.updateTimers()
end
