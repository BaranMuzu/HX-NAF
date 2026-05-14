package hxnaf.ui;

import flixel.text.FlxText.FlxTextFormat;
import flixel.text.FlxText.FlxTextFormatMarkerPair;
import flixel.system.FlxSplash;
import flixel.util.typeLimit.NextState;
import hxnaf.ui.title.TitleState;

class WarningState extends FlxState
{
  var warnText:FlxText;
  var isFading:Bool = false;

  override public function create():Void
  {
    super.create();

    warnText = new FlxText(0, 0, FlxG.width, "");
    warnText.setFormat("assets/fonts/consolas.ttf", 32, FlxColor.WHITE, CENTER);

    var redFormat = new FlxTextFormat(FlxColor.RED);
    var yellowFormat = new FlxTextFormat(FlxColor.YELLOW);

    warnText.applyMarkup("#WARNING!!#\n\nthis game contains @flashing lights@\n@loud noises@ and lots of @jumpscares@", [
      new FlxTextFormatMarkerPair(redFormat, "#"),
      new FlxTextFormatMarkerPair(yellowFormat, "@")
    ]);

    warnText.screenCenter();
    add(warnText);
  }

  override public function update(elapsed:Float):Void
  {
    super.update(elapsed);

    if (isFading) return;

    if (FlxG.keys.justPressed.ENTER || FlxG.mouse.justPressed)
    {
      isFading = true;

      FlxTween.tween(warnText, {alpha: 0}, 1.0, {
        onComplete: function(twn:FlxTween)
        {
          FlxG.switchState(() ->
          {
            var titleNext:NextState = () -> new TitleState();
            return new FlxSplash(titleNext);
          });
        }
      });
    }
  }
}