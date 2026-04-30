package hxnaf.ui.option;

import hxnaf.ui.option.OptionItemGroup;
import hxnaf.ui.option.items.OptionMenuItem.CheckboxOptionItem;
import hxnaf.ui.option.items.OptionMenuItem.NumberOptionItem;
import hxnaf.ui.option.items.OptionMenuItem.ValueOptionItem;
import hxnaf.ui.title.items.BaseMenuItem;

class OptionsSubState extends FlxSubState
{
  // TODO : MAKE THE DESIGN BETTER
  var selectArrow:FlxSprite;
  var optionGroup:OptionItemGroup;
  var optionItems:Array<BaseMenuItem> = [];
  var ItemSelectSound:FlxSound = FlxG.sound.load('assets/sounds/blip3.ogg');

  override public function create():Void
  {
    var blackBg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    blackBg.alpha = 0;
    add(blackBg);
    FlxTween.tween(blackBg, {alpha: 0.8}, 0.5);

    selectArrow = new FlxSprite(0, 0).loadGraphic("assets/images/mainmenu/texts/SET_.png");
    selectArrow.visible = false;
    add(selectArrow);

    optionGroup = new OptionItemGroup();

    var boolTest1 = new CheckboxOptionItem('boolTest', 'Evil Mode', false);
    var valueTest1 = new NumberOptionItem('numTest', 'Volume', 0, 100, 50, 10);
    var valueTest2 = new ValueOptionItem('strTest', 'Evilness', ['Normal', 'Evil', 'TRUE EVIL'], 1);

    var settingsList:Array<BaseMenuItem> = [boolTest1, valueTest1, valueTest2];

    for (setting in settingsList)
    {
      optionGroup.add(setting);
      optionItems.push(setting);
    }

    add(optionGroup);

    var closeButton = new BaseMenuItem('close', 'Close');
    closeButton.setPosition(FlxG.width - closeButton.width - 50, FlxG.height - 70);
    closeButton.setConfirmCallback(() -> close());
    add(closeButton);
    optionItems.push(closeButton);

    super.create();
  }

  override public function update(elapsed:Float):Void
  {
    super.update(elapsed);

    var currentHover:BaseMenuItem = null;

    for (item in optionItems)
    {
      var wasSelected = item.selected;
      item.selected = FlxG.mouse.overlaps(item);

      if (item.selected)
      {
        currentHover = item;

        if (!wasSelected)
        {
          ItemSelectSound.play(true);
        }
      }
    }

    if (currentHover != null)
    {
      selectArrow.visible = true;
      selectArrow.x = currentHover.x - 70;
      selectArrow.y = currentHover.y + 15;
    }
    else
    {
      selectArrow.visible = false;
    }

    if (FlxG.mouse.justPressed)
    {
      for (item in optionItems)
      {
        if (item.selected) item.confirm();
      }
    }
  }
}
