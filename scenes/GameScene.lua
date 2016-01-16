local Fonts = require("Fonts")
local GameConfig = require("GameConfig")
local EnterFrameManager = require("managers.EnterFrameManager")
local ColorUtils = require("utils.ColorUtils")
local GameUXManager = require("managers.GameUXManager")
local StageClearPopup = require("scenes.controls.StageClearPopup")
local SettingsPopup = require("scenes.controls.SettingsPopup")
local MissionFailedPopup = require("scenes.controls.MissionFailedPopup")
local MathUtils = require("utils.MathUtils")

--##############################  Main Code Begin  ##############################--
local composer = require( "composer" )

local scene = composer.newScene()

local createBg, createPlayerLevelBox, createCoronaMan, createTopUI, createAPIText, missionComplete
local coinTxt, stageTxt, plrLvlTxt, plrLvlUpTxt, coronaMan, apiTextLayer
local startGameTimer, stopGameTimer, pauseGameTimer, resumeGameTimer
local bottomPlayerLevelG -- 하단 플레이어 레벨 박스

-- "scene:create()"
function scene:create( event )
	local sceneGroup = self.view
	
	-- 게임 데이터 초기화
	GameConfig.init()
	
	-- 배경음악
	GameConfig.playBGM("sounds/game.mp3")

	--=========== 배경 생성 Begin ===========--
	local bg = createBg(sceneGroup)
	--=========== 배경 생성 End ===========--
    
    -- API 텍스트 레이어
    apiTextLayer = display.newGroup()
    sceneGroup:insert(apiTextLayer)
    
	--=========== 하단 플레이어 레벨 박스 관련 Begin ===========--
	bottomPlayerLevelG = createPlayerLevelBox(sceneGroup)
	--=========== 하단 플레이어 레벨 박스 관련 End ===========--
    
	--=========== 코로나맨 생성 Begin ===========--
	coronaMan = createCoronaMan(sceneGroup)
	coronaMan.x, coronaMan.y = __appContentWidth__ * 0.5, __appContentHeight__ * 0.42
	--=========== 코로나맨 생성 End ===========--
	
	--=========== 상단 UI 생성 Begin ===========--
	createTopUI(sceneGroup)
	--=========== 상단 UI 생성 End ===========--

	--=========== 게임 타이머 Begin ===========--
	local gTimer
    local gTimerPaused
    
	-- 게임 타이머 시작
	startGameTimer = function (totalTime)
        gTimerPaused = false
		local function on_Timer(e)
			-- 타임 아웃!!
			if totalTime <= e.count then
				stopGameTimer()
				
				sceneGroup.touchEnabled = false
				
				-- 미션 실패 팝업 생성
				local failedPopup = MissionFailedPopup.create(function ()
					sceneGroup.touchEnabled = true
					coronaMan.init()
					startGameTimer(GameConfig.countdownInitTime)
				end)
				sceneGroup:insert(failedPopup)
			end
            
            coronaMan.setTime(totalTime - e.count)
		end
		gTimer = timer.performWithDelay(1000, on_Timer, totalTime)
		coronaMan.setTime(totalTime)
	end
	
	-- 게임 타이머 정지
	stopGameTimer = function ()
        gTimerPaused = false
		if gTimer ~= nil then timer.cancel(gTimer) end
		gTimer= nil
	end
    
    pauseGameTimer = function ()
        if gTimerPaused then return end
        
        timer.pause(gTimer)
        gTimerPaused = true
    end
    
    resumeGameTimer = function ()
        if not gTimerPaused then return end
        
        timer.resume(gTimer)
        gTimerPaused = false
    end
	
	startGameTimer(GameConfig.countdownInitTime)
	--=========== 게임 타이머 End ===========--

	--================ 이벤트 처리 Begin ================--
	-- 일시 정지
	local function on_PauseGame(e)
	end
	Runtime:addEventListener("pauseGame", on_PauseGame)

	-- 재개
	local function on_ResumeGame(e)
	end
	Runtime:addEventListener("resumeGame", on_ResumeGame)
	--================ 이벤트 처리 End ================--
