package states;

import flixel.FlxObject;
import flixel.FlxG;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import states.editors.MasterEditorMenu;
import options.OptionsState;
import states.StoryMenuState;
import hxwindowmode.WindowColorMode;

import backend.WeekData;

import flixel.input.keyboard.FlxKey;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import haxe.Json;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

import shaders.ColorSwap;

enum ComputerColumn {
	LEFT;
	RIGHT;
}

typedef MenuData =
{
	var bpm:Float;
}

class ComputerMainMenuState extends MusicBeatState {
    public static var curColumn:ComputerColumn = LEFT;
    public static var curSelected:Int = 1;
    public static var initialized:Bool = false;

    var bg:FlxSprite;
    var camFollow:FlxObject;
    var monitor:FlxSprite;
    var screenbg:FlxSprite;
    var screenGlow:FlxSprite;
    var menuImages:FlxTypedGroup <FlxSprite>;
    var musicBPM:Float = 102;
    var selectedSomethin:Bool = false;

    var leftOption:String = #if ACHIEVEMENTS_ALLOWED 'achievements' #else null #end;
	var rightOption:String = 'options';

    var array:Array <String> = 
    [

        'storymode',
        'freeplay',
        'credits',
        'options'

    ];

    override function create() {
        super.create();

        DiscordClient.changePresence("In the Menus", null);

        WindowColorMode.setWindowBorderColor([255, 105, 180], true, true);

        bg = new FlxSprite(0,0).loadGraphic(Paths.image('computermenu/bg'));
        bg.x = (FlxG.width / 2) - (bg.width / 2);
        bg.y = (FlxG.height / 2) - (bg.height / 2);
        bg.scale.set(0.75, 0.75);
        add(bg);

        screenbg = new FlxSprite(0,0).loadGraphic(Paths.image('computermenu/blueBG'));
        screenbg.scale.set(0.75, 0.75);
        screenbg.x = (FlxG.width / 2) - (screenbg.width / 2);
        screenbg.y = (FlxG.height / 2) - (screenbg.height / 2);
        add(screenbg);

        menuImages = new FlxTypedGroup<FlxSprite>();
        add(menuImages);

        
        for (menuitem in 0...array.length) {
            var menu:FlxSprite = new FlxSprite(0,0, Paths.image('computermenu/BUTTONS/' + array[menuitem]));
            menu.scale.set(0.75, 0.75);
            menu.x = (FlxG.width / 2) - (menu.width / 2);
            menu.y = (FlxG.height / 2) - (menu.height / 2);
            menu.ID = menuitem;
            menuImages.add(menu);
        }

        monitor = new FlxSprite(0,0).loadGraphic(Paths.image('computermenu/monitor'));
        monitor.scale.set(0.75, 0.75);
        monitor.x = (FlxG.width / 2) - (monitor.width / 2);
        monitor.y = (FlxG.height / 2) - (monitor.height / 2);
        add(monitor);

        screenGlow = new FlxSprite(0,0).loadGraphic(Paths.image('computermenu/blueBGglow'));
        screenGlow.x = (FlxG.width / 2) - (screenGlow.width / 2);
        screenGlow.y = (FlxG.height / 2) - (screenGlow.height / 2);
        screenGlow.scale.set(0.75, 0.75);
        add(screenGlow);

        persistentUpdate = true;
		if (!initialized && FlxG.sound.music == null)
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 100);

		loadJsonData();
		#if TITLE_SCREEN_EASTER_EGG easterEggData(); #end
		Conductor.bpm = musicBPM;

    }

    function loadJsonData()
	{
		if(Paths.fileExists('images/gfDanceTitle.json', TEXT))
		{
			var titleRaw:String = Paths.getTextFromFile('images/gfDanceTitle.json');
			if(titleRaw != null && titleRaw.length > 0)
			{
				try
				{
					var titleJSON:MenuData = tjson.TJSON.parse(titleRaw);
					musicBPM = titleJSON.bpm;
				}
				catch(e:haxe.Exception)
				{
					trace('[WARN] Title JSON might broken, ignoring issue...\n${e.details()}');
				}
			}
			else trace('[WARN] No Title JSON detected, using default values.');
		}
		//else trace('[WARN] No Title JSON detected, using default values.');
	}

    function ButtonThingy() {

        for(menuitem in menuImages){

            if(menuitem.ID == curSelected) {

                menuitem.color = 0xAAAAAAAA;

            } else {

                menuitem.color = 0xFFFFFFFF;

            }

        }

    }


    override function update(elapsed:Float)
	{
        if(!selectedSomethin){
        	
            if(controls.UI_DOWN_P){
            		
            		FlxG.sound.play(Paths.sound('scrollMenu'));
            		curSelected ++;
                    curSelected ++;
            		if(curSelected > 3) {
                        trace("more than 3");
                        curSelected --;
                        curSelected --;
                    }
                    trace(curSelected);
            		ButtonThingy();
        	} if(controls.UI_UP_P){

            		FlxG.sound.play(Paths.sound('scrollMenu'));
            		curSelected --;
                    curSelected --;
            		if(curSelected < 0) {
                        trace("less than 0");
                        curSelected ++;
                        curSelected ++;
                    }
                    trace(curSelected);
            		ButtonThingy();

        	} if (controls.UI_LEFT_P) {
                     FlxG.sound.play(Paths.sound('scrollMenu'));
            		curSelected --;
            		if(curSelected == -1) {
                        trace("less than 0");
                        curSelected ++;
                    }
                    else if(curSelected == 1) {
                        trace("less than 2");
                        curSelected ++;
                    }
            		trace(curSelected);
                    ButtonThingy();

            } if (controls.UI_RIGHT_P) {
                     FlxG.sound.play(Paths.sound('scrollMenu'));
            		curSelected ++;
            		if(curSelected == 2) { 
                        trace("more than 1");
                        curSelected --;
                    }
                    else if(curSelected == 4) {
                        trace("more than 3");
                        curSelected --;
                    }
                    trace(curSelected);
            		ButtonThingy();

            } if(controls.ACCEPT){

            	selectedSomethin = true;
            	switch(curSelected){

                	case 0:

                	    FlxG.sound.play(Paths.sound('confirmMenu'));
                        MusicBeatState.switchState(new states.StoryMenuState());

                	case 1:

                    	if (StoryMenuState.weekCompleted.exists("k1-KINITOPET") && StoryMenuState.weekCompleted.get("k1-KINITOPET")) {

                            FlxG.sound.play(Paths.sound('confirmMenu'));
                            MusicBeatState.switchState(new states.FreeplayState());

                        } else {
                            
                            FlxG.camera.shake(0.025, 0.5, null, true);
                            selectedSomethin = false;

                        }

            	    case 2:

                	    FlxG.sound.play(Paths.sound('confirmMenu'));
                        MusicBeatState.switchState(new states.CreditsState());

            	    case 3:
                    	
                        FlxG.sound.play(Paths.sound('confirmMenu'));
                        MusicBeatState.switchState(new options.OptionsState());

            	}

       		} if (controls.justPressed('debug_1')) {
			
                selectedSomethin = true;
			    FlxG.mouse.visible = false;	
                MusicBeatState.switchState(new MasterEditorMenu());
        	}
	    }
	    super.update(elapsed);
    }
}