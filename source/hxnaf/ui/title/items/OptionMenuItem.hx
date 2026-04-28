package hxnaf.ui.title.items;

import flixel.FlxSprite;
import flixel.text.FlxBitmapFont;
import flixel.text.FlxBitmapText;

class OptionMenuItem extends BaseMenuItem
{
  public var optionFont:FlxBitmapFont;

  public function new(id:String, text:String)
  {
    super(id, text);
    optionFont = FlxBitmapFont.fromAngelCode('assets/images/numbers/PIXEL_NUMBER.png', 'assets/images/numbers/PIXEL_NUMBER.fnt');
  }
}

class CheckboxOptionItem extends OptionMenuItem
{
  public var isChecked(default, set):Bool;

  var checkmark:FlxSprite;

  public function new(id:String, text:String, defaultValue:Bool = false)
  {
    super(id, text);

    checkmark = new FlxSprite();
    checkmark.loadGraphic('assets/images/mainmenu/options/checkmark.png');

    this.isChecked = defaultValue;
  }

  override public function draw():Void
  {
    checkmark.setPosition(this.x + this.width + 20, this.y + (this.height / 2) - (checkmark.height / 2));
    checkmark.scrollFactor.copyFrom(this.scrollFactor);
    checkmark.cameras = this.cameras;

    super.draw();
    if (isChecked) checkmark.draw();
  }

  override public function confirm():Void
  {
    isChecked = !isChecked;
    super.confirm();
  }

  function set_isChecked(value:Bool):Bool
  {
    return isChecked = value;
  }
}

class ValueOptionItem extends OptionMenuItem
{
  public var valueText:FlxBitmapText;
  public var options:Array<String>;
  public var currentIndex:Int = 0;

  public function new(id:String, text:String, options:Array<String>, defaultIndex:Int = 0)
  {
    super(id, text);
    this.options = options;
    this.currentIndex = defaultIndex;

    valueText = new FlxBitmapText(optionFont);
    valueText.text = options[currentIndex];
    valueText.scale.set(17 / optionFont.size, 17 / optionFont.size);
    valueText.updateHitbox();
  }

  override public function draw():Void
  {
    valueText.setPosition(this.x + this.width + 30, this.y + (this.height / 2) - (valueText.height / 2));
    valueText.scrollFactor.copyFrom(this.scrollFactor);
    valueText.cameras = this.cameras;

    super.draw();
    valueText.draw();
  }

  override public function confirm():Void
  {
    currentIndex = (currentIndex + 1) % options.length;
    valueText.text = options[currentIndex];
    valueText.updateHitbox();

    super.confirm();
  }
}
