package classes.ui;

import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import motion.Actuate;

class VScrollBar extends UIComponent
{
	public var scroll(get, set) : Float;
	public var scrollFactor(get, set) : Float;
	public var showDragger(get, set) : Bool;

	private var _lastScroll : Float = 0;
	private var _scrollFactor : Float = 0.5;
	
	private var _dragger : Sprite;
	
	public function new(parent : DisplayObjectContainer = null, xpos : Float = 0, ypos : Float = 0)
	{
		super(parent, xpos, ypos);
	}
	
	/**
	 * Initializes the component.
	 */
	override private function init() : Void
	{
		setSize(15, 100, false);
		super.init();
	}
	
	/**
	 * Creates and adds the child display objects of this component.
	 */
	override private function addChildren() : Void
	{
		_dragger = new Sprite();
		_dragger.buttonMode = true;
		addChild(_dragger);
		
		_dragger.addEventListener(MouseEvent.MOUSE_DOWN, e_startDrag);
	}
	
	///////////////////////////////////
	// public methods
	///////////////////////////////////
	
	/**
	 * Draws the visual ui of the component.
	 */
	override public function draw() : Void
	{
		this.graphics.clear();
		this.graphics.beginFill(0xffffff, 0.1);
		this.graphics.drawRect(0, 0, width, height);
		this.graphics.endFill();
		
		_dragger.graphics.clear();
		_dragger.graphics.lineStyle(1, 0xffffff, 0.5);
		_dragger.graphics.beginFill(0xffffff, 0.25);
		_dragger.graphics.drawRect(0, 0, width - 1, Math.max(height * scrollFactor, 30));
		_dragger.graphics.endFill();
		
		scroll = _lastScroll;
	}
	
	///////////////////////////////////
	// event handlers
	///////////////////////////////////
	
	private function e_startDrag(e : MouseEvent) : Void
	{
		stage.addEventListener(MouseEvent.MOUSE_UP, e_stopDrag);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, e_mouseMove);
		_dragger.startDrag(false, new Rectangle(0, 0, 0, height - _dragger.height));
	}
	
	private function e_stopDrag(e : MouseEvent) : Void
	{
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, e_mouseMove);
		stage.removeEventListener(MouseEvent.MOUSE_UP, e_stopDrag);
		_dragger.stopDrag();
		_lastScroll = _dragger.y / (height - 1 - _dragger.height);
		this.dispatchEvent(new Event(Event.CHANGE));
	}
	
	private function e_mouseMove(e : MouseEvent) : Void
	{
		_lastScroll = _dragger.y / (height - 1 - _dragger.height);
		this.dispatchEvent(new Event(Event.CHANGE));
	}
	
	///////////////////////////////////
	// getter/setters
	///////////////////////////////////
	
	/**
	 * Returns the current scroll percent.
	 */
	private function get_scroll() : Float
	{
		return _lastScroll;
	}
	
	/**
	 * Sets the current scroll percent.
	 * @param percent Range of 0-1
	 */
	private function set_scroll(val : Float) : Float
	{
		if (UIStyle.USE_ANIMATION) 
			Actuate.tween(_dragger, 0.25, { y : ((height - _dragger.height) * Math.max(Math.min(val, 1), 0)) } );
		else 
			_dragger.y = (height - _dragger.height) * Math.max(Math.min(val, 1), 0);
		_lastScroll = Math.max(Math.min(val, 1), 0);
		this.dispatchEvent(new Event(Event.CHANGE));
		return val;
	}
	
	/**
	 * Gets the current scroll factor.
	 * Scroll factor is the percent of the height the dragger should be displayed as.
	 */
	private function get_scrollFactor() : Float
	{
		return _scrollFactor;
	}
	
	/**
	 * Sets the scroll factor for the dragger to use.
	 */
	private function set_scrollFactor(value : Float) : Float
	{
		_scrollFactor = value;
		draw();
		return value;
	}
	
	/**
	 * Returns if the dragger is visible.
	 */
	private function get_showDragger() : Bool
	{
		return _dragger.visible;
	}
	
	/**
	 * Show / Hide the dragger.
	 */
	private function set_showDragger(value : Bool) : Bool
	{
		_dragger.visible = value;
		return value;
	}
}