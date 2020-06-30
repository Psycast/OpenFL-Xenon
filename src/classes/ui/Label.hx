package classes.ui;

import classes.ui.UIComponent;
import openfl.display.DisplayObjectContainer;
import openfl.text.AntiAliasType;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;


class Label extends UIComponent
{
	public var text(get, set) : String;
	public var formatted_text(get, never) : String;
	public var htmlText(get, set) : String;
	public var autoSize(get, set) : TextFieldAutoSize;
	public var textField(get, never) : TextField;
	public var fontSize(get, set) : Null<Int>;

	private var DEFAULT_FONT_SIZE : Null<Int> = UIStyle.FONT_SIZE;
	private var RESET_FONT_SIZE : Null<Int> = UIStyle.FONT_SIZE;
	private var _useHtml : Bool = false;
	private var _useArea : Bool = false;
	private var _autoSize : TextFieldAutoSize = TextFieldAutoSize.LEFT;
	private var _fontSize : Null<Int> = 14;
	private var _text : String = "";
	private var _tf : TextField;
	
	private var _textformat : TextFormat;
	
	public function new(parent : DisplayObjectContainer = null, xpos : Float = 0, ypos : Float = 0, text : String = "", useHtml : Bool = false)
	{
		_useHtml = useHtml;
		_text = text;
		super(parent, xpos, ypos);
	}
	
	/**
	 * Initializes the component.
	 */
	override private function init() : Void
	{
		_textformat = UIStyle.getTextFormat(UIStyle.textIsUnicode(text));
		mouseEnabled = false;
		mouseChildren = false;
		super.init();
	}
	
	/**
	 * Creates and adds the child display objects of this component.
	 */
	override private function addChildren() : Void
	{
		_height = 18;
		_tf = new TextField();
		_tf.embedFonts = UIStyle.USE_EMBED_FONTS;
		_tf.selectable = false;
		_tf.mouseEnabled = false;
		_tf.defaultTextFormat = _textformat;
		_tf.autoSize = TextFieldAutoSize.LEFT;
		_tf.antiAliasType = AntiAliasType.ADVANCED;
		//_tf.border = true;
		addChild(_tf);
		draw();
	}
	
	/**
	 * Sets the size of the component.
	 * @param w The width of the component.
	 * @param h The height of the component.
	 */
	override public function setSize(w : Float, h : Float, redraw : Bool = true) : Void
	{
		if (w != _width || h != _height) 
		{
			if (w > _width)
				_fontSize = RESET_FONT_SIZE;
			if (h > height) 
				_fontSize = RESET_FONT_SIZE;
			_useArea = true;
			_width = w;
			_height = h;
			
			if (redraw) 
				draw();
		}
	}
	
	/**
	 * Draws the visual ui of the component.
	 */
	override public function draw() : Void
	{
		super.draw();
		
		_tf.htmlText = formatted_text;
		
		// Adjust sizes
		if (_useArea) 
		{
			//- Fit Witin Area
			while (_tf.width > width)
			{
				if (_fontSize <= 1) 
					break;
					
				_fontSize--;
				_tf.htmlText = formatted_text;
			}
			
			_height = Math.max(_height, _tf.height);
			
			//- Text Alignment Vertical
			_tf.y = ((height - _tf.height) / 2);
		}
		
		//- Text Alignment to Area
		if (_autoSize == TextFieldAutoSize.LEFT)
			_tf.x = 0;
		else if (_autoSize == TextFieldAutoSize.CENTER)
			_tf.x = ((width - _tf.width) / 2);
		else if (_autoSize == TextFieldAutoSize.RIGHT)
			_tf.x = (width - _tf.width);
		
		// Draw Click Area
		this.graphics.clear();
		this.graphics.beginFill(0, 0);
		//this.graphics.lineStyle(1, 0x00FFFF, 1);
		this.graphics.drawRect(0, 0, width, height);
		this.graphics.endFill();
	}
	
	///////////////////////////////////
	// getter/setters
	///////////////////////////////////
	
	/**
	 * Sets/gets the width of the component.
	 */
	@:setter(width)
	override private function set_width(w : Float) : #if flash Void #else Float #end
	{
		if (w > _width)
			_fontSize = RESET_FONT_SIZE;
		_useArea = true;
		_width = w;
		draw();
		#if !flash return w; #end
	}
	
	/**
	 * Sets/gets the height of the component.
	 */
	@:setter(height)
	override private function set_height(h : Float) : #if flash Void #else Float #end
	{
		if (h > height) 
			_fontSize = RESET_FONT_SIZE;
		_useArea = true;
		_height = h;
		draw();
		#if !flash return h; #end
	}
	
	/**
	 * Gets / sets the text of this Label.
	 */
	private function set_text(t : String) : String
	{
		_useHtml = false;
		_textSet(t);
		return t;
	}
	
	private function get_text() : String
	{
		return _text;
	}
	
	private function get_formatted_text() : String
	{
		#if html5
			var fontTag:Int = text.indexOf("<font");
			if (fontTag != -1 && _useHtml)
			{
				return text.substring(0, fontTag+5) + " size=\"" + _fontSize + "px\"" + text.substr(fontTag+5);
			}
			return "<font size=\"" + _fontSize + "px\">" + (_useHtml ? text : StringTools.htmlEscape(text)) + "</font>";
		#else
			if (_fontSize != DEFAULT_FONT_SIZE)
			{
				return "<font size=\"" + _fontSize + "px\">" + (_useHtml ? text : StringTools.htmlEscape(text)) + "</font>";
			}
			return (_useHtml ? text : StringTools.htmlEscape(text));
		#end
	}
	/**
	 * Gets / sets the html text of this Label.
	 */
	private function set_htmlText(t : String) : String
	{
		_useHtml = true;
		_textSet(t);
		return t;
	}
	
	private function get_htmlText() : String
	{
		return _text;
	}
	
	/**
	 * Sets the text variable from tet and htmlText.
	 * @param	t
	 */
	private function _textSet(t : String) : Void
	{
		_text = t;
		if (_text == null) 
			_text = "";
		
		draw();
	}
	
	/**
	 * Gets / sets whether or not this Label will autosize.
	 */
	private function set_autoSize(auto : TextFieldAutoSize) : TextFieldAutoSize 
	{
		_autoSize = auto;
		draw();
		return auto;
	}
	
	private function get_autoSize() : TextFieldAutoSize
	{
		return _autoSize;
	}
	
	/**
	 * Gets the internal TextField of the label if you need to do further customization of it.
	 */
	private function get_textField() : TextField
	{
		return _tf;
	}
	
	private function get_fontSize() : Null<Int>
	{
		return _textformat != null ? _textformat.size : UIStyle.FONT_SIZE;
	}
	
	private function set_fontSize(value : Null<Int>) : Null<Int>
	{
		var def : TextFormat = UIStyle.getTextFormat(UIStyle.textIsUnicode(text));
		if (value == DEFAULT_FONT_SIZE) 
		{
			_textformat = def;
		}
		else 
		{
			_textformat = new TextFormat();
			_textformat.font = def.font;
			_textformat.color = def.color;
			_textformat.size = value;
		}
		RESET_FONT_SIZE = value;
		_fontSize = value;
		draw();
		return value;
	}
}