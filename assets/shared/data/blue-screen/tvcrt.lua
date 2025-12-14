local shaderName1 = "tvcrt"
local shaderName2 = "glitch"
function onCreate()
    shaderCoordFix() -- initialize a fix for textureCoord when resizing game window

    makeLuaSprite("tvcrt")
    makeGraphic("shaderImage", screenWidth, screenHeight)

    makeLuaSprite("glitch")
    makeGraphic("shaderImage2", screenWidth, screenHeight)

   setSpriteShader("shaderImage", "tvcrt")
   setSpriteShader("shaderImage2", "glitch")


    runHaxeCode([[

        var shaderName1 = "]] .. shaderName1 .. [[";
        
        game.initLuaShader(shaderName1);

        var shaderName2 = "]] .. shaderName2 .. [[";
        
        game.initLuaShader(shaderName2);

        
        var shader0 = game.createRuntimeShader(shaderName1);

        var shader1 = game.createRuntimeShader(shaderName2);

        shader1.data.aberrationStrength.value = [0.005];

        dad.shader = shader1;

        game.getLuaObject("tvcrt").shader = shader0; // setting it into temporary sprite so luas can set its shader uniforms/properties

        game.getLuaObject("glitch").shader = shader1; // setting it into temporary sprite so luas can set its shader uniforms/properties

        game.camGame.setFilters([new ShaderFilter(game.getLuaObject("tvcrt").shader)]);
        game.camOther.setFilters([new ShaderFilter(game.getLuaObject("tvcrt").shader)]);
        game.camHUD.setFilters([new ShaderFilter(game.getLuaObject("tvcrt").shader)]);
        return;
    ]])
end

function onUpdate(elapsed)
    setShaderFloat("tvcrt", "iTime", os.clock())
    setShaderFloat("glitch", "iTime", os.clock())
 end

 function onStepHit()

    if curStep == 736 then 
        runHaxeCode([[
            dad.shader = null;
            game.camGame.setFilters([]);
            game.camOther.setFilters([]);
            game.camHUD.setFilters([]);
        ]])
    elseif curStep == 1408 then
        runHaxeCode([[
            game.camGame.setFilters([]);
            game.camOther.setFilters([]);
            game.camHUD.setFilters([]);
        ]])
    elseif curStep == 2256 then
        setShaderFloat('glitch', 'aberrationStrength', 0.0075)
        runHaxeCode([[
            dad.shader = game.getLuaObject("glitch").shader;
            game.camGame.setFilters([new ShaderFilter(game.getLuaObject("tvcrt").shader)]);
            game.camOther.setFilters([new ShaderFilter(game.getLuaObject("tvcrt").shader)]);
            game.camHUD.setFilters([new ShaderFilter(game.getLuaObject("tvcrt").shader)]);
        ]])
    elseif curStep == 2864 then
        setShaderFloat('glitch', 'aberrationStrength', 0.05)
        runHaxeCode([[
            dad.shader = game.getLuaObject("glitch").shader;
            game.camGame.setFilters([]);
            game.camOther.setFilters([]);
            game.camHUD.setFilters([]);
        ]])
    end

end

function shaderCoordFix()
    runHaxeCode([[
        resetCamCache = function(?spr) {
            if (spr == null || spr.filters == null) return;
            spr.__cacheBitmap = null;
            spr.__cacheBitmapData = null;
        }
        
        fixShaderCoordFix = function(?_) {
            resetCamCache(game.camGame.flashSprite);
            resetCamCache(game.camHUD.flashSprite);
            resetCamCache(game.camOther.flashSprite);
        }
    
        FlxG.signals.gameResized.add(fixShaderCoordFix);
        fixShaderCoordFix();
        return;
    ]])
    
    local temp = onDestroy
    function onDestroy()
        runHaxeCode([[
            FlxG.signals.gameResized.remove(fixShaderCoordFix);
            return;
        ]])
        if (temp) then temp() end
    end
end