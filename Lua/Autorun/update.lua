-- 初始化和设置
ST.UpdateCooldown = 0
ST.UpdateInterval = 120
ST.Deltatime = ST.UpdateInterval / 60
ST.tickTasks = {}

local limbtypes = {
    LimbType.Torso,
    LimbType.Head,
    LimbType.LeftArm,
    LimbType.RightArm,
    LimbType.LeftLeg,
    LimbType.RightLeg,
}
-- 添加 think 钩子
Hook.Add("think", "NT.update", function()
    if GameIsPaused() then return end

    
    ST.UpdateCooldown = ST.UpdateCooldown - 1
    if ST.UpdateCooldown <= 0 then
        ST.UpdateCooldown = ST.UpdateInterval
        ST.Update()
    end

    ST.TickUpdate()
end)
function ST.TickUpdate() 
    for key,value in pairs(ST.tickTasks) do 

        value.duration = value.duration-1
        if value.duration <= 0 then 
            ST.tickTasks[key]=nil
        end
    end
end
-- 每两秒运行一次的更新函数
function ST.Update()
    local updatecha = {}
    local updateHumans = {}
    local updateMonsters = {}

    -- 获取所有需要更新的角色
    for _, character in pairs(Character.CharacterList) do
        if not character.IsDead and character.IsHuman then
            table.insert(updateHumans,character)
        elseif not character.Removed then
            table.insert(updateMonsters,character)
        end
    end

    -- 更新人类角色
    for key, value in pairs(updateHumans) do
        if value and not value.Removed and value.IsHuman and not value.IsDead then
            Timer.Wait(function()
                ST.UpdateHuman(value)
            end,ST.Deltatime * 1000)
        end
    end

    -- 更新怪物角色
    for key, value in pairs(updateMonsters) do
        if value and not value.Removed and not value.IsDead then
            Timer.Wait(function()
                ST.UpdateMonster(value)
            end,ST.Deltatime * 1500)
        end
    end
    print("ST.UPDATE 》 》 》 数据更新中...本更新每两秒执行一次...")
    for k , v in pairs(updateHumans) do
        print("ST.UpdateHumans/人类更新："..k..":",v)
    end
    for k , v in pairs(updateMonsters) do
        print("ST.UpdateMonsters/怪物更新："..k..":",v)
    end
end
-- 更新人类角色的状态
function ST.UpdateHuman(character)
    local charData = {character=character, afflictions={}, stats={}}
    --防止血压/体温丢失
    if not HasAffliction(character,"bloodpressure",0.1) then AddAfflictionLimb(character,"bloodpressure",LimbType.Torso,2) end
    if not HasAffliction(character,"temperature",0.1) then AddAfflictionLimb(character,"temperature",LimbType.Torso,2) end
    -- 更新非肢体特定的病症
    for identifier, data in pairs(ST.Afflictions) do

        if data.update then
            --传入数据
            data.update(character, identifier)
        end
    end
end
-- 更新怪物
function ST.UpdateMonster(character)
    -- 获取角色的失血程度
    local bloodloss = GetAfflictionStrength(character,"bloodloss",0)
    -- 如果有失血
    if bloodloss > 0 then
        -- 将失血转换为器官损伤
        AddAffliction(character,"organdamage",bloodloss*2)
        -- 将失血程度重置为 0
        SetAffliction(character,"bloodloss",0)
    end
end

ST.Afflictions = {
    bloodpressure={ --血压
        update=function(c,i)
            if GetAfflictionStrength(c,i) < 70 then AddAffliction(c,"oxygenlow",random(0.1,0.3)*(100-GetAfflictionStrength(c,i))) end
            --if GetAfflictionStrength(c,i) < 70-80 then 导致心绞痛、心肌梗死 end
            if GetAfflictionStrength(c,i) < 60 then AddAffliction(c,"ST_paleskin",5) end
        end
    },
    bodytemperature={ --体温
        update=function(c,i)
        
        end
    },
    immunity={ --免疫力
        update=function(c,i)
            
        end
    }
}