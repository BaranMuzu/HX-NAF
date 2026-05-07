package hxnaf.ui.option.items;

import hxnaf.ui.option.items.OptionMenuItem;

class CategoryOptionItem extends OptionMenuItem
{
	public var children:Array<OptionMenuItem> = [];

	public function new(id:String, text:String, description:String = "", children:Array<OptionMenuItem> = null)
	{
		super(id, text, description);
		if (children != null)
			this.children = children;
	}

	override public function confirm():Void
	{
		super.confirm();
	}
}
