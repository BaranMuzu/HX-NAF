package hxnaf;

import hxnaf.ui.menu.MenuState;
import flixel.FlxG;
import flixel.FlxState;

class InitState extends FlxState
{
  override public function create():Void
  {
    super.create();

    // Unlocked Framerate
    // TODO: move to an option later
    FlxG.updateFramerate = 0;
    FlxG.drawFramerate = 0;

    FlxG.switchState(() -> new MenuState());
  }
}
