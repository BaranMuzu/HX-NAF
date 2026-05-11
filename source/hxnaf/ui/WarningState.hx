package hxnaf.ui;

import flixel.system.FlxSplash;
import flixel.util.typeLimit.NextState;
import hxnaf.ui.title.TitleState;

class WarningState extends FlxState
{
  override public function create():Void
  {
    super.create();

    var font = FlxBitmapFont.fromAngelCode('assets/images/mainmenu/texts/consolas.png', 'assets/images/mainmenu/texts/consolas.fnt');

    var warnText:FlxBitmapText = new FlxBitmapText(font);
    warnText.autoSize = false;
    warnText.fieldWidth = FlxG.width;
    warnText.multiLine = true;
    warnText.alignment = CENTER;
    warnText.text = "WARNING!!\n\nthis game contains flashing lights\nloud noises and lots of jumpscares";
    warnText.screenCenter();
    add(warnText);
  }

  override public function update(elapsed:Float):Void
  {
    super.update(elapsed);

    if (FlxG.keys.justPressed.ENTER || FlxG.mouse.justPressed)
    {
      FlxG.switchState(() ->
      {
        var titleNext:NextState = () -> new TitleState();
        return new FlxSplash(titleNext);
      });
    }
  }
}