end

-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )

-- -------------------------------------------------------------------------------

-- 배경 생성
createBg = function (sceneGroup)
	local bg = display.newImage(sceneGroup, "images/game_bg.png", 0, 0)

	local scaleFactor = __appContentWidth__ / bg.width

	bg.width, bg.height = bg.width * scaleFactor, bg.height * scaleFactor
	bg.y = __appContentHeight__ - bg.height

	return bg
end

-- 하단 플레이어 레벨 박스 생성
createPlayerLevelBox = function (sceneGroup)
	-- 레벨업을 위한 코인의 양
	local function getPlayerLvlUpCoin(_lv, isPureNum)
		isPureNum = isPureNum or false
		local _lvUp = math.ceil((20 * _lv) + (math.floor(_lv / 0.5) * (20 + (_lv * 3))))
		if not isPureNum and _lvUp >= 1000 then _lvUp = MathUtils.roundToNthDecimal(_lvUp * 0.001, 2).."k" end
		return _lvUp
	end
	
	-- 레벨 박스 전체 그룹
	local boxG = display.newGroup()
	sceneGroup:insert(boxG)
	
	-- 배경
	local plrLvlBg = display.newImage(boxG, "images/skill_box.png", 0, 0)
	plrLvlBg.anchorX, plrLvlBg.anchorY = 0.5, 0.5
	__setScaleFactor(plrLvlBg)
	
	-- 레벨 텍스트
	plrLvlTxt = display.newText(boxG, "LV"..GameConfig.getPlayerLevel(), 0, 0, 0, 0, Fonts.NotoSans, 25)
	plrLvlTxt.x, plrLvlTxt.y = 20 - (plrLvlBg.width * 0.5), (plrLvlBg.height * 0.5) - (plrLvlTxt.height * 0.5) - 2 - (plrLvlBg.height * 0.5)

	--===== 레벨 업 버튼 그룹 Begin
	local plrLeverUpBtnG = display.newGroup()
	boxG:insert(plrLeverUpBtnG)
	
	local plrLvlUpBtnBg = display.newImage(plrLeverUpBtnG, "images/btn_coin_bg.png", 0, 0)
	__setScaleFactor(plrLvlUpBtnBg)

	local plrLvlUpBtnBgDisabled = display.newImage(plrLeverUpBtnG, "images/btn_coin_bg_disabled.png", 0, 0)
	__setScaleFactor(plrLvlUpBtnBgDisabled)
	
	-- 레벨 업 코인 텍스트
	plrLvlUpTxt = display.newText(plrLeverUpBtnG, "C "..getPlayerLvlUpCoin(GameConfig.getPlayerLevel()), 0, 0, 0, 0, Fonts.NotoSans, 16)
	plrLvlUpTxt.anchorX = 0.5
	plrLvlUpTxt:setFillColor(ColorUtils.hexToPercent("be835a"))
	plrLvlUpTxt.x, plrLvlUpTxt.y = plrLvlUpBtnBg.width * 0.5, (plrLvlUpBtnBg.height * 0.5) - (plrLvlUpTxt.height * 0.5)

	plrLeverUpBtnG.x, plrLeverUpBtnG.y = plrLvlBg.width - plrLeverUpBtnG.width - 20 - (plrLvlBg.width * 0.5), (plrLvlBg.height * 0.5) - (plrLeverUpBtnG.height * 0.5) - 2 - (plrLvlBg.height * 0.5)
	--===== 레벨 업 버튼 그룹 End

	-- 레벨 업 이벤트 핸들러
	local function on_PlayerLvlUp()
		if boxG.enabled == false then return end
        
        -- 레벨 업 사운드
        GameConfig.playEffectSound("sounds/levelUp.mp3")
		
		local _lvUpCoin = getPlayerLvlUpCoin(GameConfig.getPlayerLevel(), true)
		
		-- 코인 차감
		local _coin = GameConfig.getCoin(true) - _lvUpCoin
		GameConfig.setCoin(_coin)
		coinTxt.text = "C "..GameConfig.getCoin(false)
		
		-- 다음 레벨업 코인 설정
		local _lv = GameConfig.getPlayerLevel() + 1
		GameConfig.setPlayerLevel(_lv) -- DB 저장
		plrLvlTxt.text = "LV".._lv
		
		plrLvlUpTxt.text = "C "..getPlayerLvlUpCoin(_lv)
		
		-- 레벨 업 가능 여부 업데이트
		boxG.update()
	end
	GameUXManager.applyMotionButton(boxG, nil, nil, on_PlayerLvlUp)

	boxG.x, boxG.y = (__appContentWidth__ * 0.5), __appContentHeight__ - boxG.height - (__appContentHeight__ * 0.07)

	-- 하단 플레이어 레벨 박스 업데이트
	boxG.update = function ()
		local isCanUpdatePlayerLevel = (GameConfig.getCoin(true) >= getPlayerLvlUpCoin(GameConfig.getPlayerLevel(), true))

		plrLvlUpBtnBgDisabled.isVisible = not isCanUpdatePlayerLevel
		plrLvlUpBtnBg.isVisible = isCanUpdatePlayerLevel

		boxG.enabled = isCanUpdatePlayerLevel
	end
	boxG.update()
	
	return boxG
