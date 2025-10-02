package states;

import flixel.FlxObject;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import states.editors.MasterEditorMenu;
import options.OptionsState;

enum ComputerColumn {
	LEFT;
	RIGHT;
}

class ComputerMainMenuState extends MusicBeatState {
    public static var curColumn:ComputerColumn = LEFT;
    public static var curSelected:Int = 0;

    var bg:FlxSprite;
    var camFollow:FlxObject;
    var monitor:FlxSprite;
    var screenbg:FlxSprite;
    var screenGlow:FlxSprite;
    var menuImages:FlxTypedGroup <FlxSprite>;

    var leftOption:String = #if ACHIEVEMENTS_ALLOWED 'achievements' #else null #end;
	var rightOption:String = 'options';

    var array:Array <String> = 
    [

        'storymode',
        'freeplay',
        'options',
        'credits'

    ];

    override function create() {
        super.create();

        DiscordClient.changePresence("In the Menus", null);
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


    }
    override function update(elapsed:Float)
	{


    }
}