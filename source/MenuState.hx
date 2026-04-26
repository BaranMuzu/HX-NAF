import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.sound.FlxSound;
import flixel.util.FlxTimer;
import lime.app.Application;
import openfl.display.BlendMode;
import substates.Newspaper;

class MenuState extends FlxState
{
    // Variables
    var selectedInt:Int = 1;
    var titleClick:Int = 0;
    var evilxel:Bool = false;
    var nightNumber:Int = 1;
    var charmenu:String = "freddy";

    // Sprites
    var menuStatic:FlxSprite;
    var gameTitle:FlxSprite;
    var credits:FlxSprite;
    var newGame:FlxSprite;
    var continueNight:FlxSprite;
    var sixthNight:FlxSprite;
    var customNight:FlxSprite;
    var freddy:FlxSprite;
    var selectArrow:FlxSprite;
    var fiveHitbox:FlxSprite;
    
    var night:FlxSprite;
    var nighttext:FlxSprite;

    var flipsound:FlxSound;

    override public function create()
	{
        if (FlxG.sound.music == null)
        {
            FlxG.sound.playMusic("assets/music/darknessmusic.wav", 1, true);
        }
        flipsound = FlxG.sound.load("assets/sounds/blip3.wav");

        freddy = new FlxSprite(0, 0);
        freddy.loadGraphic("assets/images/mainmenu/freddy/1.png");
        add(freddy);

        new FlxTimer().start(0.2, function(freddything:FlxTimer) {
            freddy.alpha = FlxG.random.float(0.5, 1);
            
            freddything.reset(FlxG.random.float(0.2, 1)); 
        }, 0);

        menuStatic = new FlxSprite(0, 0);
		var staticFrame = FlxAtlasFrames.fromSparrow("assets/images/mainmenu/menu_static.png", "assets/images/mainmenu/menu_static.xml");
		menuStatic.frames = staticFrame;
		menuStatic.animation.addByPrefix("static", "static", 30, true);
		menuStatic.alpha = 0.35; 
		menuStatic.scrollFactor.set(0, 0);
		menuStatic.animation.play("static");
		add(menuStatic);

        new FlxTimer().start(0.2, function(staticthing:FlxTimer) {
            menuStatic.alpha = FlxG.random.float(0.3, 0.5);
            
            staticthing.reset(FlxG.random.float(0.1, 0.3)); 
        }, 0);

        gameTitle = new FlxSprite(150, 80);
        gameTitle.loadGraphic("assets/images/mainmenu/texts/FIVE_GAME_TITLE.png");
        add(gameTitle);

        newGame = new FlxSprite(150, 400);
        newGame.loadGraphic("assets/images/mainmenu/texts/NEW_GAME.png");
        add(newGame);

        continueNight = new FlxSprite(150, 470);
        continueNight.loadGraphic("assets/images/mainmenu/texts/CONTINUE.png");
        add(continueNight);

        night = new FlxSprite(150, 508);
        night.loadGraphic("assets/images/mainmenu/texts/Night.png");
        night.visible = false;
        add(night);

        nighttext = new FlxSprite(225, 509.5);
        nighttext.loadGraphic("assets/images/numbers/PIXEL_NUMBER/" + nightNumber + ".png");
        nighttext.blend = BlendMode.ADD;
        nighttext.setGraphicSize(17,17);
        nighttext.updateHitbox();
        nighttext.visible = false;
        add(nighttext);

        sixthNight = new FlxSprite(150, 540);
        sixthNight.loadGraphic("assets/images/mainmenu/texts/SIXTH_NIGHT.png");
        add(sixthNight);
        
        customNight = new FlxSprite(150, 610);
        customNight.loadGraphic("assets/images/mainmenu/texts/CUSTOM_NIGHT.png");
        add(customNight);

        selectArrow = new FlxSprite(100, 400 + 5);
        selectArrow.loadGraphic("assets/images/mainmenu/texts/SET_.png");
        selectArrow.visible = false;
        add(selectArrow);

        fiveHitbox = new FlxSprite(150,80);
        fiveHitbox.makeGraphic(100, 50, 0x00000000);
        add(fiveHitbox);

        credits = new FlxSprite(1050, 700);
        credits.loadGraphic("assets/images/mainmenu/texts/CREDIT.png");
        add(credits);

		super.create();
	}

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        var lastSelected:Int = selectedInt;

        if (FlxG.mouse.overlaps(continueNight))
        {
            selectArrow.y = continueNight.y + 5;
            selectedInt = 2;
            selectArrow.visible = true;

            if (!night.visible)
            {
                night.visible = true;
                nighttext.visible = true;
                
                nighttext.loadGraphic("assets/images/numbers/PIXEL_NUMBER/" + nightNumber + ".png");
                nighttext.setGraphicSize(17,17);
                nighttext.updateHitbox();
            }
        }
        else if (FlxG.mouse.overlaps(newGame))
        {
            selectArrow.y = newGame.y + 5;
            selectedInt = 1;
            selectArrow.visible = true;
            if (night.visible) {
                night.visible = false;
                nighttext.visible = false;
            }
        }
        else if (FlxG.mouse.overlaps(sixthNight))
        {
            selectArrow.y = sixthNight.y + 5;
            selectedInt = 3;
            selectArrow.visible = true;
            if (night.visible) {
                night.visible = false;
                nighttext.visible = false;
            }
        }
        else if (FlxG.mouse.overlaps(customNight))
        {
            selectArrow.y = customNight.y + 5;
            selectedInt = 4;
            selectArrow.visible = true;
            if (night.visible) {
                night.visible = false;
                nighttext.visible = false;
            }
        }
        else if (FlxG.mouse.overlaps(fiveHitbox))
        {
            selectArrow.y = 80 + 5;
            selectedInt = 5;
            selectArrow.visible = true;
            if (night.visible) {
                night.visible = false;
                nighttext.visible = false;
            }
        }
        else 
        {
            selectedInt = 0; 
            selectArrow.visible = false;
            if (night.visible) {
                night.visible = false;
                nighttext.visible = false;
            }
        }
        if (selectedInt != lastSelected && selectedInt != 0)
        {
            flipsound.play(true);
        }

        if (FlxG.mouse.justPressed) 
        {
            if (FlxG.mouse.overlaps(newGame))
                clickPlay();
            
            if (FlxG.mouse.overlaps(fiveHitbox))
            {
                titleClick++;
                flipsound.play(true);
                if (!evilxel)
                    gameTitle.loadGraphic("assets/images/mainmenu/texts/ONE_GAME_TITLE.png");
                
                if (titleClick == 69)
                {
                    evilxel = true;
                    FlxG.sound.play("flixel/sounds/beep.ogg");
                    gameTitle.loadGraphic("assets/images/mainmenu/texts/FLIXEL_GAME_TITLE.png");
                    freddy.loadGraphic("assets/images/mainmenu/hxnaf.png");
                    charmenu = "haxeflixel";
                    Application.current.window.title = "HaxeFlixel Nights At Freddy's";
                }
            }
        }
    }

    function clickPlay()
    {
        openSubState(new Newspaper());
    }
}