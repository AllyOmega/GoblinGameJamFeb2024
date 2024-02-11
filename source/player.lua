local pd <const> = playdate
local gfx <const> = pd.graphics

class('Player').extends(gfx.sprite)
local floor = math.floor

local leftArmImage = gfx.image.new('images/leftArm')
local rightArmImage = gfx.image.new('images/rightArm')
local leftLegImage = gfx.image.new('images/leftLeg')
local rightLegImage = gfx.image.new('images/rightLeg')

local sleeveLeft = gfx.sprite.new()
local sleeveRight = gfx.sprite.new()
local pantLegLeft = gfx.sprite.new()
local pantLegRight = gfx.sprite.new()

local leftArm = Player(x, y)
local rightArm = Player(x, y)
local leftLeg = Player(x, y)
local rightLeg = Player(x, y)

function Player:init(x, y)
   
    leftArm:setImage(leftArmImage)
    leftArm:setCenter(.35, 1)
	leftArm:moveTo(x, y)
    leftArm:add()
    sleeveLeft:moveTo(x,y+3)
    sleeveLeft:setCenter(.5,1)
    sleeveLeft.imagetable = gfx.imagetable.new('images/sleeves')
    sleeveLeft.animation = gfx.animation.loop.new(100, sleeveLeft.imagetable, true)
    sleeveLeft:add()
    

    rightArm:setImage(rightArmImage)
    rightArm:setCenter(.75, 1)
	rightArm:moveTo(x + 100, y)
    rightArm:add()
    sleeveRight:moveTo(x + 100, y+3)
    sleeveRight:setCenter(.65,1)
    sleeveRight.imagetable = gfx.imagetable.new('images/sleeves')
    sleeveRight.animation = gfx.animation.loop.new(100, sleeveRight.imagetable, true)
    sleeveRight:add()


    leftLeg:setImage(leftLegImage)
    leftLeg:setCenter(.6, 0)
	leftLeg:moveTo(x, y + 50)
    leftLeg:add()
    pantLegLeft:moveTo(x, y+50)
    pantLegLeft:setCenter(.25,0)
    pantLegLeft.imagetable = gfx.imagetable.new('images/pantleg')
    pantLegLeft.animation = gfx.animation.loop.new(100, pantLegLeft.imagetable, true)
    pantLegLeft:add()
    

    rightLeg:setImage(rightLegImage)
    rightLeg:setCenter(.4, 0)
	rightLeg:moveTo(x + 100, y + 50)
    rightLeg:add()
    pantLegRight:moveTo(x + 100, y+50)
    pantLegRight:setCenter(.8,0)
    pantLegRight.imagetable = gfx.imagetable.new('images/pantleg')
    pantLegRight.animation = gfx.animation.loop.new(100, pantLegRight.imagetable, true)
    pantLegRight:add()

end

function Player:update()

    sleeveLeft:setImage(sleeveLeft.animation:image())
    sleeveRight:setImage(sleeveRight.animation:image())
    pantLegLeft:setImage(pantLegLeft.animation:image())
    pantLegRight:setImage(pantLegRight.animation:image())

    local crank_angle = floor(pd.getCrankPosition())

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

