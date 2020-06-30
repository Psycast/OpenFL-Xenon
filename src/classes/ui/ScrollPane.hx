package classes.ui;

import classes.ui.UIComponent;
import motion.Actuate;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;

import flash.geom.Rectangle;

class ScrollPane extends UIComponent
{
	public var scrollVertical(get, set) : Float;
	public var scrollHorizontal(get, set) : Float;
	public var scrollFactorVertical(get, never) : Float;
	public var scrollFactorHorizontal(get, never) : Float;
	public var doScrollVertical(get, never) : Bool;
	public var doScrollHorizontal(get, never) : Bool;
	public var contentHeight(get, never) : Float;
	public var contentWidth(get, never) : Float;
	public var content(get, never) : Sprite;

	public var _content : Sprite;
	
	public function new(parent : DisplayObjectContainer = null, xpos : Float = 0, ypos : Float = 0)
	{
		super(parent, xpos, ypos);
	}
	
	/**
	 * Initializes the component.
	 */
	override private function init() : Void
	{
		setSize(150, 100, false);
		super.init();
		scrollRect = new Rectangle(0, 0, width + 1, height);
	}
	
	/**
	 * Sets the size of the component.
	 * @param w The width of the component.
	 * @param h The height of the component.
	 */
	override public function setSize(w : Float, h : Float, redraw : Bool = true) : Void
	{
		scrollRect = new Rectangle(0, 0, w + 1, h);
		super.setSize(w, h, redraw);
	}
	
	/**
	 * Creates and adds the child display objects of this component.
	 */
	override private function addChildren() : Void
	{
		_content = new Sprite();
		super.addChild(_content);
		_content.x = 0;
		_content.y = 0;
		draw();
	}
	
	override public function addChild(child : DisplayObject) : DisplayObject
	{
		_content.addChild(child);
		
		// Update Visibility
		var maskY : Float = _content.y * -1;
		child.visible = ((child.y >= maskY || child.y + child.height >= maskY) && child.y < maskY + this.height);
		
		return child;
	}
	
	override public function removeChild(child : DisplayObject) : DisplayObject
	{
		return _content.removeChild(child);
	}
	
	/**
	 * Draws the visual ui of the component.
	 */
	override public function draw() : Void
	{
		this.graphics.clear();
		//this.graphics.lineStyle(1, 0xFF0000);
		this.graphics.beginFill(0x000000, 0);
		this.graphics.drawRect(0, 0, width, height);
		this.graphics.endFill();
		updateChildrenVisibility();
	}
	
	///////////////////////////////////
	// public methods
	///////////////////////////////////
	
	/**
	 * Remove All Children for this UI component.
	 */
	override public function removeChildren(beginIndex : Int = 0, endIndex : Int = 0x7FFFFFFF) : Void
	{
		while (_content.numChildren > 0)
		{
			_content.removeChildAt(0);
		}
	}
	
	///////////////////////////////////
	// private methods
	///////////////////////////////////
	
	private function updateChildrenVisibility() : Void
	{
		var maskX : Float = _content.x * -1;
		var maskY : Float = _content.y * -1;
		var _children : Int = _content.numChildren;
		var _child : DisplayObject;
		for (i in 0..._children){
			_child = _content.getChildAt(i);
			_child.visible = ((_child.x >= maskX || _child.x + _child.width >= maskX) && _child.x < maskX + this.width)
					&& ((_child.y >= maskY || _child.y + _child.height >= maskY) && _child.y < maskY + this.height);
		}
	}
	
	///////////////////////////////////
	// getter/setters
	///////////////////////////////////
	
	/**
	 * Sets the width of the component.
	 */
	#if flash @:setter(width) #end
	override private function set_width(w : Float) : #if flash Void #else Float #end
	{
		scrollRect = new Rectangle(0, 0, w, height);
		super.width = w;
		#if !flash return w; #end
	}
	
	/**
	 * Sets the height of the component.
	 */
	#if flash @:setter(height) #end
	override private function set_height(h : Float) : #if flash Void #else Float #end
	{
		scrollRect = new Rectangle(0, 0, width + 1, h);
		super.height = h;
		#if !flash return h; #end
	}
	
	public function scroll(v : Float, h : Float) : Void
	{
		scrollVertical = v;
		scrollHorizontal = h;
	}
	
	/**
	 * Returns the current vertical scroll percent.
	 */
	private function get_scrollVertical() : Float
	{
		return -_content.y / (contentHeight - this.height);
	}
	
