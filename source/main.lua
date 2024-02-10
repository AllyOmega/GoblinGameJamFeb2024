import "CoreLibs/graphics"

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

-- Function to update speed line variations
function updateSpeedLineVariations(numberOfSpeedLines, speedLineLength)
    for i = 1, numberOfSpeedLines do
        speedLineVariations[i] = {
            offsetX = math.random(0, 20),
            offsetY = math.random(0, 20),
            length = speedLineLength + math.random(-10, 10) }
    end
end



function randNegative()
	
	if math.random() == 1 then
		return 1
	else
		return -1
	end
end


function speedLines()

end


function pd.update()
	gfx.clear()

    if turnCount % turbSpeed == 0 then
        altCenterX = centerX + turbVal*math.random()
        altCenterY = centerY + turbVal*math.random()
	-- else 
	-- 	altCenterX = centerX
	-- 	altCenterY = centerY
    end



	for i = 0, 10, 1 do
		if turnCount < 50 then
			gfx.drawCircleAtPoint(altCenterX, altCenterY, outerCircleRadius - turnCount - i)
		else 
			gfx.drawCircleAtPoint(altCenterX, altCenterY, outerCircleRadius - turnCount - i)
		end
	end

    gfx.fillCircleAtPoint(centerX, centerY, centralCircleRadius)
    gfx.drawCircleAtPoint(altCenterX, altCenterY, outerCircleRadius)

	


    for i = 1, numberOfTriangles do
        local angle = (math.pi * 2) * (i / numberOfTriangles)
        local edgeX = centerX + centralCircleRadius * math.cos(angle)
        local edgeY = centerY + centralCircleRadius * math.sin(angle)
        
        local widerAngleOffset = math.pi / numberOfTriangles / 2
        local tipX1 = altCenterX + outerCircleRadius * math.cos(angle - widerAngleOffset)
        local tipY1 = altCenterY + outerCircleRadius * math.sin(angle - widerAngleOffset)
        local tipX2 = altCenterX + outerCircleRadius * math.cos(angle + widerAngleOffset)
        local tipY2 = altCenterY + outerCircleRadius * math.sin(angle + widerAngleOffset)
        
        gfx.drawTriangle(edgeX, edgeY, tipX1, tipY1, tipX2, tipY2)
    end

    -- Calculate and draw each filled triangle to match half the size of the outlined triangles
	for i = 1, numberOfTriangles do
		local angle = (math.pi * 2) * (i / numberOfTriangles)
		local edgeX = centerX + centralCircleRadius * math.cos(angle)
		local edgeY = centerY + centralCircleRadius * math.sin(angle)
		
		local widerAngleOffset = math.pi / numberOfTriangles / 2
		-- Calculate midpoint between the central circle edge and the tip of the outlined triangle
		local midX1 = (edgeX + (altCenterX + outerCircleRadius * math.cos(angle - widerAngleOffset))) / 2
		local midY1 = (edgeY + (altCenterY + outerCircleRadius * math.sin(angle - widerAngleOffset))) / 2
		local midX2 = (edgeX + (altCenterX + outerCircleRadius * math.cos(angle + widerAngleOffset))) / 2
		local midY2 = (edgeY + (altCenterY + outerCircleRadius * math.sin(angle + widerAngleOffset))) / 2
	
		-- Use these midpoints as the tips for the filled triangles
		gfx.fillTriangle(edgeX, edgeY, midX1, midY1, midX2, midY2)

		
	end

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
        local startX = centerX + (outerCircleRadius + variation.offsetX) * math.cos(angle)
        local startY = centerY + (outerCircleRadius + variation.offsetY) * math.sin(angle)
        local endX = startX + variation.length * math.cos(angle)
        local endY = startY + variation.length * math.sin(angle)
        
        gfx.drawLine(startX, startY, endX, endY)
    end

	playdate.graphics.fillRoundRect(280, 5, 115, 230, 10) 

    turnCount -= 2
    turnCount %= 100

    -- Optional: Draw FPS, etc.
    pd.drawFPS(0, 0)
end
