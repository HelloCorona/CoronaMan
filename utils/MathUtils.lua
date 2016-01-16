local Class = {}

-- 소수점 n자리까지 변환
Class.roundToNthDecimal = function (num, n)
	local mult = 10^(n or 0)
	return math.floor(num * mult + 0.5) / mult
end

return Class