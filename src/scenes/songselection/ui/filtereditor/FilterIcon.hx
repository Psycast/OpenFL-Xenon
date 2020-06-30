package scenes.songselection.ui.filtereditor;

import assets.menu.icons.*;
import classes.engine.EngineLevelFilter;
import classes.ui.UIComponent;
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;

class FilterIcon extends UIComponent
{
	public static inline var ICON_GEAR : String = "gear";
	public static inline var ICON_STYLE : String = "style";
	public static inline var ICON_NAME : String = "name";
	public static inline var ICON_ARTIST : String = "artist";
	public static inline var ICON_STEPARTIST : String = "stepartist";
	public static inline var ICON_BPM : String = "bpm";
	public static inline var ICON_DIFFICULTY : String = "difficulty";
	public static inline var ICON_ARROWCOUNT : String = "arrows";
	public static inline var ICON_ID : String = "id";
	public static inline var ICON_MIN_NPS : String = "min_nps";
	public static inline var ICON_MAX_NPS : String = "max_nps";
	public static inline var ICON_RANK : String = "rank";
	public static inline var ICON_SCORE : String = "score";
	public static inline var ICON_STATS : String = "stats";
	public static inline var ICON_TIME : String = "time";
	
	private var _border : Bool;
	private var _icon : MovieClip;
	
	public function new(parent : DisplayObjectContainer = null, xpos : Float = 0, ypos : Float = 0, icon : String = "Unknown", border : Bool = true)
	{
		_icon = getIconFromString(icon);
		_border = border;
		super(parent, xpos, ypos);
	}
	
	/**
	 * Initializes the component.
	 */
	override private function init() : Void
	{
		setSize(24, 24);
		super.init();
	}
	
	/**
	 * Creates and adds the child display objects of this component.
	 */
	override private function addChildren() : Void
	{
		_icon.width = width - 4;
		_icon.height = height - 4;
		_icon.x = 2;
		_icon.y = 2;
		addChild(_icon);
	}
	
	///////////////////////////////////
	// public methods
	///////////////////////////////////
	
	/**
	 * Draws the visual ui of the component.
	 */
	override public function draw() : Void
	{
		super.draw();
		_icon.width = width - 4;
		_icon.height = height - 4;
		
		graphics.clear();
		if (_border)
			graphics.lineStyle(1, 0xffffff, 1, true);
		graphics.beginFill(0, 0);
		graphics.drawRect(0, 0, width - 1, height - 1);
		graphics.endFill();
	}
	
	private function getIconFromString(icon : String) : MovieClip
	{
		switch (icon)
		{
			case ICON_GEAR:
				return new IconGear();
			
			// Engine Filters
			case ICON_ARROWCOUNT:
				return new IconFilterArrowCount();
			case ICON_ARTIST:
				return new IconFilterArtist();
			case ICON_BPM:
				return new IconFilterBPM();
			case ICON_DIFFICULTY:
				return new IconFilterDifficulty();
			case ICON_STYLE:
				return new IconFilterGenre();
			case ICON_ID:
				return new IconFilterID();
			case ICON_NAME:
				return new IconFilterName();
			case ICON_MAX_NPS, ICON_MIN_NPS:
				return new IconFilterNPS();
			case ICON_RANK:
				return new IconFilterRank();
			case ICON_SCORE:
				return new IconFilterScore();
			case ICON_STATS:
				return new IconFilterStats();
			case ICON_STEPARTIST:
				return new IconFilterStepArtist();
			case ICON_TIME:
				return new IconFilterTime();
		}
		return new IconFilterUnknown();
	}
}

