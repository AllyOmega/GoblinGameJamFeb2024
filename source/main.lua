import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import 'CoreLibs/easing'
import 'CoreLibs/animation'
import 'CoreLibs/frameTimer'


import "cloud"
import "player"
import "score"
import "shadow"

local pd <const> = playdate
local gfx <const> = pd.graphics

local playerX, playerY = 200, 120
local playerRadius = 10
local playerSpeed = 3
local ballInc = 1

local screenWidth, screenHeight = playdate.display.getSize()
local centerX = screenWidth / 2 - 60
local centerY = screenHeight / 2
local centralCircleRadius = 20
local outerCircleRadius = 100
local numberOfTriangles = 16

local turbSpeed = 3
local turbVal = 10

altCenterX = centerX
altCenterY = centerY

turnCount = 100

local speedLineUpdateCounter = 0
local speedLineUpdateFrequency = 3 
local speedLineVariations = {} 

local gScore = Score()
gScore:setZIndex(32600)
gScore:addSprite()

gScore:setScore(0)




mainCloud = Cloud(centerX,centerY, 1)
altClouds = {
	Cloud(centerX-30, centerY-20, 0),
	Cloud(centerX+10, centerY - 20, 0),
	Cloud(centerX-30, centerY+10, 0),
	Cloud(centerX+10, centerY+10, 0),
	Cloud(centerX, centerY-30, 0),
	Cloud(centerX+30, centerY, 0)
}



-- Function to update speed line variations
function updateSpeedLineVariations(numberOfSpeedLines, speedLineLength)
    for i = 1, numberOfSpeedLines do
        speedLineVariations[i] = {
            offsetX = math.random(10, 20),
            offsetY = math.random(0, 20),
            length = speedLineLength + math.random(-10, 10) }
    end
end



function randNegative()
	
	if math.random(1,2) == 1 then
		return 1
	else
		return -1
	end
end


function speedLines()

end

Player(centerX, centerY)
local shadow = Shadow(centerX, centerY)

