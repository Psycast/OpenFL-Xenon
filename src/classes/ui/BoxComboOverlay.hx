package classes.ui;

import TypeDefinitions;
import classes.ui.ScrollPaneBars;
import classes.ui.UIOverlay;
import openfl.text.AntiAliasType;

import flash.display.BitmapData;

import flash.display.Sprite;
import flash.events.Event;
import flash.filters.BlurFilter;
import flash.geom.ColorTransform;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

class BoxComboOverlay extends UIOverlay
{
	public var listPostion(get, set) : Int;

	private var _holder : Box;
	private var _pane : ScrollPaneBars;
	private var _title : String;
	private var _titletf : TextField;
	private var _options : Array<ComboOptionDef> = [];
	private var _optionButtons : Array<Dynamic> = [];
	private var _defaultHandler : Null<Dynamic>;
	private var _listPostion : Int;
	
	public function new(?title : String = null, ?options : Array<ComboOptionDef> = null, ?defaultHandler : Null<Dynamic> = null, ?postion : Int = UIAnchor.CENTER)
	{
		_title = title;
		_options = options;
		_defaultHandler = defaultHandler;
		_listPostion = postion;
		super(null, 0, 0);
	}
	
	override private function addChildren() : Void
	{
		// Add Background
		_holder = new Box(this, 15, -1);
		_holder.setSize(250, Constant.GAME_HEIGHT + 2);
		
		// Pane
		_pane = new ScrollPaneBars(_holder, 10, 10);
		_pane.width = _holder.width - 22;
		
		// Add Title
		if (_title != null) 
		{
			_titletf = new TextField();
			_titletf.width = _holder.width - 20;
			_titletf.x = 10;
			_titletf.y = 10;
			_titletf.multiline = true;
			_titletf.wordWrap = true;
			_titletf.embedFonts = UIStyle.USE_EMBED_FONTS;
			_titletf.selectable = false;
			_titletf.mouseEnabled = false;
			_titletf.defaultTextFormat = UIStyle.getTextFormat();
			_titletf.autoSize = TextFieldAutoSize.LEFT;
			_titletf.antiAliasType = AntiAliasType.ADVANCED;
			_titletf.htmlText = _title;
			_holder.addChild(_titletf);
		}
		
		// Add Options
		_addOptions();
		
		// Move / Positioning
		onResize();
	}
	
	override public function onResize() : Void
	{
		super.onResize();
		
		// Box Holder
		if (_listPostion & UIAnchor.LEFT != 0) 
			_holder.x = 15
		else if (_listPostion & UIAnchor.RIGHT != 0) 
			_holder.x = Constant.GAME_WIDTH - _holder.width - 15
		else 
		_holder.x = Constant.GAME_WIDTH_CENTER - (_holder.width / 2);
		
		_holder.setSize(250, Constant.GAME_HEIGHT + 2);
		
		// Scroll Pane Position / size
		var yOffset : Float = ((_titletf != null) ? _titletf.y + _titletf.height + 10 : 10);
		_pane.height = _holder.height - 10 - yOffset;
		_pane.y = yOffset;
		
		// button Size
		var paneWidth : Float = _pane.paneWidth;
		for (i in 0..._optionButtons.length){
			_optionButtons[i].width = paneWidth;
		}
	}
	
	///////////////////////////////////
	// private methods
	///////////////////////////////////
	
	/**
	 * Creates the option buttons and adds them to the scrollpane.
	 */
	private function _addOptions() : Void
	{
		var btn : BoxButton;
		for (i in 0..._options.length) {
			btn = new BoxButton(_pane, 0, i * 37, _options[i].label, e_buttonHandler);
			btn.setSize(200, 32);
			btn.tag = _options[i];
			_optionButtons.push(btn);
		}
	}
	
	///////////////////////////////////
	// event handlers
	///////////////////////////////////
	
	/**
	 * Event handler for the option buttons.
	 */
	private function e_buttonHandler(e : Event) : Void
	{
		ResizeListener.removeObject(this);
		if (_defaultHandler != null) 
		{
			_defaultHandler(cast(e.target, BoxButton).tag);
		}
		if (parent != null && parent.contains(this) && (Std.is(parent, UI))) 
		{
			cast(parent, UI).removeOverlay(this);
		}
	}
	
	///////////////////////////////////
	// getter/setters
	///////////////////////////////////
	/**
	 * Gets the list postion on screen.
	 * Either: TOP_LEFT, TOP_CENTER, TOP_RIGHT
	 */
	private function get_listPostion() : Int
	{
		return _listPostion;
	}
	
	/**
	 * Sets the list postion on screen using UIAnchor points.
	 * Either: LEFT, CENTER, RIGHT
	 */
	private function set_listPostion(postion : Int) : Int
	{
		_listPostion = postion;
		onResize();
		return postion;
	}
}