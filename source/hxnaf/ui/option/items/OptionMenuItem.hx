package hxnaf.ui.option.items;

import flixel.text.FlxBitmapFont;
import flixel.text.FlxBitmapText;
import hxnaf.ui.title.items.BaseMenuItem;

class OptionMenuItem extends BaseMenuItem
{
  public var optionFont:FlxBitmapFont;

  public function new(id:String, text:String, description:String = "")
  {
    super(id, text);
    this.description = description;
    optionFont = FlxBitmapFont.fromAngelCode('assets/images/mainmenu/texts/consolas.png', 'assets/images/mainmenu/texts/consolas.fnt');
  }

  function alignItem(valueLabel:FlxBitmapText):Void
  {
    valueLabel.x = this.x + this.width + 40;
    valueLabel.y = this.y + (this.height / 2) - (valueLabel.height / 2);
  }
}

class CheckboxOptionItem extends OptionMenuItem
{
  public var isChecked(default, set):Bool;

  var stateText:FlxBitmapText;

  public function new(id:String, text:String, description:String = "", defaultValue:Bool = false)
  {
    super(id, text, description);
    stateText = new FlxBitmapText(optionFont);
    this.isChecked = defaultValue;
  }

  override public function update(elapsed:Float):Void
  {
    super.update(elapsed);
    if (selected && FlxG.mouse.wheel != 0) isChecked = !isChecked;
  }

  override public function draw():Void
  {
    alignItem(stateText);
    super.draw();
    stateText.draw();
  }

  override public function confirm():Void
  {
    isChecked = !isChecked;
    super.confirm();
  }

  function set_isChecked(value:Bool):Bool
  {
    isChecked = value;
    if (stateText != null)
    {
      stateText.text = isChecked ? "[X]" : "[ ]";
      stateText.updateHitbox();
    }
    return isChecked;
  }
}

class ValueOptionItem extends OptionMenuItem
{
  public var options:Array<String>;
  public var curIndex:Int = 0;

  var valueText:FlxBitmapText;

  public function new(id:String, text:String, description:String = "", options:Array<String>, defaultIndex:Int = 0)
  {
    super(id, text, description);
    this.options = options;
    this.curIndex = defaultIndex;

    valueText = new FlxBitmapText(optionFont);
    updateDisplay();
  }

  override public function update(elapsed:Float):Void
  {
    super.update(elapsed);

    if (selected && FlxG.mouse.wheel != 0)
    {
      changeIndex(FlxG.mouse.wheel > 0 ? -1 : 1);
    }
  }

  override public function draw():Void
  {
    alignItem(valueText);
    super.draw();
    valueText.draw();
  }

  override public function confirm():Void
  {
    changeIndex(1);
    super.confirm();
  }

  function changeIndex(dir:Int):Void
  {
    curIndex += dir;
    if (curIndex >= options.length) curIndex = 0;
    if (curIndex < 0) curIndex = options.length - 1;
    updateDisplay();
  }

  function updateDisplay():Void
  {
    valueText.text = options[curIndex];
    valueText.updateHitbox();
  }
}

class NumberOptionItem extends OptionMenuItem
{
  public var curValue:Int;
  public var minValue:Int;
  public var maxValue:Int;
  public var step:Int;

  var valueText:FlxBitmapText;

  public function new(id:String, text:String, description:String = "", min:Int, max:Int, defaultValue:Int, step:Int = 1)
  {
    super(id, text, description);
    this.minValue = min;
    this.maxValue = max;
    this.curValue = defaultValue;
    this.step = step;

    valueText = new FlxBitmapText(optionFont);
    updateDisplay();
  }

  override public function update(elapsed:Float):Void
  {
    super.update(elapsed);

    if (selected && FlxG.mouse.wheel != 0)
    {
      changeValue(FlxG.mouse.wheel > 0 ? step : -step);
    }
  }

  override public function draw():Void
  {
    alignItem(valueText);
    super.draw();
    valueText.draw();
  }

  override public function confirm():Void
  {
    changeValue(step);
    super.confirm();
  }

  function changeValue(dir:Int):Void
  {
    curValue += dir;

    if (curValue > maxValue) curValue = maxValue;
    if (curValue < minValue) curValue = minValue;

    updateDisplay();
  }

  function updateDisplay():Void
  {
    valueText.text = Std.string(curValue);
    valueText.updateHitbox();
  }
}
