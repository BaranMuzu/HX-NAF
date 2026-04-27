package hxnaf.ui.menu;

import hxnaf.ui.menu.items.ContinueNightMenuItem;
import hxnaf.ui.menu.items.BaseMenuItem;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.sound.FlxSound;
import flixel.util.FlxTimer;
import lime.app.Application;
import openfl.display.BlendMode;
import hxnaf.ui.menu.NewspaperSubState;

class MenuState extends FlxState
{
  public function createMenuItems():Void
  {
    menuItems.add(new BaseMenuItem('newGame', 'NEW_GAME').setConfirmCallback(() -> openSubState(new NewspaperSubState())));
    menuItems.add(new ContinueNightMenuItem());
    menuItems.add(new BaseMenuItem('sixthNight', 'SIXTH_NIGHT'));
    menuItems.add(new BaseMenuItem('customNight', 'CUSTOM_NIGHT'));
  }

  public var menuItems:MenuItemGroup;
  public var freddy:FlxSprite;
  public var selectArrow:FlxSprite;

  var freddyTweakTimer:FlxTimer;
  var freddyAlphaTimer:FlxTimer;
  var staticTimer:FlxTimer;

  override public function create():Void
  {
    if (FlxG.sound.music == null)
    {
      FlxG.sound.playMusic("assets/music/darknessmusic.wav", 1, true);
    }

    freddy = new FlxSprite(0, 0);
    freddy.frames = FlxAtlasFrames.fromSparrow("assets/images/mainmenu/freddy.png", "assets/images/mainmenu/freddy.xml");
    freddy.animation.frameIndex = 0;
    add(freddy);

    freddyAlphaTimer = new FlxTimer();
    freddyAlphaTimer.start(0, (tmr:FlxTimer) ->
    {
      freddy.alpha = FlxG.random.float(0.5, 1);
      tmr.reset(FlxG.random.float(0.2, 1));
    });

    freddyTweakTimer = new FlxTimer();
    freddyTweakTimer.start(0, (tmr:FlxTimer) ->
    {
      // TODO
      tmr.reset(1);
    });

    var menuStatic:FlxSprite = new FlxSprite(0, 0);
    menuStatic.frames = FlxAtlasFrames.fromSparrow("assets/images/mainmenu/menu_static.png", "assets/images/mainmenu/menu_static.xml");
    menuStatic.animation.addByPrefix("static", "static", 30, true);
    menuStatic.animation.play("static");
    add(menuStatic);

    staticTimer = new FlxTimer();
    staticTimer.start(0, (tmr:FlxTimer) ->
    {
      menuStatic.alpha = FlxG.random.float(0.3, 0.5);
      tmr.reset(FlxG.random.float(0.1, 0.3));
    });

    menuItems = new MenuItemGroup(150, 400);
    createMenuItems();
    add(menuItems);

    selectArrow = new FlxSprite(100, 0);
    selectArrow.loadGraphic("assets/images/mainmenu/texts/SET_.png");
    selectArrow.visible = false;
    add(selectArrow);

    var gameTitle:FlxSprite = new FlxSprite(150, 80);
    gameTitle.loadGraphic("assets/images/mainmenu/texts/FIVE_GAME_TITLE.png");
    add(gameTitle);

    super.create();
  }

  override public function update(elapsed:Float)
  {
    super.update(elapsed);

    // controller support?
    if (FlxG.mouse.justMoved)
    {
      var selectedSprite:Null<BaseMenuItem> = null;
      for (sprite in menuItems.members)
      {
        sprite.selected = FlxG.mouse.overlaps(sprite);
        if (sprite.selected) selectedSprite = sprite;
      }

      selectArrow.visible = selectedSprite != null;
      selectArrow.x = (selectedSprite?.x ?? 0) - 50;
      selectArrow.y = (selectedSprite?.y ?? 0) + 5;
    }

    if (FlxG.mouse.justPressed)
    {
      for (sprite in menuItems.members)
      {
        if (sprite.selected) sprite.confirm();
      }
    }
  }
}
