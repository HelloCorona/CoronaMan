local EnterFrameManager = require("managers.EnterFrameManager")
local SQLiteManager = require("managers.SQLiteManager")
local MathUtils = require("utils.MathUtils")
local APIList = require("APIList")

local Class = {}

Class.totalLevels = 10 -- 게임 스테이지 수
Class.countdownInitTime = 60 -- 게임 시간

Class.getAPI = function ()
    return APIList.list[math.random(1, #APIList.list)]
end

-- 코로나맨들의 HP
Class.coronaManHP = {300, 820, 1340, 2160, 3040, 5220, 9050, 15070, 25000, 63000}

Class.DB_GAME_LEVEL = "gameLevel" -- 1 ~ 10
Class.DB_PLAYER_LEVEL = "playerLevel" -- 1 ~ n
Class.DB_COIN = "coin" -- int
Class.DB_SOUND_ENABLED = "soundEnabled" -- on or off

--========= 게임 레벨 관련 Get/Set Begin =========--
local _gameLevel

Class.getGameLevel = function ()
	return tonumber(_gameLevel)
end

Class.setGameLevel = function (value)
	_gameLevel = tonumber(value)
	
	-- DB 업데이트
	SQLiteManager.setConfig(Class.DB_GAME_LEVEL, _gameLevel)
end
--========= 게임 레벨 관련 Get/Set End =========--

--========= 플레이어 레벨 관련 Get/Set Begin =========--
local _playerLevel

Class.getPlayerLevel = function ()
	return tonumber(_playerLevel)
end

Class.setPlayerLevel = function (value)
	_playerLevel = tonumber(value)
	
	-- DB 업데이트
	SQLiteManager.setConfig(Class.DB_PLAYER_LEVEL, _playerLevel)
end
--========= 플레이어 레벨 관련 Get/Set End =========--

--========= 점수(코인) 관련 Get/Set Begin =========--
local _coin

Class.getCoin = function (isPureNum)
	isPureNum = isPureNum or false
	local __coin = _coin
	if not isPureNum and __coin >= 1000 then __coin = MathUtils.roundToNthDecimal(__coin * 0.001, 2).."k" end
	return __coin
end

Class.setCoin = function (value)
	_coin = tonumber(value)
	
	-- DB 업데이트
	SQLiteManager.setConfig(Class.DB_COIN, _coin)
end
--========= 점수(코인) 관련 Get/Set End =========--

--========= 일시정지 관련 Get/Fn Begin =========--
local _isPaused = false
local timerIDs = nil

Class.isPaused = function ()
	return _isPaused
end

Class.pauseGame = function (dispatchEvent)
	dispatchEvent = dispatchEvent or true
	
	if _isPaused == true then return end
	
	_isPaused = true
	
	--===== 일시 정지 Begin =====--
	-- physics.pause()는 GameScene의 상황에 따라
	EnterFrameManager.pause()
	transition.pause()
	
	timerIDs = {}
	for k, v in pairs(timer._runlist) do
		table.insert(timerIDs, v)
		timer.pause(v)
	end
	--===== 일시 정지 End =====--
	
	if dispatchEvent == true then Runtime:dispatchEvent({name="pauseGame"}) end
end

Class.resumeGame = function (dispatchEvent)
	dispatchEvent = dispatchEvent or true
	
	if _isPaused == false then return end
	
	_isPaused = false
	
	--===== 일시 정지 Begin =====--
	-- physics.start()는 GameScene의 상황에 따라
	EnterFrameManager.resume()
	transition.resume()
	
	for k, v in pairs(timerIDs) do
		timer.resume(v)
	end
	timerIDs = nil
	--===== 일시 정지 End =====--

	if dispatchEvent == true then Runtime:dispatchEvent({name="resumeGame"}) end
end
--========= 일시정지 관련 Get/Fn End =========--

--========= 사운드 제어 Begin =========--
local bgmChannel = nil
Class.playBGM = function (sndPath)
	Class.stopBGM()
	
	local gbm = audio.loadStream(sndPath)
	bgmChannel = audio.play( gbm, { channel=1, loops=-1 } )
end

Class.stopBGM = function ()
	if bgmChannel ~= nil then audio.stop(bgmChannel) end
	bgmChannel = nil
end

Class.playEffectSound = function (sndPath)
	local snd = audio.loadSound(sndPath)
	local availableChannel = audio.findFreeChannel()
	audio.play( snd, { channel=availableChannel } )
end

Class.stopAllSounds = function ()
	audio.stop()
end

Class.setVolume = function (value)
	audio.setVolume(value)
end
--========= 사운드 제어 End =========--

--========= 설정 초기화 Begin =========--
Class.init = function ()
	_gameLevel = tonumber(SQLiteManager.getConfig(Class.DB_GAME_LEVEL))
	_playerLevel = tonumber(SQLiteManager.getConfig(Class.DB_PLAYER_LEVEL))
	_coin = tonumber(SQLiteManager.getConfig(Class.DB_COIN))
	_isPaused = false
	
	EnterFrameManager.init()
end
--========= 설정 초기화 End =========--

return Class