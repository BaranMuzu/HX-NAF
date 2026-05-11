package hxnaf;

import hxnaf.ui.WarningState;

class InitState extends FlxState
{
  override public function create():Void
  {
    super.create();
    FlxG.switchState(() -> new WarningState());
  }
}
