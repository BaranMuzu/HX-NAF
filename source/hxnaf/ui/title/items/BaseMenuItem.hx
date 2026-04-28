package hxnaf.ui.title.items;

import flixel.graphics.frames.FlxBitmapFont;
import flixel.text.FlxBitmapText;

class BaseMenuItem extends FlxBitmapText
{
  public final id:String;
  public var selected(default, set):Bool;
  public var itemSpacing:Float = 0;
m
  var onConfirm:Null<Void->Void> = null;

  public function new(id:String, text:String)
  {
    this.id = id;

    var customFont = FlxBitmapFont.fromAngelCode("assets/images/mainmenu/texts/consolas.png", "assets/images/mainmenu/texts/consolas.fnt");
    super(customFont);

    this.text = text;
  }

  public function setConfirmCallback(callback:() -> Void):BaseMenuItem
  {
    onConfirm = callback;
    return this;
  }

  public function confirm():Void
  {
    if (onConfirm != null) onConfirm();
  }

  function set_selected(value:Bool):Bool
  {
    selected = value;
    return value;
  }
}
