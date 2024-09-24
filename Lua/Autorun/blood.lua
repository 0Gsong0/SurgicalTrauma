BLOODTYPE = {
    {type = "o-", probability = 7},
    {type = "o+", probability = 37},
    {type = "a-", probability = 6},
    {type = "a+", probability = 36},
    {type = "b-", probability = 2},
    {type = "b+", probability = 8},
    {type = "ab-", probability = 1},
    {type = "ab+", probability = 3}
} 
-- 计算总概率值
local totalProbability = 0
for i = 1, #BLOODTYPE do
    totalProbability = totalProbability + BLOODTYPE[i].probability
end
local function getRandomBloodType(createdCharacter)
    local randomValue = math.random(totalProbability) -- 生成1到总概率之间的随机数
    local cumulativeProbability = 0

    -- 根据累积概率判断血型
    for i = 1, #BLOODTYPE do
        cumulativeProbability = cumulativeProbability + BLOODTYPE[i].probability
        if randomValue <= cumulativeProbability then
            return BLOODTYPE[i].type
        end
    end
end

Hook.Add("characterCreated", "ST.BloodAndImmunity", function(createdCharacter)
    Timer.Wait(function()
        if (createdCharacter.IsHuman and not createdCharacter.IsDead) then
            apply(createdCharacter,"bloodpressure")
            apply(createdCharacter,"immunity")
            SetAffliction(createdCharacter, "temperature", random(35,37))
            local randomBloodType = getRandomBloodType()
            apply(createdCharacter,randomBloodType)
            print(createdCharacter.Name.. "随机生成的血型是: " .. randomBloodType)
        end
    end, 1000)
end)

function apply(createdCharacter,id)
    SetAffliction(createdCharacter, id, 100)
end

