package;

import flixel.FlxGame;
import hxnaf.InitState;
import hxnaf.ui.StatsPerformance;
import openfl.display.Sprite;

class Main extends Sprite
{
  public function new()
  {
    super();

    var game:FlxGame = new FlxGame(0, 0, InitState, 0, 0, true);
    addChild(game);

    var stats:StatsPerformance = new StatsPerformance(10, 10);
    addChild(stats);
  }
}
