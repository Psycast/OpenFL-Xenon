package classes.ui;

import flash.events.Event;
import flash.events.FocusEvent;
import flash.text.TextField;
import flash.text.TextFieldType;
import openfl.display.DisplayObjectContainer;
import openfl.text.AntiAliasType;

class BoxInput extends Box
{
	public var text(get, set) : String;
	public var textField(get, never) : TextField;
	public var restrict(get, set) : String;
	public var maxChars(get, set) : Int;
	public var password(get, set) : Bool;

	private var _focus : Bool = false;
	private var _password : Bool = false;
	private var _text : String = "";
	private var _tf : TextField;
	
	public function new(parent : DisplayObjectContainer = null, xpos : Float = 0, ypos : Float = 0, text : String = "", defaultHandler : Null<Dynamic> = null)
	{
		_text = text;
		super(parent, xpos, ypos);
		if (defaultHandler != null) 
		{
			addEventListener(Event.CHANGE, defaultHandler);
		}
	}
	
	/**
	 * Initializes the component.
	 */
	override private function init() : Void
	{
		setSize(100, 16, false);
		super.init();
	}
	
	/**
	 * Creates and adds child display objects.
	 */
	override private function addChildren() : Void
	{
		_tf = new TextField();
		_tf.embedFonts = UIStyle.USE_EMBED_FONTS;
		_tf.selectable = true;
		_tf.type = TextFieldType.INPUT;
		_tf.antiAliasType = AntiAliasType.ADVANCED;
		_tf.defaultTextFormat = UIStyle.getTextFormat(true);
		addChild(_tf);
		_tf.addEventListener(Event.CHANGE, onChange);
		_tf.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
	}
	
	/**
	 * Draws the visual ui of the component.
	 */
	override public function draw() : Void
	{
		super.draw();
		
		_tf.displayAsPassword = _password;
		
		if (_text != null) 
		{
			_tf.text = _text;
		}
		else 
		{
			_tf.text = "";
		}
		_tf.width = _width - 4;
		if (_tf.text == "") 
		{
			_tf.text = "X";
			_tf.height = Math.min(_tf.textHeight + 4, _height);
			_tf.text = "";
		}
		else 
		{
			_tf.height = Math.min(_tf.textHeight + 4, _height);
		}
		_tf.x = 2;
		_tf.y = Math.round(_height / 2 - _tf.height / 2);
	}
	
	///////////////////////////////////
	// event handlers
	///////////////////////////////////
	
	/**
	 * Internal change handler.
	 * @param event The Event passed by the system.
	 */
	private function onChange(event : Event) : Void
	{
		_text = _tf.text;
		event.stopImmediatePropagation();
		dispatchEvent(event);
	}
	
	/**
	 * Internal focus handler.
	 * @param event The Event passed by the system.
	 */
	private function onFocusIn(event : Event) : Void
	{
		_focus = true;
		_tf.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
		draw();
	}
	
	/**
	 * Internal focus handler.
	 * @param event The Event passed by the system.
	 */
	private function onFocusOut(event : Event) : Void
	{
		_focus = false;
		_tf.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
		draw();
	}
	
	///////////////////////////////////
	// getter/setters
	///////////////////////////////////
	
	/**
	 * Gets / sets the text shown in this InputText.
	 */
	private function set_text(t : String) : String
	{
		_text = t;
		if (_text == null) 
			_text = "";
		draw();
		return t;
	}
	
	private function get_text() : String
	{
		return _text;
	}
	
	/**
	 * Returns a reference to the internal text field in the component.
	 */
	private function get_textField() : TextField
	{
		return _tf;
	}
	
	override private function get_highlight() : Bool
	{
		return super.highlight || _focus;
	}
	
	override private function set_highlight(value : Bool) : Bool
	{
		super.highlight = value;
		return value;
	}
	
	/**
	 * Gets / sets the list of characters that are allowed in this TextInput.
	 */
	private function set_restrict(str : String) : String
	{
		_tf.restrict = str;
		return str;
	}
	
	private function get_restrict() : String
	{
		return _tf.restrict;
	}
	
	/**
	 * Gets / sets the maximum number of characters that can be shown in this InputText.
	 */
	private function set_maxChars(max : Int) : Int
	{
		_tf.maxChars = max;
		return max;
	}
	
	private function get_maxChars() : Int
	{
		return _tf.maxChars;
	}
	
	/**
	 * Gets / sets whether or not this input text will show up as password (asterisks).
	 */
	private function set_password(b : Bool) : Bool
	{
		_password = b;
		draw();
		return b;
	}
	
	private function get_password() : Bool
	{
		return _password;
	}
	
	/**
	 * Sets/gets whether this component is enabled or not.
	 */
	override private function set_enabled(value : Bool) : Bool
	{
		super.enabled = value;
		_tf.tabEnabled = value;
		return value;
	}
}