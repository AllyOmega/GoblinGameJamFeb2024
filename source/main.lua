import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import 'CoreLibs/easing'
import 'CoreLibs/animation'
import 'CoreLibs/frameTimer'
import 'CoreLibs/ui'

import "cloud"
import "player"
import "score"
import "shadow"

local pd <const> = playdate
local gfx <const> = pd.graphics

--! Game States
local kGameState = {initial, ready, playing, paused, over}
local currentState = kGameState.initial

local kGameInitialState, kGameGetReadyState, kGamePlayingState, kGamePausedState, kGameOverState = 0, 1, 2, 3, 4
local gameState = kGameInitialState

--



local maxBackgroundPlanes = 1
local backgroundPlaneCount = 0
local bgY = 0
local bgH = 0

local gameSpeed = 1.01 -- do NOT change for now, buggy

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

local shadowMoveX = 0.01
local shadowMoveY = 0.005

altCenterX = centerX
altCenterY = centerY

turnCount = 100

local speedLineUpdateCounter = 0
local speedLineUpdateFrequency = 10
local speedLineVariations = {}

local msg = "Score:"

local lives = 1

local shadStr, playStr = "", ""

local gScore = Score()
gScore:setZIndex(32767)
gScore:addSprite()

local spritelib = gfx.sprite
local titleSprite = spritelib.new()
--titleSprite:setImage(gfx.image.new('images/getReady'))
-- titleSprite:moveTo(centerX, centerY)
-- titleSprite:setZIndex(32767)
titleSprite:addSprite()


local ticks = 0
local buttonDown = false

mainCloud = Cloud(centerX,centerY+30, 1)
altClouds = {
	Cloud(centerX-30, centerY-20, 0),
	Cloud(centerX+10, centerY - 20, 0),
	Cloud(centerX-30, centerY+10, 0),
	Cloud(centerX+10, centerY+10, 0),
	Cloud(centerX, centerY-30, 0),
	Cloud(centerX+30, centerY, 0)
}


-- local function createBackgroundSprite()

-- 	local bg = gfx.sprite.new()
-- 	local bgImg = gfx.image.new('images/background')
-- 	local w, h = bgImg:getSize()
-- 	bgH = h
-- 	bg:setBounds(0, 0, 400, 240)

-- 	function bg:draw(x, y, width, height)
-- 		bgImg:draw(0, bgY)
-- 		bgImg:draw(0, bgY-bgH)

-- 	end

-- 	function bg:update()
-- 		bgY += 1
-- 		if bgY > bgH then
-- 			bgY = 0
-- 		end
-- 		self:markDirty()
-- 	end

-- 	bg:setZIndex(0)
-- 	bg:add()
-- end

local function createBackgroundPlane()

	local plane = gfx.sprite.new()
	local planeImg
	local planeRot = math.random(360)

	planeImg = gfx.image.new('images/plane1')

	local w, h = planeImg:getSize()
	plane:setImage(planeImg)
	plane:setRotation(planeRot - 90)
	plane:moveTo(math.random(400), -math.random(70))
	plane:add()

	backgroundPlaneCount += 1

	local planeRotRad = math.rad(planeRot)

	function plane:update()

		local newY = plane.y + (2*math.sin(planeRotRad))
		local newX = plane.x + (2*math.cos(planeRotRad))

		if newY > 400 + h or newY < 0 - h then
			plane:remove()
			backgroundPlaneCount -= 1
		else
			plane:moveTo(newX, newY)
		end
	end


	plane:setZIndex(math.random(100))
	return plane
end

local function spawnBackgroundPlaneIfNeeded()
	if backgroundPlaneCount < maxBackgroundPlanes then
		if math.random(math.floor(120/maxBackgroundPlanes)) == 1 then
			createBackgroundPlane()
		end
	end
end


local function gameOver()

	gameState = kGameOverState
	gfx.setImageDrawMode(gfx.kDrawModeCopy)
	gfx.image.new('images/gameOver'):draw(centerX-75, centerY-20)
	ticks=0


end

local function startGame()

	gameState = kGameGetReadyState
	ticks = 0
	gScore:setScore(0)

	titleSprite:setImage(gfx.image.new('images/getReady'))
	titleSprite:moveTo(centerX, centerY)
	titleSprite:setZIndex(32767)
	titleSprite:setVisible(true)
		
end

-- function pd.gameWillPause()
	
-- 	-- local img = gfx.image.new('menuImage')

-- 	gfx.lockFocus(img)
-- 	gfx.setFont(gScore.scoreFont)
-- 	gfx.drawTextAligned(gScore.score, 200, 6, kTextAlignment.right)

-- end


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

local player = Player(centerX, centerY)
local shadow = Shadow(centerX, centerY + 30)

