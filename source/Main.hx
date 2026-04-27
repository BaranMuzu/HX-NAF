package;

import openfl.display.Sprite;
import hxnaf.InitState;
import flixel.FlxGame;

class Main extends Sprite
{
  public function new()
  {
    super();

    var game:FlxGame = new FlxGame(0, 0, InitState);
    addChild(game);
  }
}
