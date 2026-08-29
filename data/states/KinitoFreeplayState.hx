import funkin.menus.FreeplayState.FreeplaySonglist;
import funkin.game.HealthIcon;
import funkin.savedata.FunkinSave;
import funkin.backend.FunkinSprite;
import Math;
import openfl.Lib;
import flixel.addons.display.FlxBackdrop;

using StringTools;

var songs:Array<Dynamic> = [];
var grpSongs:FlxTypedGroup<Alphabet>;
var iconArray:Array<HealthIcon> = [];
var cds:Array<CuteDoofSprite> = []; // heh.. cutie doofy.. so kawaii..

var curDifficulty:String = 1;
var intendedScore:Int = 0;
var intendedRating:Float = 0;
var lerpScore:Int;

var left:FlxSprite;
var right:FlxSprite;
var outlineLeft:FlxSprite;
var outlineRight:FlxSprite;
var play:FlxSprite;
var outlinePlay:FlxSprite;

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
    Lib.application.window.title = "wmplayer.exe";
    
    FlxG.mouse.visible = true;

	checked = new FlxBackdrop(Paths.image('menus/freeplaymenu/bg'), FlxAxes.X);
    checked.scale.set(0.5, 0.5);
    checked.velocity.x = 64;
    checked.screenCenter();
	add(checked);

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
        
        text.visible = text.active = text.isMenuItem = true;
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
        cd.ID = i;
        cds.push(cd);
        add(cd);
    }
    
    var base = new FlxSprite().loadGraphic(Paths.image('menus/freeplaymenu/base'));
    base.screenCenter();
    base.scale.set(0.5, 0.5);
	add(base);

    sam = new FlxSprite((2261 / 2) - 55.5, (727 / 2) - 12);
	sam.frames = Paths.getSparrowAtlas('menus/freeplaymenu/samSwag');
	sam.animation.addByIndices('I', 'samSwag I0', [0,0,1,1,2,2,3,3], "", 3, true);
	sam.scale.set(0.5, 0.5);
	sam.updateHitbox();
	sam.alpha = 1;

	jade = new FlxSprite((53 / 2) - 69.5, (878 / 2) - 63.5);
	jade.frames = Paths.getSparrowAtlas('menus/freeplaymenu/jadeSwag');
	jade.animation.addByIndices('I', 'jadeSwag I0', [0,0,1,1,2,2,3,3], "", 3, true);
	jade.scale.set(0.5, 0.5);
	jade.updateHitbox();
	jade.alpha = 1;



	kinito = new FlxSprite((737 / 2) - 22, (824 / 2) - 22);
	kinito.frames = Paths.getSparrowAtlas('menus/freeplaymenu/kinitoSwag');
	kinito.animation.addByIndices('I', 'kinitoSwag I0', [0,0,1,1,2,2,3,3], "", 3, true);
	kinito.scale.set(0.5, 0.5);
	kinito.updateHitbox();
	kinito.alpha = 1;

    for (i in [sam, jade, kinito])
        i.animation.play("I", true);

    add(sam);
    add(jade);
    add(kinito);
    
    left = new FlxSprite(388.5, 249).loadGraphic(Paths.image('menus/freeplaymenu/arrowLeft'));
    left.scale.set(0.5, 0.5);
	add(left);

    outlineLeft = new FlxSprite(left.x, left.y).loadGraphic(Paths.image('menus/freeplaymenu/arrowLeftOutline'));
	outlineLeft.color = 0xFFFFFFFF;
	outlineLeft.scale.set(0.5, 0.5);
	outlineLeft.alpha = 0.95;
	add(outlineLeft);

	right = new FlxSprite(796.5, 249).loadGraphic(Paths.image('menus/freeplaymenu/arrowRight'));
    right.scale.set(0.5, 0.5);
	add(right);

    outlineRight = new FlxSprite(right.x, right.y).loadGraphic(Paths.image('menus/freeplaymenu/arrowRightOutline'));
	outlineRight.color = 0xFFFFFFFF;
	outlineRight.scale.set(0.6, 0.6);
	outlineRight.alpha = 0.95;
	add(outlineRight);

	play = new FlxSprite(495, 469.5).loadGraphic(Paths.image('menus/freeplaymenu/playButton'));
    play.scale.set(0.5, 0.5);
	add(play);

    outlinePlay = new FlxSprite(play.x, play.y).loadGraphic(Paths.image('menus/freeplaymenu/playButtonOutline'));
	outlinePlay.color = 0xFFFFFFFF;
	outlinePlay.scale.set(0.5, 0.5);
	outlinePlay.alpha = 0.95;
	add(outlinePlay);

    songNameText = new FlxText(0, 55, FlxG.width, "", 48);
    songNameText.setFormat(Paths.font("kongtext.ttf"), 48, 0x2D2C22, "center");

    songNameShadow = new FlxText(songNameText.x + 2, songNameText.y + 2, FlxG.width, "", 48);
    songNameShadow.setFormat(Paths.font("kongtext.ttf"), 48, 0x999894, "center");

    add(songNameShadow);
    add(songNameText);

    var ref = new FlxSprite().loadGraphic(Paths.image('menus/freeplaymenu/ref'));
    ref.screenCenter();
    ref.scale.set(0.5, 0.5);
    ref.alpha = 0;
    add (ref);
}

