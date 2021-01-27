local propCamera = script:GetCustomProperty("camera"):WaitForObject()
local offset = 0



local propDrunkRotator = script:GetCustomProperty("drunkRotator"):WaitForObject()

local propArrow = script:GetCustomProperty("arrow"):WaitForObject()

local maxWidth = 300


local player = Game.GetLocalPlayer()
local currPich = 0

local soundPitch = 0

local propSound = script:GetCustomProperty("sound"):WaitForObject()

local propCurrentScore = script:GetCustomProperty("CurrentScore"):WaitForObject()
local propHighScore = script:GetCustomProperty("HighScore"):WaitForObject()


function Tick(deltaTime)
    currPich = propDrunkRotator:GetCustomProperty("currentPitch")
    offset = CoreMath.Lerp(offset, -currPich*40,0.01)
    propCamera:SetRotationOffset(Rotation.New(offset,0,0))
    propArrow.x = CoreMath.Lerp(propArrow.x, currPich*maxWidth,0.01)

    soundPitch = CoreMath.Lerp(soundPitch, -math.abs(currPich)*100,0.01)
    propSound.pitch = soundPitch

    propCurrentScore.text = "Current time: "..math.floor(time())-player:GetResource("StartTime")
    if player:GetResource("FastestTime")>0 then
        propHighScore.text = "Fastest time: "..player:GetResource("FastestTime")
    else
        propHighScore.text = "Fastest time: No"
    end

end


--UI.SetCursorVisible(true)
--UI.SetCanCursorInteractWithUI(true)



function OnPlayerMovement(player, params)
    local rot = Rotation.New(0,0,60*currPich)
    params.direction = rot*params.direction
   
end



player.movementHook:Connect(OnPlayerMovement)