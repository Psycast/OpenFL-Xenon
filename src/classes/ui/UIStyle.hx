package classes.ui;

import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import openfl.Assets;
import openfl.text.Font;

class UIStyle
{
	
	public static var NORMAL_UI(default, null):String;
	public static var UNICODE_UI(default, null):String;
	
    //- Formats
    public static var FONT_SIZE : Null<Int> = 14;
    public static var FONT_COLOR : Null<Int> = 0xFFFFFF;
    public static var ACTIVE_FONT_COLOR : String = "#93F0FF";
    public static var USE_ANIMATION : Bool = false;// #if flash false #else true #end;
	public static inline var USE_EMBED_FONTS:Bool = false;
    
    public static var TEXT_FORMAT : TextFormat;
    public static var TEXT_FORMAT_U : TextFormat;
	public static inline var BORDER_SIZE : Int = #if html5 0 #else 1 #end;
    
    public static var BG_DARK : Int = 0x033242;
    public static var BG_LIGHT : Int = 0x1495BD;
    
	public static function init():Void
	{
		//trace(Assets.list(AssetType.FONT));
		#if js
			//NORMAL_UI = UNICODE_UI = "Segoe UI";
			NORMAL_UI = UNICODE_UI = Assets.getFont("fonts/opensans-regular.ttf").fontName;
			//UNICODE_UI = Assets.getFont("fonts/Arial-Unicode-Bold.ttf").fontName;
		#else
			NORMAL_UI = UNICODE_UI = "_sans";
			//Font.registerFont(OpenSansBold);
			//NORMAL_UI = (new OpenSansBold()).fontName;
			//Font.registerFont(ArialUnicodeMS);
			//UNICODE_UI = (new ArialUnicodeMS()).fontName;
		#end
		
		TEXT_FORMAT = new TextFormat(NORMAL_UI, FONT_SIZE, FONT_COLOR, true);
		TEXT_FORMAT_U = new TextFormat(UNICODE_UI, FONT_SIZE, FONT_COLOR, true);
	}
	
    public static function getTextFormat(unicode : Bool = false) : TextFormat
    {
        return (unicode) ? TEXT_FORMAT_U : TEXT_FORMAT;
    }
    
    public static function textIsUnicode(str : String) : Bool
    {
        return !(new EReg('^[\\x20-\\x7E]*$', "").match(str));
    }

    public function new()
    {
    }
}

@:font("assets/fonts/opensans-regular.ttf")
private class OpenSansBold extends Font { }

//@:font("assets/fonts/Arial-Unicode-Bold.ttf")
//private class ArialUnicodeMS extends Font { }