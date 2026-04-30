package hxnaf.ui.option.items;

import flixel.text.FlxBitmapFont;
import flixel.text.FlxBitmapText;
import hxnaf.ui.title.items.BaseMenuItem;

class OptionMenuItem extends BaseMenuItem
{
  public var optionFont:FlxBitmapFont;

  public function new(id:String, text:String)
  {
    super(id, text);
    optionFont = FlxBitmapFont.fromAngelCode('assets/images/mainmenu/texts/consolas.png', 'assets/images/mainmenu/texts/consolas.fnt');
  }
}

class CheckboxOptionItem extends OptionMenuItem
{
  public var isChecked(default, set):Bool;

  var stateText:FlxBitmapText;

  public function new(id:String, text:String, defaultValue:Bool = false)
  {
    super(id, text);
    this.isChecked = defaultValue;

    stateText = new FlxBitmapText(optionFont);
    stateText.text = isChecked ? "[X]" : "[ ]";
    stateText.updateHitbox();
  }

  override public function draw():Void
  {
    stateText.setPosition(this.x + 300, this.y + (this.height / 2) - (stateText.height / 2));
    stateText.scrollFactor.copyFrom(this.scrollFactor);
    stateText.cameras = this.cameras;

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
    if (isChecked == value) return isChecked;

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
  public var valueText:FlxBitmapText;
  public var options:Array<String>;
  public var curIndex:Int = 0;

  public function new(id:String, text:String, options:Array<String>, defaultIndex:Int = 0)
  {
    super(id, text);
    this.options = options;
    this.curIndex = defaultIndex;

    valueText = new FlxBitmapText(optionFont);
    valueText.text = options[curIndex];
    valueText.updateHitbox();
  }

  override public function draw():Void
  {
    valueText.setPosition(this.x + 300, this.y + (this.height / 2) - (valueText.height / 2));
    valueText.scrollFactor.copyFrom(this.scrollFactor);
    valueText.cameras = this.cameras;

    super.draw();
    valueText.draw();
  }

  override public function confirm():Void
  {
    curIndex = (curIndex + 1) % options.length;
    valueText.text = options[curIndex];
    valueText.updateHitbox();

    super.confirm();
  }
}

class NumberOptionItem extends OptionMenuItem
{
  public var curValue:Int;
  public var minValue:Int;
  public var maxValue:Int;
  public var step:Int;

  var valueText:FlxBitmapText;

  public function new(id:String, text:String, min:Int, max:Int, defaultValue:Int, step:Int = 1)
  {
    super(id, text);
    this.minValue = min;
    this.maxValue = max;
    this.curValue = defaultValue;
    this.step = step;

    valueText = new FlxBitmapText(optionFont);
    valueText.text = Std.string(curValue);
    valueText.updateHitbox();
  }

  override public function draw():Void
  {
    valueText.setPosition(this.x + 300, this.y + (this.height / 2) - (valueText.height / 2));
    valueText.scrollFactor.copyFrom(this.scrollFactor);
    valueText.cameras = this.cameras;

    super.draw();
    valueText.draw();
  }

  override public function confirm():Void
  {
    curValue += step;
    if (curValue > maxValue) curValue = minValue;

    valueText.text = Std.string(curValue);
    valueText.updateHitbox();

    super.confirm();
  }
}
