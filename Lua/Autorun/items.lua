ST.Items = {} --ST物品
ST.SurgicalStatus = {"surgeryincision","clampedbleeders","retractedskin","bonecut"}
Hook.Add("item.applyTreatment", "ST.itemused", function(item, usingCharacter, targetCharacter, limb)
    
    if
        item == nil or
        usingCharacter == nil or
        targetCharacter == nil or
        limb == nil 
    then return end
    
    local identifier = item.Prefab.Identifier.Value

    print(identifier)

    local methodtorun = ST.Items[identifier] -- get the function associated with the identifier
    if(methodtorun~=nil) then 
         -- run said function
        methodtorun(item, usingCharacter, targetCharacter, limb)
        return
    end

end)
--手术刀
ST.Items.scalpel = function (item, usingCharacter, targetCharacter, limb)
    limb = limb.type
    if HasAffliction(targetCharacter,"lifestagnant",0.1) then return end

    SetAfflictionLimb(targetCharacter,"Sutures",limb,0,usingCharacter)
    SetAfflictionLimb(targetCharacter,"bandaged",limb,0)
    SetAfflictionLimb(targetCharacter,"ST_Superglue",limb,0)
    --SetAfflictionLimb(targetCharacter,"dirtybandage",limb,0,usingCharacter)
    --SetAfflictionLimb(targetCharacter,"gypsumcast",limb,0,usingCharacter)
    if CanDoing(targetCharacter) and GetSkillLevel(usingCharacter,"medical") > 20  then
        AddAfflictionLimb(targetCharacter,"surgeryincision",limb,GetSkillLevel(usingCharacter,"medical")/2)
    elseif CanDoing(targetCharacter) then
        if random(1,100) > 50 then
            AddAfflictionLimb(targetCharacter,"surgeryincision",limb,GetSkillLevel(usingCharacter,"medical")/2)
        end
    end
end
--止血钳
ST.Items.hemostat = function(item, usingCharacter, targetCharacter, limb) 
    local limbtype = limb.type
    --生命停滞
    if(HasAffliction(targetCharacter,"lifestagnant",0.1)) then return end


    if CanDoing(targetCharacter) and HasAfflictionLimb(targetCharacter,"retractedskin",limbtype,99) then
        AddAfflictionLimb(targetCharacter,"ST_arteriesclamp",limbtype,GetSkillLevel(usingCharacter,"medical")/random(0.7,1.5))
    end
    if(CanDoing(targetCharacter) and HasAfflictionLimb(targetCharacter,"surgeryincision",limbtype,99) and not HasAfflictionLimb(targetCharacter,"clampedbleeders",limbtype,1)) then
        if GetSkillLevel(usingCharacter,"medical") >= 20 then
            AddAfflictionLimb(targetCharacter,"clampedbleeders",limbtype,GetSkillLevel(usingCharacter,"medical")/1.1)
        elseif random(1,100) <= 5 then
            AddAfflictionLimb(targetCharacter,"clampedbleeders",limbtype,GetSkillLevel(usingCharacter,"medical")/1.5)
        end
    end
end
--牵引器
ST.Items.retractors = function(item, usingCharacter, targetCharacter, limb) 
    local limbtype = limb.type
    --生命停滞
    if(HasAffliction(targetCharacter,"lifestagnant",0.1)) then return end

    if(CanDoing(targetCharacter) and HasAfflictionLimb(targetCharacter,"clampedbleeders",limbtype,99) and not HasAfflictionLimb(targetCharacter,"retractedskin",limbtype,1)) then
        if GetSkillLevel(usingCharacter,"medical") >= 10 then
            AddAfflictionLimb(targetCharacter,"retractedskin",limbtype,GetSkillLevel(usingCharacter,"medical")/1.2)
        elseif random(1,100) <= 40 then
            AddAfflictionLimb(targetCharacter,"retractedskin",limbtype,GetSkillLevel(usingCharacter,"medical")/1.4)
        end
    end
