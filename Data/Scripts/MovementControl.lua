
local currentOffset = 0

function RandomPitch()
    currentOffset = 1-2*math.random()
    script.parent:SetNetworkedCustomProperty("currentPitch", currentOffset)
    Task.Spawn(RandomPitch, 1+4*math.random())

    local players = Game.GetPlayers()
    for i = 1, #players do
        local rot = players[i]:GetWorldRotation()
        rot.x = currentOffset*30
        players[i]:SetWorldRotation(rot)
        -- statements
    end
end
Task.Spawn(RandomPitch)

function EnableRagDall(player)
    if Object.IsValid(player) then
        player:EnableRagdoll("lower_spine", .8)
        player:EnableRagdoll("right_shoulder", .2)
        player:EnableRagdoll("left_shoulder", .6)
        player:EnableRagdoll("right_hip", .6)
        player:EnableRagdoll("left_hip", .6)
    end
end
function OnBindingPressed(player,ak)
    if ak =="ability_extra_34" then
        player:SetMounted(not player.isMounted)
        Task.Spawn(function()
            EnableRagDall(player)
        end,1)
    end
end
local propSleepTrigger = script:GetCustomProperty("sleepTrigger"):WaitForObject()
local propRespawnPosition = script:GetCustomProperty("respawnPosition"):WaitForObject()
propSleepTrigger.interactedEvent:Connect(function(tr, other)
    if other:IsA("Player") then
        if other:GetResource("FastestTime")==0 or (other:GetResource("FastestTime")>(time()-other:GetResource("StartTime"))) then
            other:SetResource("FastestTime", math.floor(time()-other:GetResource("StartTime")))
        end
    end
    other:SetWorldPosition(propRespawnPosition:GetWorldPosition())
    OnRespawn(other)
end)
function OnRespawn(player)
    player:SetResource("StartTime", math.floor(time()))
    EnableRagDall(player)
end
Game.playerJoinedEvent:Connect(function(player)
    local data = Storage.GetPlayerData(player)
    if data and data.FastestTime and data.FastestTime>0 then
        player:SetResource("FastestTime", data.FastestTime)
    end
    EnableRagDall(player)
    player.canMount = false
    player.bindingPressedEvent:Connect(OnBindingPressed)
    player:SetResource("StartTime", math.floor(time()))
    Task.Spawn(function()
        EnableRagDall(player)
    end,3)
    Task.Spawn(function()
        EnableRagDall(player)
    end,10)
    
    player.respawnedEvent:Connect(OnRespawn)


    
end)

Game.playerLeftEvent:Connect(function(player)
    local data = {}
    data.FastestTime = player:GetResource("FastestTime")
    Storage.SetPlayerData(player,data)
    
    
end)
