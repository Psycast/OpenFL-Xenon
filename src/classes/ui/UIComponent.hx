package classes.ui;

import flash.events.Event;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;

class UIComponent extends Sprite
{
	public var tag(get, set) : Dynamic;
	public var real_x(get, never) : Float;
	public var real_y(get, never) : Float;
	public var enabled(get, set) : Bool;
	public var anchor(get, set) : Int;

	public var _x : Float = 0;
	public var _y : Float = 0;
	public var _width : Float = 0;
	public var _height : Float = 0;
	private var _tag : Dynamic = -1;
	private var _enabled : Bool = true;
	private var _anchor : Int = UIAnchor.NONE;
	
	/**
	 * Constructor
	 * @param parent The parent DisplayObjectContainer on which to add this component.
	 * @param xpos The x position to place this component.
	 * @param ypos The y position to place this component.
	 */
	public function new(parent : DisplayObjectContainer = null, xpos : Float = 0, ypos : Float = 0)
	{
		super();
		move(xpos, ypos);
		init();
		if (parent != null) 
		{
			parent.addChild(this);
		}
	}
	
	/**
	 * Initilizes the component.
	 */
	private function init() : Void
	{
		addChildren();
		tabEnabled = false;
		draw();
	}
	
	/**
	 * Overriden in subclasses to create child display objects.
	 */
	private function addChildren() : Void
	{
		
	}
	
	/**
	 * Moves the component to the specified position.
	 * @param xpos the x position to move the component
	 * @param ypos the y position to move the component
	 */
	public function move(xpos : Float, ypos : Float) : Void
	{
		x = xpos;
		y = ypos;
	}
	
	/**
	 * Sets the size of the component.
	 * @param w The width of the component.
	 * @param h The height of the component.
	 */
	public function setSize(w : Float, h : Float, redraw : Bool = true) : Void
	{
		_width = w;
		_height = h;
		if (redraw) 
			draw();
	}
	
	/**
	 * Abstract draw function.
	 */
	public function draw() : Void
	{
		
	}
	
	/**
	 * Abstract stage resize function.
	 */
	public function onResize() : Void
	{
		move(_x, _y);
	}
	
	///////////////////////////////////
	// public methods
	///////////////////////////////////
	
	/** Remove All Children for this UI component. */
	override public function removeChildren(beginIndex : Int = 0, endIndex : Int = 0x7FFFFFFF) : Void
	{
		while (numChildren > 0)
		{
			removeChildAt(0);
		}
	}
	
	/** Update Anchored X/Y after a drag. */
	override public function stopDrag() : Void
	{
		if (anchor & UIAnchor.CENTER != 0) 
			_x = super.x - Constant.GAME_WIDTH_CENTER;
		else if (anchor & UIAnchor.RIGHT != 0) 
			_x = super.x - Constant.GAME_WIDTH;
		else 
		_x = super.x;
		
		if (anchor & UIAnchor.MIDDLE != 0) 
			_y = super.y - Constant.GAME_HEIGHT_CENTER;
		else if (anchor & UIAnchor.BOTTOM != 0) 
			_y = super.y - Constant.GAME_HEIGHT;
		else 
		_y = super.y;
		
		super.stopDrag();
	}
	
	///////////////////////////////////
	// getter/setters
	///////////////////////////////////
	
	/**
	 * Sets/gets the width of the component.
	 */
	#if flash @:keep @:setter(width) #else override #end
	private function set_width(w : Float) : #if flash Void #else Float #end
	{
		_width = w;
		draw();
		#if !flash return w; #end
	}
	#if flash @:keep @:getter(width) #else override #end
	private function get_width() : Float
	{
		return _width;
	}
	
	/**
	 * Sets/gets the height of the component.
	 */
	#if flash @:keep @:setter(height) #else override #end
	private function set_height(h : Float) : #if flash Void #else Float #end
	{
		_height = h;
		draw();
		#if !flash return h; #end
	}
	