end
--血管内气囊（已消毒）
ST.Items.ST_endovascballoon = function(item, usingCharacter, targetCharacter, limb) 
    local limbtype = limb.type
    --生命停滞
    if(HasAffliction(targetCharacter,"lifestagnant",0.1)) then return end

    if(CanDoing(targetCharacter) and HasAfflictionLimb(targetCharacter,"retractedskin",limbtype,99) and not HasAfflictionLimb(targetCharacter,"ST_balloonedaorta",limbtype,1)) then
        if GetSkillLevel(usingCharacter,"medical") >= 10 then
            AddAfflictionLimb(targetCharacter,"ST_balloonedaorta",limbtype,GetSkillLevel(usingCharacter,"medical"))
        elseif random(1,100) <= 40 then
            AddAfflictionLimb(targetCharacter,"ST_balloonedaorta",limbtype,GetSkillLevel(usingCharacter,"medical")/1.2)
        end
        RemoveItem(item)
    end
end
--血管内气囊（未消毒）
ST.Items.ST_endovascballoon_b = function(item, usingCharacter, targetCharacter, limb) 
    local limbtype = limb.type
    --生命停滞
    if(HasAffliction(targetCharacter,"lifestagnant",0.1)) then return end

    if(CanDoing(targetCharacter) and HasAfflictionLimb(targetCharacter,"retractedskin",limbtype,99) and not HasAfflictionLimb(targetCharacter,"ST_balloonedaorta",limbtype,1)) then
        if GetSkillLevel(usingCharacter,"medical") >= 10 then
            AddAfflictionLimb(targetCharacter,"ST_balloonedaorta",limbtype,GetSkillLevel(usingCharacter,"medical"))
        elseif random(1,100) <= 40 then
            AddAfflictionLimb(targetCharacter,"ST_balloonedaorta",limbtype,GetSkillLevel(usingCharacter,"medical")/1.2)
        end
        RemoveItem(item)
    end
end
--医用支架
ST.Items.ST_medstent = function(item, usingCharacter, targetCharacter, limb) 
    local limbtype = limb.type
    --生命停滞
    if(HasAffliction(targetCharacter,"lifestagnant",0.1)) then return end

    if(CanDoing(targetCharacter) and HasAfflictionLimb(targetCharacter,"retractedskin",limbtype,99) and not HasAfflictionLimb(targetCharacter,"ST_medstent_aff",limbtype,0.1)) then
        if GetSkillLevel(usingCharacter,"medical") >= 40 then
            AddAfflictionLimb(targetCharacter,"ST_medstent_aff",limbtype,10)
        elseif random(1,100) <= 40 then
            AddAfflictionLimb(targetCharacter,"ST_medstent_aff",limbtype,10)
        end
        RemoveItem(item)
    end
end
--医用支架盒
ST.Items.ST_medstent_B = function(item, usingCharacter, targetCharacter, limb) 
    local limbtype = limb.type
    --生命停滞
    if(HasAffliction(targetCharacter,"lifestagnant",0.1)) then return end

    if(CanDoing(targetCharacter) and HasAfflictionLimb(targetCharacter,"retractedskin",limbtype,99) and not HasAfflictionLimb(targetCharacter,"ST_medstent_aff",limbtype,0.1)) then
        if GetSkillLevel(usingCharacter,"medical") >= 40 then
            AddAfflictionLimb(targetCharacter,"ST_medstent_aff",limbtype,10)
        elseif random(1,100) <= 40 then
            AddAfflictionLimb(targetCharacter,"ST_medstent_aff",limbtype,10)
        end
        item.Condition = item.Condition-20
    end
