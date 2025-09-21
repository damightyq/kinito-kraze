---
--- @param tag string
--- @param loops integer
--- @param loopsLeft integer
---
--- @param eventName string
--- @param value1 string
--- @param value2 string
--- @param strumTime float
---
--- @param elapsed float
---

local travada = false
local faceGlowed = false

function onCreate()
    for i, kito in pairs({'floor', 'hill1', 'hill2', 'red_floor', 'red_hill1', 'red_hill2', 'red_sky', 'sky'}) do precacheImage('stages/kito/' .. kito) end
    setProperty('skipCountdown', true)
end


function onCreatePost()

    makeLuaSprite("blackscreen", '', 0, 0)
    makeGraphic("blackscreen", 3840, 2160, "000000")
    setProperty('blackscreen.alpha', 1)

    makeLuaSprite('sky', 'stages/kito/sky', -400, -200)
    setProperty('sky.alpha', 1)
    setScrollFactor("sky", 0.25, 0.25)
    
    makeLuaSprite('hill2', 'stages/kito/hill2', 10, 10)
    setProperty('hill2.alpha', 1)
    setScrollFactor("hill2", 0.9, 1)
    
    makeLuaSprite('hill1', 'stages/kito/hill1', -10, 10)
    setProperty('hill1.alpha', 1)
    setScrollFactor("hill1", 0.9, 1)
    
    makeLuaSprite('floor', 'stages/kito/floor', 40, -200)
    setProperty('floor.alpha', 1)
    scaleLuaSprite("floor", 1.2, 1.2)

    makeLuaSprite('ref', 'stages/kito/ref1', 0, 0)
    setProperty('ref.alpha', 1)

    -- evil

    makeLuaSprite('red_sky', 'stages/kito/red_sky', -400, -200)
    setProperty('red_sky.alpha', 0)
    setScrollFactor("red_sky", 0.25, 0.25)
    
    makeLuaSprite('red_hill2', 'stages/kito/red_hill2', 10, 10)
    setProperty('red_hill2.alpha', 0)
    setScrollFactor("red_hill2", 0.9, 1)
    
    makeLuaSprite('red_hill1', 'stages/kito/red_hill1', -10, 10)
    setProperty('red_hill1.alpha', 0)
    setScrollFactor("red_hill1", 0.9, 1)
    
    makeLuaSprite('red_floor', 'stages/kito/floor', 40, -200)
    setProperty('red_floor.alpha', 1)
    scaleLuaSprite("red_floor", 1.2, 1.2)

    addLuaSprite("sky", false)
    addLuaSprite("hill2", false)
    addLuaSprite("hill1", false)
    addLuaSprite("floor", false)

    -- addLuaSprite("ref", false)

    addLuaSprite("red_sky", false)
    addLuaSprite("red_hill2", false)
    addLuaSprite("red_hill1", false)
    addLuaSprite("red_floor", false)

    addLuaSprite("blackscreen")

    setProperty("dad.alpha", 0)
    setProperty("boyfriend.alpha", 0)
    setProperty("gf.alpha", 0)

end

function beci(beats)
    return (60 / 184) * beats
end


function onUpdate(elapsed)
    if travada == true then
        setProperty("isCameraOnForcedPos", true)
    else
        setProperty("isCameraOnForcedPos", false)
    end

    runHaxeCode([[
        if(!endingSong && !startingSong) {
			if (FlxG.keys.justPressed.ONE) {
				game.KillNotes();
				FlxG.sound.music.onComplete();
			}
			if(FlxG.keys.justPressed.TWO) { //Go 10 seconds into the future :O
				game.setSongTime(Conductor.songPosition + 10000);
				game.clearNotesBefore(Conductor.songPosition);
			}
			if(FlxG.keys.justPressed.THREE) { //Botplay omg!!
				if (game.cpuControlled) {
					game.cpuControlled = false;
					game.botplayTxt.visible = false;
				}
				else {
					game.cpuControlled = true;
					game.botplayTxt.visible = true;
					game.curStepTxt.visible = true;
				}
			}
		}
    ]])
end

