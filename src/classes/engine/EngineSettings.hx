package classes.engine;

import TypeDefinitions;
import flash.ui.Keyboard;
import haxe.Json;

/**
 * Engine Settings
 * Contains per user settings for the game.
 */
class EngineSettings
{
	public var keys(get, never) : Array<Dynamic>;

	///- Variables
	// Keys
	public var key_left : Int = Keyboard.LEFT;
	public var key_down : Int = Keyboard.DOWN;
	public var key_up : Int = Keyboard.UP;
	public var key_right : Int = Keyboard.RIGHT;
	public var key_restart : Int = 191;  // Keyboard.SLASH;  
	public var key_quit : Int = Keyboard.CONTROL;
	public var key_options : Int = 145;  // Scrolllock  
	
	private function get_keys() : Array<Int> { return [key_left, key_down, key_up, key_right, key_restart, key_quit, key_options]; }
	
	// Speed
	public var scroll_direction : String = "up";
	public var scroll_speed : Float = 1.5;
	public var receptor_spacing : Int = 80;
	public var screencut_position : Float = 0.5;
	public var playback_speed : Float = 1;
	
	// Judge
	public var offset_global : Float = 0;
	public var offset_judge : Float = 0;
	public var judge_colors : Array<Int> = [0x78ef29, 0x12e006, 0x01aa0f, 0xf99800, 0xfe0000, 0x804100];
	//public var judge_window : Array<Dynamic> = null;
	
	// Flags
	public var display_song_flags : Bool = true;
	public var display_judge : Bool = true;
	public var display_health : Bool = true;
	public var display_combo : Bool = true;
	public var display_pacount : Bool = true;
	public var display_amazing : Bool = true;
	public var display_perfect : Bool = true;
	public var display_total : Bool = true;
	public var display_screencut : Bool = false;
	public var display_song_progress : Bool = true;
	public var display_alt_engines : Bool = true;
	
	public var display_mp_mask : Bool = false;
	public var display_mp_timestamp : Bool = false;
	
	// Other
	public var filters : Array<EngineLevelFilter> = [];
	
	public function new()
	{
		
	}
	
	/**
	 * Setups Engine Settings for a passed object.
	 * @param	obj	Object containing new settings.
	 */
	public function setup(obj : EngineSettingsJsonDef) : Void
	{
		// Keys
		if (obj.keys != null) 
		{
			key_left = obj.keys[0];
			key_down = obj.keys[1];
			key_up = obj.keys[2];
			key_right = obj.keys[3];
			key_restart = obj.keys[4];
			key_quit = obj.keys[5];
			key_options = obj.keys[6];
		} 
		
		
		// Speed  
		if (obj.direction != null)			scroll_direction = obj.direction;
		if (obj.speed != null)			 	scroll_speed = obj.speed;
		if (obj.gap != null)			 	receptor_spacing = obj.gap;
		if (obj.screencutPosition != null)	screencut_position = obj.screencutPosition;
		
		// Judge
		if (obj.judgeOffset != null)		offset_judge = obj.judgeOffset;
		if (obj.viewOffset != null)			 offset_global = obj.viewOffset;
		if (obj.judgeColours != null)		judge_colors = obj.judgeColours;
		
		// Flags
		if (obj.viewSongFlag != null)		display_song_flags = obj.viewSongFlag;
		if (obj.viewJudge != null)			display_judge = obj.viewJudge;
		if (obj.viewHealth != null)			display_health = obj.viewHealth;
		if (obj.viewCombo != null)			display_combo = obj.viewCombo;
		if (obj.viewPACount != null)		display_pacount = obj.viewPACount;
		if (obj.viewAmazing != null)		display_amazing = obj.viewAmazing;
		if (obj.viewPerfect != null)		display_perfect = obj.viewPerfect;
		if (obj.viewTotal != null)			display_total = obj.viewTotal;
		if (obj.viewScreencut != null)		display_screencut = obj.viewScreencut;
		if (obj.viewSongProgress != null)	display_song_progress = obj.viewSongProgress;
		if (obj.viewMPMask != null)			display_mp_mask = obj.viewMPMask;
		if (obj.viewMPTimestamp != null)	display_mp_timestamp = obj.viewMPTimestamp;
		if (obj.viewAltEngines != null)		display_alt_engines = obj.viewAltEngines;
		if (obj.filters != null)			filters = doImportFilters(obj.filters);
	}
	
	public function export() : Dynamic
	{
		return {
			// Keys
			"keys": keys,
			
			// Speed
			"direction": scroll_direction,
			"speed": scroll_speed,
			"gap": receptor_spacing,
			"screencutPosition": screencut_position,

			// Judge
			"judgeOffset": offset_judge,
			"viewOffset": offset_global,
			"judgeColours": judge_colors,

			// Flags
			"viewSongFlag": display_song_flags,
			"viewJudge": display_judge,
			"viewHealth": display_health,
			"viewCombo": display_combo,
			"viewPACount": display_pacount,
			"viewAmazing": display_amazing,
			"viewPerfect": display_perfect,
			"viewTotal": display_total,
			"viewScreencut": display_screencut,
			"viewSongProgress": display_song_progress,
			"viewMPMask": display_mp_mask,
			"viewMPTimestamp": display_mp_timestamp,
			"viewAltEngines": display_alt_engines,
		
			// Other
			"filters": doExportFilters(filters)
		}
	}
	
	/**
		 * Imports user filters from a save object.
		 * @param	filters Array of Filter objects.
		 * @return Array of EngineLevelFilters.
		 */
	private function doImportFilters(filters_in : Array<FilterDataJsonDef>) : Array<EngineLevelFilter>
	{
		var newFilters : Array<EngineLevelFilter> = [];
		var filter : EngineLevelFilter;
		for (item in filters_in)
		{
			filter = new EngineLevelFilter();
			filter.setup(item);
			newFilters.push(filter);
		}
		return newFilters;
	}
	
	/**
		 * Exports the user filters into an array of filter objects.
		 * @param	filters_out Array of Filters to export.
		 * @return	Array of Filter Object.
		 */
	private function doExportFilters(filters_out : Array<EngineLevelFilter>) : Array<FilterDataJsonDef>
	{
		var filtersOut : Array<FilterDataJsonDef> = [];
		for (item in filters_out)
		{
			filtersOut.push(item.export());
		}
		return filtersOut;
	}
	
	public function setupFromString(settings:String) : Void
	{
		var jsonDef : EngineSettingsJsonDef = Json.parse(settings);
		setup(jsonDef);
	}
}