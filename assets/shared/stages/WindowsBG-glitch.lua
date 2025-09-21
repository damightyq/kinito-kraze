--created with Super-Hugo's Stage Editor v1.6.3

function onCreate()

	makeLuaSprite('obj3', 'stages/hill/sky-glitch', -1472, -836)
	setObjectOrder('obj3', 0)
	scaleObject('obj3', 1.8, 1.8)
	addLuaSprite('obj3', true)
	
	makeLuaSprite('obj4', 'stages/hill/stage-glitch', -1285, -816)
	setObjectOrder('obj4', 1)
	scaleObject('obj4', 1.6, 1.6)
	addLuaSprite('obj4', true)
	
	makeLuaSprite('obj6', 'stages/hill/hill-glitch', -1709, -621)
	setObjectOrder('obj6', 1)
	scaleObject('obj6', 2, 2)
	setScrollFactor('obj6', 1.2, 1.2)
	addLuaSprite('obj6', true)
	
	makeLuaSprite('obj7', 'stages/hill/mountains-glitch', -2030, -228)
	setObjectOrder('obj7', 1)
	scaleObject('obj7', 0.7, 0.7)
	setScrollFactor('obj7', 0.8, 0.8)
	setProperty('obj7.flipX', true)
	addLuaSprite('obj7', true)
	
	makeLuaSprite('obj8', 'stages/hill/mountains-glitch', -495, -178)
	setObjectOrder('obj8', 1)
	scaleObject('obj8', 0.7, 0.7)
	setScrollFactor('obj8', 0.8, 0.8)
	addLuaSprite('obj8', true)
	
	makeLuaSprite('obj9', 'stages/hill/mountains-glitch', 505, -13)
	setObjectOrder('obj9', 1)
	scaleObject('obj9', 0.7, 0.7)
	setScrollFactor('obj9', 0.8, 0.8)
	setProperty('obj9.flipX', true)
	addLuaSprite('obj9', true)
	
	makeLuaSprite('obj10', 'stages/hill/mountains-glitch', 2025, 57)
	setObjectOrder('obj10', 1)
	scaleObject('obj10', 0.7, 0.7)
	setScrollFactor('obj10', 0.8, 0.8)
	addLuaSprite('obj10', true)
	
end