package objects;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxTween;
import openfl.display.BlendMode;

class CDSprite extends FlxSpriteGroup {
    public var coverArt:FlxSprite;
    public var cdShine1:FlxSprite;
    public var cdShine2:FlxSprite;
    private var spinTween:FlxTween;
    public var formatedCoverArt:String;
    public var name:String;
    public var songName:String;
    public var songTrueName:String;

    public var originalSize:Int;

    public function new(x:Float, y:Float, coverart:String) {
        super(x, y);

        formatedCoverArt = coverart.replace(" ", "-");
        name = formatedCoverArt;
        songName = formatedCoverArt;
        songTrueName = formatedCoverArt;

        // trace("cover path antes de ser corrigido sao esses aqui: " + formatedCoverArt);


        if(!Paths.fileExists('images/freeplay/cd/' + formatedCoverArt + 'CD' + '.png', IMAGE))
            {
                formatedCoverArt = 'default';
            }
            
        // Capa do CD

        coverArt = new FlxSprite(0, 0).loadGraphic(Paths.image('freeplay/cd/' + formatedCoverArt + 'CD'));
        coverArt.setGraphicSize(Std.int(coverArt.width * 0.5));
        coverArt.updateHitbox();
        coverArt.scrollFactor.set();
        add(coverArt);

        // Brilho 1
        cdShine1 = new FlxSprite(0, 0).loadGraphic(Paths.image('freeplay/cd/cdShine'));
        cdShine1.alpha = 1;
        cdShine1.blend = BlendMode.ADD;
        cdShine1.setGraphicSize(Std.int(cdShine1.width * 0.5));
        cdShine1.updateHitbox();
        cdShine1.scrollFactor.set();
        add(cdShine1);

        // Brilho 2
        cdShine2 = new FlxSprite(0, 0).loadGraphic(Paths.image('freeplay/cd/cdShine2'));
        cdShine2.alpha = 1;
        cdShine2.blend = BlendMode.ADD;
        cdShine2.setGraphicSize(Std.int(cdShine2.width * 0.5));
        cdShine2.updateHitbox();
        cdShine2.scrollFactor.set();
        add(cdShine2);



        // trace("cover path e esse aqui o: " + formatedCoverArt);

        // Centraliza os elementos

        originalSize = Std.int(coverArt.width);

        setX(x);
        setY(y);
    }

    public function setX(newX:Float) {
        x = newX;
        coverArt.x = x;
        cdShine1.x = x;
        cdShine2.x = x;
    }

    public function setY(newY:Float) {
        y = newY;
        coverArt.y = y;
        cdShine1.y = y;
        cdShine2.y = y;
    }

    public function tweenScale(?shrink:Bool = false) {
        var targetScale = shrink ? 0.66 : 1.0;
    
        // Evita aumentar além do tamanho original
        if (!shrink && coverArt.width >= originalSize)
            return;
    
        var newSize = Std.int(originalSize * targetScale);
    
        for (sprite in [coverArt, cdShine1, cdShine2]) {
            FlxTween.num(sprite.width, newSize, 0.3, {ease: FlxEase.sineInOut}, function(val) {
                var intVal = Std.int(val);
                sprite.setGraphicSize(intVal);
                sprite.updateHitbox();
            });
        }
    }
    

    public function spinCD(duration:Float) {
        if (spinTween != null) {
            spinTween.cancel();
        }

        spinTween = FlxTween.num(0, 360, duration, {ease: FlxEase.linear, type: FlxTweenType.LOOPING}, function(val) {
            coverArt.angle = val;
        });
    }

    public function stopSpinCD() {
        if (spinTween != null) {
            spinTween.cancel();
            spinTween = null;
            tweenScale(true);
        }
        
        FlxTween.num(coverArt.angle, -0, 0.66, {ease: FlxEase.quadInOut}, function(val) {
            coverArt.angle = val;
        });
    }

    public function getName() {
        if (songName.endsWith("-dox")) {
            songName = songName.substr(0, songName.length - 4);
        }
        songName = ~/[-]/g.replace(songName, " ");
        name = songName.toUpperCase();

        return name;
    }

    public function getTrueName() {
        return songTrueName;
    }

    public function updateCover(){
        coverArt.loadGraphic(Paths.image('freeplay/cd/' + formatedCoverArt + 'CD'));
    }
}