end
--人造血管
ST.Items.Artificialbloodvessels = function(item, usingCharacter, targetCharacter, limb) 
    local limbtype = limb.type
    --生命停滞
    if(HasAffliction(targetCharacter,"lifestagnant",0.1)) then return end

    if(CanDoing(targetCharacter) and HasAfflictionLimb(targetCharacter,"retractedskin",limbtype,99) and HasAfflictionLimb(targetCharacter,"ST_medstent_aff",limbtype,0.1)) then
        if GetSkillLevel(usingCharacter,"medical") >= 40 then
            if limbtype == 12 then
                SetAfflictionLimb(targetCharacter,"ST_arterialcut_M",limbtype,0)
                SetAfflictionLimb(targetCharacter,"ST_balloonedaorta",limbtype,0)
                SetAfflictionLimb(targetCharacter,"ST_medstent_aff",limbtype,0)
            else
                SetAfflictionLimb(targetCharacter,"ST_arterialcut_F",limbtype,0)
                SetAfflictionLimb(targetCharacter,"ST_balloonedaorta",limbtype,0)
                SetAfflictionLimb(targetCharacter,"ST_medstent_aff",limbtype,0)
            end
        elseif random(1,100) <= 40 then
            if limbtype == 12 then
                SetAfflictionLimb(targetCharacter,"ST_arterialcut_M",limbtype,0)
                SetAfflictionLimb(targetCharacter,"ST_balloonedaorta",limbtype,0)
                SetAfflictionLimb(targetCharacter,"ST_medstent_aff",limbtype,0)
            else
                SetAfflictionLimb(targetCharacter,"ST_arterialcut_F",limbtype,0)
                SetAfflictionLimb(targetCharacter,"ST_balloonedaorta",limbtype,0)
                SetAfflictionLimb(targetCharacter,"ST_medstent_aff",limbtype,0)
            end
        end
        SpawnItemInventory(targetCharacter,"ST_endovascballoon_b")
        RemoveItem(item)
    end
end
--人造血管盒
ST.Items.Artificialbloodvessels_B = function(item, usingCharacter, targetCharacter, limb) 
    local limbtype = limb.type
    --生命停滞
    if(HasAffliction(targetCharacter,"lifestagnant",0.1)) then return end

    if(CanDoing(targetCharacter) and HasAfflictionLimb(targetCharacter,"retractedskin",limbtype,99) and HasAfflictionLimb(targetCharacter,"ST_medstent_aff",limbtype,0.1)) then
        if GetSkillLevel(usingCharacter,"medical") >= 40 then
            if limbtype == 12 then
                SetAfflictionLimb(targetCharacter,"ST_arterialcut_M",limbtype,0)
                SetAfflictionLimb(targetCharacter,"ST_balloonedaorta",limbtype,0)
                SetAfflictionLimb(targetCharacter,"ST_medstent_aff",limbtype,0)
            else
                SetAfflictionLimb(targetCharacter,"ST_arterialcut_F",limbtype,0)
                SetAfflictionLimb(targetCharacter,"ST_balloonedaorta",limbtype,0)
                SetAfflictionLimb(targetCharacter,"ST_medstent_aff",limbtype,0)
            end
        elseif random(1,100) <= 40 then
            if limbtype == 12 then
                SetAfflictionLimb(targetCharacter,"ST_arterialcut_M",limbtype,0)
                SetAfflictionLimb(targetCharacter,"ST_balloonedaorta",limbtype,0)
                SetAfflictionLimb(targetCharacter,"ST_medstent_aff",limbtype,0)
            else
                SetAfflictionLimb(targetCharacter,"ST_arterialcut_F",limbtype,0)
                SetAfflictionLimb(targetCharacter,"ST_balloonedaorta",limbtype,0)
                SetAfflictionLimb(targetCharacter,"ST_medstent_aff",limbtype,0)
            end
        end
        SpawnItemInventory(targetCharacter,"ST_endovascballoon_b")
        item.Condition = item.Condition-25
    end
end
--机械瓣膜
ST.Items.Mechanicalvalves = function(item, usingCharacter, targetCharacter, limb) 
    local limbtype = limb.type
    --生命停滞
    if(HasAffliction(targetCharacter,"lifestagnant",0.1)) then return end

    if CanDoing(targetCharacter) and HasAfflictionLimb(targetCharacter,"retractedskin",limbtype,99)then
        if GetSkillLevel(usingCharacter,"medical") >= 30 then
            if limbtype == 12 then
                SetAfflictionLimb(targetCharacter,"ST_arterialcut_M_b",limbtype,0)
            end
        elseif random(1,100) <= 40 then
            if limbtype == 12 then
                SetAfflictionLimb(targetCharacter,"ST_arterialcut_M_b",limbtype,0)
            end
        end
        RemoveItem(item)
    end
