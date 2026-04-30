package hxnaf.ui.option;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import hxnaf.ui.title.items.BaseMenuItem;

class OptionItemGroup extends FlxTypedSpriteGroup<BaseMenuItem>
{
  public function new()
  {
    super();
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
      var totalHeight:Float = 0;

      for (i in 0...group.members.length)
      {
        totalHeight += group.members[i].height;
        if (i < group.members.length - 1) totalHeight += 40;
      }

      var yPosition:Float = (FlxG.height - totalHeight) / 2;

      for (sprite in group.members)
      {
        sprite.x = (FlxG.width / 2) - 150;
        sprite.y = yPosition;
        yPosition += sprite.height + 40;
      }

      dirty = false;
    }

    super.update(elapsed);
  }
}
