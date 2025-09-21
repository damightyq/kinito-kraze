--created with Super_Hugo's Stage Editor v1.6.3

function onCreate()

    makeLuaSprite('obj1', 'your_world', -1139, -550)
    addLuaSprite('obj1', false)
    scaleObject('obj1', 1.4, 1.4)

    makeLuaSprite('obj2', 'bedroom_2', -1155, -558)
    setProperty('obj2.alpha', 0.001)
    addLuaSprite('obj2', false)

    makeLuaSprite('obj3', 'bedroom_red', -1155, -560)
    setProperty('obj3.alpha', 0.001)
    addLuaSprite('obj3', false)

    makeLuaSprite('obj4', 'hallway', -1155, -560)
    setProperty('obj4.alpha', 0.001)
    addLuaSprite('obj4', false)

    makeLuaSprite('obj5', 'the_monitor', -1155, -560)
    setProperty('obj5.alpha', 0.001)
    addLuaSprite('obj5', false)
end

function onStepHit()

    if curStep == 736 then 
        setProperty('obj1.alpha', 0)
        setProperty('obj2.alpha', 1)
    elseif curStep == 1408 then
        setProperty('obj2.alpha', 0)
        setProperty('obj3.alpha', 1)
    elseif curStep == 2256 then
        setProperty('obj3.alpha', 0)
        setProperty('obj4.alpha', 1)
    elseif curStep == 2864 then
        setProperty('obj4.alpha', 0)
        setProperty('obj5.alpha', 1)
    end

end