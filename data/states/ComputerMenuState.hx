import funkin.menus.ModSwitchMenu;
import funkin.menus.credits.CreditsMain;
import funkin.editors.EditorPicker;
import funkin.options.OptionsMenu;
import funkin.backend.utils.DiscordUtil;

var curSelected:Int = 0;

var bg:FlxSprite;
var camFollow:FlxObject;
var monitor:FlxSprite;
var screenbg:FlxSprite;
var screenGlow:FlxSprite;
var menuImagesGrp:FlxTypedGroup<FlxSprite>;
var selectedSomethin:Bool = false;

var menuItems:Array<String> = CoolUtil.coolTextFile(Paths.txt("config/menuItems"));

override function create()
{
    CoolUtil.playMenuSong();
	DiscordUtil.changePresence("explorer.exe", null);

    bg = new FlxSprite(0,0).loadGraphic(Paths.image('menus/computermenu/bg'));
    bg.screenCenter();
    bg.scale.set(0.75, 0.75);
    add(bg);

    screenbg = new FlxSprite(0,0).loadGraphic(Paths.image('menus/computermenu/blueBG'));
    screenbg.scale.set(0.75, 0.75);
    screenbg.screenCenter();
    add(screenbg);

    menuImagesGrp = new FlxTypedGroup<FlxSprite>();
    add(menuImagesGrp);

    var hiIAddX:Float = 0;
    var hiIAddY:Float = 0;
    for (i => item in menuItems)
    {
		var menu = new FunkinSprite().loadSprite(Paths.image("menus/computermenu/BUTTONS/windowsbuttons"));
        menu.addAnim(item, item + "0");
        menu.playAnim(item);
        menu.scale.set(0.75, 0.75);
        menu.updateHitbox();
        menu.screenCenter();
        
		menu.x += -164 + hiIAddX;
		menu.y += -46 + hiIAddY;

		hiIAddX += 317;
        if ((i + 1) % 2 == 0)
        {
            hiIAddX = 0;
            hiIAddY += 90;
        }

        menu.ID = i;
        menuImagesGrp.add(menu);
    }

    monitor = new FlxSprite(0,0).loadGraphic(Paths.image('menus/computermenu/monitor'));
    monitor.scale.set(0.75, 0.75);
    monitor.x = (FlxG.width / 2) - (monitor.width / 2);
    monitor.y = (FlxG.height / 2) - (monitor.height / 2);
    add(monitor);

    screenGlow = new FlxSprite(0,0).loadGraphic(Paths.image('menus/computermenu/blueBGglow'));
    screenGlow.x = (FlxG.width / 2) - (screenGlow.width / 2);
    screenGlow.y = (FlxG.height / 2) - (screenGlow.height / 2);
    screenGlow.scale.set(0.75, 0.75);
    add(screenGlow);
}

var selectedSomethin:Bool = false;
var mouseCurSelected:Int = 0;
var usingMouse:Bool = false;

var noSpam:String = "";
function betterTrace(msg:String)
{
    if (msg != noSpam)
        trace(noSpam = msg);
}

function update(e)
{
    if (!selectedSomethin)
    {
        if (controls.SWITCHMOD)
        {
            persistentUpdate = false;
            persistentDraw = true;
            openSubState(new ModSwitchMenu());
        }

        if (controls.DEV_ACCESS)
        {
            persistentUpdate = false;
            persistentDraw = true;
            openSubState(new EditorPicker());
        }

        if(controls.BACK)
        {
            selectedSomethin = true;
            FlxG.switchState(new TitleState());
        }

        var upP = controls.UP_P;
        var downP = controls.DOWN_P;
        var leftP = controls.LEFT_P;
        var rightP = controls.RIGHT_P;

        // mouse controls

		usingMouse = FlxG.mouse.pressed;
        
        if (usingMouse)
        {
            menuImagesGrp.forEach((item) -> {
                item.color = item.ID == mouseCurSelected ? 0xAAAAAAAA : 0xFFFFFFFF;

                if (FlxG.mouse.overlaps(item))
                {
                    mouseCurSelected = curSelected = item.ID;

                    if (FlxG.mouse.justPressed)
						select(menuItems[curSelected]);
                }
            });
        }
        else if (upP || downP || leftP || rightP)
        {
            FlxG.sound.play(Paths.sound('menu/scroll'));
            buttonThingy(upP, downP, leftP, rightP);
        }

		betterTrace("MODE: " + (usingMouse ? "MOUSE" : "KEYBOARD"));

        if(controls.ACCEPT)
        {
            selectedSomethin = true;
            select(menuItems[curSelected], true);
        }
    }
}

function select(itemID:Int, ?snd:Bool)
{
	if (snd)
		FlxG.sound.play(Paths.sound('menu/confirm'));

	var state = switch (menuItems[curSelected])
    {
		case "story": new StoryMenuState();
		case "freeplay": new FreeplayState();
		case "options": new OptionsMenu();
		case "credits": new CreditsMain();
	};

    FlxG.switchState(state);
}

function buttonThingy(?up:Bool, ?down:Bool, ?left:Bool, ?right:Bool)
{
	// trace(curSelected, mouseCurSelected);
    trace(up, down, left, right);

    if (up || down)
    {
        curSelected += (up ? -2 : 2);

        if ((up ? (curSelected < 0) : (curSelected > menuItems.length - 1)))
            curSelected += (up ? 2 : -2);
    }

    if (left || right)
    {
        curSelected += (left ? -1 : 1);

        if (curSelected == (left ? -1 : 2))
            curSelected += (left ? 1 : -1);
        else if (curSelected == (left ? 1 : 4))
			curSelected += (left ? 1 : -1);
    }

    for (m in menuImagesGrp)
        m.color = m.ID == curSelected ? 0xAAAAAAAA : 0xFFFFFFFF;
}