var curDifficulty:Dynamic = {
    name: "normal",
    index: 0
};
var curSelected:Int = 0;
function update(e:Float)
{
    if (FlxG.sound.music != null && FlxG.sound.music < 0.7)
        FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
    
    var lerpScore:Int;
    var lerpRating:Int;
    lerpScore = Math.floor(FlxMath.lerp(intendedScore, lerpScore, Math.exp(-e * 13.9)));
	lerpRating = FlxMath.lerp(intendedRating, lerpRating, Math.exp(-e * 6.9));

	if (Math.abs(lerpScore - intendedScore) <= 10)
		lerpScore = intendedScore;
	if (Math.abs(lerpRating - intendedRating) <= 0.01)
		lerpRating = intendedRating;

    var fuckingLeft = controls.LEFT_P;
    var fuckingRight = controls.RIGHT_P;

    if (fuckingLeft || fuckingRight)
        shiftDir(fuckingLeft, fuckingRight);

	checkHover(left, outlineLeft, "menus/freeplaymenu/arrowLeft");
	checkHover(right, outlineRight, "menus/freeplaymenu/arrowRight");
	checkHover(play, outlinePlay, "menus/freeplaymenu/playButton");

    if (controls.BACK)
        FlxG.switchState(new MainMenuState());
}

function changeDifficulty(?fuck:Int)
{
    fuck ??= 0;

    var songDiff = songs[curSelected].difficulties;

    if (songDiff == null || songDiff.length == 0)
        return;

	curDifficulty.index = FlxMath.wrap(curDifficulty.index + fuck, 0, songDiff.length - 1);
	curDifficulty.name = songDiff[curDifficulty.index];
}

var isBusy:Bool = false;
function shiftDir(?left:Bool, ?right:Bool, ?play:Bool)
{
    left ??= true;
    right ??= true;

    if (isBusy) return;

	curSelected = FlxMath.wrap(curSelected + (left ? -1 : 1), 0, songs.length - 1);
	changeDifficulty();
    
    var place = (left  ? cds.shift() : cds.pop());
    for (i => cd in cds)
    {
        if (cd.x == penis[left ? 3 : 1])
        {
			var save = FunkinSave.getSongHighscore(cd.getTrueName(), curDifficulty.name);
			intendedScore = save.score;
            intendedRating = save.accuracy;
        }
    }

    // ogh i need to do something else, i've been doing this for like 2 hours

    if (play)
    {
        var activeTweens:Int = 0;
	
		for (i => cd in cds)
        {
			if (cd.x == penis[2])
            {
				activeTweens++;
				var tweenCompleted = false;
	
				FlxTween.num(cd.y, 564, 1, {ease: FlxEase.quadInOut}, (val) ->
                {
					cd.setY(val);

					if (!tweenCompleted)
                    {
						tweenCompleted = true;
						isBusy = true;
						loadSong(cd.getTrueName());
					}
				});
            }
        }
    }

    updatePositions();
}

