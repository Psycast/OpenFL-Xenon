package classes.ui;

import classes.ui.UIComponent;
import classes.ui.VScrollBar;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;

import flash.events.Event;
import flash.events.MouseEvent;

class ScrollPaneBars extends UIComponent
{
	public var paneWidth(get, never) : Float;
	public var paneHeight(get, never) : Float;
	public var content(get, never) : Sprite;
	public var verticalBar(get, never) : VScrollBar;
	public var useVerticalBar(get, set) : Bool;
	public var horizontalBar(get, never) : HScrollBar;
	public var useHorizontalBar(get, set) : Bool;
	
	public var _pane : ScrollPane;
	private var _vscroll : VScrollBar;
	private var _hscroll : HScrollBar;
	private var _useVerticalBar : Bool;
	private var _useHorizontalBar : Bool;
	
	public function new(parent : DisplayObjectContainer = null, xpos : Float = 0, ypos : Float = 0, useVertical : Bool = true, useHorizontal : Bool = false)
	{
		_useVerticalBar = useVertical;
		_useHorizontalBar = useHorizontal;
		super(parent, xpos, ypos);
	}
	
	override private function addChildren() : Void
	{
		_pane = new ScrollPane();
		_pane.addEventListener(MouseEvent.MOUSE_WHEEL, e_scrollWheel);
		super.addChild(_pane);
		
		_vscroll = new VScrollBar();
		_vscroll.addEventListener(Event.CHANGE, e_scrollVerticalUpdate);
		super.addChild(_vscroll);
		
		_hscroll = new HScrollBar();
		_hscroll.addEventListener(Event.CHANGE, e_scrollHorizontalUpdate);
		super.addChild(_hscroll);
	}
	
	override public function addChild(child : DisplayObject) : DisplayObject
	{
		return _pane.addChild(child);
	}
	
	override public function removeChild(child : DisplayObject) : DisplayObject
	{
		_pane.removeChild(child);
		
		if (!_pane.doScrollVertical) 
			_vscroll.scroll = 0;
		if (!_pane.doScrollHorizontal) 
			_hscroll.scroll = 0;
		
		return child;
	}
	
	override public function draw() : Void
	{
		if (_width == 0 || _height == 0)
			return;
			
		_pane.setSize(_width, _height);
		
		if (useHorizontalBar) 
		{
			if (_pane.doScrollHorizontal) 
			{
				_pane.height = _height - 20;
			}
			_hscroll.setSize(_pane.width, 15);
			_hscroll.move(0, _height - 15);
		}
		if (useVerticalBar) 
		{
			if (_pane.doScrollVertical) 
			{
				_pane.width = _pane.width - 20;
			}
			_vscroll.setSize(15, _pane.height);
			_vscroll.move(_width - 15, 0);
		}
		if (useHorizontalBar && useVerticalBar) 
		{
			if (_pane.doScrollVertical && _pane.doScrollHorizontal) 
			{
				_hscroll.width = _pane.width;
			}
		}
		scrollUpdate();
	}
	
	///////////////////////////////////
	// public methods
	///////////////////////////////////
	
	/**
	 * Remove All Children for this UI component.
	 */
	override public function removeChildren(beginIndex : Int = 0, endIndex : Int = 0x7FFFFFFF) : Void
	{
		_pane.removeChildren(beginIndex, endIndex);
	}
	
	public function scrollUpdate() : Void
	{
		_vscroll.visible = useVerticalBar && _pane.doScrollVertical;
		_hscroll.visible = useHorizontalBar && _pane.doScrollHorizontal;
		
		if (useVerticalBar) 
		{
			_vscroll.scrollFactor = _pane.scrollFactorVertical;
			_vscroll.scroll = _pane.scrollVertical;
		}
		if (useHorizontalBar) 
		{
			_hscroll.scrollFactor = _pane.scrollFactorHorizontal;
			_hscroll.scroll = _pane.scrollHorizontal;
		}
	}
	
	public function scrollChild(child : DisplayObject) : Void
	{
		var pos : Array<Dynamic> = _pane.scrollChild(child);
		if (useVerticalBar) 
			_vscroll.scroll = pos[0];
		if (useHorizontalBar) 
			_hscroll.scroll = pos[1];
	}
	
	public function scrollReset() : Void
	{
		if (!useVerticalBar || (useVerticalBar && !_pane.doScrollVertical)) 
			_vscroll.scroll = 0;
		if (!useHorizontalBar || (useHorizontalBar && !_pane.doScrollHorizontal)) 
			_hscroll.scroll = 0;
	}
	
	///////////////////////////////////
	// event handlers
	///////////////////////////////////
	
	private function e_scrollWheel(e : MouseEvent) : Void
	{
		if (useVerticalBar && _pane.doScrollVertical) 
			_vscroll.scroll += (_pane.scrollFactorVertical / 2) * (e.delta > (1) ? -1 : 1);
	}
	
	private function e_scrollVerticalUpdate(e : Event) : Void
	{
		_pane.scrollVertical = _vscroll.scroll;
	}
	
	private function e_scrollHorizontalUpdate(e : Event) : Void
	{
		_pane.scrollHorizontal = _hscroll.scroll;
	}
	
	///////////////////////////////////
	// getter/setters
	///////////////////////////////////
	
	private function get_paneWidth() : Float
	{
		return _pane.width - 1;
	}
	
	private function get_paneHeight() : Float
	{
		return _pane.height - 1;
	}
	
	private function get_content() : Sprite
	{
		return _pane.content;
	}
	
	private function get_verticalBar() : VScrollBar
	{
		return _vscroll;
	}
	
	private function get_useVerticalBar() : Bool
	{
		return _useVerticalBar;
	}
	
	private function set_useVerticalBar(value : Bool) : Bool
	{
		_useVerticalBar = value;
		draw();
		return value;
	}
	
	private function get_horizontalBar() : HScrollBar
	{
		return _hscroll;
	}
	
	private function get_useHorizontalBar() : Bool
	{
		return _useHorizontalBar;
	}
	
	private function set_useHorizontalBar(value : Bool) : Bool
	{
		_useHorizontalBar = value;
		draw();
		return value;
	}
}
