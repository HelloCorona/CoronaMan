local GameConfig = require("GameConfig")

local Class = {}

Class.create = function()
    local mainG = display.newGroup()
    
    -- 성공 사운드
    GameConfig.playEffectSound("sounds/stageClear.mp3")
    
    local bg = display.newRect(mainG, 0, 0, __appContentWidth__, __appContentHeight__)
    bg.alpha = 0.1
    
    local function fakeEvent(e)
        return true
    end
    bg:addEventListener("touch", fakeEvent)
    bg:addEventListener("tap", fakeEvent)
    
    local title = display.newImage(mainG, "images/clear_pop.png", 0, 0)
    __setScaleFactor(title)
    title.anchorX, title.anchorY = 0.5, 0.5
    title.x, title.y = bg.width * 0.5, bg.height * 0.5
    
    return mainG
end

return Class