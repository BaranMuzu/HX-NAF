package hxnaf;

import hxnaf.ui.WarningState;

class InitState extends FlxState
{
  override public function create():Void
  {
    super.create();

    #if cpp
    DiscordUtil.initialize();
    DiscordUtil.changePresence("Test 1", "Getting ready for Freddy");
    #end

    FlxG.switchState(() -> new WarningState());
  }
}
