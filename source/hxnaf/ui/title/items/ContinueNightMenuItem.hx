package hxnaf.ui.title.items;

import flixel.text.FlxBitmapFont;
import flixel.text.FlxBitmapText;

class ContinueNightMenuItem extends BaseMenuItem
{
  var nightText:FlxBitmapText;
  var numberText:FlxBitmapText;

  public function new()
  {
    super('continue', 'Continue');

    var consolasFont:FlxBitmapFont = FlxBitmapFont.fromAngelCode('assets/images/mainmenu/texts/consolas.png', 'assets/images/mainmenu/texts/consolas.fnt');
    var numberFont:FlxBitmapFont = FlxBitmapFont.fromAngelCode('assets/images/numbers/PIXEL_NUMBER.png', 'assets/images/numbers/PIXEL_NUMBER.fnt');

    nightText = new FlxBitmapText(0, 0, 'Night', consolasFont);
    nightText.scale.set(28 / consolasFont.size, 28 / consolasFont.size);
    nightText.updateHitbox();

    numberText = new FlxBitmapText(0, 0, '1', numberFont);
    numberText.scale.set(17 / numberFont.size, 17 / numberFont.size);
    numberText.updateHitbox();

    for (sprite in [nightText, numberText]) sprite.visible = false;
  }

  override public function draw():Void
  {
    nightText.setPosition(this.x + 5, this.y + 43);
    numberText.setPosition(nightText.x + nightText.width + 10, nightText.y + 7);

    nightText.scrollFactor.copyFrom(this.scrollFactor);
    nightText.cameras = this.cameras;
    numberText.scrollFactor.copyFrom(this.scrollFactor);
    numberText.cameras = this.cameras;

    for (sprite in [nightText, numberText])
    {
      if (sprite.visible) sprite.draw();
    }

    super.draw();
  }

  override public function confirm():Void
  {
    trace('TODO');
  }

  override function set_selected(value:Bool):Bool
  {
    selected = value;
    for (sprite in [nightText, numberText]) sprite.visible = selected;
    return value;
  }
}
