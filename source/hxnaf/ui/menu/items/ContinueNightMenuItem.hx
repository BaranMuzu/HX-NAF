package hxnaf.ui.menu.items;

import flixel.text.FlxBitmapFont;
import flixel.text.FlxBitmapText;
import flixel.FlxSprite;

class ContinueNightMenuItem extends BaseMenuItem
{
  var nightText:FlxSprite;
  var numberText:FlxBitmapText;

  public function new()
  {
    super('continue', 'CONTINUE');

    nightText = new FlxSprite();
    nightText.loadGraphic('assets/images/mainmenu/texts/Night.png');

    // TODO: keep track of nights
    var numberFont:FlxBitmapFont = FlxBitmapFont.fromAngelCode('assets/images/numbers/PIXEL_NUMBER.png', 'assets/images/numbers/PIXEL_NUMBER.fnt');
    numberText = new FlxBitmapText(0, 0, '1', numberFont);
    numberText.scale.set(17 / numberFont.size, 17 / numberFont.size);
    numberText.updateHitbox();

    for (sprite in [nightText, numberText]) sprite.visible = false;
  }

  override public function draw():Void
  {
    nightText.setPosition(this.x, this.y + 38);
    numberText.setPosition(nightText.x + 75, nightText.y + 1.5);

    for (sprite in [nightText, numberText])
    {
      if (sprite.visible) sprite.draw();
    }

    super.draw();
  }

  override public function confirm():Void
  {
    // TODO: implement
    trace('TODO');
  }

  override function set_selected(value:Bool):Bool
  {
    selected = value;
    for (sprite in [nightText, numberText]) sprite.visible = selected;
    return value;
  }

  override function get_height():Float
  {
    return height + nightText.height;
  }
}
