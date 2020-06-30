package classes.engine;

import TypeDefinitions;
import classes.user.User;

class EngineLevelFilter
{
	public var type(get, set) : String;

	/// Filter Types
	public static inline var FILTER_AND : String = "and";
	public static inline var FILTER_OR : String = "or";
	public static inline var FILTER_STYLE : String = "style";
	public static inline var FILTER_NAME : String = "name";
	public static inline var FILTER_ARTIST : String = "artist";
	public static inline var FILTER_STEPARTIST : String = "stepartist";
	public static inline var FILTER_BPM : String = "bpm";
	public static inline var FILTER_DIFFICULTY : String = "difficulty";
	public static inline var FILTER_ARROWCOUNT : String = "arrows";
	public static inline var FILTER_ID : String = "id";
	public static inline var FILTER_MIN_NPS : String = "min_nps";
	public static inline var FILTER_MAX_NPS : String = "max_nps";
	public static inline var FILTER_RANK : String = "rank";
	public static inline var FILTER_SCORE : String = "score";
	public static inline var FILTER_STATS : String = "stats";
	public static inline var FILTER_TIME : String = "time";
	
	public static var FILTERS : Array<String> = [FILTER_AND, FILTER_OR, FILTER_STYLE, FILTER_ARTIST, FILTER_STEPARTIST, FILTER_DIFFICULTY, FILTER_ARROWCOUNT, FILTER_ID, FILTER_MIN_NPS, FILTER_MAX_NPS, FILTER_RANK, FILTER_SCORE, FILTER_STATS, FILTER_TIME];
	public static var FILTERS_STAT : Array<String> = ["amazing", "perfect", "average", "miss", "boo", "combo"];
	public static var FILTERS_NUMBER : Array<String> = ["=", "!=", "<=", ">=", "<", ">"];
	public static var FILTERS_STRING : Array<String> = ["equal", "start_with", "end_with", "contains"];
	
	public var name : String;
	private var _type : String;
	public var comparison : String;
	public var inverse : Bool = false;
	
	public var parent_filter : EngineLevelFilter;
	public var filters : Array<Dynamic> = [];
	public var input_number : Float = 0;
	public var input_string : String = "";
	public var input_stat : String = "";
	
	public function new(topLevelFilter : Bool = false)
	{
		input_stat = FILTERS_STAT[0];
		
		if (topLevelFilter) 
		{
			name = "Untitled Filter";
			type = "and";
			filters = [];
		}
	}
	
	private function get_type() : String
	{
		return _type;
	}
	
	private function set_type(value : String) : String
	{
		_type = value;
		setDefaultComparison();
		return value;
	}
	
	/**
	 * Process the engine level to see if it has passed the requirements of the filters currently set.
	 *
	 * @param	songData	Engine Level to be processed.
	 * @param	userData	User Data from comparisons.
	 * @return	Song passed filter.
	 */
	public function process(songData : EngineLevel, userData : User) : Bool
	{
		switch (type)
		{
			case FILTER_AND:
				if (filters == null || filters.length == 0) 
					return true;  
					
				// Check ALL Sub Filters Pass
				for (filter_and in filters)
				{
					if (!filter_and.process(songData, userData)) 
						return false;
				}
				return true;
			
			case FILTER_OR:
				if (filters == null || filters.length == 0) 
					return true;
				
				var out : Bool = false;
				// Check if any Sub Filters Pass
				for (filter_or in filters)
				{
					if (filter_or.process(songData, userData)) 
						out = true;
				}
				return out;
			
			case FILTER_ID:
				return compareString(songData.id, input_string);
			
			case FILTER_NAME:
				return compareString(songData.name, input_string);
			
			case FILTER_STYLE:
				return compareString(songData.style, input_string);
			
			case FILTER_ARTIST:
				return compareString(songData.author, input_string);
			
			case FILTER_STEPARTIST:
				return compareString(songData.stepauthor, input_string);
			
			case FILTER_BPM:
				return false;  // TODO: compareNumber(songData.bpm, input_number);  
			
			case FILTER_DIFFICULTY:
				return compareNumber(songData.difficulty, input_number);
			
			case FILTER_ARROWCOUNT:
				return compareNumber(songData.notes, input_number);
			
			case FILTER_MIN_NPS:
				return compareNumber(songData.min_nps, input_number);
			
			case FILTER_MAX_NPS:
				return compareNumber(songData.max_nps, input_number);
			
			case FILTER_RANK:
				return compareNumber(userData.levelranks.getEngineRanks(songData.source).getRank(songData.id).rank, input_number);
			
			case FILTER_SCORE:
				return compareNumber(userData.levelranks.getEngineRanks(songData.source).getRank(songData.id).score, input_number);
			
			case FILTER_STATS:
				return compareNumber(Reflect.field(userData.levelranks.getEngineRanks(songData.source).getRank(songData.id), "input_stat"), input_number);
			
			case FILTER_TIME:
				return compareNumber(songData.time_secs, input_number);
		}
		return true;
	}
	
