package classes.ui;

import flash.display.DisplayObjectContainer;

class UIOverlay extends UIComponent
{
    
    public function new(parent : DisplayObjectContainer = null, xpos : Float = 0, ypos : Float = 0)
    {
        super(parent, xpos, ypos);
    }
    
    override private function init() : Void
    {
        super.init();
        setSize(Constant.GAME_WIDTH, Constant.GAME_HEIGHT);
        ResizeListener.addObject(this);
    }
    
    /**
		 * Draws the visual ui of the component.
		 */
    override public function draw() : Void
    {
        super.draw();
        
        this.graphics.clear();
        this.graphics.beginFill(UIStyle.BG_DARK, 0.90);
        this.graphics.drawRect(0, 0, width, height);
        this.graphics.endFill();
    }
    
    /**
		 * Stage resize and child positioning.
		 */
    override public function onResize() : Void
    {
        _width = Constant.GAME_WIDTH;
        _height = Constant.GAME_HEIGHT;
        
        super.onResize();
        
        this.graphics.clear();
        this.graphics.beginFill(UIStyle.BG_DARK, 0.90);
        this.graphics.drawRect(0, 0, width, height);
        this.graphics.endFill();
    }
}