function updatePositions()
{
    if (isBusy)
        return;

    isBusy = true;

	var activeTweens:Int = 0;
	var tweenCompleted:Bool = false;

    updateHeight();
	updateSize();
    updateBump();

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

		FlxTween.num(cd.x, targetX, 0.33, {ease: FlxEase.sineInOut}, (val) -> {
			cd.setX(val);

			activeTweens--;
			if (activeTweens == 0)
				isBusy = false;
		});
	}
}

function updateHeight()
{
    for (i => cd in cds)
    {
        var prevIndex:Int = (i + 1) % penis.length;
        var from = penis[prevIndex];
        var to = penis[i];

        var targetY = cd.y;

        // hate this big line of code
		if ((from == penis[0] && to == penis[1]) || (from == penis[4] && to == penis[3]))
            targetY = 275;
		else if ((from == penis[1] && to == penis[2]) || (from == penis[3] && to == penis[2]))
            targetY = 162;
		else if ((from == penis[3] && to == penis[2]) || (from == penis[2] && to == penis[1]))
            targetY = 275;
		else if ((from == penis[3] && to == penis[4]) || (from == penis[1] && to == penis[0]))
            targetY = FlxG.height;
		else if ((from == penis[0] && to == penis[4]) || (from == penis[4] && to == penis[0]))
            targetY = FlxG.height;

		FlxTween.num(cd.y, targetY, 0.33, {ease: FlxEase.sineInOut}, (val) -> {
			cd.setY(val);
		});
    }
}

function updateSize()
{
	for (i => cd in cds)
    {
		var prevIndex:Int = (i + 1) % penis.length;
		var from = penis[prevIndex];
		var to = penis[i];

		if ((from == penis[0] && to == penis[1]) || (from == penis[4] && to == penis[3]))
			cd.tweenScale(true);
		else if ((from == penis[1] && to == penis[2]) || (from == penis[3] && to == penis[2]))
			cd.tweenScale();
		else if ((from == penis[3] && to == penis[2]) || (from == penis[2] && to == penis[1]))
			cd.tweenScale(true);
		else if ((from == penis[3] && to == penis[4]) || (from == penis[1] && to == penis[0]))
			cd.tweenScale(true);
		else if ((from == penis[0] && to == penis[4]) || (from == penis[4] && to == penis[0]))
			cd.tweenScale(true);
    }
}

var idleTimer = new FlxTimer();
function updateBump()
{
    for (i => cd in cds)
    {
        var songName = cd.getName();
        var bpm = songs[cd.ID].bpm;

        if (cd.x == penis[2])
        {
            idleTimer.cancel();
			idleTimer.start(BeCI.bpm(1, bpm), () -> {
                sam.animation.play("I", true);
				jade.animation.play("I", true);
                updateBump();
            });
        }
    }
}

function updateCDSpin() {
    for (i => cd in cds) {
        var leSongName = cd.getName();
        var bpm = songs[cd.ID].bpm;

        if (cd.x == penis[3]) { //if it's centered
            cd.spinCD(BeCI.bpm(8, bpm));
            songNameText.text = ""+ leSongName;
            songNameShadow.text = ""+ leSongName;
            // trace("dung-geulge");
        } else {
            cd.stopSpinCD();
            // trace(":sad_face:");
        }
    }
}

function checkHover(sprite:FlxSprite, outline:FlxSprite, normal:String)
{
	if (sprite == null || outline == null)
        return;
    
    if (FlxG.mouse.overlaps(sprite))
    {
        outline.visible = true;

        if (FlxG.mouse.justPressed)
        {
            sprite.loadGraphic(Paths.image(normal + "Press"));
			outline.loadGraphic(Paths.image(normal + "OutlinePress"));
            if (sprite == left || sprite == right)
				shiftDir(boolToInt(sprite == left), boolToInt(sprite == right));
        }
        else
        {
            outline.visible = false;
            sprite.loadGraphic(Paths.image(normal));
        }
    }
}

function boolToInt(bitch:Bool):Int
{
    if (bitch)
        return 1;

    return 0;
}

class BeCI {
    public static function round(beats:Float):Float {
        return (60 / PlayState.SONG.bpm) * beats;
    }

    public static function bpm(beats:Float, bpm:Int):Float {
        return (60 / bpm) * beats;
    }
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
        coverArt.loadGraphic(Paths.image('menus/freeplaymenu/cd/' + formatedCoverArt + 'CD'));
}