end
--机械瓣膜盒
ST.Items.Mechanicalvalves = function(item, usingCharacter, targetCharacter, limb) 
    local limbtype = limb.type
    --生命停滞
    if(HasAffliction(targetCharacter,"lifestagnant",0.1)) then return end

    if CanDoing(targetCharacter) and HasAfflictionLimb(targetCharacter,"retractedskin",limbtype,99)then
        if GetSkillLevel(usingCharacter,"medical") >= 30 then
            if limbtype == 12 then
                SetAfflictionLimb(targetCharacter,"ST_arterialcut_M_b",limbtype,0)
            end
        elseif random(1,100) <= 40 then
            if limbtype == 12 then
                SetAfflictionLimb(targetCharacter,"ST_arterialcut_M_b",limbtype,0)
            end
        end
        item.Condition = item.Condition-20
    end
end
--钻孔器
ST.Items.ST_surgicaldrill = function(item, usingCharacter, targetCharacter, limb) 
    local limbtype = limb.type
    --生命停滞
    if(HasAffliction(targetCharacter,"lifestagnant",0.1)) then return end

    if(CanDoing(targetCharacter) and HasAfflictionLimb(targetCharacter,"retractedskin",limbtype,99) and not HasAfflictionLimb(targetCharacter,"drilledbones",limbtype,1)) then
        if GetSkillLevel(usingCharacter,"medical") >= 45 then
            AddAfflictionLimb(targetCharacter,"drilledbones",limbtype,GetSkillLevel(usingCharacter,"medical")/1.7)
        elseif random(1,100) <= 10 then
            AddAfflictionLimb(targetCharacter,"drilledbones",limbtype,GetSkillLevel(usingCharacter,"medical")/2)
        end
    end
end
--骨植入物
ST.Items.syntheticbone = function(item, usingCharacter, targetCharacter, limb) 
    local limbtype = limb.type
    --生命停滞
    if(HasAffliction(targetCharacter,"lifestagnant",0.1)) then return end

    if CanDoing(targetCharacter) and HasAfflictionLimb(targetCharacter,"drilledbones",limbtype,99) then
        if GetSkillLevel(usingCharacter,"medical") >= 45 then
            AddAfflictionLimb(targetCharacter,"bonegrowth",limbtype,100)
        elseif random(1,100) <= 40 then
            AddAfflictionLimb(targetCharacter,"bonegrowth",limbtype,100)
        end
    end
    item.Condition = item.Condition-25
end
--钢骨植入物
ST.Items.syntheticbone_b = function(item, usingCharacter, targetCharacter, limb) 
    local limbtype = limb.type
    --生命停滞
    if(HasAffliction(targetCharacter,"lifestagnant",0.1)) then return end

    if CanDoing(targetCharacter) and HasAfflictionLimb(targetCharacter,"drilledbones",limbtype,99) then
        if GetSkillLevel(usingCharacter,"medical") >= 45 then
            AddAfflictionLimb(targetCharacter,"bonegrowth_B",limbtype,100)
        elseif random(1,100) <= 40 then
            AddAfflictionLimb(targetCharacter,"bonegrowth_B",limbtype,100)
        end
    end
    item.Condition = item.Condition-20
end
--骨头补片
ST.Items.BonePatch = function(item, usingCharacter, targetCharacter, limb) 
    local limbtype = limb.type
    --生命停滞
    if(HasAffliction(targetCharacter,"lifestagnant",0.1)) then return end

    if CanDoing(targetCharacter) and HasAfflictionLimb(targetCharacter,"drilledbones",limbtype,99) then
        if GetSkillLevel(usingCharacter,"medical") >= 30 then
            SetAfflictionLimb(targetCharacter,"drilledbones",limbtype,0)
        elseif random(1,100) <= 40 then
            SetAfflictionLimb(targetCharacter,"drilledbones",limbtype,0)
        end
    end
