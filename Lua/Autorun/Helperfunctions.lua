--give aff
function SetAffliction(character,identifier,strength)
    local Prefab = AfflictionPrefab.Prefabs[identifier]
    local limb = character.AnimController.GetLimb(LimbType.Head)
    character.CharacterHealth.ApplyAffliction(limb,Prefab.Instantiate(strength))
    return true -- returning true allows us to hide the message
end
function SetAfflictionLimb(character,identifier,limbtype,strength)
    if strength == 0 then strength = -2000 end
    local prefab = AfflictionPrefab.Prefabs[identifier]

    character.CharacterHealth.ApplyAffliction(character.AnimController.GetLimb(limbtype),prefab.Instantiate(strength))
end
function AddAffliction(character,identifier,strength)
    local Prefab = AfflictionPrefab.Prefabs[identifier]
    local limb = character.AnimController.MainLimb
    character.CharacterHealth.ApplyAffliction(limb,Prefab.Instantiate(strength))
end
function AddAfflictionLimb(character,identifier,limbtype,strength)
    local prevstrength = GetAfflictionStrengthLimb(character,identifier,limbtype)
    SetAfflictionLimb(character,identifier,limbtype,strength+prevstrength)
end
--get aff
function HasAffliction(character,identifier,minamount)
    if character==nil or character.CharacterHealth==nil then return false end
    local aff = character.CharacterHealth.GetAffliction(identifier)
    local res = false
    if(aff~=nil) then
        res = aff.Strength >= (minamount or 0.5)
    end
    return res
end
function HasAfflictionLimb(character,identifier,limbtype,minamount)
    local limb = character.AnimController.GetLimb(limbtype)
    if limb==nil then return false end
    local aff = character.CharacterHealth.GetAffliction(identifier,limb)
    local res = false
    if(aff~=nil) then
        res = aff.Strength >= (minamount or 0.5)
    end
    return res
end
function GetAfflictionStrength(character,identifier,defaultvalue)
    if character==nil or character.CharacterHealth==nil then return defaultvalue end

    local aff = character.CharacterHealth.GetAffliction(identifier)
    local res = defaultvalue or 0
    if(aff~=nil) then
        res = aff.Strength
    end
    return res
end
function GetAfflictionStrengthLimb(character,identifier,limbtype)
    local limb = character.AnimController.GetLimb(limbtype)
    if limb==nil then return end
    
    local aff = character.CharacterHealth.GetAffliction(identifier,limb)
    if aff == nil then return 0 end
    return aff.strength
end
--skill
function GetSkillLevel(character,skilltype)
    return character.GetSkillLevel(Identifier(skilltype))
end
function GiveSkill(character,skilltype,amount)
    if character ~= nil and character.Info ~= nil then
        character.Info.IncreaseSkillLevel(Identifier(skilltype), amount)
    end
end
--random
function random(min, max)
    return math.random(min, max)
end
--limb
function NormalizeLimbType(limbtype) 
    if 
        limbtype == LimbType.Head or 
        limbtype == LimbType.Torso or 
        limbtype == LimbType.RightArm or
        limbtype == LimbType.LeftArm or
        limbtype == LimbType.RightLeg or
        limbtype == LimbType.LeftLeg then 
        return limbtype end

    if limbtype == LimbType.LeftForearm or limbtype==LimbType.LeftHand then return LimbType.LeftArm end
    if limbtype == LimbType.RightForearm or limbtype==LimbType.RightHand then return LimbType.RightArm end

    if limbtype == LimbType.LeftThigh or limbtype==LimbType.LeftFoot then return LimbType.LeftLeg end
    if limbtype == LimbType.RightThigh or limbtype==LimbType.RightFoot then return LimbType.RightLeg end

    if limbtype == LimbType.Waist then return LimbType.Torso end

    return limbtype
end
--可以进行手术
function CanDoing(character)
    return HasAffliction(character,"anaesthesia",1) or HasAffliction(character,"unconsciousness",0.1)
end
--生成
function SpawnItemInventory(character,identifier)
    local prefab = ItemPrefab.GetItemPrefab(identifier)
    Entity.Spawner.AddItemToSpawnQueue(prefab, character.Inventory, nil, nil, function(item)
        print("ST.SpawnItemInventory:"..identifier.."正在生成...")
    end)
end
--移除
function RemoveItem(item)
    if item == nil or item.Removed then return end
    
    if SERVER then
        -- use server remove method
        Entity.Spawner.AddEntityToRemoveQueue(item)
    else
        -- use client remove method
        item.Remove()
    end
end
--暂停
function GameIsPaused()
    if SERVER then return false end

    return Game.Paused
end
--RemoveLimb(弃用)
function RemoveLimb(character,limbtype,limbtype2)
    character.AnimController.HideAndDisable(limbtype,100,true)
    if limbtype2 == nil then return end
    character.AnimController.HideAndDisable(limbtype2,100,true)
    print("Try Remove Limb:"..limbtype)
end
