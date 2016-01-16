local GameUXManager = require("managers.GameUXManager")
local GameConfig = require("GameConfig")

local Class = {}

Class.create = function(completeCallback)
	local mainG = display.newGroup()
    
    -- 실패 사운드
    GameConfig.playEffectSound("sounds/missionFailed.mp3")
	
	-- 전체 배경
	local bg = display.newRect(mainG, 0, 0, __appContentWidth__, __appContentHeight__)
	bg:setFillColor(0, 0, 0, 0.4)
	
	local function fakeEvent(e)
		return true
	end
	bg:addEventListener("touch", fakeEvent)
	bg:addEventListener("tap", fakeEvent)
	
	-- 중앙 미션 실패 배경
	local titleBg = display.newImage(mainG, "images/fail_pop.png", 0, 0)
	__setScaleFactor(titleBg)
	titleBg.anchorX, titleBg.anchorY = 0.5, 0.5
	titleBg.x, titleBg.y = bg.width * 0.5, bg.height * 0.45
	
	--===== 버튼 Begin =====--
	local btn = display.newImage(mainG, "images/btn_retry.png", 0, 0)
	btn.anchorX, btn.anchorY = 0.5, 0.5
	__setScaleFactor(btn)
	btn.x, btn.y = (__appContentWidth__ * 0.5), titleBg.y + (titleBg.height * 0.2)
	
	local function on_CompleteCallback(isTap)
		if isTap then
            completeCallback()
			mainG:removeSelf()
		end
	end
	GameUXManager.applyMotionButton(btn, nil, on_CompleteCallback,
        function ()
            btn.enabled = false
            
            -- 버튼 사운드
            GameConfig.playEffectSound("sounds/levelUp.mp3")
        end
    )
	--===== 버튼 End =====--
	
	return mainG
end

return Class