package hxnaf.ui.title;

import hxnaf.ui.AdSubState;
import hxnaf.ui.option.DescriptionToolTip;
import hxnaf.ui.option.OptionItemGroup;
import hxnaf.ui.option.items.CategoryOptionItem;
import hxnaf.ui.option.items.OptionMenuItem.CheckboxOptionItem;
import hxnaf.ui.option.items.OptionMenuItem.NumberOptionItem;
import hxnaf.ui.option.items.OptionMenuItem.ValueOptionItem;
import hxnaf.ui.option.items.OptionMenuItem;
import hxnaf.ui.title.items.BaseMenuItem;
import hxnaf.ui.title.items.ContinueNightMenuItem;

class TitleState extends FlxState
{
  /** til look i am trying to adapt your comment style :]-
   * UI & Visuals
   */
  public var titleChar:FlxSprite;

  public var menuStatic:FlxSprite;
  public var gameTitle:FlxSprite;
  public var selectArrow:FlxSprite;
  public var descToolTip:DescriptionToolTip;

  /**
   * Menus & Buttons
   */
  public var menuItems:MenuItemGroup;

  public var optionsGroup:OptionItemGroup;
  public var optionsButton:BaseMenuItem;
  public var backButton:BaseMenuItem;

  /**
   * Clickables (Mouse stuff)
   */
  public var mainInteractables:Array<BaseMenuItem> = [];

  public var optionsInteractables:Array<BaseMenuItem> = [];

  var rootOptionItems:Array<OptionMenuItem> = [];

  /**
   * Menu States (Where is the player?)
   */
  var inOptionsMenu:Bool = false;

  var inSubCategory:Bool = false;

  /**
   * Sounds
   */
  var ItemSelectSound:FlxSound = FlxG.sound.load('assets/sounds/blip3.ogg');

  /**
   * Timers & Background Magic
   */
  var staticTimer:FlxTimer;

  var titleCharTweakTimer:FlxTimer;
  var titleCharAlphaTimer:FlxTimer;
  var titleCharCache:Map<String, FlxAtlasFrames> = new Map();
  var titleCharTweakFrames:Int = 0;

  override public function create():Void
  {
    var consolasFont = FlxBitmapFont.fromAngelCode('assets/images/mainmenu/texts/consolas.png', 'assets/images/mainmenu/texts/consolas.fnt');

    if (FlxG.sound.music == null)
    {
      FlxG.sound.playMusic("assets/music/darknessmusic.ogg", 1, true);
    }

    var charsToCache:Array<String> = ['freddy', 'bonnie'];
    for (char in charsToCache)
    {
      var graphic = FlxG.bitmap.add('assets/images/mainmenu/${char}.png');
      graphic.persist = true;
      titleCharCache.set(char, FlxAtlasFrames.fromSparrow(graphic, 'assets/images/mainmenu/${char}.xml'));
    }

    titleChar = new FlxSprite(0, 0);
    add(titleChar);
    changeTitleChar('freddy');

    titleCharAlphaTimer = new FlxTimer();
    titleCharAlphaTimer.start(0.3, (_) ->
    {
      final alpha:Int = ClickteamUtil.exprRandom(250);
      titleChar.alpha = ClickteamUtil.getAlpha(alpha);
    }, 0);

    titleCharTweakTimer = new FlxTimer();
    titleCharTweakTimer.start(0.08, (_) ->
    {
      if (titleCharTweakFrames > 0)
      {
        titleCharTweakFrames--;
        titleChar.animation.play('random', true, false, -1);
      }
      else if (FlxG.random.bool(3))
      {
        titleCharTweakFrames = FlxG.random.int(2, 4);
        titleChar.animation.play('random', true, false, -1);
      }
      else
      {
        titleChar.animation.play('idle', true);
      }
    }, 0);

    menuStatic = new FlxSprite(0, 0);
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

    descToolTip = new DescriptionToolTip();
    add(descToolTip);

    selectArrow = new FlxSprite(100, 0);
    selectArrow.loadGraphic("assets/images/mainmenu/texts/SET_.png");
    selectArrow.visible = false;
    add(selectArrow);

    gameTitle = new FlxSprite(150, 80);
    gameTitle.loadGraphic("assets/images/mainmenu/texts/FIVE_GAME_TITLE.png");
    add(gameTitle);

    initMenuItems();
    initOptionItems();

    super.create();
    DiscordUtil.changePresence("Main Menu", "Ready for Freddy");
    persistentUpdate = true;
  }

  override public function update(elapsed:Float)
  {
    super.update(elapsed);

    if (subState == null)
    {
      var curList = inOptionsMenu ? optionsInteractables : mainInteractables;

      var curHover:Null<BaseMenuItem> = null;

      for (sprite in curList)
      {
        var wasSelected = sprite.selected;
        sprite.selected = FlxG.mouse.overlaps(sprite);

        if (sprite.selected)
        {
          curHover = sprite;
          if (!wasSelected) ItemSelectSound.play(true);
        }
      }

      if (curHover != null)
      {
        selectArrow.visible = true;
        selectArrow.x = curHover.x - 70;
        selectArrow.y = curHover.y + 15;

        if (inOptionsMenu)
        {
          descToolTip.updateText(curHover.description);
        }
      }
      else
      {
        selectArrow.visible = false;
        if (inOptionsMenu) descToolTip.updateText("");
      }

      if (FlxG.mouse.justPressed)
      {
        for (sprite in curList)
        {
          if (sprite.selected) sprite.confirm();
        }
      }
    }
  }

