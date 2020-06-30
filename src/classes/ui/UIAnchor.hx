package classes.ui;


import flash.text.TextFieldAutoSize;

class UIAnchor
{
	public static inline var NONE : Int = 0;
	public static inline var TOP : Int = 1;
	public static inline var MIDDLE : Int = 2;
	public static inline var BOTTOM : Int = 4;
	public static inline var LEFT : Int = 8;
	public static inline var CENTER : Int = 16;
	public static inline var RIGHT : Int = 32;
	
	public static inline var TOP_LEFT : Int = 9;
	public static inline var TOP_CENTER : Int = 17;
	public static inline var TOP_RIGHT : Int = 33;
	public static inline var MIDDLE_LEFT : Int = 10;
	public static inline var MIDDLE_CENTER : Int = 18;
	public static inline var MIDDLE_RIGHT : Int = 34;
	public static inline var BOTTOM_LEFT : Int = 12;
	public static inline var BOTTOM_CENTER : Int = 20;
	public static inline var BOTTOM_RIGHT : Int = 36;
	
	public static var ALIGNMENTS_A : Array<Dynamic> = [TOP_LEFT, TOP_CENTER, TOP_RIGHT, MIDDLE_LEFT, MIDDLE_CENTER, MIDDLE_RIGHT, BOTTOM_LEFT, BOTTOM_CENTER, BOTTOM_RIGHT];
	public static var ALIGNMENTS_V : Array<Dynamic> = [TOP, MIDDLE, BOTTOM];
	public static var ALIGNMENTS_H : Array<Dynamic> = [LEFT, CENTER, RIGHT];
	
	/**
	 * Returns a value based on the alignment. [0, (value/2), value]
	 * @param	alignment Anchor value of TOP,MIDDLE,BOTTOM
	 * @param	value Value to use for MIDDLE and BOTTOM alignments.
	 * @return int
	 */
	public static function getOffsetV(alignment : Int, value : Float) : Int
	{
		if (alignment & MIDDLE != 0) 
			return Math.floor( -(value / 2));
		else if (alignment & BOTTOM != 0) 
			return Math.floor( -(value));
		return 0;
	}
	
	/**
	 * Returns a value based on the alignment. [0, (value/2), value]
	 * @param	alignment Anchor value of LEFT,CENTER,RIGHT
	 * @param	value Value to use for CENTER and RIGHT alignments.
	 * @return int
	 */
	public static function getOffsetH(alignment : Int, value : Float) : Int
	{
		if (alignment & CENTER != 0) 
			return Math.floor( -(value / 2));
		else if (alignment & RIGHT != 0) 
			return Math.floor( -(value));
		return 0;
	}
	/**
	 * Returns text alignment based on anchor point.
	 * @param	alignment Anchor value of LEFT,CENTER,RIGHT
	 * @param	value Value to use for CENTER and RIGHT alignments.
	 * @return int
	 */
	public static function getTextAutoSize(alignment : Int) : TextFieldAutoSize
	{
		if (alignment & CENTER != 0) 
			return TextFieldAutoSize.CENTER
		else if (alignment & RIGHT != 0) 
			return TextFieldAutoSize.RIGHT;
		return TextFieldAutoSize.LEFT;
	}
}

