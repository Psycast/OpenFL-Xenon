package classes.ui;

import classes.ui.UIComponent;
import openfl.display.DisplayObjectContainer;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Matrix;

class Box extends UIComponent
{
	public var highlight(get, set) : Bool;
	public var color(get, set) : Int;
	public var borderColor(get, set) : Int;

	private var _highlight : Bool = false;
	
	private var _background_color : Int = 0xFFFFFF;
	private var _background_alpha : Float = 0.12;
	
	private var _border_alpha : Float = 0.4;
	private var _border_color : Int = 0xFFFFFF;
	
	public function new(parent : DisplayObjectContainer = null, xpos : Float = 0, ypos : Float = 0)
	{
		super(parent, xpos, ypos);
	}
	
	/**
	 * Initializes the component.
	 */
	override private function init() : Void
	{
		setSize(100, 20, false);
		super.init();
	}
	
	/**
	 * Draws the visual ui of the component.
	 */
	override public function draw() : Void
	{
		super.draw();
		drawBox();
	}
	
	/**
	 * Draws the background rectangle.
	 */
	public function drawBox() : Void
	{
		//- Draw Box
		this.graphics.clear();
		this.graphics.lineStyle(UIStyle.BORDER_SIZE, borderColor, ((highlight) ? _border_alpha * 1.75 : _border_alpha));
		this.graphics.beginFill(color, ((highlight) ? _background_alpha * 1.75 : _background_alpha));
		this.graphics.drawRect(0, 0, width, height);
		this.graphics.endFill();
	}
	
	///////////////////////////////////
	// getter/setters
	///////////////////////////////////
	/**
	 * Gets the highlight status of the box.
	 */
	private function get_highlight() : Bool
	{
		return _highlight;
	}
	
	/**
	 * Sets the highlight status of the box.
	 */
	private function set_highlight(val : Bool) : Bool
	{
		_highlight = val;
		drawBox();
		return val;
	}
	
	/**
	 * Gets the background color for the box.
	 */
	private function get_color() : Int
	{
		return _background_color;
	}
	
	/**
	 * Sets the background color for the box.
	 */
	private function set_color(value : Int) : Int
	{
		_background_color = value;
		draw();
		return value;
	}
	
	/**
	 * Gets the border color for the box.
	 */
	private function get_borderColor() : Int
	{
		return _border_color;
	}
	
	/**
	 * Sets the border color for the box.
	 */
	private function set_borderColor(value : Int) : Int
	{
		_border_color = value;
		draw();
		return value;
	}
}