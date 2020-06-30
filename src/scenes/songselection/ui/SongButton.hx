package scenes.songselection.ui;


import classes.engine.EngineCore;
import classes.engine.EngineLevel;
import classes.engine.EngineRanksLevel;
import classes.ui.Label;
import classes.ui.UIComponent;
import classes.ui.UIStyle;
import flash.display.DisplayObjectContainer;
import flash.display.GradientType;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import flash.text.TextFieldAutoSize;

class SongButton extends UIComponent
{
	public var highlight(get, set) : Bool;

	private static var detailsShown : Array<Array<Dynamic>> = [["Author", "author", 0.25], ["Stepauthor", "stepauthor", 0.24], ["Style", "style", 0.22], ["Length", "time", 0.1], ["Best Score", "rank", 0.19, TextFieldAutoSize.RIGHT]];
	private var core : EngineCore;
	public var songData : EngineLevel;
	
	private var _mtxGradient : Matrix;
	private var _lblSongName : Label;
	private var _lblSongFlag : Label;
	private var _lblSongDifficulty : Label;
	private var _lblSongDetails : Array<Array<Label>>;
	
	private var _title_only : Bool = true;
	private var _highlight : Bool = false;
	private var _over : Bool = false;
	
	public function new(parent : DisplayObjectContainer = null, xpos : Float = 0, ypos : Float = 0, core : EngineCore = null, songData : EngineLevel = null)
	{
		this.core = core;
		this.songData = songData;
		super(parent, xpos, ypos);
		mouseEnabled = buttonMode = !songData.is_title_only;
		mouseChildren = false;
	}
	
	/**
	 * Initializes the component.
	 */
	override private function init() : Void
	{
		//- Gradient Box
		_mtxGradient = new Matrix();
		_mtxGradient.createGradientBox(200, 200, (Math.PI / 180) * 225);
		
		_title_only = songData.is_title_only;// || songData.difficulty == 0);
		setSize(250, 31, false);
		super.init();
	}
	
	/**
	 * Creates and adds the child display objects of this component.
	 */
	override private function addChildren() : Void
	{
		if (_title_only) 
		{
			_lblSongName = new Label(this, 5, 2, "<font color=\"" + UIStyle.ACTIVE_FONT_COLOR + "\">" + songData.name + "</font>", true);
			_lblSongName.autoSize = TextFieldAutoSize.CENTER;
		}
		else 
		{
			_lblSongName = new Label(this, 5, 2, songData.name);
			_lblSongFlag = new Label(this, 5, 2, Constant.getSongIcon(core, songData), true);
			_lblSongFlag.autoSize = TextFieldAutoSize.RIGHT;
			_lblSongDifficulty = new Label(this, 5, 2, Std.string(songData.difficulty));
			_lblSongDifficulty.autoSize = TextFieldAutoSize.RIGHT;
		}
		
		addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
	}
	
	/**
	 * Draws the visual ui of the component.
	 */
	override public function draw() : Void
	{
		super.draw();
		drawBox();
		
		// Song Divider
		if (_title_only) 
		{
			_lblSongName.setSize(width - 10, 28);
		}
		else 
		{
			_lblSongDifficulty.x = width - 25;
			_lblSongDifficulty.setSize(20, 28);
			_lblSongFlag.visible = core.user.settings.display_song_flags;
			_lblSongFlag.x = _lblSongDifficulty.x - 95;
			_lblSongFlag.setSize(90, 28);
			_lblSongName.setSize(_lblSongFlag.x - 10, 28);
			if (_lblSongDetails != null && highlight) 
			{
				positionDetails(true);
			}
		}
	}
	
	///////////////////////////////////
	// public methods
	///////////////////////////////////
	
	/**
	 * Draws the background rectangle.
	 */
	public function drawBox() : Void
	{
		//- Draw Box
		this.graphics.clear();
		this.graphics.lineStyle(UIStyle.BORDER_SIZE, 0xFFFFFF, ((highlight) ? 0.8 : 0.55));
		this.graphics.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0xFFFFFF], ((highlight) ? [0.5, 0.25] : [0.35, 0.1]), [0, 255], _mtxGradient);
		this.graphics.drawRect(0, 0, width, height);
		this.graphics.endFill();
	}
	
	/**
	 * Create expanded song details.
	 */
	private function createDetails() : Void
	{
		if (_lblSongDetails == null && !_title_only) 
		{
			_lblSongDetails = [];
			for (i in 0...detailsShown.length){
				// Get Value
				var value : String = "---";
				if (detailsShown[i][1] == "rank") 
				{
					var rank : EngineRanksLevel = Constant.getSongRank(core, songData);
					if (rank != null && rank.score > 0) 
						value = rank.results;
				}
				else 
					value = Reflect.field(songData, Std.string(detailsShown[i][1]));
				
				_lblSongDetails.push([
						new Label(this, 5, 2, "<font color=\"#d3d3d3\">" + detailsShown[i][0] + ":</font>", true), 
						new Label(this, 5, 2, value)
					]);
				_lblSongDetails[_lblSongDetails.length - 1][0].fontSize = UIStyle.FONT_SIZE - 1;
				_lblSongDetails[_lblSongDetails.length - 1][1].fontSize = UIStyle.FONT_SIZE - 2;
			}
		}
	}
	
	/**
	 * Positions, adjust, and sets visibility of expanded song details.
	 * @param	visible Sets the mode to use for positioning.
	 */
	private function positionDetails(visible : Bool) : Void
	{
		if (_lblSongDetails != null) 
		{
			var maxWidth : Float = (Math.min(width, 1000) - ((_lblSongDetails.length + 1) * 5));
			var nextX : Float = 5;
			for (i in 0..._lblSongDetails.length){
				var lbl : Array<Label> = _lblSongDetails[i];
				var xWidth : Float = maxWidth * detailsShown[i][2];
				if (visible) 
				{
					lbl[0].move(nextX, 28);  // Text  
					lbl[0].setSize(xWidth, 20);
					lbl[1].move(nextX, 48);  // Value  
					lbl[1].setSize(xWidth, 20);
					
					if (detailsShown[i][3]) 
					{
						lbl[0].autoSize = detailsShown[i][3];
						lbl[1].autoSize = detailsShown[i][3];
					}
				}
				else 
				{
					lbl[0].y = 2;  // Text  
					lbl[1].y = 2;
				}
				lbl[0].visible = visible;
				lbl[1].visible = visible;
				nextX += xWidth + 5;
			}
		}
	}
	
	///////////////////////////////////
	// event handlers
	///////////////////////////////////
	
	/**
	 * Internal mouseOver handler.
	 * @param event The MouseEvent passed by the system.
	 */
	private function onMouseOver(event : MouseEvent) : Void
	{
		if (!_over)
		{
			_over = true;
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			drawBox();
		}
	}
	
	/**
	 * Internal mouseOut handler.
	 * @param event The MouseEvent passed by the system.
	 */
	private function onMouseOut(event : MouseEvent) : Void
	{
		if (_over)
		{
			_over = false;
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			drawBox();
		}
	}
	
	///////////////////////////////////
	// getter/setters
	///////////////////////////////////
	private function get_highlight() : Bool
	{
		return enabled && (_highlight || _over);
	}
	
	private function set_highlight(val : Bool) : Bool
	{
		_highlight = val;
		
		// Only create song details when required.
		if (val && _lblSongDetails == null) 
			createDetails();
			
		if (!_title_only && _lblSongDetails != null) 
		{
			_height = (val) ? 71 : 31;
			positionDetails(val);
		}
		
		drawBox();
		return val;
	}
}