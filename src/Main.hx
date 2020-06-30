package;

import classes.engine.EngineCore;
import classes.ui.UIStyle;
import classes.user.User;
import flash.events.Event;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.display.StageAlign;
import openfl.display.StageScaleMode;
import openfl.events.KeyboardEvent;
import scenes.loader.SceneGameLoader;

class Main extends Sprite 
{
	public var core : EngineCore;
	var inited:Bool;
	var userPrinted:Bool = false;
	
	/* ENTRY POINT */
	private function init(e : Event = null) : Void
	{
		if (inited) return;
		inited = true;
		
		// Welcome Message
		Logger.init();
		Logger.divider(this);
		Logger.log(this, Logger.WARNING, "Game Started, Welcome to " + Constant.GAME_NAME + "!");
		
		// Init Classes
		UIStyle.init();
		stage.stageFocusRect = false;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		
		//var fps:FPS  = new FPS(10, 10, 0xFFFFFF);
		//this.addChild(fps);
		
		core = new EngineCore();
		core.ui = new UI();
		#if debug
		stage.addEventListener(KeyboardEvent.KEY_DOWN, core.ui.e_debugKeyDown);
		#end
		addChildAt(core.ui, 0);
		
		// Load User
		core.user = new User(true, true);
		
		// Jump to Game Loader
		core.scene = new SceneGameLoader(core);
		
		stage.addEventListener(Event.RESIZE, core.e_stageResize);
		core.ui.updateStageResize();
	}
	
	/* SETUP */
	public function new() 
	{
		super();
		if (stage != null)
			init();
		else
			addEventListener(Event.ADDED_TO_STAGE, added);
	}

	function added(e) 
	{
		removeEventListener(Event.ADDED_TO_STAGE, added);
		#if ios
		haxe.Timer.delay(init, 100); // iOS 6
		#else
		init();
		#end
	}
	
	public static function main() 
	{
		// static entry point
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
		//
	}
}