  public function initMenuItems():Void
  {
    menuItems = new MenuItemGroup(150, 400);

    menuItems.add(new BaseMenuItem('newGame', 'New Game').setConfirmCallback(() -> openSubState(new AdSubState())));
    menuItems.add(new ContinueNightMenuItem());
    menuItems.add(new BaseMenuItem('sixthNight', '6th Night'));
    menuItems.add(new BaseMenuItem('customNight', 'Custom Night'));
    add(menuItems);

    optionsButton = new BaseMenuItem('options', 'Options');
    optionsButton.setConfirmCallback(() -> toggleMenu(true));
    optionsButton.setPosition(FlxG.width - optionsButton.width - 30, 30);
    add(optionsButton);

    for (item in menuItems.members) mainInteractables.push(item);
    mainInteractables.push(optionsButton);
  }

  public function initOptionItems():Void
  {
    optionsGroup = new OptionItemGroup(150, 400);
    add(optionsGroup);
    optionsGroup.visible = false;
    /**
     * Visual Options
     */
    var fullscreen = new CheckboxOptionItem('fullscreen', 'Fullscreen', 'Toggle between windowed and fullscreen mode.', false);
    var staticInt = new NumberOptionItem('staticInt', 'Static Intensity', 'Adjust the level of static noise on the cameras.', 0, 100, 50, 1);
    var flashLights = new CheckboxOptionItem('flashLights', 'Flashing Lights', 'Enable or disable flashing light effects.', true);
    /**
     * Audio Options
     */
    var masterVol = new NumberOptionItem('masterVol', 'Master Volume', 'Adjust the overall game volume.', 0, 100, 80, 1);
    var jumpVol = new NumberOptionItem('jumpVol', 'Jumpscare Volume', 'Adjust the volume of jumpscare sound effects.', 0, 100, 100, 1);
    var ambVol = new NumberOptionItem('ambVol', 'Ambience Volume', 'Adjust the volume of background office ambience.', 0, 100, 60, 1);
    /**
     * Gameplay Options
     */
    var subs = new CheckboxOptionItem('subtitles', 'Subtitles', 'Show or hide subtitles for the dialogue.', true);
    var tips = new CheckboxOptionItem('tips', 'Death Tips', 'Show or hide helpful tips on the game over screen.', true);
    /**
     * Categories
     */
    var visualCat = new CategoryOptionItem('catVisual', 'Visuals', 'Graphics and visual effect settings.', [fullscreen, staticInt, flashLights]);
    var audioCat = new CategoryOptionItem('catAudio', 'Audio', 'Sound and music volume settings.', [masterVol, jumpVol, ambVol]);
    var gameplayCat = new CategoryOptionItem('catGame', 'Gameplay', 'General gameplay and accessibility settings.', [subs, tips]);
    /**
     * Callbacks
     */
    visualCat.setConfirmCallback(() -> loadOptionPage(visualCat.children));
    audioCat.setConfirmCallback(() -> loadOptionPage(audioCat.children));
    gameplayCat.setConfirmCallback(() -> loadOptionPage(gameplayCat.children));
    /**
     * Last Stuff
     */
    rootOptionItems = [visualCat, audioCat, gameplayCat];

    backButton = new BaseMenuItem('back', 'Back');
    backButton.setPosition(FlxG.width - backButton.width - 30, 30);
    backButton.setConfirmCallback(() -> handleBackButton());
    backButton.visible = false;
    add(backButton);

    loadOptionPage(rootOptionItems, true);
  }

  function toggleMenu(showOptions:Bool):Void
  {
    inOptionsMenu = showOptions;
    resetHover();

    if (inOptionsMenu)
    {
      changeTitleChar('bonnie');
    }
    else
    {
      changeTitleChar('freddy');
    }

    menuItems.visible = !inOptionsMenu;
    optionsButton.visible = !inOptionsMenu;

    optionsGroup.visible = inOptionsMenu;
    backButton.visible = inOptionsMenu;

    selectArrow.visible = false;

    if (!inOptionsMenu)
    {
      descToolTip.updateText("");
    }
  }

  function changeTitleChar(char:String):Void
  {
    if (!titleCharCache.exists(char))
    {
      var graphic = FlxG.bitmap.add('assets/images/mainmenu/${char}.png');
      graphic.persist = true;
      titleCharCache.set(char, FlxAtlasFrames.fromSparrow(graphic, 'assets/images/mainmenu/${char}.xml'));
    }

    titleChar.frames = titleCharCache.get(char);
    titleChar.animation.add('idle', [0]);
    titleChar.animation.add('random', [1, 2, 3]);
    titleChar.animation.play('idle', true);
  }

  function loadOptionPage(items:Array<OptionMenuItem>, isRoot:Bool = false):Void
  {
    inSubCategory = !isRoot;

    optionsGroup.clear();
    optionsInteractables = [];
    resetHover();

    for (item in items)
    {
      optionsGroup.add(item);
      optionsInteractables.push(item);

      item.visible = true;
      item.alpha = 1;
    }

    optionsInteractables.push(backButton);

    optionsGroup.arrangeItems();
  }

  function handleBackButton():Void
  {
    if (inSubCategory)
    {
      loadOptionPage(rootOptionItems, true);
    }
    else
    {
      toggleMenu(false);
    }
  }

  function resetHover():Void
  {
    for (item in mainInteractables) item.selected = false;
    for (item in optionsInteractables) item.selected = false;

    selectArrow.visible = false;
    descToolTip.updateText("");
  }
}
