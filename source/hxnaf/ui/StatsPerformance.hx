package hxnaf.ui;

import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.utils.Assets;

class StatsPerformance extends Sprite
{
  var mainText:TextField;
  var times:Array<Float> = [];

  public function new(X:Float = 10, Y:Float = 10)
  {
    super();
    this.x = X;
    this.y = Y;

    this.graphics.beginFill(0x000000, 0.5);

    this.graphics.drawRect(-5, -2, 118, 32);
    this.graphics.endFill();

    mainText = new TextField();
    mainText.selectable = false;
    mainText.mouseEnabled = false;
    mainText.width = 300;
    mainText.height = 100;

    var format = new TextFormat(Assets.getFont("assets/fonts/consolas.ttf").fontName, 14, 0xFFFFFF);
    format.leading = -2;

    mainText.defaultTextFormat = format;
    mainText.text = "FPS: 0\nMEM: 0 MB";

    addChild(mainText);

    addEventListener(Event.ENTER_FRAME, onEnterFrame);
  }

  private function onEnterFrame(e:Event):Void
  {
    var now = Lib.getTimer();
    times.push(now);
    while (times[0] < now - 1000)
    {
      times.shift();
    }

    var curFps = times.length;
    var curRam = Math.round(System.totalMemory / 1048576 * 100) / 100;

    mainText.text = "FPS: " + curFps + "\nMEM: " + curRam + " MB";
  }
}
