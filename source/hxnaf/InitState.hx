package hxnaf;

import flixel.FlxG;
import flixel.FlxState;
import flixel.system.FlxSplash;
import flixel.util.typeLimit.NextState;
import hxnaf.ui.title.TitleState;

class InitState extends FlxState
{
  override public function create():Void
  {
    super.create();

    FlxG.switchState(() ->
    {
      var title:NextState = () -> new TitleState();
      return new FlxSplash(title);
    });
  }
}
