local pd <const> = playdate
local gfx <const> = pd.graphics

class('Shadow').extends(gfx.sprite)
local floor = math.floor

local leftArmImage = gfx.image.new('images/leftArm')
local rightArmImage = gfx.image.new('images/rightArm')
local leftLegImage = gfx.image.new('images/leftLeg')
local rightLegImage = gfx.image.new('images/rightLeg')

local sleeveLeft = gfx.sprite.new()
local sleeveRight = gfx.sprite.new()
local pantLegLeft = gfx.sprite.new()
local pantLegRight = gfx.sprite.new()

local leftArm = Shadow(x, y)
local rightArm = Shadow(x, y)
local leftLeg = Shadow(x, y)
local rightLeg = Shadow(x, y)

local leftArmPosX = 0
local leftArmPosY = 0

local rightArmPosX = 0
local rightArmPosY = 0

local leftLegPosX = 0
local leftLegPosY = 0

local rightLegPosX = 0
local rightLegPosY = 0


local scaleVal = 0.02

local leftArmPos =  0
local rightArmPos = 0
local leftLegPos =  0
local rightLegPos = 0

function Shadow:init(x, y)
   
    leftArm:setImage(leftArmImage)
    leftArm:setCenter(.35, 1)
    leftArm:setZIndex(32765)
	leftArm:moveTo(x, y)
    leftArm:add()
    leftArm:setScale(scaleVal)
    sleeveLeft:moveTo(x,y)
    sleeveLeft:setCenter(.5,1)
    sleeveLeft:setZIndex(32765)
    sleeveLeft.imagetable = gfx.imagetable.new('images/sleeves')
    sleeveLeft.animation = gfx.animation.loop.new(100, sleeveLeft.imagetable, true)
    sleeveLeft:setScale(scaleVal)
    sleeveLeft:add()
    

    rightArm:setImage(rightArmImage)
    rightArm:setCenter(.75, 1)
    rightArm:setZIndex(32765)
	rightArm:moveTo(x, y)
    rightArm:add()
    rightArm:setScale(scaleVal)
    sleeveRight:moveTo(x, y)
    sleeveRight:setZIndex(32765)
    sleeveRight:setCenter(.65,1)
    sleeveRight.imagetable = gfx.imagetable.new('images/sleeves')
    sleeveRight.animation = gfx.animation.loop.new(100, sleeveRight.imagetable, true)
    sleeveRight:add()
    sleeveRight:setScale(scaleVal)


    leftLeg:setImage(leftLegImage)
    leftLeg:setCenter(.6, 0)
    leftLeg:setZIndex(32765)
	leftLeg:moveTo(x, y)
    leftLeg:add()
    leftLeg:setScale(scaleVal)
    pantLegLeft:moveTo(x, y)
    pantLegLeft:setZIndex(32765)
    pantLegLeft:setCenter(.25,0)
    pantLegLeft.imagetable = gfx.imagetable.new('images/pantleg')
    pantLegLeft.animation = gfx.animation.loop.new(100, pantLegLeft.imagetable, true)
    pantLegLeft:add()
    pantLegLeft:setScale(scaleVal)
    

    rightLeg:setImage(rightLegImage)
    rightLeg:setCenter(.4, 0)
    rightLeg:setZIndex(32765)
	rightLeg:moveTo(x, y)
    rightLeg:add()
    rightLeg:setScale(scaleVal)
    pantLegRight:moveTo(x, y)
    pantLegRight:setZIndex(32765)
    pantLegRight:setCenter(.8,0)
    pantLegRight.imagetable = gfx.imagetable.new('images/pantleg')
    pantLegRight.animation = gfx.animation.loop.new(100, pantLegRight.imagetable, true)
    pantLegRight:add()
    pantLegRight:setScale()

    leftArmPos = math.random(1,360)
    leftArm:setRotation(leftArmPos)
    sleeveLeft:setRotation(leftArmPos)
    
    rightArmPos = math.random(1,360)
    rightArm:setRotation(rightArmPos)
    sleeveRight:setRotation(rightArmPos)
    
    leftLegPos = math.random(1,360)
    leftLeg:setRotation(leftLegPos)
    pantLegLeft:setRotation(leftLegPos)
    
    rightLegPos = math.random(1,360)
    rightLeg:setRotation(rightLegPos)
    pantLegRight:setRotation(rightLegPos)


    leftArmPosX = x
    leftArmPosY = y
    
    rightArmPosX = x
    rightArmPosY = y

    leftLegPosX = x
    leftLegPosY = y
    
    rightLegPosX = x
    rightLegPosY = y

    

end

function Shadow:resetRotPos() 
    leftArmPos = 50 --math.random(1,360)
    leftArm:setRotation(leftArmPos)
    sleeveLeft:setRotation(leftArmPos)
    
    rightArmPos = 50 
    rightArm:setRotation(rightArmPos)
    sleeveRight:setRotation(rightArmPos)
    
    leftLegPos = 50 
    leftLeg:setRotation(leftLegPos)
    pantLegLeft:setRotation(leftLegPos)
    
    rightLegPos = 50
    rightLeg:setRotation(rightLegPos)
    pantLegRight:setRotation(rightLegPos)
end


function Shadow:setVals(x,y, gameSpeed)
 -- Assuming gameSpeed is a multiplier, e.g., 1.0 for normal speed, 2.0 for double speed, etc.
 local adjustedX = x * (gameSpeed - 1)*100
 local adjustedY = y * (gameSpeed - 1)*100

 leftArmPosX -= adjustedX * 1.6
 leftArmPosY -= adjustedY

 rightArmPosX += adjustedX * 1.1
 rightArmPosY -= adjustedY

 leftLegPosX -= adjustedX
 leftLegPosY += adjustedY

 rightLegPosX += adjustedX
 rightLegPosY += adjustedY
end

function Shadow:setValReset(x,y)
    leftArmPosX, rightArmPosX, leftLegPosX, rightLegPosX = x, x, x, x
    leftArmPosY, rightArmPosY, leftLegPosY, rightLegPosY = y, y, y, y
    self:resetRotPos()
end

function Shadow:getPos() 
    return {leftArmPos, rightArmPos, leftLegPos, rightLegPos}
end

function Shadow:setValScale(num)
    scaleVal = num
end
function Shadow:getValScale()
    return scaleVal
end

function Shadow:update()

    sleeveLeft:setImage(sleeveLeft.animation:image())
    sleeveRight:setImage(sleeveRight.animation:image())
    pantLegLeft:setImage(pantLegLeft.animation:image())
    pantLegRight:setImage(pantLegRight.animation:image())

    local crank_angle = floor(pd.getCrankPosition())


    leftArm:setScale(scaleVal)
    sleeveLeft:setScale(scaleVal)
    rightArm:setScale(scaleVal)
    sleeveRight:setScale(scaleVal)
    leftLeg:setScale(scaleVal)
    pantLegLeft:setScale(scaleVal)
    rightLeg:setScale(scaleVal)
    pantLegRight:setScale(scaleVal)

    leftArm:moveTo(leftArmPosX, leftArmPosY)
    sleeveLeft:moveTo(leftArmPosX, leftArmPosY)

    rightArm:moveTo(rightArmPosX, rightArmPosY)
    sleeveRight:moveTo(rightArmPosX, rightArmPosY)

    leftLeg:moveTo(leftLegPosX, leftLegPosY)
    pantLegLeft:moveTo(leftLegPosX, leftLegPosY)
    
    rightLeg:moveTo(rightLegPosX, rightLegPosY)
    pantLegRight:moveTo(rightLegPosX, rightLegPosY)


end