end

-- 코로나맨 생성
createCoronaMan = function(sceneGroup)
	local mainG = display.newGroup()
	sceneGroup:insert(mainG)
    
    -- 터치 영역
    local touchArea = display.newRect(mainG, 0, 0, 200, 250)
    touchArea.anchorX, touchArea.anchorY = 0.5, 0.5
    touchArea.alpha = 0.01
    
	mainG.cm = nil -- 코로나맨

	--===== HP Begin =====--
	local hpG = display.newGroup()
	mainG:insert(hpG)

	local hpTxt = display.newText(hpG, "HP", 0, 0, 0, 0, Fonts.NotoSans, 15)
	hpTxt:setFillColor(ColorUtils.hexToPercent("fbed20"))
	hpTxt.x, hpTxt.y = -hpTxt.width - 5, -5.5

	local hpBg = display.newImage(hpG, "images/gauge_bg.png", 0, 0)
	__setScaleFactor(hpBg)

	local hpBar = display.newImage(hpG, "images/gauge_bar.png", 3.5, 3.5)
	__setScaleFactor(hpBar)
	--===== HP End =====--

	local nameTxt = display.newText(mainG, "", 0, 0, 0, 0, Fonts.NotoSans, 17)
	nameTxt.anchorX = 0.5

	local timerTxt = display.newText(mainG, "00:00", 0, 0, 0, 0, Fonts.NotoSans, 25)
	timerTxt.anchorX = 0.5
	timerTxt:setFillColor(ColorUtils.hexToPercent("d3135a"))
	
	-- 코로나맨 터치
	local function touchCoronaMan(_x, _y)
        if GameConfig.isPaused() then return end -- 일시 정지
		if sceneGroup.touchEnabled == false then return end -- nil은 true로 간주
        
        -- 터치 사운드
        GameConfig.playEffectSound("sounds/touch.mp3")
        
        -- API 텍스트 생성
        createAPIText()
        
		local target = mainG.cm
		
		-- 튕기는 모션
		transition.to(target, {time=100, xScale=1.15, yScale=1.15,
			onComplete = function ()
				transition.to(target, {time=100, xScale=0.9, yScale=0.9,
					onComplete = function ()
						transition.to(target, {time=100, xScale=1, yScale=1})
					end
				})
			end
		})
		
		local _playerLvl = GameConfig.getPlayerLevel()
		
		-- 코인 증가
		local _coin = GameConfig.getCoin(true) + _playerLvl
		GameConfig.setCoin(_coin)
		coinTxt.text = "C "..GameConfig.getCoin(false)
		
		-- 점수+
		local plusTxt = display.newText(sceneGroup, "+".._playerLvl, _x, _y, 0, 0, Fonts.NotoSans, 25)
		plusTxt.anchorX, plusTxt.anchorY = 0.5, 0.5
		plusTxt:setFillColor(0, 0, 0, 1)
		transition.to(plusTxt, {time=300, y=plusTxt.y - 70, alpha=0.2,
			onComplete = function ()
				if plusTxt ~= nil and plusTxt.parent ~= nil then plusTxt:removeSelf() end
			end
		})
		
		-- 하단의 게임 레벨 그룹 업데이트(업데이트 가능 여부 표시)
		bottomPlayerLevelG.update()
		
		-- HP 감소
		mainG.cm.hp = mainG.cm.hp - _playerLvl
		local percent = mainG.cm.hp / GameConfig.coronaManHP[GameConfig.getGameLevel()]
		hpBar.xScale = (percent < 0 and 0.001 or percent)
		
		-- 스테이지 클리어!!
		if percent < 0 then
			sceneGroup.touchEnabled = false
			
			local clearPopup = StageClearPopup.create()
			sceneGroup:insert(clearPopup)
			
			stopGameTimer()
			
			local function nextStage(e2)
				clearPopup:removeSelf()
				
				local _newLvl = GameConfig.getGameLevel() + 1
                
                stageTxt.text = "Stage "..(_newLvl < 10 and "0".._newLvl or _newLvl)
				
				if _newLvl > GameConfig.totalLevels then -- 미션 컴플릿!!
					missionComplete()
				else -- 다음 미션 진행
					GameConfig.setGameLevel(_newLvl)
					mainG.init()
					startGameTimer(GameConfig.countdownInitTime)
					sceneGroup.touchEnabled = true
				end
			end
			timer.performWithDelay(3000, nextStage, 1)
		end
	end
	
	-- 코로나맨 터치 이벤트 핸들러
	local function on_Touch(e)
		if e.phase == "began" then
			touchCoronaMan(e.x, e.y)
		end
	end
	touchArea:addEventListener("touch", on_Touch)

	-- 코로나맨 초기화 또는 업데이트 (게임 판수에 따라 변경)
	mainG.init = function ()
		if mainG.cm then mainG.cm:removeSelf() end

		local _gameLvl = GameConfig.getGameLevel()
		
		mainG.cm = display.newImage(mainG, "images/coronaman_"..GameConfig.getGameLevel()..".png", 0, 0)
		mainG.cm.anchorX, mainG.cm.anchorY = 0.5, 0.5
		__setScaleFactor(mainG.cm)
		mainG.cm.hp = GameConfig.coronaManHP[_gameLvl]

		hpG.x, hpG.y = -(hpG.width * 0.5) + (hpTxt.width * 0.6), -(mainG.cm.height * 0.5) - 25

		nameTxt.text = (_gameLvl < 10 and "0".._gameLvl or _gameLvl).." CORONAMAN"
		nameTxt.y = (mainG.cm.height * 0.5) + 15

		timerTxt.text = "00:00"
		timerTxt.y = hpG.y - timerTxt.height - 15
	end

	mainG.setTime = function (seconds)
		local m = math.floor(seconds / 60)
		local s = seconds % 60
		timerTxt.text = (m < 10 and "0"..m or m)..":"..(s < 10 and "0"..s or s)
	end

	mainG.init()
	
	-- 자동 터치