function onStepHit()

    if curStep == 368 then
        runTimer("fade1", beci(4))
        setProperty("gf.alpha", 0)
        setProperty("boyfriend.alpha", 0)
        setProperty("dad.alpha", 0)
        setProperty("blackscreen.alpha", 1)
    end

    if curStep == 256 then
        -- olhaCHAR('kinito')
    end

    if curStep == 576 then
        runTimer("fade2", beci(15.9))
        runTimer("kitotrans", beci(8))
        setProperty("gf.alpha", 0)
        setProperty("boyfriend.alpha", 0)
        setProperty("dad.alpha", 0)
        setProperty("blackscreen.alpha", 1)
    end

    if curStep == 608 then
        olhaCHAR('kinito')
    end

end



function olhaCHAR(char)
    if char == '' then
    end

    if char == 'kinito' then
        travada = true
        doTweenX("pintoX", "camFollow", 940, beci(8), "sineInOut")
        doTweenY("pintoY", "camFollow", 400, beci(8), "sineInOut")
        doTweenZoom('pinto', 'camGame', 1, beci(12), 'quartInOut')
        end
end

function onEvent(eventName, value1, value2, strumTime)
    
    if eventName == 'kitoFACEGLOW' and value1 ~= '' then
        face(value1)
    end

end

function face(face)
    if faceGlowed == false then
        if face == '1' then
        
        end
    
        if face == '2' then
            
        end
    
        if face == '3' then
            setProperty("gf.alpha", 1)
            doTweenAlpha("face", "gf", 0, beci(2), "sineInOut")
        end
    
        if face == '4' then
            setProperty("boyfriend.alpha", 1)
            doTweenAlpha("face", "boyfriend", 0, beci(2), "sineInOut")
        end
    
        if face == '5' then
            setProperty("dad.alpha", 1)
            doTweenAlpha("face", "dad", 0, beci(1.9), "sineInOut")
        end
    
        if face == 'off' then
            faceGlowed = true
            doTweenAlpha("face", "", 0, beci(1), "sineInOut")
            cameraFlash("camGame", "FFFFFF", beci(4), "sineInOut")
            setProperty("dad.alpha", 1)
            setProperty("boyfriend.alpha", 1)
            setProperty("gf.alpha", 1)
            setProperty("blackscreen.alpha", 0)
        end
    
    end
    
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'fade1' then
        cameraFlash("camGame", "FFFFFF", beci(4), "sineInOut")
        setProperty("dad.alpha", 1)
        setProperty("boyfriend.alpha", 1)
        setProperty("gf.alpha", 1)
        setProperty("blackscreen.alpha", 0)
    end

    if tag == 'kitotrans' then
        setProperty("dad.alpha", 1)
    end

    if tag == 'fade2' then
        cameraFlash("camOther", "FF0000", beci(4), "sineInOut")
        setProperty("dad.alpha", 1)
        setProperty("boyfriend.alpha", 1)
        setProperty("gf.alpha", 1)
        setProperty("blackscreen.alpha", 0)

        setProperty('sky.alpha', 0)
        setProperty('hill2.alpha', 0)
        setProperty('hill1.alpha', 0)
        setProperty('floor.alpha', 0)

        setProperty('red_sky.alpha', 1)
        setProperty('red_hill2.alpha', 1)
        setProperty('red_hill1.alpha', 1)
        setProperty('red_floor.alpha', 1)

        for i = 0, getProperty('opponentStrums.length')-1 do
            setPropertyFromGroup('opponentStrums', i, 'texture', 'kitoNotes');
        end
        for i = 0, getProperty('unspawnNotes.length')-1 do
            if getPropertyFromGroup('unspawnNotes', i, 'mustPress') == false then
            setPropertyFromGroup('unspawnNotes', i, 'texture', 'kitoNotes');
            end
        end
        for i = 0, getProperty('playerStrums.length')-1 do
        setPropertyFromGroup('playerStrums', i, 'texture', 'kitoNotes');
        end
        for i = 0, getProperty('unspawnNotes.length')-1 do
            if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
            setPropertyFromGroup('unspawnNotes', i, 'texture', 'kitoNotes');
            end
        end
    end
    
end

function onTweenCompleted(pinto)
    if pinto then
        travada = false
    end
end