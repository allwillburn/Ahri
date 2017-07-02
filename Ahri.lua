
local ver = "0.05"

if GetObjectName(GetMyHero()) ~= "Ahri" then return end

require('MixLib')
require("DamageLib")
require("OpenPredict")


function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        PrintChat('<font color = "#00FFFF">New version found! ' .. data)
        PrintChat('<font color = "#00FFFF">Downloading update, please wait...')
        DownloadFileAsync('https://raw.githubusercontent.com/allwillburn/Ahri/master/Ahri.lua', SCRIPT_PATH .. 'Ahri.lua', function() PrintChat('<font color = "#00FFFF">Ahri Update Complete, please 2x F6!') return end)
    else
        PrintChat('<font color = "#00FFFF">No new Ahri updates found!')
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/allwillburn/Ahri/master/Ahri.version", AutoUpdate)


GetLevelPoints = function(unit) return GetLevel(unit) - (GetCastLevel(unit,0)+GetCastLevel(unit,1)+GetCastLevel(unit,2)+GetCastLevel(unit,3)) end
local SetDCP, SkinChanger = 0

local AhriMenu = Menu("Ahri", "Ahri")

AhriMenu:SubMenu("Combo", "Combo")

AhriMenu.Combo:Boolean("Q", "Use Q in combo", true)
AhriMenu.Combo:Slider("Qpred", "Q Hit Chance", 3,0,10,1)
AhriMenu.Combo:Boolean("W", "Use W in Combo", true)
AhriMenu.Combo:Boolean("E", "Use E in Combo", false)
AhriMenu.Combo:Slider("Epred", "E Hit Chance", 3,0,10,1)
AhriMenu.Combo:Boolean("R", "Use R in Combo", true)
AhriMenu.Combo:Slider("RX", "X Enemies to Cast R",3,1,5,1)
AhriMenu.Combo:Boolean("Gunblade", "Use Gunblade", true)
AhriMenu.Combo:Boolean("Randuins", "Use Randuins", true)


AhriMenu:SubMenu("AutoMode", "AutoMode")
AhriMenu.AutoMode:Boolean("Level", "Auto level spells", false)
AhriMenu.AutoMode:Boolean("Ghost", "Auto Ghost", false)
AhriMenu.AutoMode:Boolean("Q", "Auto Q", false)
AhriMenu.AutoMode:Slider("Qpred", "Q Hit Chance", 3,0,10,1)
AhriMenu.AutoMode:Boolean("W", "Auto W", false)
AhriMenu.AutoMode:Boolean("E", "Auto E", false)
AhriMenu.AutoMode:Slider("Epred", "E Hit Chance", 3,0,10,1)
AhriMenu.AutoMode:Boolean("R", "Auto R", false)
AhriMenu.AutoMode:Slider("RX", "X Enemies to Cast R",3,1,5,1)

AhriMenu:SubMenu("AutoFarm", "AutoFarm")
AhriMenu.AutoFarm:Boolean("Q", "Auto Q", false)
AhriMenu.AutoFarm:Boolean("W", "Auto W", false)
AhriMenu.AutoFarm:Boolean("E", "Auto E", false)




AhriMenu:SubMenu("LaneClear", "LaneClear")
AhriMenu.LaneClear:Boolean("Q", "Use Q", true)
AhriMenu.LaneClear:Boolean("W", "Use W", true)
AhriMenu.LaneClear:Boolean("E", "Use E", true)


AhriMenu:SubMenu("Harass", "Harass")
AhriMenu.Harass:Boolean("Q", "Use Q", true)
AhriMenu.Harass:Boolean("W", "Use W", true)

AhriMenu:SubMenu("KillSteal", "KillSteal")
AhriMenu.KillSteal:Boolean("Q", "KS w Q", true)
AhriMenu.KillSteal:Slider("Qpred", "Q Hit Chance", 3,0,10,1)
AhriMenu.KillSteal:Boolean("W", "KS w W", true)
AhriMenu.KillSteal:Boolean("E", "KS w E", true)
AhriMenu.KillSteal:Slider("Epred", "E Hit Chance", 3,0,10,1)
AhriMenu.KillSteal:Boolean("R", "KS w R", true)


AhriMenu:SubMenu("AutoIgnite", "AutoIgnite")
AhriMenu.AutoIgnite:Boolean("Ignite", "Ignite if killable", true)

AhriMenu:SubMenu("Drawings", "Drawings")
AhriMenu.Drawings:Boolean("DQ", "Draw Q Range", true)