--	timer.performWithDelay(1, function ()
--		local _stageX, _stageY = mainG.cm:localToContent(mainG.cm.x, mainG.cm.y)
--		touchCoronaMan(_stageX, _stageY)
--	end, 0)

	return mainG
end

-- 상단 UI 생성
createTopUI = function (sceneGroup)
	--=========== 좌상단 코인 관련 Begin ===========--
	local coinG = display.newGroup()
	coinG.x, coinG.y = 17, 18
	sceneGroup:insert(coinG)

	local coinBg = display.newImage(coinG, "images/btn_coin_bg.png", 0, 0)
	__setScaleFactor(coinBg)

	coinTxt = display.newText(coinG, "C "..GameConfig.getCoin(false), 0, 0, 0, 0, Fonts.NotoSans, 16)
	coinTxt.anchorX = 0.5
	coinTxt:setFillColor(ColorUtils.hexToPercent("be835a"))
	coinTxt.x, coinTxt.y = coinBg.width * 0.5, (coinBg.height * 0.5) - (coinTxt.height * 0.5)
	--=========== 좌상단 코인 관련 End ===========--

	--=========== 우상단 세팅 버튼 Begin ===========--
	local settingsBtn = display.newImage(sceneGroup, "images/btn_system.png", 0, 0)
	settingsBtn.anchorX, settingsBtn.anchorY = 0.5, 0.5
	__setScaleFactor(settingsBtn)
	settingsBtn.x, settingsBtn.y = __appContentWidth__ - settingsBtn.width - 17 + (settingsBtn.width * 0.5), coinG.y + (settingsBtn.height * 0.5)
	
	local function on_SettinsBtnTap()
        GameConfig.pauseGame(true)
        
        -- 버튼 사운드
        GameConfig.playEffectSound("sounds/levelUp.mp3")
        
        local settingsPopup = SettingsPopup.create(function ()
            GameConfig.resumeGame(true)
        end)
        sceneGroup:insert(settingsPopup)
	end
	GameUXManager.applyMotionButton(settingsBtn, nil, nil, on_SettinsBtnTap)
	--=========== 우상단 세팅 버튼 End ===========--

	--=========== 상단 중앙 Stage 텍스트 Begin ===========--
	local _gameLvl = GameConfig.getGameLevel()
	stageTxt = display.newText(sceneGroup, "Stage "..(_gameLvl < 10 and "0".._gameLvl or _gameLvl), 0, 0, 0, 0, Fonts.NotoSans, 20)
	stageTxt.anchorX = 0.5
	stageTxt.x, stageTxt.y = (coinG.x + coinG.width) + ((settingsBtn.x - (settingsBtn.width * 0.5) - (coinG.x + coinG.width)) * 0.5), 22
	--=========== 상단 중앙 Stage 텍스트 End ===========--
