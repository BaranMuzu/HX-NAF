package hxnaf.ui.menu;

import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.tweens.FlxTween;

class NewspaperSubState extends FlxSubState
{
  var NewspaperSprite:FlxSprite;
  var NewspaperTween:FlxTween;

  override public function create()
  {
    NewspaperSprite = new FlxSprite(0, 0);
    NewspaperSprite.loadGraphic("assets/images/mainmenu/newspaper.png");
    add(NewspaperSprite);
    NewspaperSprite.alpha = 0;
    NewspaperTween = FlxTween.tween(NewspaperSprite, {alpha: 1}, 1);
    super.create();
  }

  override public function update(elapsed:Float)
  {
    super.update(elapsed);
  }
}
