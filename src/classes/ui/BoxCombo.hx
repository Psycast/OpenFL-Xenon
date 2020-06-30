package classes.ui;

import TypeDefinitions;
import classes.engine.EngineCore;
import classes.ui.BoxComboOverlay;
import flash.events.MouseEvent;
import flash.text.TextFieldAutoSize;
import openfl.display.DisplayObjectContainer;


class BoxCombo extends BoxButton
{
	public var selectedIndex(get, set) : Dynamic;
	public var options(get, set) : Array<ComboOptionDef>;

	private var core : EngineCore;
	private var handler : Null<Dynamic>;
	private var _selectedIndex : Int = 0;
	public var _options : Array<ComboOptionDef>;
	public var overlayPosition : Int = UIAnchor.TOP_CENTER;
	public var title : String = "";
	
	/**
	 * User selectable combo box containing a set of options.
	 * @param	core Engine core to use.
	 * @param	parent Display parent to use.
	 * @param	xpos X Position
	 * @param	ypos Y Position
	 * @param	label Default Label for box.
	 * @param	defaultHandler Function handler for for value change events.
	 * @tiptext
	 */
	public function new(core : EngineCore, parent : DisplayObjectContainer = null, xpos : Float = 0, ypos : Float = 0, label : String = "", defaultHandler : Null<Dynamic> = null)
	{
		this.core = core;
		this.handler = defaultHandler;
		super(parent, xpos, ypos, label);
	}
	
	/**
	 * Creates and adds child display objects.
	 */
	override private function addChildren() : Void
	{
		mouseChildren = false;
		super.addChildren();
		_label.autoSize = TextFieldAutoSize.LEFT;
		addEventListener(MouseEvent.CLICK, e_clickDown);
	}
	
	/**
	 * Draws the box background.
	 */
	override public function drawBox() : Void
	{
		super.drawBox();
		
		graphics.moveTo(width - 21, 0);
		graphics.lineTo(width - 21, height);
		
		graphics.lineStyle(1, 0xFFFFFF, 0);
		graphics.beginFill(0xFFFFFF, 0.55);
		graphics.moveTo(width - 16, (height / 2) - 3);
		graphics.lineTo(width - 4, (height / 2) - 3);
		graphics.lineTo(width - 10, (height / 2) + 5);
		graphics.moveTo(width - 16, (height / 2) - 3);
		graphics.endFill();
	}
	
	///////////////////////////////////
	// event handlers
	///////////////////////////////////
	
	/**
	 * Event: Mouse Down
	 * @param	e
	 */
	private function e_clickDown(e : MouseEvent) : Void
	{
		if (options != null && options.length > 0) 
		{
			core.addOverlay(new BoxComboOverlay(title, options, e_overlayReturn, overlayPosition));
		}
	}
	
	/**
	 * Event: Overlay Closed
	 * @param	e Object containing selected value.
	 */
	private function e_overlayReturn(e : ComboOptionDef) : Void
	{
		selectedIndex = e.value;
		if (handler != null) 
		{
			handler(e);
		}
	}
	
	///////////////////////////////////
	// getter/setters
	///////////////////////////////////
	/**
	 * Gets the currently selected index.
	 */
	private function get_selectedIndex() : Int
	{
		return _selectedIndex;
	}
	
	/**
	 * Sets the current index to the provided number or matching string.
	 */
	private function set_selectedIndex(i : Dynamic) : Dynamic
	{
		if (options == null || options.length == 0) 
			return i;
		
		if (Std.is(i, Int) || Std.is(i, Float)) 
		{
			if (i < 0 || i >= options.length) 
				return i;
			
			label = options[i].label;
			_selectedIndex = i;
			return i;
		}
		else 
		{
			for (j in 0...options.length)
			{
				if (options[j].value == i) 
				{
					label = options[j].label;
					_selectedIndex = j;
					break;
				}
			}
			return i;
		}
		label = options[0].label;
		_selectedIndex = 0;
		return i;
	}
	
	/**
	 * Gets the current options.
	 */
	private function get_options() : Array<ComboOptionDef>
	{
		return _options;
	}
	
	/**
	 * Sets the combo box options.
	 */
	private function set_options(newOptions : Array<ComboOptionDef>) : Array<ComboOptionDef>
	{
		_options = newOptions;
		return newOptions;
	}
	
	static public function fromStringArray(inputStrings:Array<String>) 
	{
		var options : Array<ComboOptionDef> = [];
		for (i in 0...inputStrings.length){
			options.push({
				label: inputStrings[i],
				value: inputStrings[i]
			});
		}
		
		return options;
	}
}