package hxnaf;

import hxnaf.ui.WarningState;

class InitState extends FlxState
{
  override public function create():Void
  {
    super.create();

    DiscordUtil.initialize(); 
    DiscordUtil.changePresence("Entering", "Getting ready for Freddy");

    FlxG.switchState(() -> new WarningState());
  }
}
