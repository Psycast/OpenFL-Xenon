package classes.ui;


import flash.display.DisplayObjectContainer;
import flash.display.Sprite;

/**
	 * Wrapper for normal sprites into UIComponent compatible sprites.
	 */
class UISprite extends UIComponent
{
    
    public function new(parent : DisplayObjectContainer = null, sprite : Sprite = null, xpos : Float = 0, ypos : Float = 0)
    {
        super(parent, xpos, ypos);
        
        if (sprite != null) 
            addChild(sprite);
    }
}

