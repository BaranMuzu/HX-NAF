package;

import flixel.FlxGame;
import hxnaf.InitState;
import openfl.display.Sprite;

class Main extends Sprite
{
  public function new()
  {
    super();

    var game:FlxGame = new FlxGame(0, 0, InitState, 0, 0, true);
    addChild(game);
  }
}
