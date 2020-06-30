import com.flashfla.utils.TimeUtil;
import openfl.Lib;

class Logger
{
	public static var enabled : Bool = true;
	
	public static var DEBUG_LINES : Array<Dynamic> = ["Info: ", "Debug: ", "Warning: ", "Error: ", "Fatal: "];
	public static inline var INFO : Float = 0;  // Gray  
	public static inline var DEBUG : Float = 1;  // Black  
	public static inline var WARNING : Float = 2;  // Orange  
	public static inline var ERROR : Float = 3;  // Red  
	public static inline var NOTICE : Float = 4;  // Purple  
	public static var START_TIME : Float = -1;
	public static var history : Array<Dynamic> = [];
	public static var debugUpdateCallback:Null<Dynamic>;

	public static function init() : Void
	{
		START_TIME = haxe.Timer.stamp();
	}
	
	public static function divider(clazz : Dynamic) : Void
	{
		log(clazz, WARNING, "------------------------------------------------------------------------------------------------", true);
	}
	
	public static function log(clazz : Dynamic, level : Int, text : Dynamic, simple : Bool = false) : Void
	{
			
		// Check if Logger Enabled
		if (!enabled) return;
		
		// Store History
		history.push([class_name(clazz), level, text, simple]);
		if (history.length > 250)	history.shift();
		if (debugUpdateCallback) debugUpdateCallback();
		
		// Display
		var str:String = (!(simple) ? "[" + TimeUtil.convertToHHMMSS(Math.round(haxe.Timer.stamp() - START_TIME)) + "][" + class_name(clazz) + "] " : "") + text;
		
		#if flash
			#if (fdb || native_trace)
				untyped __global__["trace"](level + ":" + str);
			#else
				untyped flash.Boot.__trace(level + ":" + str);
			#end
		//#elseif js
		//	untyped js.Boot.__trace(str);
		#else
			trace(str);
		#end
	}
	
	public static function class_name(clazz : Dynamic) : String
	{
		return Type.getClassName(Type.getClass(clazz)).split(".").pop();
	}
}

