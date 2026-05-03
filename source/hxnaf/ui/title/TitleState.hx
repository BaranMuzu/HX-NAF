package hxnaf.ui.title;

import hxnaf.ui.AdSubState;
import hxnaf.ui.option.OptionItemGroup;
import hxnaf.ui.option.items.OptionMenuItem.CheckboxOptionItem;
import hxnaf.ui.option.items.OptionMenuItem.NumberOptionItem;
import hxnaf.ui.option.items.OptionMenuItem.ValueOptionItem;
import hxnaf.ui.title.items.BaseMenuItem;
import hxnaf.ui.title.items.ContinueNightMenuItem;

class TitleState extends FlxState
{
  // UI
  public var titleChar:FlxSprite;
  public var menuStatic:FlxSprite;
  public var gameTitle:FlxSprite;
  public var selectArrow:FlxSprite;
  public var descText:FlxBitmapText;

  // ITEMS
  public var menuItems:MenuItemGroup;
  public var optionsGroup:OptionItemGroup;
  public var optionsButton:BaseMenuItem;
  public var backButton:BaseMenuItem;
  public var mainInteractables:Array<BaseMenuItem> = [];
  public var optionsInteractables:Array<BaseMenuItem> = [];

  // SYSTEM
  var ItemSelectSound:FlxSound = FlxG.sound.load('assets/sounds/blip3.ogg');
  var staticTimer:FlxTimer;
  var inOptionsMenu:Bool = false;

  var titleCharTweakTimer:FlxTimer;
  var titleCharAlphaTimer:FlxTimer;
  var titleCharCache:Map<String, FlxAtlasFrames> = new Map();
  var titleCharTweakFrames:Int = 0;

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

    // TODO ,add the actual settings
    var boolTest1 = new CheckboxOptionItem('boolTest', 'Evil Mode', 'Dexter 1', false);
    var valueTest1 = new NumberOptionItem('numTest', 'Volume', 'num test 1 haha', 0, 100, 50, 10);
    var valueTest2 = new ValueOptionItem('strTest', 'Evilness', 'wtf is this!!', ['Normal', 'Evil', 'TRUE EVIL'], 1);

    var optionItemList:Array<BaseMenuItem> = [boolTest1, valueTest1, valueTest2];
    for (setting in optionItemList)
    {
      optionsGroup.add(setting);
      optionsInteractables.push(setting);
    }
    add(optionsGroup);
    optionsGroup.visible = false;

    backButton = new BaseMenuItem('back', 'Back');
    backButton.setPosition(FlxG.width - backButton.width - 30, 30);
    backButton.setConfirmCallback(() -> toggleMenu(false));
    backButton.visible = false;
    add(backButton);
    optionsInteractables.push(backButton);
  }

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

    initMenuItems();
    initOptionItems();

    descText = new FlxBitmapText(0, FlxG.height - 150, "", consolasFont);
    descText.scale.set(30 / consolasFont.size, 30 / consolasFont.size);
    descText.updateHitbox();
    add(descText);
    descText.visible = false;

    selectArrow = new FlxSprite(100, 0);
    selectArrow.loadGraphic("assets/images/mainmenu/texts/SET_.png");
    selectArrow.visible = false;
    add(selectArrow);

    gameTitle = new FlxSprite(150, 80);
    gameTitle.loadGraphic("assets/images/mainmenu/texts/FIVE_GAME_TITLE.png");
    add(gameTitle);

    super.create();
    persistentUpdate = true;
  }

  function toggleMenu(showOptions:Bool):Void
  {
    inOptionsMenu = showOptions;

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
    descText.visible = inOptionsMenu;

    selectArrow.visible = false;
    descText.text = "";
  }

  override public function update(elapsed:Float)
  {
    super.update(elapsed);

    if (subState == null)
    {
      var curList = inOptionsMenu ? optionsInteractables : mainInteractables;

      if (FlxG.mouse.justMoved)
      {
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
            descText.text = curHover.description;
            descText.screenCenter(X);
          }
        }
        else
        {
          selectArrow.visible = false;
          if (inOptionsMenu) descText.text = "";
        }
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
}