function pd.update()
	gfx.clear()
	gfx.sprite.update()
	
	--pd.timer.updateTimers()
	pd.frameTimer.updateTimers()

    if turnCount % turbSpeed == 0 then
        altCenterX = centerX + turbVal*math.random()*randNegative()
        altCenterY = centerY + turbVal*math.random()*randNegative()
	-- else 
	-- 	altCenterX = centerX
	-- 	altCenterY = centerY
    end
	
	



	-- for i = 0, 20, 10 do
	-- 	gfx.drawCircleAtPoint(centerX, centerY, outerCircleRadius + 50 - turnCount - i)
		
	-- end

    -- gfx.fillCircleAtPoint(centerX, centerY, centralCircleRadius)
    -- gfx.drawCircleAtPoint(altCenterX, altCenterY, outerCircleRadius)

	


    -- for i = 1, numberOfTriangles do
    --     local angle = (math.pi * 2) * (i / numberOfTriangles)
    --     local edgeX = centerX + centralCircleRadius * math.cos(angle)
    --     local edgeY = centerY + centralCircleRadius * math.sin(angle)
        
    --     local widerAngleOffset = math.pi / numberOfTriangles / 2
    --     local tipX1 = altCenterX + outerCircleRadius * math.cos(angle - widerAngleOffset)
    --     local tipY1 = altCenterY + outerCircleRadius * math.sin(angle - widerAngleOffset)
    --     local tipX2 = altCenterX + outerCircleRadius * math.cos(angle + widerAngleOffset)
    --     local tipY2 = altCenterY + outerCircleRadius * math.sin(angle + widerAngleOffset)
        
    --     gfx.drawTriangle(edgeX, edgeY, tipX1, tipY1, tipX2, tipY2)
    -- end

    -- -- Calculate and draw each filled triangle to match half the size of the outlined triangles
	-- for i = 1, numberOfTriangles do
	-- 	local angle = (math.pi * 2) * (i / numberOfTriangles)
	-- 	local edgeX = centerX + centralCircleRadius * math.cos(angle)
	-- 	local edgeY = centerY + centralCircleRadius * math.sin(angle)
		
	-- 	local widerAngleOffset = math.pi / numberOfTriangles / 2
	-- 	-- Calculate midpoint between the central circle edge and the tip of the outlined triangle
	-- 	local midX1 = (edgeX + (altCenterX + outerCircleRadius * math.cos(angle - widerAngleOffset))) / 2
	-- 	local midY1 = (edgeY + (altCenterY + outerCircleRadius * math.sin(angle - widerAngleOffset))) / 2
	-- 	local midX2 = (edgeX + (altCenterX + outerCircleRadius * math.cos(angle + widerAngleOffset))) / 2
	-- 	local midY2 = (edgeY + (altCenterY + outerCircleRadius * math.sin(angle + widerAngleOffset))) / 2
	
	-- 	-- Use these midpoints as the tips for the filled triangles
	-- 	gfx.fillTriangle(edgeX, edgeY, midX1, midY1, midX2, midY2)

		
	-- end

	local numberOfSpeedLines = numberOfTriangles* 1.5  -- Adjust for more or fewer lines
	local speedLineLength = outerCircleRadius  -- Length of each speed line
	
    if speedLineUpdateCounter % speedLineUpdateFrequency == 0 then
        updateSpeedLineVariations(numberOfSpeedLines, speedLineLength)
    end
    speedLineUpdateCounter += 1

    -- Drawing speed lines with current variations
    for i = 1, numberOfSpeedLines do
        local variation = speedLineVariations[i] or {offsetX = 0, offsetY = 0, length = speedLineLength}
        local angle = (math.pi * 2) * (i / numberOfSpeedLines)
        
        -- Apply variations
        local startX = altCenterX + (outerCircleRadius + variation.offsetX) * math.cos(angle)
        local startY = altCenterY + (outerCircleRadius + variation.offsetY) * math.sin(angle)
        local endX = startX + variation.length * math.cos(angle)
        local endY = startY + variation.length * math.sin(angle)
        
        gfx.drawLine(startX, startY, endX, endY)
    end

	gfx.fillRoundRect(280, 5, 115, 230, 10) 
	gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
	gfx.drawText("Score:", 310, 130)
	gScore:draw(320, 160)

    turnCount -= 5
    turnCount %= 100

	if turnCount % 10 == 0 then
		gScore:addOne()
		shadow.setVals()
	end 

	if turnCount % 5 == 0 then
		if mainCloud:getScale() >= 12 then
			mainCloud:setScale(.5)
			shadow:setValScale(.02)
			shadow:setValReset(centerX, centerY)
			gScore:setScore(gScore:getScore()+100)
		else
			mainCloud:setScale(mainCloud:getScale()*1.01)
			shadow:setValScale(shadow:getValScale()*1.01)

			
		end

		for i = 1, #altClouds do
			local cloud = altClouds[i]
			--newX = cloud.x + 2*math.random()*randNegative()
			--newY = cloud.y + 2*math.random()*randNegative()
			newX = cloud.x + 0.01*(cloud.x - centerX)
			newY = cloud.y + 0.01*(cloud.y - centerY)
			cloud:moveTo(newX, newY)
			if cloud:getScale() >= 3.5 then
				cloud:setScale(.5)
				cloud:moveTo(centerX + math.random(10,40)*randNegative(), centerY+math.random(10,40)*randNegative())
			else
				cloud:setScale(cloud:getScale()*cloud.randGrow)
			end
		end
	end
	mainCloud:moveTo(centerX-mainCloud.width/2, centerY-mainCloud.width/2)
	shadow:setScale(5)


	--altClouds[1]:moveTo(altCenterX-altClouds[1].width/2, altCenterY-altClouds[1].width/2)


    -- Optional: Draw FPS, etc.
    pd.drawFPS(0, 0)
end
