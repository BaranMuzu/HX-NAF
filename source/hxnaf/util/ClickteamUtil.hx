package hxnaf.util;

class ClickteamUtil
{
  /**
   * Converts an Alpha-blending Coefficient to a percentage.
   * @param value Alpha-blending Coefficient
   * @return Percentage.
   */
  public static function getAlpha(value:Int):Float
  {
    return 1 - (value / 255);
  }

  /**
    * `Random` expression.
    * @param value Max value.
    * @return Random from 0 to `value` - 1.
    }
   */
  public static function exprRandom(value:Int):Int
  {
    return FlxG.random.int(0, value - 1);
  }
}
