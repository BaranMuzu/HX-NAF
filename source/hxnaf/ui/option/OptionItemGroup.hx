package hxnaf.ui.option;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import hxnaf.ui.title.items.BaseMenuItem;

class OptionItemGroup extends FlxTypedSpriteGroup<BaseMenuItem>
{
  public function new(?x:Float = 0, ?y:Float = 0)
  {
    super(x, y);
  }

  // rip isDirty, sorry but you were breaking stuff

  public function arrangeItems():Void
  {
    var y:Float = this.y;

    for (sprite in group.members)
    {
      if (sprite == null) continue;

      sprite.x = this.x;
      sprite.y = y;

      y += sprite.height + sprite.itemSpacing + 25;
    }
  }

  override public function add(sprite:BaseMenuItem):BaseMenuItem
  {
    var addedItem = super.add(sprite);

    arrangeItems();

    return addedItem;
  }
}
