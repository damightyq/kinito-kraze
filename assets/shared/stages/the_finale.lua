
---
---
--- 
--- @param phase string
--- 
--- 
--- 


function onCreatePost()

    makeLuaSprite("blackscreen", '', -1139, -550)
    makeGraphic("blackscreen", 3840, 2160, "000000")
    setProperty('blackscreen.alpha', 0)
    setObjectCamera('blackscreen', 'hud')

    for i, finale in pairs({'your_world1', 'your_world2', 'bedroom_2', 'bedroom_red', 'hallway', 'the_monitor'}) do precacheImage('stages/finale/' .. finale) end

    makeLuaSprite('check1', 'stages/finale/your_world1', -1139, -550)
    setProperty('check1.alpha', 1)
    scaleObject('check1', 1.4, 1.4)

    makeLuaSprite('check2', 'stages/finale/your_world2', -1139, -550)
    setProperty('check2.alpha', 1)
    scaleObject('check2', 1.4, 1.4)

    makeLuaSprite('quarto', 'stages/finale/bedroom_2', -1155, -558)
    setProperty('quarto.alpha', 0)


    makeLuaSprite('quartodoMAL', 'stages/finale/bedroom_red', -1155, -560)
    setProperty('quartodoMAL.alpha', 0)


    makeLuaSprite('corridor', 'stages/finale/hallway', -1155, -560)
    setProperty('corridor.alpha', 0)


    makeLuaSprite('tv', 'stages/finale/the_monitor', -1155, -560)
    setProperty('tv.alpha', 0)

    addLuaSprite('check1', false)
    addLuaSprite('check2', false)
    addLuaSprite('quarto', false)
    addLuaSprite('quartodoMAL', false)
    addLuaSprite('corridor', false)
    addLuaSprite('tv', false)
    addLuaSprite('blackscreen', true)

    setObjectOrder('check1', getObjectOrder('noteGroup')+1)
    setObjectOrder('dad', getObjectOrder('check1')+1)


    runHaxeCode([[

		for (strum in game.opponentStrums)
		{
			strum.cameras = [game.camGame];
			strum.scrollFactor.set(1, 1);
            strum.alpha *= 0.35;
		}
		for (note in game.unspawnNotes) 
		{
			if (!note.mustPress) {
				note.cameras = [game.camGame];
				note.scrollFactor.set(1, 1);
                note.alpha *= 0.35;
			} 
		};
    			for (i in 0...opponentStrums.length) {
                opponentStrums.members[i].x += 360;
                if(ClientPrefs.data.downScroll)
                {
                    opponentStrums.members[i].y += 120;
                } else
                {
                    opponentStrums.members[i].y += 100;
                }

                }
    ]])
end

---
--- @param elapsed float
---

local onCountdown = true

function onUpdate(elapsed)

    if curStep >= 730 then
        runHaxeCode([[
            for (i in 0...opponentStrums.length) {
                opponentStrums.members[i].x = 99999;
                }
        ]])
    end

    if onCountdown == true then
        runHaxeCode([[
            for (strum in game.opponentStrums)
            {
                strum.alpha = 0;
            }
            for (note in game.unspawnNotes) 
            {
                if (!note.mustPress) {
                    note.alpha = 0;
            } 
        }
        ]])
    end

end

function beci(bpm, beats)
    return (60 / bpm) * beats
end

function changePhase(phase)

    if phase == 'bed' then
        cameraFlash("camGame", "FFFFFF", beci(140, 4), "quartInOut")
        setProperty("blackscreen.alpha", 0)
        setProperty("check1.alpha", 0)
        setProperty("check1.alpha", 0)
        setProperty("check2.alpha", 0)
        setProperty("quarto.alpha", 1)
    end


end

function onStepHit()

    if curStep == 1 then
        onCountdown = false
        if onCountdown == false then
            runHaxeCode([[
                for (strum in game.opponentStrums)
                {
                FlxTween.tween(strum, {alpha: 0.35}, 1.71, {
                ease: FlxEase.cubeInOut,
                });
                }
                for (note in game.unspawnNotes) 
                {
                FlxTween.tween(note, {alpha: 0.35}, 1.71, {
                ease: FlxEase.cubeInOut,
                });
                }
            ]])
        end
    end


    if curStep == 640 then
        doTweenAlpha("theSWITCH", "blackscreen", beci(140, 16), 1, "quartInOut")
    end

    if curStep == 736 then 
        changePhase('bed')
    elseif curStep == 1408 then
        setProperty('quarto.alpha', 0)
        setProperty('quartodoMAL.alpha', 1)
    elseif curStep == 2256 then
        setProperty('quartodoMAL.alpha', 0)
        setProperty('corridor.alpha', 1)
    elseif curStep == 2864 then
        setProperty('corridor.alpha', 0)
        setProperty('tv.alpha', 1)
    end

end