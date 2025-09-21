--created with Super_Hugo's Stage Editor v1.6.3

function onCreate()

	makeLuaSprite('obj1', 'computer_bg', -2225, -2123)
	setObjectOrder('obj1', 0)
	scaleObject('obj1', 1.5, 1.5)
	addLuaSprite('obj1', true)
	
	makeLuaSprite('obj2', 'computer_frame', -2209, -2189)
	setObjectOrder('obj2', 5)
	scaleObject('obj2', 1.5, 1.5)
	addLuaSprite('obj2', true)
	
	makeLuaSprite('obj3', 'windows_bg', -2225, -2133)
	setObjectOrder('obj3', 1)
	scaleObject('obj3', 1.5, 1.5)
	addLuaSprite('obj3', true)
	
	makeLuaSprite('obj4', 'windows', -2229, -2129)
	setObjectOrder('obj4', 5)
	scaleObject('obj4', 1.5, 1.5)
	addLuaSprite('obj4', true)
	
end