end
--骨头补片（盒）
ST.Items.BonePatch_B = function(item, usingCharacter, targetCharacter, limb) 
    local limbtype = limb.type
    --生命停滞
    if(HasAffliction(targetCharacter,"lifestagnant",0.1)) then return end

    if CanDoing(targetCharacter) and HasAfflictionLimb(targetCharacter,"drilledbones",limbtype,99) then
        if GetSkillLevel(usingCharacter,"medical") >= 30 then
            SetAfflictionLimb(targetCharacter,"drilledbones",limbtype,0)
        elseif random(1,100) <= 40 then
            SetAfflictionLimb(targetCharacter,"drilledbones",limbtype,0)
        end
    end
    item.Condition = item.Condition-25
end
--驱血带
ST.Items.Phalliquebelt = function(item, usingCharacter, targetCharacter, limb) 
    local limbtype = limb.type

    if not HasAfflictionLimb(targetCharacter,"ST_arteriesclamp",limbtype,1) then
        if GetSkillLevel(usingCharacter,"medical") >= 15 then
            AddAfflictionLimb(targetCharacter,"ST_arteriesclamp",limbtype,GetSkillLevel(usingCharacter,"medical")/random(0.7,1.5))
        elseif random(1,100) <= 50 then
            AddAfflictionLimb(targetCharacter,"ST_arteriesclamp",limbtype,GetSkillLevel(usingCharacter,"medical")/random(0.7,1.5))
        end
    end
end
--驱血带盒
ST.Items.Phalliquebelt_B = function(item, usingCharacter, targetCharacter, limb) 
    local limbtype = limb.type

    if not HasAfflictionLimb(targetCharacter,"ST_arteriesclamp",limbtype,1) then
        if GetSkillLevel(usingCharacter,"medical") >= 15 then
            AddAfflictionLimb(targetCharacter,"ST_arteriesclamp",limbtype,GetSkillLevel(usingCharacter,"medical")/random(0.7,1.5))
        elseif random(1,100) <= 50 then
            AddAfflictionLimb(targetCharacter,"ST_arteriesclamp",limbtype,GetSkillLevel(usingCharacter,"medical")/random(0.7,1.5))
        end
    end
    item.Condition = item.Condition-20
end
--手术锯
ST.Items.surgerysaw = function (item, usingCharacter, targetCharacter, limb)
    local limbtype = NormalizeLimbType(limb.type)
    --生命停滞
    if(HasAffliction(targetCharacter,"lifestagnant",0.1)) then return end

    if CanDoing(targetCharacter) and HasAfflictionLimb(targetCharacter,"retractedskin",limbtype,99) then
        if GetSkillLevel(usingCharacter,"medical") >= 50 then
            if HasAfflictionLimb(targetCharacter,"ST_arteriesclamp",limbtype,99) then
                AddAfflictionLimb(targetCharacter,"bonecut",limbtype,GetSkillLevel(usingCharacter,"medical")/1.2)
            else
                AddAfflictionLimb(targetCharacter,"bleeding",limbtype,random(30,50))
                AddAfflictionLimb(targetCharacter,"Nerverupture",limbtype,random(30,50))
                AddAfflictionLimb(targetCharacter,"ST_arterialcut_F",limbtype,random(50,80))
                AddAfflictionLimb(targetCharacter,"bonecut",limbtype,GetSkillLevel(usingCharacter,"medical")/0.7)
            end
        elseif random(1,100) <= 50 then
            if HasAfflictionLimb(targetCharacter,"ST_arteriesclamp",limbtype,99) then
                AddAfflictionLimb(targetCharacter,"bonecut",limbtype,GetSkillLevel(usingCharacter,"medical")/1.5)
            else
                AddAfflictionLimb(targetCharacter,"bleeding",limbtype,random(30,50))
                AddAfflictionLimb(targetCharacter,"Nerverupture",limbtype,random(30,50))
                AddAfflictionLimb(targetCharacter,"ST_arterialcut_F",limbtype,random(50,80))
                AddAfflictionLimb(targetCharacter,"bonecut",limbtype,GetSkillLevel(usingCharacter,"medical")/2)
            end
        end
    end
