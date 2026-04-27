package hxnaf.ui;

class AdSubState extends FlxSubState
{
  var newspaper:FlxSprite;
  var tween:FlxTween;

  override public function create():Void
  {
    newspaper = new FlxSprite(0, 0);
    newspaper.loadGraphic("assets/images/mainmenu/newspaper.png");
    newspaper.alpha = 0;
    add(newspaper);

    tween = FlxTween.tween(newspaper, {alpha: 1}, 1);
    super.create();
  }

  override public function update(elapsed:Float):Void
  {
    super.update(elapsed);
  }
}
