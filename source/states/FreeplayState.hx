package states;

import backend.WeekData;
import backend.Highscore;
import backend.Song;
import backend.BeCI;

import objects.HealthIcon;
import objects.MusicPlayer;
import objects.CDSprite;

import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

import substates.GameplayChangersSubstate;
import substates.ResetScoreSubState;

import flixel.math.FlxMath;
import flixel.util.FlxDestroyUtil;

import haxe.Json;
import lime.utils.Assets;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	private static var curSelected:Int = 0;
	var lerpSelected:Float = 0;
	var curDifficulty:Int = -1;
	private static var lastDifficultyName:String = Difficulty.getDefault();

	var scoreBG:FlxSprite;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var lerpRating:Float = 0;
	var intendedScore:Int = 0;
	var intendedRating:Float = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	var bg:FlxSprite;
	var intendedColor:Int;
	var colorTween:FlxTween;

	var missingTextBG:FlxSprite;
	var missingText:FlxText;

	var bottomString:String;
	var bottomText:FlxText;
	var bottomBG:FlxSprite;

	var player:MusicPlayer;

	// new menu WOOOOOW

	var freeplay:FlxGroup;

	var cd:FlxGroup;
	var notcd:FlxGroup;

	var back:FlxSprite;

	var checked:FlxBackdrop;
	var base:FlxSprite;

	var outlineLeft:FlxSprite;
	var outlineRight:FlxSprite;

	var left:FlxSprite;
	var right:FlxSprite;

	var outlinePlay:FlxSprite;

	var play:FlxSprite;

	var artist:FlxText;
	var artistName:FlxText;

	var composer:FlxText;
	var composerName:FlxText;

	var songNameText:FlxText;
	var songNameShadow:FlxText;

	var scoreText:FlxText;
	var scoreTextShadow:FlxText;

	var highscore:FlxText;
	var highscoreShadow:FlxText;

	var ref:FlxSprite;

	var jade:FlxSprite;
	var sam:FlxSprite;
	var kinito:FlxSprite;

	var sprites:Array<FlxSprite> = [];

    var cds:Array<CDSprite> = [];
    var positions:Array<Float> = [
        -355,                     // 0 -> Fora da tela (esquerda)
        (955 / 2) - 335,          // 1 -> Segunda posição visível
        (955 / 2),                // 2 -> Centro (posição inicial do primeiro CD)
        (955 / 2) + 444,          // 3 -> Quarta posição visível
        FlxG.width + 355          // 4 -> Fora da tela (direita)
    ];

	public static function loadBPMData():Map<String, Int> {
		var rawJson:String = null;
		var bpmMap:Map<String, Int> = new Map();
	
		if (rawJson == null) {
			var path:String = Paths.json("bpmData");
			#if sys
			if (FileSystem.exists(path))
				rawJson = File.getContent(path).trim();
				else 
				#end
				rawJson = Assets.getText(Paths.json("bpmData")).trim();
		}

		var data:Dynamic = Json.parse(rawJson);

			var bpmList:Array<Dynamic> = data.bpmMap;
			for (entry in bpmList) {
				var name:String = entry.name;
				var bpm:Int = entry.bpm;
				bpmMap.set(name, bpm);
			}
	
		return bpmMap;	

	}
		
		var musicBPM:Map<String, Int>;


	override function create()
	{
		//Paths.clearStoredMemory();
		//Paths.clearUnusedMemory();

		FlxG.mouse.visible = true;
		
		musicBPM = loadBPMData();

		freeplay = new FlxGroup();
		
		persistentUpdate = true;
		PlayState.isStoryMode = false;
		WeekData.reloadWeekFiles(false);

		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		for (i in 0...WeekData.weeksList.length) {
			if(weekIsLocked(WeekData.weeksList[i])) continue;

			var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			var leSongs:Array<String> = [];
			var leChars:Array<String> = [];

			for (j in 0...leWeek.songs.length)
			{
				leSongs.push(leWeek.songs[j][0]);
				leChars.push(leWeek.songs[j][1]);
			}

			WeekData.setDirectoryFromWeek(leWeek);
			for (song in leWeek.songs)
			{
				var colors:Array<Int> = song[2];
				if(colors == null || colors.length < 3)
				{
					colors = [146, 113, 253];
				}
				addSong(song[0], i, song[1], FlxColor.fromRGB(colors[0], colors[1], colors[2]));
			}
		}
		Mods.loadTopMod();

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);
		bg.screenCenter();

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(90, 320, songs[i].songName, true);
			songText.targetY = i;
			grpSongs.add(songText);

			songText.scaleX = Math.min(1, 980 / songText.width);
			songText.snapToPosition();

			Mods.currentModDirectory = songs[i].folder;
			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			
			// too laggy with a lot of songs, so i had to recode the logic for it
			songText.visible = songText.active = songText.isMenuItem = false;
			icon.visible = icon.active = false;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}
		WeekData.setDirectoryFromWeek();


		missingTextBG = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		missingTextBG.alpha = 0.6;
		missingTextBG.visible = false;
		add(missingTextBG);
		
		missingText = new FlxText(50, 0, FlxG.width - 100, '', 24);
		missingText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		missingText.scrollFactor.set();
		missingText.visible = false;
		add(missingText);

		if(curSelected >= songs.length) curSelected = 0;
		bg.color = songs[curSelected].color;
		intendedColor = bg.color;
		lerpSelected = curSelected;

		curDifficulty = Math.round(Math.max(0, Difficulty.defaultList.indexOf(lastDifficultyName)));

		bottomBG = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		bottomBG.alpha = 0.6;
		add(bottomBG);

		var leText:String = "Press SPACE to listen to the Song / Press CTRL to open the Gameplay Changers Menu / Press RESET to Reset your Score and Accuracy.";
		bottomString = leText;
		var size:Int = 16;
		bottomText = new FlxText(bottomBG.x, bottomBG.y + 4, FlxG.width, leText, size);
		bottomText.setFormat(Paths.font("vcr.ttf"), size, FlxColor.WHITE, CENTER);
		bottomText.scrollFactor.set();
		add(bottomText);

		// new menu yiipee

		back = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		back.visible = true;
		add(back);

		checked = new FlxBackdrop(Paths.image('freeplay/bg'), flixel.util.FlxAxes.X);
		checked.velocity.x = 64;
		add(checked);

		
        var musicas:Array<String> = [];
        
        // Pega todas as músicas disponíveis
        for (i in 0...WeekData.weeksList.length) {
            if (weekIsLocked(WeekData.weeksList[i])) continue;
            var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
            
            for (song in leWeek.songs) {
                musicas.push(song[0].toLowerCase());
            }
        }

		if (musicas.length > positions.length) {
			var lastPos = positions[positions.length - 1]; // Última posição da array
			while (positions.length < musicas.length) {
				positions.push(lastPos); // Clona a última posição para os extras
			}
		}
        
        // Criar CDs
        for (i in 0...musicas.length) {
            var posIndex = 0;

            if (i == 0) posIndex = 2; // Primeiro CD começa no meio
            else if (i == 1) posIndex = 3;
            else if (i == 2) posIndex = 4;
            else if (i == musicas.length - 1) posIndex = 1; // Último CD começa no centro também

            var cd = new CDSprite(positions[posIndex], 162, musicas[i]);
            cds.push(cd);
            add(cd);
        }

		base = new FlxSprite().loadGraphic(Paths.image('freeplay/base'));
		add(base);

		outlineLeft = new FlxSprite().loadGraphic(Paths.image('freeplay/arrowLeftOutline'));
		outlineLeft.color = 0xFFFFFFFF;
		outlineLeft.scale.set(0.6, 0.6);
		outlineLeft.alpha = 0.95;
		add(outlineLeft);

		left = new FlxSprite().loadGraphic(Paths.image('freeplay/arrowLeft'));
		add(left);

		outlineRight = new FlxSprite().loadGraphic(Paths.image('freeplay/arrowRightOutline'));
		outlineRight.color = 0xFFFFFFFF;
		outlineRight.scale.set(0.6, 0.6);
		outlineRight.alpha = 0.95;
		add(outlineRight);

		right = new FlxSprite().loadGraphic(Paths.image('freeplay/arrowRight'));
		add(right);

		outlinePlay = new FlxSprite().loadGraphic(Paths.image('freeplay/playButtonOutline'));
		outlinePlay.color = 0xFFFFFFFF;
		outlinePlay.scale.set(0.6, 0.6);
		outlinePlay.alpha = 0.95;
		add(outlinePlay);

		play = new FlxSprite().loadGraphic(Paths.image('freeplay/playButton'));
		add(play);

		songNameText = new FlxText(0, 55, FlxG.width, "", 48);
		songNameText.setFormat(Paths.font("kongtext.ttf"), 48, 0x2D2C22, FlxTextAlign.CENTER);

		songNameShadow = new FlxText(songNameText.x + 2, songNameText.y + 2, FlxG.width, "", 48);
		songNameShadow.setFormat(Paths.font("kongtext.ttf"), 48, 0x999894, FlxTextAlign.CENTER);

		scoreText = new FlxText(1035, 110, 0, "", 32);
		scoreText.setFormat(Paths.font("kongtext.ttf"), 24, 0x2D2C22, FlxTextAlign.CENTER);

		scoreTextShadow = new FlxText(scoreText.x + 2, scoreText.y + 2, 0, "", 16);
		scoreTextShadow.setFormat(Paths.font("kongtext.ttf"), 24, 0x999894, FlxTextAlign.CENTER);

		highscore = new FlxText(scoreText.x + 20, 72, 0, "HIGHSCORE:", 32);
		highscore.setFormat(Paths.font("kongtext.ttf"), 16, 0x2D2C22, FlxTextAlign.CENTER);
	
		highscoreShadow = new FlxText(highscore.x + 2, highscore.y + 2, 0, "HIGHSCORE", 16);
		highscoreShadow.setFormat(Paths.font("kongtext.ttf"), 16, 0x999894, FlxTextAlign.CENTER);

		scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(1, 66, 0xFF000000);
		scoreBG.alpha = 0;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		diffText.alpha = 0;
		add(diffText);


		add(scoreTextShadow);
		add(scoreText);

		add(highscoreShadow);
		add(highscore);


		add(songNameShadow);
		add(songNameText);

		

		ref = new FlxSprite().loadGraphic(Paths.image('freeplay/ref'));
		ref.alpha = 0.75;
		add(ref);

		sam = new FlxSprite((2261 / 2) - 55, (727 / 2) - 10);

		sam.frames = Paths.getSparrowAtlas('freeplay/samSwag');
		sam.animation.addByIndices('I', 'samSwag I0', [0,0,1,1,2,2,3,3,3,3,3,3,3,3,3,3], "", 24, false);
		sam.scale.set(0.5, 0.5);
		sam.updateHitbox();
		sam.alpha = 1;

		jade = new FlxSprite((53 / 2) - 65, (878 / 2) - 60);

		jade.frames = Paths.getSparrowAtlas('freeplay/jadeSwag');
		jade.animation.addByIndices('I', 'jadeSwag I0', [0,0,1,1,2,2,3,3,3,3,3,3,3,3,3,3], "", 24, false);
		jade.scale.set(0.5, 0.5);
		jade.updateHitbox();
		jade.alpha = 1;



		kinito = new FlxSprite((737 / 2) - 30, (824 / 2) - 20);

		kinito.frames = Paths.getSparrowAtlas('freeplay/kinitoSwag');
		kinito.animation.addByIndices('I', 'kinitoSwag I0', [0,0,0,1,1,1,2,2,2,3,3,3], "", 24, true);
		kinito.scale.set(0.5, 0.5);
		kinito.updateHitbox();
		kinito.alpha = 1;

        sam.animation.play("I");
		jade.animation.play("I");
        kinito.animation.play("I", true);

		freeplay.add(checked);
		freeplay.add(base);
		freeplay.add(left);
		freeplay.add(right);
		freeplay.add(play);

		freeplay.add(ref);

		add(sam);
		add(jade);
		add(kinito);

		freeplay.forEach(function(coisas:Dynamic) {
			coisas.antialiasing = false;
			coisas.scale.set(0.5 , 0.5);
			coisas.updateHitbox();

			if (Std.is(coisas, FlxSprite)) {
				if (coisas == base || coisas == ref || coisas == checked) {
					coisas.screenCenter();
				}
				if (coisas == play) {
					coisas.x = (1135 / 2);
					coisas.y = (1065 / 2) + 10;
				}
				if (coisas == left || coisas == right) {
					coisas.y = (547 / 2) + 10;
				}
				if (coisas == left) {
					coisas.x = (824 / 2);
				}
				if (coisas == right) {
					coisas.x = (1641 / 2);
				}
			}
						
		});

		outlineLeft.setPosition(left.x - (outlineLeft.width - left.width) / 2, 
        left.y - (outlineLeft.height - left.height) / 2);

		outlineRight.setPosition(right.x - (outlineRight.width - right.width) / 2, 
        right.y - (outlineRight.height - right.height) / 2);

		outlinePlay.setPosition(play.x - (outlinePlay.width - play.width) / 2, 
        play.y - (outlinePlay.height - play.height) / 2);

		// trace("CDs criados: " + cds.length);

		shiftRight();


		for (cd in cds) {
			cd.updateCover();
			if (cd.x == positions[1]) {
				intendedScore = Highscore.getScore(cd.getTrueName(), curDifficulty);
				intendedRating = Highscore.getRating(cd.getTrueName(), curDifficulty);
			}
		}


		// I FUCKING HATE THIS PLAYER GRRRRRRR

		player = new MusicPlayer(this);
		add(player);

		changeSelection();
		updateTexts();
		super.create();
	}

	function traceScore() {
		trace ("intendedScore: " + intendedScore);
		trace ("intendedRating: " + intendedRating);

				for (cd in cds) {
			cd.updateCover();
			if (cd.x == positions[1]) {
				intendedScore = Highscore.getScore(cd.getTrueName(), curDifficulty);
				trace ("alguma coisa: " + Highscore.getScore(cd.getTrueName(), curDifficulty));
				intendedRating = Highscore.getRating(cd.getTrueName(), curDifficulty);
			}
		}
	}

	override function closeSubState() {
		changeSelection(0, false);
		persistentUpdate = true;
		super.closeSubState();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String, color:Int)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter, color));
	}	

	function weekIsLocked(name:String):Bool {
		var leWeek:WeekData = WeekData.weeksLoaded.get(name);
		return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!StoryMenuState.weekCompleted.exists(leWeek.weekBefore) || !StoryMenuState.weekCompleted.get(leWeek.weekBefore)));
	}

	var instPlaying:Int = -1;
	public static var vocals:FlxSound = null;
	public static var opponentVocals:FlxSound = null;
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}
		lerpScore = Math.floor(FlxMath.lerp(intendedScore, lerpScore, Math.exp(-elapsed * 13.9)));
		lerpRating = FlxMath.lerp(intendedRating, lerpRating, Math.exp(-elapsed * 6.9));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
		if (Math.abs(lerpRating - intendedRating) <= 0.01)
			lerpRating = intendedRating;

		var ratingSplit:Array<String> = Std.string(CoolUtil.floorDecimal(lerpRating * 100, 2)).split('.');
		if(ratingSplit.length < 2) { //No decimals, add an empty space
			ratingSplit.push('');
		}
		
		while(ratingSplit[1].length < 2) { //Less than 2 decimals in it, add decimals then
			ratingSplit[1] += '0';
		}

		var shiftMult:Int = 1;
		if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

		ref.visible = FlxG.keys.pressed.HOME;



			scoreText.text = '' + lerpScore + '\n(' + ratingSplit.join('.') + '%)';
			scoreTextShadow.text  = '' + lerpScore + '\n(' + ratingSplit.join('.') + '%)';
			// positionHighscore();
			
			// if(songs.length > 1)
			// {
			// 	if(FlxG.keys.justPressed.HOME)
			// 	{
			// 		curSelected = 0;
			// 		changeSelection();
			// 		holdTime = 0;	
			// 	}
			// 	else if(FlxG.keys.justPressed.END)
			// 	{
			// 		curSelected = songs.length - 1;
			// 		changeSelection();
			// 		holdTime = 0;	
			// 	}
			// 	if (controls.UI_UP_P)
			// 	{
			// 		changeSelection(-shiftMult);
			// 		holdTime = 0;
			// 	}
			// 	if (controls.UI_DOWN_P)
			// 	{
			// 		changeSelection(shiftMult);
			// 		holdTime = 0;
			// 	}

			// 	if(controls.UI_DOWN || controls.UI_UP)
			// 	{
			// 		var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
			// 		holdTime += elapsed;
			// 		var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

			// 		if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
			// 			changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
			// 	}

			// 	if(FlxG.mouse.wheel != 0)
			// 	{
			// 		FlxG.sound.play(Paths.sound('scrollMenu'), 0.2);
			// 		changeSelection(-shiftMult * FlxG.mouse.wheel, false);
			// 	}
			// }

			// if (controls.UI_LEFT_P)
			// {
			// 	changeDiff(-1);
			// 	_updateSongLastDifficulty();
			// }
			// else if (controls.UI_RIGHT_P)
			// {
			// 	changeDiff(1);
			// 	_updateSongLastDifficulty();
			// }

		checkHover(left, outlineLeft, "freeplay/arrowLeft");
		checkHover(right, outlineRight, "freeplay/arrowRight");
		checkHover(play, outlinePlay, "freeplay/playButton");

		if (controls.BACK)
		{
			if (player.playingMusic)
			{
				FlxG.sound.music.stop();
				destroyFreeplayVocals();
				FlxG.sound.music.volume = 0;
				instPlaying = -1;

				player.playingMusic = false;
				player.switchPlayMusic();

				FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
				FlxTween.tween(FlxG.sound.music, {volume: 1}, 1);
			}
			else 
			{
				persistentUpdate = false;
				if(colorTween != null) {
					colorTween.cancel();
				}
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
			}
		}

		if(FlxG.keys.justPressed.CONTROL && !player.playingMusic)
		{
			persistentUpdate = false;
			openSubState(new GameplayChangersSubstate());
		}
		else if(FlxG.keys.justPressed.SPACE)
		{
			if(instPlaying != curSelected && !player.playingMusic)
			{
				destroyFreeplayVocals();
				FlxG.sound.music.volume = 0;

				Mods.currentModDirectory = songs[curSelected].folder;
				var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
				Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
				if (PlayState.SONG.needsVoices)
				{
					vocals = new FlxSound();
					try
					{
						var playerVocals:String = getVocalFromCharacter(PlayState.SONG.player1);
						var loadedVocals = Paths.voices(PlayState.SONG.song, (playerVocals != null && playerVocals.length > 0) ? playerVocals : 'Player');
						if(loadedVocals == null) loadedVocals = Paths.voices(PlayState.SONG.song);
						
						if(loadedVocals != null && loadedVocals.length > 0)
						{
							vocals.loadEmbedded(loadedVocals);
							FlxG.sound.list.add(vocals);
							vocals.persist = vocals.looped = true;
							vocals.volume = 0.8;
							vocals.play();
							vocals.pause();
						}
						else vocals = FlxDestroyUtil.destroy(vocals);
					}
					catch(e:Dynamic)
					{
						vocals = FlxDestroyUtil.destroy(vocals);
					}
					
					opponentVocals = new FlxSound();
					try
					{
						//trace('please work...');
						var oppVocals:String = getVocalFromCharacter(PlayState.SONG.player2);
						var loadedVocals = Paths.voices(PlayState.SONG.song, (oppVocals != null && oppVocals.length > 0) ? oppVocals : 'Opponent');
						
						if(loadedVocals != null && loadedVocals.length > 0)
						{
							opponentVocals.loadEmbedded(loadedVocals);
							FlxG.sound.list.add(opponentVocals);
							opponentVocals.persist = opponentVocals.looped = true;
							opponentVocals.volume = 0.8;
							opponentVocals.play();
							opponentVocals.pause();
							//trace('yaaay!!');
						}
						else opponentVocals = FlxDestroyUtil.destroy(opponentVocals);
					}
					catch(e:Dynamic)
					{
						//trace('FUUUCK');
						opponentVocals = FlxDestroyUtil.destroy(opponentVocals);
					}
				}

				FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.8);
				FlxG.sound.music.pause();
				instPlaying = curSelected;

				player.playingMusic = true;
				player.curTime = 0;
				player.switchPlayMusic();
				player.pauseOrResume(true);
			}
			else if (instPlaying == curSelected && player.playingMusic)
			{
				player.pauseOrResume(!player.playing);
			}
		}
		else if (controls.ACCEPT && !player.playingMusic)
		{
			persistentUpdate = false;
			var songLowercase:String = Paths.formatToSongPath(songs[curSelected].songName);
			var poop:String = Highscore.formatSong(songLowercase, curDifficulty);
			trace(poop);
			try
			{
				PlayState.SONG = Song.loadFromJson(poop, songLowercase);
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = curDifficulty;

				trace('CURRENT WEEK: ' + WeekData.getWeekFileName());
				if(colorTween != null) {
					colorTween.cancel();
				}
			}
			catch(e:Dynamic)
			{
				trace('ERROR! $e');

				var errorStr:String = e.toString();
				if(errorStr.startsWith('[file_contents,assets/data/')) errorStr = 'Missing file: ' + errorStr.substring(34, errorStr.length-1); //Missing chart
				missingText.text = 'ERROR WHILE LOADING CHART:\n$errorStr';
				missingText.screenCenter(Y);
				missingText.visible = true;
				missingTextBG.visible = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));

				updateTexts(elapsed);
				super.update(elapsed);
				return;
			}
			LoadingState.loadAndSwitchState(new PlayState());

			FlxG.sound.music.volume = 0;
					
			destroyFreeplayVocals();
			#if (MODS_ALLOWED && DISCORD_ALLOWED)
			DiscordClient.loadModRPC();
			#end
		}
		else if(controls.RESET && !player.playingMusic)
		{
			persistentUpdate = false;
			openSubState(new ResetScoreSubState(songs[curSelected].songName, curDifficulty, songs[curSelected].songCharacter));
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}

		updateTexts(elapsed);
		super.update(elapsed);
	}

	function getVocalFromCharacter(char:String)
	{
		try
		{
			var path:String = Paths.getPath('characters/$char.json', TEXT);
			#if MODS_ALLOWED
			var character:Dynamic = Json.parse(File.getContent(path));
			#else
			var character:Dynamic = Json.parse(Assets.getText(path));
			#end
			return character.vocals_file;
		}
		catch (e:Dynamic) {}
		return null;
	}

	function chooseSong(leSong:String) {
		persistentUpdate = false;
		var songLowercase:String = Paths.formatToSongPath(leSong);
		var poop:String = Highscore.formatSong(songLowercase, 1);
		trace(poop);
		try
		{
			PlayState.SONG = Song.loadFromJson(poop, songLowercase);
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;

			trace('CURRENT WEEK: ' + WeekData.getWeekFileName());
			if(colorTween != null) {
				colorTween.cancel();
			}
		}
		catch(e:Dynamic)
		{
			trace('ERROR! $e');

			var errorStr:String = e.toString();
			if(errorStr.startsWith('[file_contents,assets/data/')) errorStr = 'Missing file: ' + errorStr.substring(34, errorStr.length-1); //Missing chart
			missingText.text = 'ERROR WHILE LOADING CHART:\n$errorStr';
			missingText.screenCenter(Y);
			missingText.visible = true;
			missingTextBG.visible = true;
			FlxG.sound.play(Paths.sound('cancelMenu'));

			return;
		}
		LoadingState.loadAndSwitchState(new PlayState());

		FlxG.sound.music.volume = 0;
				
		destroyFreeplayVocals();
		#if (MODS_ALLOWED && DISCORD_ALLOWED)
		DiscordClient.loadModRPC();
		#end
	}

	var isBusy:Bool = false;

	function shiftLeft() {
		if (isBusy) return;
	
		var first = cds.shift();
		cds.push(first);
	
		for (i in 0...cds.length) {
			var cd = cds[i];
			if (cd.x == positions[1]) {
				intendedScore = Highscore.getScore(cd.getTrueName(), curDifficulty);
				intendedRating = Highscore.getRating(cd.getTrueName(), curDifficulty);
			}
		}
	
		updatePositions();
	}
	
	function shiftRight() {
		if (isBusy) return;
	
		var last = cds.pop();
		cds.unshift(last);
	
		for (i in 0...cds.length) {
			var cd = cds[i];
			if (cd.x == positions[3]) {
				intendedScore = Highscore.getScore(cd.getTrueName(), curDifficulty);
				intendedRating = Highscore.getRating(cd.getTrueName(), curDifficulty);
			}
		}
	
		updatePositions();
	}
	
	function shiftDown() {
		if (isBusy) return;
	
		isBusy = true;
		var activeTweens = 0;
	
		for (i in 0...cds.length) {
			var cd = cds[i];
			if (cd.x == positions[2]) {
				activeTweens++;
				var tweenCompleted = false;
	
				FlxTween.num(cd.y, 564, 1, {ease: FlxEase.quadInOut}, function(val) {
					cd.setY(val);
				}).onComplete = function(_) {
					if (!tweenCompleted) {
						tweenCompleted = true;
						isBusy = true;
						chooseSong(cd.getTrueName());
					}
				};
	
				break;
			}
		}
	}
	
	function updatePositions() {
		if (isBusy) return;
	
		isBusy = true;
		var activeTweens = 0;
		var tweenCompleted = false;
	
		updateHeight();
		updateSize();
		updateBump();
	
		FlxTween.num(0, 1, 0.33, {ease: FlxEase.sineInOut}, function(_) {}).onComplete = function(_) {
			if (!tweenCompleted) {
				tweenCompleted = true;
				updateCDSpin();
			}
		};
	
		for (i in 0...cds.length) {
			var cd = cds[i];
			var targetX = positions[i % positions.length];
	
			activeTweens++;
	
			FlxTween.num(cd.x, targetX, 0.33, {ease: FlxEase.sineInOut}, function(val) {
				cd.setX(val);
			}).onComplete = function(_) {
				activeTweens--;
				if (activeTweens == 0) {
					isBusy = false;
				}
			};
		}
	}
	
	function updateHeight() {
		for (i in 0...cds.length) {
			var cd = cds[i];
			var prevIndex = (i + 1) % positions.length;
			var from = positions[prevIndex];
			var to = positions[i];
	
			var targetY = cd.y;
	
			if ((from == positions[0] && to == positions[1]) || (from == positions[4] && to == positions[3])) {
				targetY = 275;
			} else if ((from == positions[1] && to == positions[2]) || (from == positions[3] && to == positions[2])) {
				targetY = 162;
			} else if ((from == positions[3] && to == positions[2]) || (from == positions[2] && to == positions[1])) {
				targetY = 275;
			} else if ((from == positions[3] && to == positions[4]) || (from == positions[1] && to == positions[0])) {
				targetY = FlxG.height;
			} else if ((from == positions[0] && to == positions[4]) || (from == positions[4] && to == positions[0])) {
				targetY = FlxG.height;
			}
	
			FlxTween.num(cd.y, targetY, 0.33, {ease: FlxEase.sineInOut}, function(val) {
				cd.setY(val);
			});
		}
	}

	function updateSize() {
		for (i in 0...cds.length) {
			var cd = cds[i];
			var prevIndex = (i + 1) % positions.length;
			var from = positions[prevIndex];
			var to = positions[i];
	
			if ((from == positions[0] && to == positions[1]) || (from == positions[4] && to == positions[3])) {
				cd.tweenScale(true);
			} else if ((from == positions[1] && to == positions[2]) || (from == positions[3] && to == positions[2])) {
				cd.tweenScale();
			} else if ((from == positions[3] && to == positions[2]) || (from == positions[2] && to == positions[1])) {
				cd.tweenScale(true);
			} else if ((from == positions[3] && to == positions[4]) || (from == positions[1] && to == positions[0])) {
				cd.tweenScale(true);
			} else if ((from == positions[0] && to == positions[4]) || (from == positions[4] && to == positions[0])) {
				cd.tweenScale(true);
			}
		}
	}

	var idleTimer:FlxTimer = new FlxTimer();

	function updateBump():Void {
		for (cd in cds) {
			var leSongName = cd.getName();
			var bpm = musicBPM.exists(leSongName) ? musicBPM[leSongName] : musicBPM["default"];
	
			if (cd.x == positions[2]) {
				idleTimer.cancel();
				idleTimer.start(BeCI.bpm(1, bpm), function(_) {
					sam.animation.play("I");
					jade.animation.play("I");
					updateBump();
				});
		}

	}
}

	

	function getName() {

		for (cd in cds) {
			trace("CD -> x: " + cd.x + ", visible: " + cd.visible + ", name: " + cd.getName() + ", True name: " + cd.getTrueName());
		}
	}

	function updateCDSpin() {
		for (cd in cds) {
			var leSongName = cd.getName();
			var bpm = musicBPM.exists(leSongName) ? musicBPM[leSongName] : musicBPM["default"];
	
			if (cd.x == positions[2]) { // Se estiver na posição central
				cd.spinCD(BeCI.bpm(8, bpm));
				songNameText.text = ""+ leSongName;
				songNameShadow.text = ""+ leSongName;
				// trace("dung-geulge");
			} else {
				cd.stopSpinCD();
				// trace(":sad_face:");
			}

			// if (cd.x != positions[1] && cd.x != positions[2] && cd.x != positions[3]) {
			// 	cd.visible = false;
			// } else {
			// 	cd.visible = true;
			// }
		}
	}
	

	function checkHover(sprite:FlxSprite, outline:FlxSprite, normal:String) {
		if (sprite.overlapsPoint(FlxG.mouse.getScreenPosition())) {
			outline.visible = true; // Mostra a outline
	
			if (FlxG.mouse.justPressed) {
				sprite.loadGraphic(Paths.image(normal + "Press"));
				outline.loadGraphic(Paths.image(normal + "Outline" + "Press"));
				if (sprite == left) 
					{
						shiftRight();
					}
				if (sprite == right) 
					{
						shiftLeft();
					}
				if (sprite == play)
					{
						getName();
						shiftDown();
					}
			} else {
				sprite.loadGraphic(Paths.image(normal));
				outline.loadGraphic(Paths.image(normal + "Outline" ));
			}
		} else {
			outline.visible = false; // Esconde a outline se o mouse sair
			sprite.loadGraphic(Paths.image(normal));
		}
	}

	public static function destroyFreeplayVocals() {
		if(vocals != null) vocals.stop();
		vocals = FlxDestroyUtil.destroy(vocals);

		if(opponentVocals != null) opponentVocals.stop();
		opponentVocals = FlxDestroyUtil.destroy(opponentVocals);
	}


	function changeDiff(change:Int = 0)
	{
		if (player.playingMusic)
			return;

		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = Difficulty.list.length-1;
		if (curDifficulty >= Difficulty.list.length)
			curDifficulty = 0;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end

		lastDifficultyName = Difficulty.getString(curDifficulty);
		if (Difficulty.list.length > 1)
			diffText.text = '< ' + lastDifficultyName.toUpperCase() + ' >';
		else
			diffText.text = lastDifficultyName.toUpperCase();

		positionHighscore();
		missingText.visible = false;
		missingTextBG.visible = false;
	}

	function changeSelection(change:Int = 0, playSound:Bool = true)
	{
		if (player.playingMusic)
			return;

		_updateSongLastDifficulty();
		if(playSound) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		var lastList:Array<String> = Difficulty.list;
		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;
			
		var newColor:Int = songs[curSelected].color;
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			bullShit++;
			item.alpha = 0.6;
			if (item.targetY == curSelected)
				item.alpha = 1;
		}
		
		Mods.currentModDirectory = songs[curSelected].folder;
		PlayState.storyWeek = songs[curSelected].week;
		Difficulty.loadFromWeek();
		
		var savedDiff:String = songs[curSelected].lastDifficulty;
		var lastDiff:Int = Difficulty.list.indexOf(lastDifficultyName);
		if(savedDiff != null && !lastList.contains(savedDiff) && Difficulty.list.contains(savedDiff))
			curDifficulty = Math.round(Math.max(0, Difficulty.list.indexOf(savedDiff)));
		else if(lastDiff > -1)
			curDifficulty = lastDiff;
		else if(Difficulty.list.contains(Difficulty.getDefault()))
			curDifficulty = Math.round(Math.max(0, Difficulty.defaultList.indexOf(Difficulty.getDefault())));
		else
			curDifficulty = 0;

		changeDiff();
		_updateSongLastDifficulty();
	}

	inline private function _updateSongLastDifficulty()
	{
		songs[curSelected].lastDifficulty = Difficulty.getString(curDifficulty);
	}

	private function positionHighscore() {
		// scoreText.x = FlxG.width - scoreText.width - 6;
		// scoreBG.scale.x = FlxG.width - scoreText.x + 6;
		// scoreBG.x = FlxG.width - (scoreBG.scale.x / 2);
		// diffText.x = Std.int(scoreBG.x + (scoreBG.width / 2));
		// diffText.x -= diffText.width / 2;
	}

	var _drawDistance:Int = 4;
	var _lastVisibles:Array<Int> = [];
	public function updateTexts(elapsed:Float = 0.0)
	{
		lerpSelected = FlxMath.lerp(curSelected, lerpSelected, Math.exp(-elapsed * 9.6));
		for (i in _lastVisibles)
		{
			grpSongs.members[i].visible = grpSongs.members[i].active = false;
			iconArray[i].visible = iconArray[i].active = false;
		}
		_lastVisibles = [];

		var min:Int = Math.round(Math.max(0, Math.min(songs.length, lerpSelected - _drawDistance)));
		var max:Int = Math.round(Math.max(0, Math.min(songs.length, lerpSelected + _drawDistance)));
		for (i in min...max)
		{
			var item:Alphabet = grpSongs.members[i];
			item.visible = item.active = true;
			item.x = ((item.targetY - lerpSelected) * item.distancePerItem.x) + item.startPosition.x;
			item.y = ((item.targetY - lerpSelected) * 1.3 * item.distancePerItem.y) + item.startPosition.y;

			var icon:HealthIcon = iconArray[i];
			icon.visible = icon.active = true;
			_lastVisibles.push(i);
		}
	}

	override function destroy():Void
	{
		super.destroy();

		FlxG.autoPause = ClientPrefs.data.autoPause;
		if (!FlxG.sound.music.playing)
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
	}	
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var color:Int = -7179779;
	public var folder:String = "";
	public var lastDifficulty:String = null;

	public function new(song:String, week:Int, songCharacter:String, color:Int)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.color = color;
		this.folder = Mods.currentModDirectory;
		if(this.folder == null) this.folder = '';
	}
}