AhriMenu:SubMenu("SkinChanger", "SkinChanger")
AhriMenu.SkinChanger:Boolean("Skin", "UseSkinChanger", true)
AhriMenu.SkinChanger:Slider("SelectedSkin", "Select A Skin:", 1, 0, 4, 1, function(SetDCP) HeroSkinChanger(myHero, SetDCP)  end, true)

OnTick(function (myHero)
	      local target = GetCurrentTarget()
        
        local Gunblade = GetItemSlot(myHero, 3146)       
        local Cutlass = GetItemSlot(myHero, 3144)
        local Randuins = GetItemSlot(myHero, 3143)
        local AhriQ = {delay = 0.25, range = 880, width = 100, speed = 1700}
        local AhriE = {delay = 0.25, range = 975, width = 60, speed = 1600}        
        

	--AUTO LEVEL UP
	if AhriMenu.AutoMode.Level:Value() then

			spellorder = {_E, _W, _Q, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
			if GetLevelPoints(myHero) > 0 then
				LevelSpell(spellorder[GetLevel(myHero) + 1 - GetLevelPoints(myHero)])
			end
	end
        
        --Harass
          if Mix:Mode() == "Harass" then
            if AhriMenu.Harass.Q:Value() and Ready(_Q) and ValidTarget(target, 850) then		
                                      CastSkillShot(_Q, target)
                                
            end

            if AhriMenu.Harass.W:Value() and Ready(_W) and ValidTarget(target, 800) then
				       CastSpell(_W)
            end     
          end

	--COMBO
	  if Mix:Mode() == "Combo" then
        

            if AhriMenu.Combo.Randuins:Value() and Randuins > 0 and Ready(Randuins) and ValidTarget(target, 500) then
			           CastSpell(Randuins)
            end
			
	    if AhriMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 880) then
                 local QPred = GetPrediction(target,AhriQ)
                 if QPred.hitChance > (AhriMenu.Combo.Qpred:Value() * 0.1) then
                           CastSkillShot(_Q, QPred.castPos)
                 end
            end	
                   
            	
	    	
	    if AhriMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 975) then
                 local EPred = GetPrediction(target,AhriE)
                 if EPred.hitChance > (AhriMenu.Combo.Epred:Value() * 0.1) and not EPred:mCollision(1) then
                           CastSkillShot(_E, EPred.castPos)
                 end
            end		
           
            if AhriMenu.Combo.Gunblade:Value() and Gunblade > 0 and Ready(Gunblade) and ValidTarget(target, 700) then
			            CastTargetSpell(target, Gunblade)
                  end
          
            if AhriMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 700) then                                     
                                    CastSpell(_W)
                   
            end
	    	    
            if AhriMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 450) and (EnemiesAround(myHeroPos(), 450) >= AhriMenu.Combo.RX:Value()) then            
                             CastSkillShot(_R, target.pos)
                   
        
            end
			
	    			

          end

         --AUTO IGNITE
	for _, enemy in pairs(GetEnemyHeroes()) do
		
		if GetCastName(myHero, SUMMONER_1) == 'SummonerDot' then
			 Ignite = SUMMONER_1
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end

		elseif GetCastName(myHero, SUMMONER_2) == 'SummonerDot' then
			 Ignite = SUMMONER_2
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end
		end

	end

    --KillSteal

        for _, enemy in pairs(GetEnemyHeroes()) do
                
                if IsReady(_Q) and ValidTarget(enemy, 880) and AhriMenu.KillSteal.Q:Value() and GetHP(enemy) < getdmg("Q",enemy) then
                       local QPred = GetPrediction(target,AhriQ)
                       if QPred.hitChance > (AhriMenu.KillSteal.Qpred:Value() * 0.1) then
                                 CastSkillShot(_Q, QPred.castPos)
                       end
            end

                
		         if IsReady(_W) and ValidTarget(enemy, 800) and AhriMenu.KillSteal.W:Value() and GetHP(enemy) < getdmg("W",enemy) then                   
                                  CastSpell(_W)
                    
             end
			
			
		         if AhriMenu.KillSteal.E:Value() and Ready(_E) and ValidTarget(target, 975) then
                 local EPred = GetPrediction(target,AhriE)
                 if EPred.hitChance > (AhriMenu.Combo.Epred:Value() * 0.1) and not EPred:mCollision(1) then
                           CastSkillShot(_E, EPred.castPos)
                 end
            end	


              if AhriMenu.KillSteal.R:Value() and Ready(_R) and ValidTarget(target, 450) and GetHP(enemy) < getdmg("R",enemy) then                      
                                 CastSkillShot(_R, target.pos)
                       end
            
                
            
              end

    
      --Laneclear	
      if Mix:Mode() == "LaneClear" then
      	  for _,closeminion in pairs(minionManager.objects) do
	        if AhriMenu.LaneClear.Q:Value() and Ready(_Q) and ValidTarget(closeminion, 880) then
	        	CastSkillShot(_Q, closeminion)
                end

                if AhriMenu.LaneClear.W:Value() and Ready(_W) and ValidTarget(closeminion, 800) then
	        	CastSkillShot(_W, closeminion)
	        end

                if AhriMenu.LaneClear.E:Value() and Ready(_E) and ValidTarget(closeminion, 975) then
	        	CastTargetSpell(closeminion, _E)
	        end

               
          end
      end

      --Auto on minions
          for _, minion in pairs(minionManager.objects) do
      			
      			   	
              if AhriMenu.AutoFarm.Q:Value() and Ready(_Q) and ValidTarget(minion, 880) and GetCurrentHP(minion) < CalcDamage(myHero,minion,QDmg,Q) then
                  CastSkillShot(_Q, minion)
              end

              if AhriMenu.AutoFarm.W:Value() and Ready(_W) and ValidTarget(minion, 800) and GetCurrentHP(minion) < CalcDamage(myHero,minion,WDmg,W) then
                  CastSkillShot(_Q, minion)
              end

              if AhriMenu.AutoFarm.E:Value() and Ready(_E) and ValidTarget(minion, 975) and GetCurrentHP(minion) < CalcDamage(myHero,minion,EDmg,E) then
                  CastTargetSpell(minion, _E)
              end
		
	      if AhriMenu.AutoFarm.E:Value() and Ready(_E) and ValidTarget(minion, 450) and minion.isPoisoned and GetCurrentHP(minion) < CalcDamage(myHero,minion,EDmg,E) then
                  CastTargetSpell(minion, _E)
              end		
			
          end


      


      
      --AutoMode
      
        if AhriMenu.AutoMode.Q:Value() and ValidTarget(target, 880) then        
               local QPred = GetPrediction(target,AhriQ)
               if QPred.hitChance > (AhriMenu.AutoMode.Qpred:Value() * 0.1) then
                         CastSkillShot(_Q, QPred.castPos)
               end
       end

        
        if AhriMenu.AutoMode.W:Value() and ValidTarget(target, 800) then                       
                         CastSpell(_W)
               
        end
    
        if AhriMenu.AutoMode.E:Value() and Ready(_E) and ValidTarget(target, 975) then
                 local EPred = GetPrediction(target,AhriE)
                 if EPred.hitChance > (AhriMenu.Combo.Epred:Value() * 0.1) and not EPred:mCollision(1) then
                           CastSkillShot(_E, EPred.castPos)
                 end
            end	
        if AhriMenu.AutoMode.R:Value() and Ready(_R) and ValidTarget(target, 450) and (EnemiesAround(myHeroPos(), 825) >= AhriMenu.AutoMode.RX:Value()) then               
                         CastSkillShot(_R, target.pos)
               
    
        end
                
	--AUTO GHOST
	if AhriMenu.AutoMode.Ghost:Value() then
		if GetCastName(myHero, SUMMONER_1) == "SummonerHaste" and Ready(SUMMONER_1) then
			CastSpell(SUMMONER_1)
		elseif GetCastName(myHero, SUMMONER_2) == "SummonerHaste" and Ready(SUMMONER_2) then
			CastSpell(Summoner_2)
		end
	end
end)

OnDraw(function (myHero)
        
         if AhriMenu.Drawings.DQ:Value() then
		DrawCircle(GetOrigin(myHero), 880, 0, 150, GoS.Black)
	end

end)



local function SkinChanger()
	if AhriMenu.SkinChanger.UseSkinChanger:Value() then
		if SetDCP >= 0  and SetDCP ~= GlobalSkin then
			HeroSkinChanger(myHero, SetDCP)
			GlobalSkin = SetDCP
		end
        end
end


print('<font color = "#01DF01"><b>Ahri</b> <font color = "#01DF01">by <font color = "#01DF01"><b>Allwillburn</b> <font color = "#01DF01">Loaded!')
