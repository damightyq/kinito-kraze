import funkin.menus.FreeplayState.FreeplaySonglist;
import funkin.game.HealthIcon;
import funkin.savedata.FunkinSave;
import Math;

using StringTools;

var songs:Array<Dynamic> = [];
var grpSongs:FlxTypedGroup<Alphabet>;
var iconArray:Array<HealthIcon> = [];
var cds:Array<CuteDoofSprite> = []; // heh.. cutie doofy.. so kawaii..

var intendedScore:Int = 0;
var intendedRating:Float = 0;
var lerpScore:Int;

var penis:Array<Float> = [
	-355,
	(955 / 2) - 335,
	(955 / 2),
	(955 / 2) + 444,
	FlxG.width + 355
];

function create()
{
	songs = FreeplaySonglist.get().songs;
    
    FlxG.mouse.visible = true;

	var bg = new FlxSprite().loadGraphic(Paths.image('menus/menuDesat'));
	bg.antialiasing = true;
	bg.screenCenter();
    add(bg);

    grpSongs = new FlxTypedGroup<Alphabet>();

    for (i => song in songs)
    {
		var text = new Alphabet(90, 320, song.displayName, "bold");
        text.targetY = i;
        text.scale.x = Math.min(1, 980 / text.width);
        // text.snapToPosition();
        text.ID = i;
		grpSongs.add(text);

        var icon = new HealthIcon(song.icon);
        icon.sprTracker = text;
        
        text.visible = text.active = text.isMenuItem = false;
        icon.visible = icon.active = false;
        icon.ID = i;
        iconArray.push(icon);
        add(icon);
    }

    for (i => musicWhat in songs)
    {
        var posIndex:Int = i + 2;
        if (i == songs.length - 1)
            posIndex = 1;

		var cd = new CuteDoofSprite(penis[posIndex], 162, musicWhat.name.replace(" ", "-"));
        cds.push(cd);
        add(cd);
    }
}

function updatePositions()
{
    if (isBusy)
        return;

    isBusy = true;

	var activeTweens:Int = 0;
	var tweenCompleted:Bool = false;

    // add other function calls here

	FlxTween.num(0, 1, 0.33, {ease: FlxEase.sineInOut}, () -> {
		if (!tweenCompleted)
        {
			tweenCompleted = true;
			updateCDSpin();
		}
    });

	for (i => cd in cds)
    {
		var targetX = penis[i % penis.length];

		activeTweens++;

		FlxTween.num(cd.x, targetX, 0.33, {ease: FlxEase.sineInOut}, function(val) {
			cd.setX(val);
		}).onComplete = function(_) {
			activeTweens--;
			if (activeTweens == 0)
				isBusy = false;
		};
	}
}

function update(e:Float)
{
    if (FlxG.sound.music != null && FlxG.sound.music < 0.7)
        FlxG.sound.music.volume += 0.5 * FlxG.elapsed;

    var fuckingLeft = controls.LEFT_P;
    var fuckingRight = controls.RIGHT_P;

    if (fuckingLeft || fuckingRight)
        shiftDir(fuckingLeft);

    if (controls.BACK)
        FlxG.switchState(new MainMenuState());
}

var isBusy:Bool = false;
function shiftDir(?left:Bool)
{
    left ??= true;
    if (isBusy) return;

    var place = (left ? cds.shift() : cds.pop());
    for (i => cd in cds)
    {
        if (cd.x == penis[left ? 3 : 1])
        {
			intendedScore = FunkinSave.getSongHighscore(cd.getTrueName(), curDifficulty);
        }
    }

    updatePositions();
}

import funkin.backend.MusicBeatGroup;
import openfl.display.BlendMode;

class CuteDoofSprite extends MusicBeatGroup // yes, this is MY change..
{
    public var coverArt:FlxSprite;
    public var cdShine1:FlxSprite;
    public var cdShine2:FlxSprite;
    private var spinTween:FlxTween;
    public var formatedCoverArt:String;
    public var name:String;
    public var songName:String;
    public var songTrueName:String;

    public var originalSize:Int;
    var dir:String = "menus/freeplaymenu";

    function new(x:Float, y:Float, coverart:String)
    {
        super(x, y, 0);

        formatedCoverArt = name = songName = songTrueName = coverart;

		if (!Assets.exists("images/" + dir + '/cd/' + formatedCoverArt + 'CD.png'))
            formatedCoverArt = 'default';
            
        coverArt = new FlxSprite().loadGraphic(Paths.image(dir +'/cd/' + formatedCoverArt + 'CD'));
        coverArt.setGraphicSize(Std.int(coverArt.width * 0.5));
        coverArt.updateHitbox();
        coverArt.scrollFactor.set();
        add(coverArt);

        cdShine1 = new FlxSprite().loadGraphic(Paths.image(dir +'/cd/cdShine'));
        cdShine1.blend = BlendMode.ADD;
        cdShine1.setGraphicSize(Std.int(cdShine1.width * 0.5));
        cdShine1.updateHitbox();
        cdShine1.scrollFactor.set();
        add(cdShine1);

        cdShine2 = new FlxSprite().loadGraphic(Paths.image(dir +'/cd/cdShine2'));
        cdShine2.blend = BlendMode.ADD;
        cdShine2.setGraphicSize(Std.int(cdShine2.width * 0.5));
        cdShine2.updateHitbox();
        cdShine2.scrollFactor.set();
        add(cdShine2);

        originalSize = Std.int(coverArt.width);

        setX(x);
        setY(y);
    }

    public function setX(newX:Float)
        x = coverArt.x = cdShine1.x = cdShine2.x = newX;

    public function setY(newY:Float)
		y = coverArt.y = cdShine1.y = cdShine2.y = newY;

    public function tweenScale(?shrink:Bool = false)
    {
        var targetScale = shrink ? 0.66 : 1.0;
    
        if (!shrink && coverArt.width >= originalSize)
            return;
    
        var newSize = Std.int(originalSize * targetScale);
    
        for (sprite in [coverArt, cdShine1, cdShine2])
        {
            FlxTween.num(sprite.width, newSize, 0.3, {ease: FlxEase.sineInOut}, (val) -> {
                var intVal = Std.int(val);
                sprite.setGraphicSize(intVal);
                sprite.updateHitbox();
            });
        }
    }
    

    public function spinCD(duration:Float)
    {
        if (spinTween != null)
            spinTween.cancel();

        spinTween = FlxTween.num(0, 360, duration, {ease: FlxEase.linear, type: 2}, (val) -> {
            coverArt.angle = val;
        });
    }

    public function stopSpinCD()
    {
        if (spinTween != null)
        {
            spinTween.cancel();
            spinTween = null;
            tweenScale(true);
        }
        
        FlxTween.num(coverArt.angle, -0, 0.66, {ease: FlxEase.quadInOut}, function(val) {
            coverArt.angle = val;
        });
    }

    public function getName()
    {
        if (songName.endsWith("-dox"))
            songName = songName.substr(0, songName.length - 4);

        // songName = ~/[-]/g.replace(songName, " "); // useless me thinks, why format it
        name = songName.toUpperCase();

        return name;
    }

    public function getTrueName()
        return songTrueName;

    public function updateCover()
        coverArt.loadGraphic(Paths.image('freeplay/cd/' + formatedCoverArt + 'CD'));
}