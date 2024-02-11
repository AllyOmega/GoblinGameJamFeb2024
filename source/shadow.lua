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



local scaleVal = 0.083

function Shadow:init(x, y)
   
    leftArm:setImage(leftArmImage)
    leftArm:setCenter(.35, 1)
    leftArm:setZIndex(32767)
	leftArm:moveTo(x, y)
    leftArm:add()
    leftArm:setScale(scaleVal)
    sleeveLeft:moveTo(x,y)
    sleeveLeft:setCenter(.5,1)
    sleeveLeft:setZIndex(32767)
    sleeveLeft.imagetable = gfx.imagetable.new('images/sleeves')
    sleeveLeft.animation = gfx.animation.loop.new(100, sleeveLeft.imagetable, true)
    sleeveLeft:setScale(scaleVal)
    sleeveLeft:add()
    

    rightArm:setImage(rightArmImage)
    rightArm:setCenter(.75, 1)
    rightArm:setZIndex(32767)
	rightArm:moveTo(x, y)
    rightArm:add()
    rightArm:setScale(0.5)
    sleeveRight:moveTo(x, y)
    sleeveRight:setZIndex(32767)
    sleeveRight:setCenter(.65,1)
    sleeveRight.imagetable = gfx.imagetable.new('images/sleeves')
    sleeveRight.animation = gfx.animation.loop.new(100, sleeveRight.imagetable, true)
    sleeveRight:add()
    sleeveRight:setScale(0.5)


    leftLeg:setImage(leftLegImage)
    leftLeg:setCenter(.6, 0)
    leftLeg:setZIndex(32767)
	leftLeg:moveTo(x, y)
    leftLeg:add()
    leftLeg:setScale(0.5)
    pantLegLeft:moveTo(x, y)
    pantLegLeft:setZIndex(32767)
    pantLegLeft:setCenter(.25,0)
    pantLegLeft.imagetable = gfx.imagetable.new('images/pantleg')
    pantLegLeft.animation = gfx.animation.loop.new(100, pantLegLeft.imagetable, true)
    pantLegLeft:add()
    pantLegLeft:setScale(0.5)
    

    rightLeg:setImage(rightLegImage)
    rightLeg:setCenter(.4, 0)
    rightLeg:setZIndex(32767)
	rightLeg:moveTo(x, y)
    rightLeg:add()
    rightLeg:setScale(0.5)
    pantLegRight:moveTo(x, y)
    pantLegRight:setZIndex(32767)
    pantLegRight:setCenter(.8,0)
    pantLegRight.imagetable = gfx.imagetable.new('images/pantleg')
    pantLegRight.animation = gfx.animation.loop.new(100, pantLegRight.imagetable, true)
    pantLegRight:add()
    pantLegRight:setScale(0.5)


    leftArmPosX = x
    leftArmPosY = y
    
    rightArmPosX = x
    rightArmPosY = y

    leftLegPosX = x
    leftLegPosY = y
    
    rightLegPosX = x
    rightLegPosY = y

end

function Shadow:setVals()
    leftArmPosX -= 0.2
    leftArmPosY -= 0.1

    rightArmPosX += 0.2
    rightArmPosY -= 0.1

    leftLegPosX -= 0.2
    leftLegPosY += 0.1

    rightLegPosX += 0.2
    rightLegPosY += 0.1
end

function Shadow:setValReset(x,y)
    leftArmPosX, rightArmPosX, leftLegPosX, rightLegPosX = x, x, x, x
    leftArmPosY, rightArmPosY, leftLegPosY, rightLegPosY = y, y, y, y
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



    if (pd.buttonIsPressed(pd.kButtonUp) and (pd.buttonIsPressed(pd.kButtonLeft))) then
        leftArm:setRotation(crank_angle)
        sleeveLeft:setRotation(crank_angle)
   end
    if (pd.buttonIsPressed(pd.kButtonUp) and (pd.buttonIsPressed(pd.kButtonRight))) then
        rightArm:setRotation(crank_angle)
        sleeveRight:setRotation(crank_angle)
    end
    if (pd.buttonIsPressed(pd.kButtonDown) and (pd.buttonIsPressed(pd.kButtonLeft))) then
        leftLeg:setRotation(crank_angle)
        pantLegLeft:setRotation(crank_angle)
    end
    if (pd.buttonIsPressed(pd.kButtonDown) and (pd.buttonIsPressed(pd.kButtonRight))) then
        rightLeg:setRotation(crank_angle)
        pantLegRight:setRotation(crank_angle)
    end

end

