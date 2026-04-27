package hxnaf.ui.title.items;

import flixel.FlxSprite;

class BaseMenuItem extends FlxSprite
{
  public final id:String;
  public var selected(default, set):Bool;

  var onConfirm:Null<Void->Void> = null;

  public function new(id:String, path:String)
  {
    this.id = id;

    super();
    loadGraphic('assets/images/mainmenu/texts/$path.png');
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