	#if flash @:keep @:getter(height) #else override #end
	private function get_height() : Float
	{
		return _height;
	}
	
	/**
	 * Sets/gets in integer that can identify the component.
	 */
	private function set_tag(value : Dynamic) : Dynamic
	{
		_tag = value;
		return value;
	}
	
	private function get_tag() : Dynamic
	{
		return _tag;
	}
	
	/**
	 * Overrides the getter for x to allow for anchor points.
	 */
	#if flash @:keep @:getter(x) #else override #end
	public function get_x() : Float
	{
		return _x;
	}
	
	/**
	 * Returns the real x position instead of the anchor based x.
	 */
	private function get_real_x() : Float
	{
		return super.x;
	}
	
	/**
	 * Overrides the setter for x to always place the component on a whole pixel and anchors..
	 */
	
	#if flash @:keep @:setter(x) #else override #end
	private function set_x(value:Float) : #if flash Void #else Float #end
	{
		_x = Math.round(value);
		if ((anchor & UIAnchor.CENTER) != 0) 
			super.x = Constant.GAME_WIDTH_CENTER + _x;
		else if ((anchor & UIAnchor.RIGHT) != 0) 
			super.x = Constant.GAME_WIDTH + _x;
		else 
			super.x = _x;
		#if !flash return value; #end
	}
	
	/**
	 * Overrides the getter for y to allow for anchor points.
	 */
	#if flash @:keep @:getter(y) #else override #end
	public function get_y() : Float
	{
		return _y;
	}
	
	/**
	 * Returns the real y position instead of the anchor based y.
	 */
	private function get_real_y() : Float
	{
		return super.y;
	}
	
	/**
	 * Overrides the setter for y to always place the component on a whole pixel and anchors.
	 */
	#if flash @:keep @:setter(y) #else override #end
	public function set_y(value : Float) : #if flash Void #else Float #end
	{
		_y = Math.round(value);
		if ((anchor & UIAnchor.MIDDLE) != 0) 
			super.y = Constant.GAME_HEIGHT_CENTER + _y;
		else if ((anchor & UIAnchor.BOTTOM) != 0) 
			super.y = Constant.GAME_HEIGHT + _y;
		else 
			super.y = _y;
		#if !flash return value; #end
	}
	
	/**
	 * Sets/gets whether this component is enabled or not.
	 */
	private function set_enabled(value : Bool) : Bool
	{
		var ta : Float = alpha;
		_enabled = value;
		mouseEnabled = mouseChildren = tabEnabled = _enabled;
		alpha = ta;
		draw();
		return value;
	}
	
	private function get_enabled() : Bool
	{
		return _enabled;
	}
	
	/**
	 * Overrides the setter for alpha to allow althering of alpha without breaking enabled status.
	 */
	@:getter(alpha) #if !flash override #end
	private function get_alpha() : Float
	{
		return super.alpha * (!(enabled) ? 2 : 1);
	}
	
	/**
	 * Overrides the setter for alpha to allow althering of alpha without breaking enabled status.
	 */
	@:setter(alpha) #if !flash override #end
	private function set_alpha(val : Float) : #if flash Void #else Float #end
	{
		super.alpha = val / (!(enabled) ? 2 : 1);
		#if !flash return val; #end
	}
	
	/**
	 * Gets the currently set anchor point.
	 */
	private function get_anchor() : Int
	{
		return _anchor;
	}
	
	/**
	 * Sets the anchor point for the object to follow when the game stage resizes.
	 * Positioning is relative to the anchor points provided in the UIAnchor class.
	 * Thus being, (0,0) is the anchor point on the stage and not it's real coordinates on stage.
	 */
	private function set_anchor(value : Int) : Int
	{
		Logger.log(this, Logger.INFO, "ANCHOR:"+value);
		_anchor = value;
		(_anchor == (UIAnchor.NONE) ? ResizeListener.removeObject(this) : ResizeListener.addObject(this));
		onResize();
		return value;
	}
}