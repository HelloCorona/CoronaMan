local GameUXManager = require("managers.GameUXManager")
local SQLiteManager = require("managers.SQLiteManager")
local GameConfig = require("GameConfig")

local Class = {}

Class.create = function(completeCallback)
	local mainG = display.newGroup()
	
	-- 전체 배경
	local bg = display.newRect(mainG, 0, 0, __appContentWidth__, __appContentHeight__)
	bg:setFillColor(0, 0, 0, 0.7)
	
	local function fakeEvent(e)
		return true
	end
	bg:addEventListener("touch", fakeEvent)
	bg:addEventListener("tap", fakeEvent)
    
    local box = display.newGroup()
    mainG:insert(box)
    
    local boxBg = display.newImage(box, "images/system_bg.png", 0, 0)
    __setScaleFactor(boxBg)
	
	--===== 사운드 버튼 Begin =====--
    local soundBtnG = display.newGroup()
    box:insert(soundBtnG)

    local sndOnBtn, sndOffBtn

    sndOnBtn = display.newImage(soundBtnG, "images/btn_sound_on.png", 0, 0)
    __setScaleFactor(sndOnBtn)
    sndOnBtn.isVisible = (SQLiteManager.getConfig(GameConfig.DB_SOUND_ENABLED) == "on")

    local function on_SndOnBtnTap(e)
        SQLiteManager.setConfig(GameConfig.DB_SOUND_ENABLED, "off")
        sndOnBtn.isVisible = false
        sndOffBtn.isVisible = true
        GameConfig.setVolume(0)
    end
    sndOnBtn:addEventListener("tap", on_SndOnBtnTap)

    sndOffBtn = display.newImage(soundBtnG, "images/btn_sound_off.png", 0, 0)
    __setScaleFactor(sndOffBtn)
    sndOffBtn.isVisible = (SQLiteManager.getConfig(GameConfig.DB_SOUND_ENABLED) ~= "on")

    local function on_SndOffBtnTap(e)
        SQLiteManager.setConfig(GameConfig.DB_SOUND_ENABLED, "on")
        sndOnBtn.isVisible = true
        sndOffBtn.isVisible = false
        GameConfig.setVolume(1)
    end
    sndOffBtn:addEventListener("tap", on_SndOffBtnTap)

    soundBtnG.x, soundBtnG.y = (boxBg.width * 0.5) - (soundBtnG.width * 0.5), 80
    --===== 사운드 버튼 End =====--
	
	--===== 닫기 버튼 Begin =====--
	local btn = display.newImage(box, "images/btn_system_close.png", 0, 0)
	btn.anchorX = 0.5
	__setScaleFactor(btn)
	btn.x, btn.y = (boxBg.width * 0.5), boxBg.height - btn.height - 40
	
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
	--===== 닫기 버튼 End =====--
    
    box.x, box.y = (__appContentWidth__ * 0.5) - (box.width * 0.5), (__appContentHeight__ * 0.45) - (box.height * 0.5)
	
	return mainG
end

return Class