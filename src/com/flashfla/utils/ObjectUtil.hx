package com.flashfla.utils;


import flash.geom.ColorTransform;
import flash.utils.ByteArray;

class ObjectUtil
{
	/**
	 * Returns the size of an object
	 * @param obj Object to be counted
	 */
	public static function count(obj : Dynamic) : Int{
		if (Std.is(obj, Array)) 
			return obj.length
		else {
			var len : Int = 0;
			for (item in Reflect.fields(obj)) {
				len++;
			}
			return len;
		}
	}
	
	/**
	 * Return a gradient given a colour.
	 *
	 * @param color	  Base color of the gradient.
	 * @param intensity  Amount to shift secondary color.
	 * @return An array with a length of two colors.
	 */
	public static function fadeColour(color : Int, intensity : Int = 20) : Array<Dynamic>
	{
		var c : Dynamic = hexToRGB(color);
		for (key in Reflect.fields(c))
		{
			Reflect.setField(c, key, Math.max(Math.min(Reflect.field(c, key) + intensity, 255), 0));
		}
		return [color, RGBToHex(c)];
	}
	
	/**
		 * Interpolates between 2 given colours based on the percentage.
		 * @param	fromColor
		 * @param	toColor
		 * @param	progress
		 * @return
		 */
	public static function interpolateColour(fromColour : Int, toColour : Int, progress : Float) : Int
	{
		var q : Float = 1 - progress;
		var fromA : Int = (fromColour >> 24) & 0xFF;
		var fromR : Int = (fromColour >> 16) & 0xFF;
		var fromG : Int = (fromColour >> 8) & 0xFF;
		var fromB : Int = fromColour & 0xFF;
		
		var toA : Int = (toColour >> 24) & 0xFF;
		var toR : Int = (toColour >> 16) & 0xFF;
		var toG : Int = (toColour >> 8) & 0xFF;
		var toB : Int = toColour & 0xFF;
		
		var resultA : Int = Math.floor(fromA * q + toA * progress);
		var resultR : Int = Math.floor(fromR * q + toR * progress);
		var resultG : Int = Math.floor(fromG * q + toG * progress);
		var resultB : Int = Math.floor(fromB * q + toB * progress);
		return (resultA << 24 | resultR << 16 | resultG << 8 | resultB);
	}
	
	/**
	 * Convert a uint (0x000000) to a colour object.
	 *
	 * @param hex  Colour.
	 * @return Converted object {r:, g:, b:}
	 */
	public static function hexToRGB(hex : UInt) : Dynamic
	{
		var c : Dynamic = { };
		
		c.a = hex >> 24 & 0xFF;
		c.r = hex >> 16 & 0xFF;
		c.g = hex >> 8 & 0xFF;
		c.b = hex & 0xFF;
		
		return c;
	}
	
	/**
	 * Convert a colour object to uint octal (0x000000).
	 *
	 * @param c  Colour object {r:, g:, b:}.
	 * @return Converted colour uint (0x000000).
	 */
	public static function RGBToHex(c : Dynamic) : UInt
	{
		var ct : ColorTransform = new ColorTransform(0, 0, 0, 0, c.r, c.g, c.b, 100);
		return ct.color;
	}
	
	public static function containsHtml(text:String):Bool
	{
		return text != null && (text.indexOf("<") >= 0 && text.indexOf(">") >= 0 && text.indexOf("</") >= 0);
	}
}