package hxnaf.ui.title;

import flixel.graphics.frames.FlxAtlasFrames;
import hxnaf.ui.AdSubState;
import hxnaf.ui.title.items.BaseMenuItem;
import hxnaf.ui.title.items.ContinueNightMenuItem;

class TitleState extends FlxState
{
  public function createMenuItems():Void
  {
    menuItems.add(new BaseMenuItem('newGame', 'NEW_GAME').setConfirmCallback(() -> openSubState(new AdSubState())));
    menuItems.add(new ContinueNightMenuItem());
    menuItems.add(new BaseMenuItem('sixthNight', 'SIXTH_NIGHT'));
    menuItems.add(new BaseMenuItem('customNight', 'CUSTOM_NIGHT'));
  }

  public var menuItems:MenuItemGroup;
  public var freddy:FlxSprite;
  public var selectArrow:FlxSprite;

  var ItemSelectSound:FlxSound = FlxG.sound.load('assets/sounds/blip3.ogg');

  var freddyTweakTimer:FlxTimer;
  var freddyAlphaTimer:FlxTimer;
  var staticTimer:FlxTimer;

  override public function create():Void
  {
    if (FlxG.sound.music == null)
    {
      FlxG.sound.playMusic("assets/music/darknessmusic.ogg", 1, true);
    }

    freddy = new FlxSprite(0, 0);
    freddy.frames = FlxAtlasFrames.fromSparrow("assets/images/mainmenu/freddy.png", "assets/images/mainmenu/freddy.xml");
    freddy.animation.add('idle', [0]);
    freddy.animation.add('random', [1, 2, 3]);
    freddy.animation.play('idle', true);
    add(freddy);

    freddyAlphaTimer = new FlxTimer();
    freddyAlphaTimer.start(0.3, (_) ->
    {
      final alpha:Int = ClickteamUtil.exprRandom(250);
      freddy.alpha = ClickteamUtil.getAlpha(alpha);
    }, 0);

    freddyTweakTimer = new FlxTimer();
    freddyTweakTimer.start(0.08, (_) ->
    {
      // `-1` makes it use a random frame!
      final animName:String = FlxG.random.bool(3) ? 'random' : 'idle';
      freddy.animation.play(animName, true, false, -1);
    }, 0);

    var menuStatic:FlxSprite = new FlxSprite(0, 0);
    menuStatic.frames = FlxAtlasFrames.fromSparrow("assets/images/mainmenu/menu_static.png", "assets/images/mainmenu/menu_static.xml");
    menuStatic.animation.addByPrefix("static", "static", 30, true);
    menuStatic.animation.play("static");
    add(menuStatic);

    staticTimer = new FlxTimer();
    staticTimer.start(0.09, (_) ->
    {
      final alpha:Int = 50 + ClickteamUtil.exprRandom(100);
      menuStatic.alpha = ClickteamUtil.getAlpha(alpha);
    }, 0);

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
        var wasSelected = sprite.selected;

        sprite.selected = FlxG.mouse.overlaps(sprite);

        if (sprite.selected)
        {
          selectedSprite = sprite;
          
          if (!wasSelected)
          {
            ItemSelectSound.play(true);
          }
        }
      }

      selectArrow.visible = selectedSprite != null;
      selectArrow.x = (selectedSprite?.x ?? 0) - 70;
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