	/**
	 * Compares 2 Number values with the selected comparision.
	 * @param	value1	Input Value
	 * @param	value2	Value to compare to.
	 * @param	comparison	Method of comparision.
	 * @return	If comparision was successful.
	 */
	private function compareNumber(value1 : Float, value2 : Float) : Bool
	{
		switch (comparison)
		{
			case "=":
				return value1 == value2;
			
			case "!=":
				return value1 != value2;
			
			case "<=":
				return value1 <= value2;
			
			case ">=":
				return value1 >= value2;
			
			case "<":
				return value1 < value2;
			
			case ">":
				return value1 > value2;
		}
		return false;
	}
	
	/**
	 * Compares 2 String values with the selected comparision.
	 * @param	value1	Input Value
	 * @param	value2	Value to compare to.
	 * @param	comparison	Method of comparision.
	 * @param	inverse	Use inverse comparisions.
	 * @return	If comparision was successful.
	 */
	private function compareString(value1 : String, value2 : String) : Bool
	{
		var out : Bool = false;
		value1 = value1.toLowerCase();
		value2 = value2.toLowerCase();
		
		switch (comparison)
		{
			case "equal": 
				out = (value1 == value2);
			
			case "start_with": 
				out = StringTools.startsWith(value1, value2);
			
			case "end_with": 
				out = StringTools.endsWith(value1, value2);
			
			case "contains": 
				out = (value1.indexOf(value2) >= 0);
		}
		return inverse ? !out : out;
	}
	
	public function setup(obj : FilterDataJsonDef) : Void
	{
		if (obj.type != null)
			type = obj.type;
		
		if (obj.filters != null)
		{
			var in_filter : EngineLevelFilter;
			var in_filters : Array<FilterDataJsonDef> = obj.filters;
			for (i in 0...in_filters.length){
				in_filter = new EngineLevelFilter();
				in_filter.setup(in_filters[i]);
				in_filter.parent_filter = this;
				filters.push(in_filter);
			}
			if (obj.name != null)
				name = obj.name;
		}
		else 
		{
			if (obj.comparison != null)
				comparison = obj.comparison;
			
			if (obj.input_number != null)
				input_number = obj.input_number;
			
			if (obj.input_string != null)
				input_string = obj.input_string;
			
			if (obj.input_stat != null)
				input_stat = obj.input_stat;
		}
	}
	
	public function export() : FilterDataJsonDef
	{
		var obj : FilterDataJsonDef =  { type : type };
		
		// Filter AND/OR
		if (type == FILTER_AND || type == FILTER_OR) 
		{
			var ex_array : Array<FilterDataJsonDef> = [];
			for (i in 0...filters.length){
				ex_array.push(filters[i].export());
			}
			obj.filters = ex_array;
			
			if (name != null && name != "") 
				obj.name = name;
		}
		else 
		{
			obj.comparison = comparison;
			obj.input_number = input_number;
			obj.input_string = input_string;
			
			if (type == FILTER_STATS) 
				obj.input_stat = input_stat;
		}
		return obj;
	}
	
	public function setDefaultComparison() : Void
	{
		switch (type)
		{
			case FILTER_STATS:
				input_stat = FILTERS_STAT[0];
				comparison = FILTERS_NUMBER[0];
			case FILTER_ARROWCOUNT, FILTER_BPM, FILTER_DIFFICULTY, FILTER_MAX_NPS, FILTER_MIN_NPS, FILTER_RANK, FILTER_SCORE, FILTER_TIME:
				comparison = FILTERS_NUMBER[0];
			case FILTER_ID, FILTER_NAME, FILTER_STYLE, FILTER_ARTIST, FILTER_STEPARTIST:
				comparison = FILTERS_STRING[0];
		}
	}
	
	public function toString() : String
	{
		return type + " [" + comparison + "]" + (!(Math.isNaN(input_number)) ? " input_number=" + input_number : "") + (input_string != (null) ? " input_string=" + input_string : "") + (input_stat != (null) ? " input_stat=" + input_stat : "");
	}
	
	public static function createOptions(core : EngineCore, filtersString : Array<Dynamic>, type : String) : Array<ComboOptionDef>
	{
		var options : Array<ComboOptionDef> = [];
		for (i in 0...filtersString.length){
			options.push({
				label: core.getString("filter_" + type + "_" + filtersString[i]),
				value: filtersString[i]
			});
		}
		
		return options;
	}
}
