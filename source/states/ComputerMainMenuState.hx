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
    var bg:FlxSprite;
    var camFollow:FlxObject;
    var monitor:FlxSprite;
    var screenbg:FlxSprite;
    var screenGlow:FlxSprite;
    var freeplay:FlxText;
    var story:FlxSprite;
    var options:FlxSprite;
    var credits:FlxSprite;
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

}