function pd.update()

	ticks = ticks+1

	if gameState == kGameInitialState then 

		gfx.setColor(gfx.kColorWhite)
		gfx.fillRect(0, 0, screenWidth, screenHeight)
		local startButton = gfx.image.new('images/startButton')
		local y = screenHeight/2 - startButton.height/2
		if buttonDown == false then
		
			y -= 3
		
		end
		startButton:draw(screenWidth/2- startButton.width/2, y)
		gfx.setColor(gfx.kColorBlack)

	elseif gameState == kGameGetReadyState then

		spritelib.update()

		if ticks > 30 then
			gameState = kGamePlayingState
			titleSprite:setVisible(false)
		end
	elseif gameState == kGamePlayingState then
		
	
		spritelib.update()
		pd.frameTimer.updateTimers()

		spawnBackgroundPlaneIfNeeded()
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
	
		local numberOfSpeedLines = numberOfTriangles * 1.5  -- Adjust for more or fewer lines
		local speedLineLength = outerCircleRadius  -- Length of each speed line
		
		if speedLineUpdateCounter % speedLineUpdateFrequency == 0 then
			updateSpeedLineVariations(numberOfSpeedLines, speedLineLength)
		end
		speedLineUpdateCounter += 1
		
		--Drawing speed lines with current variations
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
		gfx.setImageDrawMode(gfx.kDrawModeInverted)
		
		if lives ~= 0 then
			for i = 1, lives do
				gfx.image.new('images/leftArm'):draw(260 + 35*i, 20 )
			end
		end
		
		gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
		
		
		--gfx.drawText(shadStr, 290, 50)
		--gfx.drawText(playStr, 290, 90)
		

		turnCount -= 5
		turnCount %= 100

		if turnCount % 10 == 0 then
			gScore:addOne()
			shadow:setVals(shadowMoveX, shadowMoveY, gameSpeed)
			shadowMoveX += 0.0014
			shadowMoveY += 0.001
		end
		if turnCount % 5 == 0 then
			if mainCloud:getScale() >= 25 then

				mainCloud:setScale(.5)
				shadow:setValScale(.02*gameSpeed)
				
				shadowMoveX = 0.01
				shadowMoveY = 0.005
				
				

				shadowArr = shadow:getPos()
				playerArr = player:getPos()

				shadStr = ""
				playStr = ""

				for i = 1, #playerArr do
					local playerDegree = playerArr[i]
					local targetDegree = shadowArr[i]
					

					shadStr = shadStr .. tostring(targetDegree) .. " "

					playStr = playStr .. tostring(playerDegree) .. " "
					
				
					-- Calculate the difference in degrees in a circular way
					local diff = (playerDegree - targetDegree + 360) % 360
				
					-- Check if the difference is within +/- 20 degrees, considering circular conditions
					if diff <= 20 or diff >= 340 then
						
						gScore:setScore(gScore:getScore()+25)
					else
						gScore:setScore(math.max(gScore:getScore() - 200, 0))
						--msg = "Fail!"
						if lives == 0 then
							
							msg="Final Score: "
							gameOver()
						else
							lives -= 1
						end
						shadow:setValReset(centerX, centerY + 30)
						break
					end
				end
				
				--msg = "Success!"
				
				shadow:setValReset(centerX, centerY + 30)
			else
				mainCloud:setScale(mainCloud:getScale()*gameSpeed)
				shadow:setValScale(shadow:getValScale()*gameSpeed)
			end

			for i = 1, #altClouds do
				local cloud = altClouds[i]
				--newX = cloud.x + 2*math.random()*randNegative()
				--newY = cloud.y + 2*math.random()*randNegative()
				newX = cloud.x + (gameSpeed - 1)*(cloud.x - centerX)
				newY = cloud.y +(gameSpeed - 1)*(cloud.y - centerY)
				cloud:moveTo(newX, newY)
				if cloud:getScale() >= 3.5 then
					cloud:setScale(.5)
					cloud:moveTo(centerX + math.random(10,40)*randNegative(), centerY+math.random(10,40)*randNegative())
				else
					cloud:setScale(cloud:getScale()*(gameSpeed - .01)*cloud.randGrow)
				end
			end
		end

		mainCloud:moveTo(centerX-mainCloud.width/2, centerY+30 - mainCloud.width/2)
		shadow:setScale(5)

		gScore:draw(320, 160)
		gfx.drawText(msg, 300, 130)

		-- Optional: Draw FPS, etc.
		pd.drawFPS(0, 0)
	elseif gameState == kGameOverState then
		
		if ticks < 5 then
			pd.display.setInverted(ticks % 2)
		end

	end

end

-- ! Button Functions

function playdate.leftButtonDown()
	if gameState == kGamePlayingState then
		--flippy:left()
	end
end

function playdate.rightButtonDown()
	if gameState == kGamePlayingState then
		--flippy:right()
	end
end

function playdate.upButtonDown()
	if gameState == kGamePlayingState then
		--flippy:up()
	end
end

function playdate.AButtonDown()

	if gameState == kGameInitialState then
		buttonDown = true
	elseif gameState == kGameOverState and ticks > 5  then	-- the ticks thing is just so the player doesn't accidentally restart immediately
		lives = 3
		msg = "Score:"
		startGame()
	elseif gameState == kGamePlayingState then
		--flippy:up()		
	end
end

function playdate.BButtonDown()
	if gameState == kGameInitialState then
		buttonDown = true
	elseif gameState == kGameOverState and ticks > 5 then
		lives = 3
		msg = "Score:"
		startGame()
	elseif gameState == kGamePlayingState then
		--flippy:up()
	end
end

function playdate.AButtonUp()

	if gameState == kGameInitialState then
		buttonDown = false
		lives = 3
		msg = "Score:"
		startGame()
	end
end

function playdate.BButtonUp()
	if gameState == kGameInitialState then
		buttonDown = false
		lives = 3
		msg = "Score:"
		startGame()
	end

end