end

-- API 텍스트 생성
createAPIText = function ()
    local txt = display.newText(apiTextLayer, GameConfig.getAPI(), math.random(50, __appContentWidth__ - 50), -50, 0, 0, Fonts.NotoSans, 15)
    txt:setFillColor(math.random(), math.random(), math.random(), 1)
    local vx, vy = math.random(-3, 3), math.random(1, 3)
    txt.on_EnterFrame = EnterFrameManager.addListener(function ()
        txt.x, txt.y = txt.x + vx, txt.y + vy
        if txt.x + txt.width < 0 or txt.x > __appContentWidth__ or txt.y > __appContentHeight__ + 50 then
            EnterFrameManager.removeListener(txt.on_EnterFrame)
            txt.on_EnterFrame = nil
            txt:removeSelf()
            txt = nil
        end
    end)
end

-- 미션 성공!!
missionComplete = function()
	-- 모두 정지
	EnterFrameManager.removeAllListeners()
	for id, value in pairs(timer._runlist) do
		timer.cancel(value)
	end
	GameConfig.stopBGM()

	-- 게임 오버 이벤트 발생 (GameInfoBox 사용)
	Runtime:dispatchEvent({name="missionComplete"})

	--============= 씬 이동(현재 씬 제거) Begin =============--
	local currScene = composer.getSceneName("current")
	composer.removeScene(currScene)

	local options = {
		effect = "fade",
		time = 300,
--			params = nil
	}
	composer.gotoScene("scenes.MissionCompleteScene", options)
	--============= 씬 이동(현재 씬 제거) End =============--
end
-- -------------------------------------------------------------------------------

return scene
--##############################  Main Code End  ##############################--