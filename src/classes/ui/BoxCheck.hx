package classes.ui;

import classes.ui.UIComponent;
import openfl.display.DisplayObjectContainer;

import flash.events.MouseEvent;

class BoxCheck extends UIComponent
{
	public var checked(get, set) : Bool;
	public var highlight(get, set) : Bool;
	public var color(get, set) : Int;
	public var border_color(get, set) : Int;
	public var check_color(get, set) : Int;

	private var _over : Bool = false;
	private var _checked : Bool = false;
	private var _highlight : Bool = false;
	
	private var _background_color : Int = 0xFFFFFF;
	private var _background_alpha : Float = 0.1;
	private var _check_color : Int = 0x51B6FF;
	private var _check_alpha : Float = 0.6;
	
	private var _border_alpha : Float = 0.4;
	private var _border_color : Int = 0xFFFFFF;
	
	public function new(parent : DisplayObjectContainer = null, xpos : Float = 0, ypos : Float = 0, isChecked : Bool = false)
	{
		_checked = isChecked;
		super(parent, xpos, ypos);
	}
	
	/**
	 * Initializes the component.
	 */
	override private function init() : Void
	{
		buttonMode = true;
		useHandCursor = true;
		mouseChildren = false;
		setSize(14, 14, false);
		super.init();
	}
	
	/**
	 * Creates and adds the child display objects of this component.
	 */
	override private function addChildren() : Void
	{
		addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		addEventListener(MouseEvent.CLICK, onMouseClick);
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
		this.graphics.clear();
		
		//- Draw Box
		var _alpha : Float = ((highlight) ? 1.5 : 1);
		this.graphics.lineStyle(UIStyle.BORDER_SIZE, border_color, _border_alpha * _alpha);
		if (checked) 
			this.graphics.beginFill(check_color, _check_alpha * _alpha)
		else 
		this.graphics.beginFill(color, _background_alpha * _alpha);
		this.graphics.drawRect(0, 0, width, height);
		this.graphics.endFill();
	}
	
	///////////////////////////////////
	// event handler
	///////////////////////////////////
	
	/**
	 * Internal click handler.
	 * @param event The MouseEvent passed by the system.
	 */
	private function onMouseClick(e : MouseEvent) : Void
	{
		checked = !checked;
	}
	
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
			draw();
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
			draw();
		}
	}
	
	///////////////////////////////////
	// getter/setters
	///////////////////////////////////
	/**
	 * Returns true if checked.
	 */
	private function get_checked() : Bool
	{
		return _checked;
	}
	
	private function set_checked(val : Bool) : Bool
	{
		_checked = val;
		draw();
		return val;
	}
	
	private function get_highlight() : Bool
	{
		return enabled && (_highlight || _over);
	}
	
	private function set_highlight(val : Bool) : Bool
	{
		_highlight = val;
		draw();
		return val;
	}
	
	private function get_color() : Int
	{
		return _background_color;
	}
	
	private function set_color(value : Int) : Int
	{
		_background_color = value;
		draw();
		return value;
	}
	
	private function get_border_color() : Int
	{
		return _border_color;
	}
	
	private function set_border_color(value : Int) : Int
	{
		_border_color = value;
		draw();
		return value;
	}
	
	private function get_check_color() : Int
	{
		return _check_color;
	}
	
	private function set_check_color(value : Int) : Int
	{
		_check_color = value;
		draw();
		return value;
	}
}