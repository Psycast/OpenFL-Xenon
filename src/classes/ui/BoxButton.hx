package classes.ui;

import classes.ui.Label;
import com.flashfla.utils.ObjectUtil;
import haxe.Constraints.Function;
import openfl.display.DisplayObjectContainer;

import flash.events.MouseEvent;
import flash.text.TextFieldAutoSize;

class BoxButton extends Box
{
	public var label(get, set) : String;
	public var fontSize(never, set) : Int;

	private var _label : Label;
	private var _label_text : String = "";
	private var _over : Bool = false;
	private var _down : Bool = false;
	
	public function new(parent : DisplayObjectContainer = null, xpos : Float = 0, ypos : Float = 0, label : String = "", defaultHandler : Null<Dynamic> = null)
	{
		this._label_text = label;
		super(parent, xpos, ypos);
		if (defaultHandler != null) 
		{
			addEventListener(MouseEvent.CLICK, defaultHandler);
		}
	}
	
	/**
	 * Initializes the component.
	 */
	override private function init() : Void
	{
		buttonMode = true;
		useHandCursor = true;
		mouseChildren = false;
		setSize(100, 20, false);
		super.init();
	}
	
	/**
	 * Creates and adds the child display objects of this component.
	 */
	override private function addChildren() : Void
	{
		_label = new Label(this, 3, 0, _label_text, ObjectUtil.containsHtml(_label_text));
		_label.autoSize = TextFieldAutoSize.CENTER;
		addChild(_label);
		
		addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
	}
	
	/**
	 * Draws the visual ui of the component.
	 */
	override public function draw() : Void
	{
		super.draw();
		_label.setSize(width - 6, height + 1);
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
	private function get_label() : String
	{
		return _label_text;
	}
	
	private function set_label(val : String) : String
	{
		_label.text = _label_text = val;
		return val;
	}
	
	override private function get_highlight() : Bool
	{
		return enabled && (super.highlight || _over);
	}
	
	private function set_fontSize(size : Int) : Int
	{
		_label.fontSize = size;
		return size;
	}
}