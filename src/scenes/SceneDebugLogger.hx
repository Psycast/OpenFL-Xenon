package scenes;
import classes.engine.EngineCore;
import classes.ui.UICore;
import classes.ui.UIStyle;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

class SceneDebugLogger extends UICore
{
	private var _tf:TextField;
	private var _colours:Array<String> = ["#DDDDDD", "#FFFFFF", "#FFCE7F", "#FF5E5B", "#E7ADFF"];

	//------------------------------------------------------------------------------------------------//

	public function new(core:EngineCore)
	{
		super(core);
		init();
	}

	override public function init():Void
	{
		_tf = new TextField();
		_tf.x = 5;
		_tf.y = 5;
		_tf.width = Constant.GAME_WIDTH - 10;
		_tf.height = Constant.GAME_HEIGHT - 10;
		_tf.embedFonts = true;
		_tf.multiline = true;
		_tf.defaultTextFormat = UIStyle.getTextFormat(true);
		_tf.autoSize = TextFieldAutoSize.NONE;
		addChild(_tf);

		this.graphics.beginFill(0, 0.5);
		this.graphics.drawRect(0, 0, Constant.GAME_WIDTH, Constant.GAME_HEIGHT);
		this.graphics.endFill();

		Logger.debugUpdateCallback = draw;
	}

	override public function onStage():Void
	{
		draw();
	}

	override public function draw():Void
	{
		_tf.htmlText = _buildHistory();
		_tf.scrollV = _tf.maxScrollV;
	}

	//------------------------------------------------------------------------------------------------//

	///////////////////////////////////
	// private methods
	///////////////////////////////////

	private function _buildHistory():String
	{
		var a:Array<Dynamic> = Logger.history;
		var b:Array<Dynamic>;
		var s:String = "";
		var i:Int = 0;
		while (i < a.length)
		{
			b = a[i];
			s += "<font color=\"" + _colours[b[1]] + "\">" + (!b[3] ? "[" + b[0] + "] " : "") + b[2] + "</font><br>";
			i++;
		}
		return s;
	}
}