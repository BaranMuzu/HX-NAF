package hxnaf.ui.menu.items;

import flixel.FlxSprite;

class ContinueNightMenuItem extends BaseMenuItem
{
  var nightText:FlxSprite;
  var numberText:FlxSprite;

  public function new()
  {
    super('continue', 'CONTINUE');

    nightText = new FlxSprite();
    nightText.loadGraphic('assets/images/mainmenu/texts/Night.png');

    // TODO: keep track of nights
    numberText = new FlxSprite();
    numberText.loadGraphic('assets/images/numbers/PIXEL_NUMBER/1.png');
    numberText.setGraphicSize(17, 17);
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
