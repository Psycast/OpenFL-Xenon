package classes.ui;

import assets.SGameBackground;
import classes.engine.EngineCore;
import flash.display.Sprite;
import flash.utils.Object;

class UICore extends Sprite
{
	public var class_name(get, never) : String;

	private var core : EngineCore;
	public var INPUT_DISABLED : Bool = false;
	
	public function new(core : EngineCore)
	{
		super();
		this.core = core;
	}
	
	/**
	 * Abstract init() function.
	 * Called by UI before placement on the stage.
	 */
	public function init() : Void { }
	
	/**
	 * Abstract destroy() function.
	 * Called by UI before removal from the stage.
	 */
	public function destroy() : Void { }
	
	/**
	 * Abstract destroy() function.
	 * Called by UI after placement on the stage.
	 */
	public function onStage() : Void
	{
		var bg : SGameBackground = new SGameBackground();
		addChildAt(bg, 0);
		
		position();
		draw();
	}
	
	/**
	 * Abstract onResize() function.
	 * Called by UI when the stage size changes.
	 */
	public function onResize() : Void
	{
		position();
	}
	
	/** Abstract draw() function. */
	public function draw() : Void { }
	
	/** Abstract position() function. */
	public function position() : Void { }
	
	/** Returns the constructor class name. */
	private function get_class_name() : String
	{
		return Type.getClassName(Type.getClass(this)).split(".").pop();
	}
}