local isGlitched = false

local bgSprites = {
    'sky', 'mountains', 'mountains2', 'hill', 'hill2', 'stage'
}

function onCreate()
    for _, name in pairs(bgSprites) do
        precacheImage('stages/hill/' .. name)
        precacheImage('stages/hill/' .. name .. '-glitch')
    end

    setProperty('skipCountdown', false)
end

function onCreatePost()

    -- Versão normal
    makeLuaSprite('sky', 'stages/hill/sky', -800, -300)
    scaleObject('sky', 1.5, 1.5, true)
    setScrollFactor("sky", 0.25, 0.25)

    makeLuaSprite('mountains', 'stages/hill/mountains', -500, 0)
    scaleObject('mountains', 1.25, 1.25, true)
    setScrollFactor("mountains", 0.5, 0.9)

    makeLuaSprite('mountains2', 'stages/hill/mountains', 500, 0)
    scaleObject('mountains2', 1.25, 1.25, true)
    setProperty('mountains2.flipX', true)
    setScrollFactor("mountains2", 0.6, 1)

    makeLuaSprite('hill', 'stages/hill/hill', -350, 0)
    scaleObject('hill', 1.25, 1.25, true)
    setScrollFactor("hill", 0.75, 1)

    makeLuaSprite('hill2', 'stages/hill/hill', 600, 300)
    scaleObject('hill2', 1, 1, true)
    setProperty('hill2.flipX', true)
    setScrollFactor("hill2", 0.75, 1)

    makeLuaSprite('stage', 'stages/hill/stage', -200, -500)
    scaleObject('stage', 1.5, 1.5, true)

    -- Versão glitch (idêntica, mas começa invisível)
    makeLuaSprite('skyGlitch', 'stages/hill/sky-glitch', -800, -300)
    scaleObject('skyGlitch', 1.5, 1.5, true)
    setScrollFactor("skyGlitch", 0.25, 0.25)
    setProperty('skyGlitch.alpha', 0)

    makeLuaSprite('mountainsGlitch', 'stages/hill/mountains-glitch', -500, 0)
    scaleObject('mountainsGlitch', 1.25, 1.25, true)
    setScrollFactor("mountainsGlitch", 0.5, 0.9)
    setProperty('mountainsGlitch.alpha', 0)

    makeLuaSprite('mountains2Glitch', 'stages/hill/mountains-glitch', 500, 0)
    scaleObject('mountains2Glitch', 1.25, 1.25, true)
    setProperty('mountains2Glitch.flipX', true)
    setScrollFactor("mountains2Glitch", 0.6, 1)
    setProperty('mountains2Glitch.alpha', 0)

    makeLuaSprite('hillGlitch', 'stages/hill/hill-glitch', -350, 0)
    scaleObject('hillGlitch', 1.25, 1.25, true)
    setScrollFactor("hillGlitch", 0.75, 1)
    setProperty('hillGlitch.alpha', 0)

    makeLuaSprite('hill2Glitch', 'stages/hill/hill-glitch', 600, 300)
    scaleObject('hill2Glitch', 1, 1, true)
    setProperty('hill2Glitch.flipX', true)
    setScrollFactor("hill2Glitch", 0.75, 1)
    setProperty('hill2Glitch.alpha', 0)

    makeLuaSprite('stageGlitch', 'stages/hill/stage-glitch', -200, -500)
    scaleObject('stageGlitch', 1.5, 1.5, true)
    setProperty('stageGlitch.alpha', 0)

    -- Adiciona em ordem correta
    addLuaSprite('sky', false)
    addLuaSprite('skyGlitch', false)
    addLuaSprite('mountains2', false)
    addLuaSprite('mountains2Glitch', false)
    addLuaSprite('mountains', false)
    addLuaSprite('mountainsGlitch', false)
    addLuaSprite('hill2', false)
    addLuaSprite('hill2Glitch', false)
    addLuaSprite('hill', false)
    addLuaSprite('hillGlitch', false)
    addLuaSprite('stage', false)
    addLuaSprite('stageGlitch', false)

end

function beci(beats)
    return (60 / curBpm) * beats
end

local fadeTime = beci(1)

function onUpdate()

    local animName = getProperty('dad.animation.curAnim.name')

    if animName ~= nil and string.find(animName, '-alt') and not isGlitched then
        isGlitched = true
        fadeBG(true)

        runHaxeCode([[
            if (gpu != null && gpu.shader != null)
                camHUD.setFilters([new ShaderFilter(gpu.shader)]);
        ]])

    elseif animName ~= nil and not string.find(animName, '-alt') and isGlitched then
        isGlitched = false
        fadeBG(false)

        runHaxeCode([[
            camHUD.setFilters([]);
        ]])
    end
end

function fadeBG(toGlitch)
    for _, name in pairs(bgSprites) do
        local glitch = name .. 'Glitch'

        if toGlitch then
            doTweenAlpha(glitch .. 'In', glitch, 1, 0.00001, 'cubeinout')
            doTweenAlpha(name .. 'Out', name, 0, 0.00001, 'cubeinout')
        else
            doTweenAlpha(glitch .. 'Out1', glitch, 0, fadeTime, 'cubeinout')
            doTweenAlpha(name .. 'In1', name, 1, fadeTime, 'cubeinout')
        end
    end
end
