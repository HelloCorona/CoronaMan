local Class = {}

local firstPt = nil

Class.applyMotionButton = function (btn, eventCallBack, completeCallback, tapCallBack)
	local function on_Touch(e)
		if btn.enabled == false then return end
		
		local phase = e.phase
		if phase == "began" then
			display:getCurrentStage():setFocus(btn)
			firstPt = {x=e.x, y=e.y}			
			transition.cancel(btn)
			btn.xScale = 0.9
			btn.yScale = 0.9
        elseif phase =="moved" then
			if firstPt ~= nil and (math.abs(e.x - firstPt.x) > 10 or math.abs(e.y - firstPt.y) > 10) then firstPt = nil end
        elseif phase == "ended" then
			display:getCurrentStage():setFocus(nil)
            
            if tapCallBack and firstPt ~= nil then tapCallBack() end
            
			transition.to(btn, {time=100, xScale=1.15, yScale=1.15,
				onComplete = function ()
					transition.to(btn, {time=100, xScale=0.9, yScale=0.9,
						onComplete = function ()
							transition.to(btn, {time=100, xScale=1, yScale=1,
								onComplete = function ()
									-- 완료되었을 때 탭(tap)이 되었는지 여부를 넘겨줌
									if completeCallback then completeCallback(firstPt ~= nil) end
									firstPt = nil
								end
							})
						end
					})
				end
			})
		end

		if eventCallBack then eventCallBack(e) end
	end
	btn:addEventListener("touch", on_Touch)
end

return Class