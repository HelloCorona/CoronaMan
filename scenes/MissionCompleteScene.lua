local GameConfig = require("GameConfig")
local GameUXManager = require("managers.GameUXManager")
local SQLiteManager = require("managers.SQLiteManager")

--##############################  Main Code Begin  ##############################--
local composer = require( "composer" )

local scene = composer.newScene()

local createBg

-- "scene:create()"
function scene:create( event )
	local sceneGroup = self.view
    
    -- 미션 성공 사운드
    GameConfig.playEffectSound("sounds/missionCompleted.mp3")
    
    -- 배경생성
    createBg(sceneGroup)
    
    -- 타이틀
    local title = display.newImage(sceneGroup, "images/ending_txt.png", 0, 0)
    __setScaleFactor(title)
    title.anchorX = 0.5
    title.x, title.y = __appContentWidth__ * 0.5, __appContentHeight__ * 0.3
    
    --===== 버튼 Begin =====--
	local btn = display.newImage(sceneGroup, "images/btn_retry.png", 0, 0)
	btn.anchorX, btn.anchorY = 0.5, 0.5
	__setScaleFactor(btn)
	btn.x, btn.y = (__appContentWidth__ * 0.5), title.y + title.height + 80
	
	local function on_CompleteCallback(isTap)
		if isTap then
            -- DB 초기화
            SQLiteManager.setConfig(GameConfig.DB_GAME_LEVEL, 1)
            SQLiteManager.setConfig(GameConfig.DB_PLAYER_LEVEL, 1)
            SQLiteManager.setConfig(GameConfig.DB_COIN, 0)

            GameConfig.stopAllSounds()
            GameConfig.init()
            
            --============= 씬 이동(현재 씬 제거) Begin =============--
            local currScene = composer.getSceneName("current")
            composer.removeScene(currScene)

            local options = {
                effect = "fade",
                time = 300,
        --			params = nil
            }
            composer.gotoScene("scenes.GameScene", options)
            --============= 씬 이동(현재 씬 제거) End =============--
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
-- -------------------------------------------------------------------------------

return scene
--##############################  Main Code End  ##############################--