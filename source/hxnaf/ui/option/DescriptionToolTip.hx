package hxnaf.ui.option;

import flixel.group.FlxSpriteGroup;

class DescriptionToolTip extends FlxSpriteGroup
{
    var bg:FlxSprite;
    var txt:FlxBitmapText;

    public function new()
    {
        super();

        bg = new FlxSprite(0, FlxG.height - 70);
        bg.makeGraphic(FlxG.width, 50, 0xFF000000);
        bg.alpha = 0.5;
        add(bg);

        var font = FlxBitmapFont.fromAngelCode(
            'assets/images/mainmenu/texts/consolas.png',
            'assets/images/mainmenu/texts/consolas.fnt'
        );

        txt = new FlxBitmapText(font);
        
        txt.scale.set(0.5, 0.5); 
        
        add(txt);

        scrollFactor.set(0, 0);
        visible = false;
    }

    public function updateText(text:String):Void
    {
        if (text == null || text == "")
        {
            txt.text = "";
            visible = false;
            return;
        }

        txt.text = text;
        txt.updateHitbox();
        
        txt.screenCenter(X); 
        txt.y = bg.y + (bg.height / 2) - (txt.height / 2);
        
        visible = true;
    }
}