end
--缝合线
ST.Items.Sutures = function (item, usingCharacter, targetCharacter, limb)
    local limbtype = NormalizeLimbType(limb.type)

    AddAfflictionLimb(targetCharacter,"Sutures",limbtype,random(1,10))

    if HasAfflictionLimb(targetCharacter,"drilledbones",limbtype,0.1) then return end
    if HasAfflictionLimb(targetCharacter,"bonecut",limbtype,0.1) and not HasAfflictionLimb(targetCharacter,"TearingLimbs",limbtype,0.1) then
        if limbtype == LimbType.RightArm then AddAfflictionLimb(targetCharacter,"sra_amputation",LimbType.RightArm,100) SpawnItemInventory(targetCharacter,"rarm")end
        if limbtype == LimbType.LeftArm then AddAfflictionLimb(targetCharacter,"sla_amputation",LimbType.LeftArm,100) SpawnItemInventory(targetCharacter,"larm")end
        if limbtype == LimbType.RightLeg then AddAfflictionLimb(targetCharacter,"srl_amputation",LimbType.RightLeg,100) SpawnItemInventory(targetCharacter,"rleg")end
        if limbtype == LimbType.LeftLeg then AddAfflictionLimb(targetCharacter,"sll_amputation",LimbType.LeftLeg,100) SpawnItemInventory(targetCharacter,"lleg")end
    elseif HasAfflictionLimb(targetCharacter,"bonecut",limbtype,0.1) and HasAfflictionLimb(targetCharacter,"TearingLimbs",limbtype,0.5) then
        if limbtype == LimbType.RightArm then AddAfflictionLimb(targetCharacter,"sra_amputation",LimbType.RightArm,100) SpawnItemInventory(targetCharacter,"RottenMeat") end
        if limbtype == LimbType.LeftArm then AddAfflictionLimb(targetCharacter,"sla_amputation",LimbType.LeftArm,100) SpawnItemInventory(targetCharacter,"RottenMeat") end
        if limbtype == LimbType.RightLeg then AddAfflictionLimb(targetCharacter,"srl_amputation",LimbType.RightLeg,100) SpawnItemInventory(targetCharacter,"RottenMeat") end
        if limbtype == LimbType.LeftLeg then AddAfflictionLimb(targetCharacter,"sll_amputation",LimbType.LeftLeg,100) SpawnItemInventory(targetCharacter,"RottenMeat") end
    end
    local cansuture = ST.SurgicalStatus
    for val in cansuture do
        if HasAfflictionLimb(targetCharacter,"drilledbones",limbtype,0.1) then return end
        SetAfflictionLimb(targetCharacter,val,limbtype,0)
    end
end
--强力胶
ST.Items.Superglue = function(item, usingCharacter, targetCharacter, limb) 
    local limbtype = limb.type
    print(limbtype)
    if(HasAfflictionLimb(targetCharacter,"ST_Superglue",limbtype,0.1)) then return end

    -- 获取并保存当前痛苦值
    local bleedingValue = GetAfflictionStrengthLimb(targetCharacter,"bleeding",limbtype)
    local gunshotWoundValue = GetAfflictionStrengthLimb(targetCharacter,"gunshotwound",limbtype)
    local lacerationsV = GetAfflictionStrengthLimb(targetCharacter,"lacerations",limbtype)
    local bloodlossV = GetAfflictionStrengthLimb(targetCharacter,"bloodloss",limbtype)
    -- 将痛苦值设为 0
    SetAfflictionLimb(targetCharacter,"bleeding",limbtype,0)
    SetAfflictionLimb(targetCharacter,"gunshotwound",limbtype,0)
    SetAfflictionLimb(targetCharacter,"lacerations",limbtype,0)
    SetAfflictionLimb(targetCharacter,"bloodloss",limbtype,0)
    SetAfflictionLimb(targetCharacter,"ST_Superglue",limbtype,10)
    Timer.Wait(function()
        -- 恢复痛苦值
        SetAfflictionLimb(targetCharacter,"bleeding",limbtype,bleedingValue/random(1,1.3))
        SetAfflictionLimb(targetCharacter,"gunshotwound",limbtype,gunshotWoundValue/random(1,1.3))
        SetAfflictionLimb(targetCharacter,"lacerations",limbtype,lacerationsV/random(1,1.1))
        SetAfflictionLimb(targetCharacter,"bloodloss",limbtype,bloodlossV/random(1,1.2))
    end, 100000)
end
