package;

typedef SiteConfigJsonDef = {
	var id:String;
	var name:String;
	@:optional var short_name:String;
	var domain:String;
	var songURL:String;
	var playlistURL:String;
	@:optional var siteinfoURL:String;
	@:optional var languageURL:String;
}

typedef SongDataListJsonDef = Array<SongDataJsonDef>;
typedef SongDataJsonDef = {
	var genre : Null<Int>;
	var level : Null<String>;
	var name : Null<String>;
	var author : Null<String>;
	var authorURL : Null<String>;
	var stepauthor : Null<String>;
	var style : Null<String>;
	var releasedate : Null<Int>;
	var time : Null<String>;
	var order : Null<Int>;
	var difficulty : Null<Int>;
	var arrows : Null<Int>;
	var playhash : Null<String>;
	var previewhash : Null<String>;
	@:optional var prerelease : Null<Bool>;
	@:optional var is_title_only : Null<Bool>;
	@:optional var min_nps : Null<Float>;
	@:optional var max_nps : Null<Float>;
	@:optional var sync : Null<Int>;
}

typedef EngineSettingsJsonDef = {
	var keys : Null<Array<Int>>;
	
	var direction : Null<String>;
	var speed : Null<Float>;
	var gap : Null<Int>;
	var screencutPosition : Null<Float>;
	
	var judgeOffset : Null<Float>;
	var viewOffset : Null<Float>;
	var judgeColours : Null<Array<Int>>;
	
	var viewSongFlag : Null<Bool>;
	var viewJudge : Null<Bool>;
	var viewHealth : Null<Bool>;
	var viewCombo : Null<Bool>;
	var viewPACount : Null<Bool>;
	var viewAmazing : Null<Bool>;
	var viewPerfect : Null<Bool>;
	var viewTotal : Null<Bool>;
	var viewScreencut : Null<Bool>;
	var viewSongProgress : Null<Bool>;
	var viewMPMask : Null<Bool>;
	var viewMPTimestamp : Null<Bool>;
	var viewAltEngines : Null<Bool>;
	
	var filters : Null<Array<FilterDataJsonDef>>;
}

typedef FilterDataJsonDef = {
	var type : String;
	@:optional var comparison : String;
	@:optional var input_number : Float;
	@:optional var input_string : String;
	@:optional var input_stat : String;
	@:optional var name : String;
	@:optional var filters : Array<FilterDataJsonDef>;
	@:optional var inverse : Bool;
}

typedef ComboOptionDef = {
	var label : String;
	var value : Dynamic;
}