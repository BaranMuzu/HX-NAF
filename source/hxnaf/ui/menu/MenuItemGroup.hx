package hxnaf.ui.menu;

import hxnaf.ui.menu.items.BaseMenuItem;

class MenuItemGroup extends FlxTypedSpriteGroup<BaseMenuItem>
{
  public function new(?x:Float, ?y:Float)
  {
    super(x, y);
  }

  override function preAdd(sprite:BaseMenuItem):Void
  {
    dirty = true;
    super.preAdd(sprite);
  }

  override public function update(elapsed:Float):Void
  {
    if (dirty)
    {
      var newY:Float = this.y;
      for (sprite in group.members)
      {
        sprite.y = newY;
        newY += sprite.height;
        newY += 25;
      }

      dirty = false;
    }

    super.update(elapsed);
  }
}
