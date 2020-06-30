package classes.engine;

import TypeDefinitions;
import flash.errors.Error;
import haxe.Json;

class EnginePlaylist
{
	public var id : String;
	public var valid : Bool = false;
	
	public var load_path : String;
	
	public var song_list : Array<Dynamic>;
	public var index_list : Array<EngineLevel>;
	public var genre_list : Array<Dynamic>;
	public var generated_queues : Array<Dynamic>;
	
	public var total_genres : Int = 0;
	public var total_songs : Int = 0;
	public var total_public_songs : Int = 0;
	
	public function new(id : String)
	{
		this.id = id;
	}
	
	public function parseData(input : String) : Void
	{
		input = StringTools.trim(input);
		var data : SongDataListJsonDef = null;
		
		// Create Arrays
		song_list = [];
		index_list = [];
		genre_list = [];
		generated_queues = [];
		
		// Create Data Array
		try
		{
			// TODO: XML Parsing Playlist
			// Data is XML - Legacy Type
			/*
			if (input.charAt(0) == "<") 
			{
				data = parse_xml_playlist(input);
			}
			*/
			// Data is JSON - R^3 Type
			if (input.charAt(0) == "{" || input.charAt(0) == "[") 
			{
				data = Json.parse(input);
			}
		}
		catch (e : Error)
		{
			Logger.log(this, Logger.ERROR, "\"" + id + "\" - Malformed Playlist Format");
			return;
		}
		
		// Check that playlist was parsed correctly.
		if (data == null) 
		{
			Logger.log(this, Logger.ERROR, "\"" + id + "\" - Playlist is null");
			return;
		}
		
		// Build song_list  
		var song : EngineLevel;
		for (item in data)
		{
			// Skip Invalid Levels
			if (item.level == null || item.level == "") 
				continue;
			
			// Create Genre-based list.
			var _genre : Int = item.genre;
			if (!genre_list[_genre]) 
			{
				genre_list[_genre] = [];
				generated_queues[_genre] = [];
			}
			
			// Create Song Object 
			song = new EngineLevel();
			song.source = id;
			song.id = Std.string(item.level);
			song.index = genre_list[_genre].length;
			
			if (item.genre != null) 
				song.genre = item.genre;
			if (item.name != null) 
				song.name = item.name;
			if (item.author != null) 
				song.author = item.author;
			if (item.authorURL != null) 
				song.author_url = item.authorURL;
			if (item.stepauthor != null) 
				song.stepauthor = item.stepauthor;
			if (item.style != null) 
				song.style = item.style;
			if (item.releasedate != null) 
				song.release_date = item.releasedate;
			if (item.time != null) 
				song.time = item.time;
			if (item.order != null) 
				song.order = item.order;
			if (item.difficulty != null) 
				song.difficulty = item.difficulty;
			if (item.arrows != null) 
				song.notes = item.arrows;
			if (item.previewhash != null) 
				song.play_hash = item.previewhash;
			if (item.previewhash != null) 
				song.preview_hash = item.previewhash;
			if (item.prerelease != null) 
				song.prerelease = item.prerelease;
			
			// Optional
			if (item.is_title_only != null) 
				song.is_title_only = item.is_title_only;
			if (item.min_nps != null) 
				song.min_nps = item.min_nps;
			if (item.max_nps != null) 
				song.max_nps = item.max_nps;
			if (item.sync != null) 
				song.sync_frames = item.sync;
			
			
			// Push Into Arrays
			Reflect.setField(song_list, song.id, song); // song_list[song.id] = song;
			index_list.push(song);
			genre_list[_genre].push(song);
			generated_queues[_genre].push(song.id);
		}
		
		valid = true;
	}
	
	public function parse_xml_playlist(data : String) : TypeDefinitions.SongDataJsonDef
	{
		return null;
		// TODO: DP XML Playlist Parsing Recode
		/*
		var xml : FastXML = new FastXML(data);
		var nodes : FastXMLList = xml.node.children.innerData();
		var count : Int = nodes.length();
		var songs : Array<Dynamic> = [];
		for (i in 0...count){
			var node : FastXML = nodes.get(i);
			var song : Dynamic = new Dynamic();
			song.source = id;
			
			if (node.att.genre) 
				song.genre = as3hx.Compat.parseInt(Std.string(node.att.genre));
			if (node.node.songname.innerData) 
				song.name = Std.string(node.node.songname.innerData);
			if (node.node.songdifficulty.innerData) 
				song.difficulty = as3hx.Compat.parseInt(Std.string(node.node.songdifficulty.innerData));
			if (node.node.songstyle.innerData) 
				song.style = Std.string(node.node.songstyle.innerData);
			if (node.node.songlength.innerData) 
				song.time = Std.string(node.node.songlength.innerData);
			if (node.node.level.innerData) 
				song.level = Std.string(node.node.level.innerData);
			if (node.node.order.innerData) 
				song.order = as3hx.Compat.parseInt(Std.string(node.node.order.innerData));
			if (node.node.arrows.innerData) 
				song.arrows = as3hx.Compat.parseInt(Std.string(node.node.arrows.innerData));
			if (node.node.songauthor.innerData) 
				song.author = Std.string(node.node.songauthor.innerData);
			if (node.node.songauthorURL.innerData) 
				song.authorURL = Std.string(node.node.songauthorURL.innerData);
			if (node.node.songstepauthor.innerData) 
				song.stepauthor = Std.string(node.node.songstepauthor.innerData);
			if (node.node.songstepauthorurl.innerData) 
				song.stepauthorURL = Std.string(node.node.songstepauthorurl.innerData);
			if (node.node.secretcredits.innerData) 
				song.credits = as3hx.Compat.parseInt(Std.string(node.node.secretcredits.innerData));
			if (node.node.price.innerData) 
				song.price = as3hx.Compat.parseInt(Std.string(node.node.price.innerData));
				
			// Optional
			if (node.node.min_nps.innerData) 
				song.min_nps = as3hx.Compat.parseInt(Std.string(node.node.min_nps.innerData));
			if (node.node.max_nps.innerData) 
				song.max_nps = as3hx.Compat.parseInt(Std.string(node.node.max_nps.innerData));
			if (node.node.is_title_only.innerData) 
				song.is_title_only = cast(Std.string(node.node.is_title_only.innerData), Bool);
			
			if (cast(Std.string(node.node.arc_sync.innerData), Bool)) 
				song.sync = as3hx.Compat.parseInt(Std.string(node.node.arc_sync.innerData));
			
			songs.push(song);
		}
		return songs;
		*/
	}
	
	public function setLoadPath(song_url : String) : Void
	{
		this.load_path = song_url;
	}
	
	public function getLevelPath(level : EngineLevel) : String
	{
		// TODO: sprintf replace.
		/*
		var path : String = sprintf(load_path, level);
		
		// Append Legacy URLs if URL didn't change with song details.
		if (path == load_path) 
			path = sprintf(load_path + "level_%(id)s.swf", level);
		
		return path;
		*/
		return load_path;
	}
}