	/**
	 * Sets the current vertical scroll percent.
	 * @param percent Range of 0-1
	 */
	private function set_scrollVertical(val : Float) : Float
	{
		if (UIStyle.USE_ANIMATION)
		{
			Actuate.tween(content, 0.25, {
					y : -((contentHeight - this.height) * Math.max(Math.min(val, 1), 0))
				}).onUpdate(updateChildrenVisibility).onComplete(updateChildrenVisibility);
		}
		else 
			_content.y = -((contentHeight - this.height) * Math.max(Math.min(val, 1), 0));
		updateChildrenVisibility();
		return val;
	}
	
	/**
	 * Returns the current horizontal scroll percent.
	 */
	private function get_scrollHorizontal() : Float
	{
		return -_content.x / (contentWidth - this.width);
	}
	
	/**
	 * Sets the current horizontal scroll percent.
	 * @param percent Range of 0-1
	 */
	private function set_scrollHorizontal(val : Float) : Float
	{
		if (UIStyle.USE_ANIMATION) 
			Actuate.tween(content, 0.25, {
					x : -((contentWidth - this.width) * Math.max(Math.min(val, 1), 0))
				}).onUpdate(updateChildrenVisibility).onComplete(updateChildrenVisibility);
		else 
			_content.x = -((contentWidth - this.width) * Math.max(Math.min(val, 1), 0));
		updateChildrenVisibility();
		return val;
	}
	
	/**
	 * Gets the scroll values required to display a specified child.
	 * @param	child Child to show.
	 * @return	Scroll Value required to show child in center of scroll pane.
	 */
	public function scrollChild(child : DisplayObject) : Array<Dynamic>
	{
		return [scrollChildVertical(child), scrollChildHorizontal(child)];
	}
	
	/**
	 * Gets the vertical scroll value required to display a specified child.
	 * @param	child Child to show.
	 * @return	Scroll Value required to show child in center of scroll pane.
	 */
	public function scrollChildVertical(child : DisplayObject) : Float
	{
		// Checks
		if (child == null || !_content.contains(child) || !doScrollVertical) 
			return 0;
			
		// Child to Tall, Scroll to top.
		if (child.height > height) 
			return Math.max(Math.min(child.y / (contentHeight - this.height), 1), 0);
		
		return Math.max(Math.min(((child.y + (child.height / 2)) - (this.height / 2)) / (contentHeight - this.height), 1), 0);
	}
	
	/**
	 * Gets the horizontal scroll value required to display a specified child.
	 * @param	child Child to show.
	 * @return	Scroll Value required to show child in center of scroll pane.
	 */
	public function scrollChildHorizontal(child : DisplayObject) : Float
	{
		// Checks
		if (child == null || !_content.contains(child) || !doScrollHorizontal) 
			return 0;
			
		// Child to Tall, Scroll to top.
		if (child.width > width) 
			return Math.max(Math.min(child.x / (contentWidth - this.width), 1), 0);
		
		return Math.max(Math.min(((child.x + (child.width / 2)) - (this.width / 2)) / (contentWidth - this.width), 1), 0);
	}
	
	/**
	 * Gets the current vertical scroll factor.
	 * Scroll factor is the percent of the height the scrollpane is compared to the overall content height.
	 */
	private function get_scrollFactorVertical() : Float
	{
		if (contentHeight == 0 || height == 0)
			return 0;
			
		return Math.max(Math.min(height / contentHeight, 1), 0);
	}
	
	/**
	 * Gets the current horizontal scroll factor.
	 * Scroll factor is the percent of the width the scrollpane is compared to the overall content width.
	 */
	private function get_scrollFactorHorizontal() : Float
	{
		if (contentWidth == 0 || width == 0)
			return 0;
			
		return Math.max(Math.min(width / contentWidth, 1), 0);
	}
	
	/**
	 * Gets if the content height is taller then the scrollpane height visible area.
	 */
	private function get_doScrollVertical() : Bool
	{
		return contentHeight > height;
	}
	
	/**
	 * Gets if the content width is taller then the scrollpane width visible area.
	 */
	private function get_doScrollHorizontal() : Bool
	{
		return contentWidth > width;
	}
	
	/**
	 * Gets the overall content height.
	 */
	private function get_contentHeight() : Float
	{
		var bottom:Float = _content.getBounds(_content).bottom;
		return !Math.isNaN(bottom) ? bottom : 0;
	}
	
	/**
	 * Gets the overall content width.
	 */
	private function get_contentWidth() : Float
	{
		var right:Float = _content.getBounds(_content).right;
		return !Math.isNaN(right) ? right : 0;
	}
	
	private function get_content() : Sprite
	{
		return _content;
	}
}