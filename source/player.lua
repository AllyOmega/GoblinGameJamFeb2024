local pd <const> = playdate
local gfx <const> = pd.graphics

class('Player').extends(gfx.sprite)
local floor = math.floor

local leftArmImage = gfx.image.new('images/leftArm')
local rightArmImage = gfx.image.new('images/rightArm')
local leftLegImage = gfx.image.new('images/leftLeg')
local rightLegImage = gfx.image.new('images/rightLeg')
--local playerBodyImage = gfx.image.new('images/playerBody')

local sleeveLeft = gfx.sprite.new()
local sleeveRight = gfx.sprite.new()
local pantLegLeft = gfx.sprite.new()
local pantLegRight = gfx.sprite.new()
--local hair = gfx.sprite.new()

local leftArm = Player(x, y)
local rightArm = Player(x, y)
local leftLeg = Player(x, y)
local rightLeg = Player(x, y)
--local playerBody = Player(x, y)

local scaler = 1.01

local leftArmPos = 0
local rightArmPos = 0
local leftLegPos = 0 
local rightLegPos = 0

function Player:init(x, y)
   
    leftArm:setImage(leftArmImage)
    leftArm:setCenter(.35, 1)
    leftArm:setZIndex(32765)
	leftArm:moveTo(x - 50, y)
    leftArm:add()
    sleeveLeft:moveTo(x - 50,y + 3)
    sleeveLeft:setCenter(.5,1)
    sleeveLeft:setZIndex(32765)
    sleeveLeft.imagetable = gfx.imagetable.new('images/sleeves')
    sleeveLeft.animation = gfx.animation.loop.new(100, sleeveLeft.imagetable, true)
    sleeveLeft:add()
    

    rightArm:setImage(rightArmImage)
    rightArm:setCenter(.75, 1)
    rightArm:setZIndex(32765)
	rightArm:moveTo(x + 50, y)
    rightArm:add()
    sleeveRight:moveTo(x + 50, y + 3)
    sleeveRight:setZIndex(32765)
    sleeveRight:setCenter(.65,1)
    sleeveRight.imagetable = gfx.imagetable.new('images/sleeves')
    sleeveRight.animation = gfx.animation.loop.new(100, sleeveRight.imagetable, true)
    sleeveRight:add()


    leftLeg:setImage(leftLegImage)
    leftLeg:setCenter(.6, 0)
    leftLeg:setZIndex(32765)
	leftLeg:moveTo(x - 25, y + 50)
    leftLeg:add()
    pantLegLeft:moveTo(x - 25, y + 50)
    pantLegLeft:setZIndex(32765)
    pantLegLeft:setCenter(.25,0)
    pantLegLeft.imagetable = gfx.imagetable.new('images/pantleg')
    pantLegLeft.animation = gfx.animation.loop.new(100, pantLegLeft.imagetable, true)
    pantLegLeft:add()
    

    rightLeg:setImage(rightLegImage)
    rightLeg:setCenter(.4, 0)
    rightLeg:setZIndex(32765)
	rightLeg:moveTo(x + 25, y + 50)
    rightLeg:add()
    pantLegRight:moveTo(x + 25, y + 50)
    pantLegRight:setZIndex(32765)
    pantLegRight:setCenter(.8,0)
    pantLegRight.imagetable = gfx.imagetable.new('images/pantleg')
    pantLegRight.animation = gfx.animation.loop.new(100, pantLegRight.imagetable, true)
    pantLegRight:add()


    -- playerBody:setImage(playerBodyImage)
    -- playerBody:setCenter(.5,.5)
    -- playerBody:setZIndex(32767)
	-- playerBody:moveTo(x, y)
    -- playerBody:add()


    -- hair:moveTo(x , y - 40)
    -- hair:setCenter(.5,1)
    -- hair:setZIndex(32767)
    -- hair.imagetable = gfx.imagetable.new('images/hair')
    -- hair.animation = gfx.animation.loop.new(100, hair.imagetable, true)
    -- hair:add()

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


end

function Player:getPos() 
    return {leftArmPos, rightArmPos, leftLegPos, rightLegPos}
end


function Player:update()

    sleeveLeft:setImage(sleeveLeft.animation:image())
    sleeveRight:setImage(sleeveRight.animation:image())
    pantLegLeft:setImage(pantLegLeft.animation:image())
    pantLegRight:setImage(pantLegRight.animation:image())
   --hair:setImage(hair.animation:image())


    local crank_angle, temp = pd.getCrankChange()
    
    if (pd.buttonIsPressed(pd.kButtonUp) and (pd.buttonIsPressed(pd.kButtonLeft))) then
        leftArmPos = (leftArmPos + temp*.1)%360
        leftArm:setRotation(leftArmPos)
        sleeveLeft:setRotation(leftArmPos)
   end
    if (pd.buttonIsPressed(pd.kButtonUp) and (pd.buttonIsPressed(pd.kButtonRight))) then
        rightArmPos = (rightArmPos + temp*.1)%360
        rightArm:setRotation(rightArmPos)
        sleeveRight:setRotation(rightArmPos)
    end
    if (pd.buttonIsPressed(pd.kButtonDown) and (pd.buttonIsPressed(pd.kButtonLeft))) then
        leftLegPos = (leftLegPos + temp*.1)%360
        leftLeg:setRotation(leftLegPos)
        pantLegLeft:setRotation(leftLegPos)
    end
    if (pd.buttonIsPressed(pd.kButtonDown) and (pd.buttonIsPressed(pd.kButtonRight))) then
        rightLegPos = (rightLegPos + temp*.1)%360
        rightLeg:setRotation(rightLegPos)
        pantLegRight:setRotation(rightLegPos)
    end
end

