import classes.ui.ResizeListener;
import classes.ui.UICore;
import classes.ui.UIStyle;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.display.StageScaleMode;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import openfl.filters.BlurFilter;
import openfl.geom.ColorTransform;
import scenes.SceneDebugLogger;

class UI extends Sprite
{
	public var scene(get, set) : UICore;

	// Active Scene
	private var _scene : UICore;
	private var _debugscrene:UICore = new SceneDebugLogger(null);
	private var _overlays : Int = 0;
	
	// Game Scene
	private function get_scene() : UICore
	{
		return _scene;
	}
	
	private function set_scene(new_scene : UICore) : UICore
	{
		Logger.divider(this);
		Logger.log(this, Logger.WARNING, "Scene Change: " + new_scene.class_name);
		
		// Remove Old
		if (_scene != null) 
		{
			_scene.destroy();
			if (this.contains(_scene)) 
				this.removeChild(_scene);
			_scene = null;
		}
		
		// Add to Stage  
		_scene = new_scene;
		_scene.init();
		addChildAt(_scene, 0);
		_scene.onStage();
		
		if (_overlays > 0) 
			blurInterface();  
		
		// Reset Stage Focus
		if (stage != null) 
			stage.focus = null;
		return new_scene;
	}
	
	// Overlays
	public function addOverlay(overlay : DisplayObject) : Void
	{
		addChild(overlay);
		_overlays++;
		
		if (_overlays > 0) 
			blurInterface();
	}
	
	public function removeOverlay(overlay : DisplayObject) : Void
	{
		removeChild(overlay);
		_overlays--;
		
		if (_overlays <= 0) 
			unblurInterface();
	}
	
	public function blurInterface() : Void
	{
		scene.filters = [new BlurFilter(8, 8, 1)];
		scene.transform.colorTransform = new ColorTransform(0.5, 0.5, 0.5);
	}
	
	public function unblurInterface() : Void
	{
		scene.filters = [];
		scene.transform.colorTransform = new ColorTransform();
	}
	
	public function setStageSize(w : Int, h : Int, scale : StageScaleMode = null) : Void
	{
		var oS : StageScaleMode = stage.scaleMode;
		var oW : Int = Constant.GAME_WIDTH;
		var oH : Int = Constant.GAME_HEIGHT;
		
		Constant.GAME_WIDTH = w;
		Constant.GAME_HEIGHT = h;
		
		if (Constant.GAME_WIDTH < 800)		Constant.GAME_WIDTH = 800;
		if (Constant.GAME_HEIGHT < 600)		Constant.GAME_HEIGHT = 600;
		
		Constant.GAME_WIDTH_CENTER = Math.floor(Constant.GAME_WIDTH / 2);
		Constant.GAME_HEIGHT_CENTER = Math.floor(Constant.GAME_HEIGHT / 2);
		
		if (oW != Constant.GAME_WIDTH || oH != Constant.GAME_HEIGHT) 
		{
			if(scene != null)
				scene.onResize();
			ResizeListener.signal();
		}
		if (scale != null && oS != scale) 
		{
			stage.scaleMode = scale;
		}
	}
	
	public function updateStageResize() : Void
	{
		if (stage.scaleMode == StageScaleMode.NO_SCALE) 
		{
			setStageSize(stage.stageWidth, stage.stageHeight);
		}
	}

	#if debug
	public function e_debugKeyDown(e:KeyboardEvent):Void 
	{
		if (e.keyCode == Keyboard.F11)
		{
			UIStyle.USE_ANIMATION = !UIStyle.USE_ANIMATION;
		}
		if (e.keyCode == Keyboard.F12)
		{
			if (contains(_debugscrene))
			{
				removeChild(_debugscrene);
			}
			else
			{
				addChild(_debugscrene);
				_debugscrene.onStage();
			}
		}
	}
	#end
	
	public function new()
	{
		super();
	}
}