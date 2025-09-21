--created with Super_Hugo's Stage Editor v1.6.3

function onCreate()

    makeLuaSprite('obj1', 'sam_bg', -1139, -700)
    addLuaSprite('obj1', false)
    scaleObject('obj1', 3, 3)

    makeLuaSprite('obj2', 'jade_bg', 0, -785)
    setProperty('obj2.alpha', 0.001)
    scaleObject('obj2', 3, 3)
    addLuaSprite('obj2', false)

end

function onStepHit()

    if curStep == 1272 then 
        setProperty('obj1.alpha', 0)
        setProperty('obj2.alpha', 1)

end

end