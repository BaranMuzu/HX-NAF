package hxnaf.ui.option;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import hxnaf.ui.title.items.BaseMenuItem;

class OptionItemGroup extends FlxTypedSpriteGroup<BaseMenuItem>
{
  public function new(?x:Float = 0, ?y:Float = 0)
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
        sprite.x = this.x;
        sprite.y = newY;

        newY += sprite.height + sprite.itemSpacing + 25;
      }

      dirty = false;
    }

    super.update(elapsed);
  }
}
