package classes.engine;

import TypeDefinitions;
import classes.engine.EnginePlaylist;
import classes.engine.EngineSiteInfo;
import flash.errors.Error;
import haxe.Json;
import openfl.net.URLLoader;

import com.flashfla.net.WebRequest;
import com.flashfla.utils.ArrayUtil;
import flash.events.Event;

class EngineLoader
{
	public var short_name(get, set) : String;
	public var infoArray(get, never) : Array<String>;
	public var loaded(get, never) : Bool;
	public var loaded_playlist(get, never) : Bool;
	public var loaded_info(get, never) : Bool;
	public var loaded_language(get, never) : Bool;
	public var playlist(get, never) : EnginePlaylist;
	public var info(get, never) : EngineSiteInfo;
	public var language(get, never) : EngineLanguage;

	private var _core : EngineCore;
	
	private var _playlist : EnginePlaylist;
	private var _info : EngineSiteInfo;
	private var _language : EngineLanguage;
	
	private var domain : String = "";
	private var song_url : String;
	
	private var _plURL : String = "";
	private var _inURL : String = "";
	private var _laURL : String = "";
	
	private var _isInit : Bool = false;
	private var _plIsLoaded : Bool = false;
	private var _inIsLoaded : Bool = false;
	private var _laIsLoaded : Bool = false;
	
	private var _requestParams : Dynamic;
	
	private var configURL : String = "";
	
	public var isCanon : Bool = false;
	public var isLegacy : Bool = false;
	
	public var id : String = "";
	public var name : String = "";
	private var _short_name : String = "";
	
	public function new(core : EngineCore, id : String = "", name : String = "")
	{
		this._core = core;
		this.id = id;
		this.name = name;
		
		if (id != "") 
		{
			_core.registerLoader(this);
		}
	}
	
	private function get_short_name() : String
	{
		return _short_name != null && _short_name != ("") ? _short_name : name;
	}
	
	private function set_short_name(value : String) : String
	{
		_short_name = value;
		return value;
	}
	
	/** Contains [name, short_name, id]  */
	private function get_infoArray() : Array<String>
	{
		return [name, short_name, id];
	}
	
	///- Get Loaded Status
	private function get_loaded() : Bool
	{
		var load : Bool = _isInit;
		
		// A Engine source requires a playlist to be valid.
		if (_plURL == "") 
			load = false;
		
		// Check Sources
		if (_plURL != "" && !_plIsLoaded) 
			load = false;
		if (_inURL != "" && !_inIsLoaded) 
			load = false;
		if (_laURL != "" && !_laIsLoaded) 
			load = false;
		
		return load;
	}
	
	private function get_loaded_playlist() : Bool
	{
		return _plURL != "" ? _plIsLoaded : true;
	}
	
	private function get_loaded_info() : Bool
	{
		return _inURL != "" ? _inIsLoaded : true;
	}
	
	private function get_loaded_language() : Bool
	{
		return _laURL != "" ? _laIsLoaded : true;
	}
	
	///- Loader
	public function loadFromConfig(url : String, params : Dynamic = null) : Void
	{
		if (url != "") 
		{
			configURL = url;
			_requestParams = params;
			url = Constant.prepare_url(url);
			var wr : WebRequest = new WebRequest(url, e_configLoad);
			wr.load(_requestParams);
			Logger.log(this, Logger.INFO, "Loading Engine Config: " + url);
		}
	}
	
	private function e_configLoad(e : URLLoader) : Void
	{
		var data : String = StringTools.trim(e.data);
		/*
		// Data is XML - Legacy Type
		if (data.charAt(0) == "<") 
		{
			// Create XML Tree
			try
			{
				var xml : FastXML = new FastXML(data);
			}			catch (e : Error)
			{
				Logger.log(this, Logger.ERROR, "Malformed XML Config.");
				return;
			}  // Check if FFR Engine XML  
			
			
			
			if (xml.localName() != "ffr_engines" && xml.localName() != "arc_engines") 
				return;
			
			for (node in xml.children())
			{
				if (node.id == null) 
					continue;
				
				if (node.playlistURL == null) 
					return;
				
				if (this.id == "") 
					this.id = Std.string(node.id) + "-external";
				
				if (node.name != null) 
					this.name = Std.string(node.name);
				if (node.shortName != null) 
					this.short_name = Std.string(node.shortName);
				if (node.domain != null) 
					this.domain = Std.string(node.domain);
				if (node.songURL != null) 
					this.song_url = Std.string(node.songURL);
					
				// Load Playlist
				if (node.playlistURL != null) 
					loadPlaylist(Std.string(node.playlistURL), _requestParams);
					
				// Load Site Info is existing.
				if (node.siteinfoURL != null) 
					loadInfo(Std.string(node.siteinfoURL), _requestParams);
					
				// Load Language is existing.
				if (node.languageURL != null) 
					loadLanguage(Std.string(node.languageURL), _requestParams);
					
				Logger.log(this, Logger.INFO, "Loaded XML \"" + id + "\" Name: " + this.name);
				_core.registerLoader(this);
				
				break;
			}
		}
		*/
		// Data is JSON - R^3 Type  
		if (data.charAt(0) == "{" || data.charAt(0) == "[") 
		{
			var json : SiteConfigJsonDef;
			try
			{
				json = Json.parse(data);
			}
			catch (e : Error)
			{
				Logger.log(this, Logger.ERROR, "Malformed JSON Config.");
				return;
			}
			if (this.id == "") 
				this.id = json.id + "-external";
			
			if (json.name != null) 
				this.name = json.name;
			if (json.short_name != null) 
				this.short_name = json.short_name;
			if (json.domain != null) 
				this.domain = json.domain;
			if (json.songURL != null) 
				this.song_url = json.songURL;
			
			// Load Playlist
			if (json.playlistURL != null) 
				loadPlaylist(json.playlistURL, _requestParams);
				
			// Load Site Info
			if (json.siteinfoURL != null) 
				loadInfo(json.siteinfoURL, _requestParams);
				
			// Load Language
			if (json.languageURL != null) 
				loadLanguage(json.languageURL, _requestParams);
			
			Logger.log(this, Logger.INFO, "Loaded JSON \"" + id + "\" Name: " + this.name);
			_core.registerLoader(this);
		}
	}
	
	//- Playlist
	private function get_playlist() : EnginePlaylist
	{
		return _playlist;
	}
	
	public function loadPlaylist(url : String, params : Dynamic = null) : Void
	{
		if (url != "") 
		{
			_plURL = Constant.prepare_url(url);
			var wr : WebRequest = new WebRequest(_plURL, e_playlistLoad);
			wr.load(params);
			Logger.log(this, Logger.INFO, "Loading \"" + id + "\" Playlist: " + _plURL);
		}
	}
	
	private function e_playlistLoad(e : URLLoader) : Void
	{
		Logger.log(this, Logger.INFO, "\"" + id + "\" Playlist Loaded!");
		_playlist = new EnginePlaylist(id);
		_playlist.parseData(e.data);
		_playlist.setLoadPath(this.song_url);
		
		// Register Playlist if Valid
		if (_playlist.valid) 
		{
			_plIsLoaded = true;
			_core.registerPlaylist(_playlist);
		}
		else 
		{
			_plURL = "";
			_plIsLoaded = false;
		}
		_doLoadCompleteInit();
	}
	
	//- Info
	private function get_info() : EngineSiteInfo
	{
		return _info;
	}
	
	public function loadInfo(url : String, params : Dynamic = null) : Void
	{
		if (url != "") 
		{
			_inURL = Constant.prepare_url(url);
			var wr : WebRequest = new WebRequest(_inURL, e_dataLoad);
			wr.load(params);
			Logger.log(this, Logger.INFO, "Loading \"" + id + "\" SiteInfo: " + _inURL);
		}
	}
	
	private function e_dataLoad(e : URLLoader) : Void
	{
		Logger.log(this, Logger.INFO, "\"" + id + "\" SiteInfo Loaded!");
		_info = new EngineSiteInfo(id);
		_info.parseData(e.data);
		
		// Register SiteInfo if Valid
		if (_info.valid) 
		{
			_inIsLoaded = true;
			_core.registerInfo(_info);
		}
		else 
		{
			_inURL = "";
			_inIsLoaded = false;
		}
		_doLoadCompleteInit();
	}
	
	//- Language
	private function get_language() : EngineLanguage
	{
		return _language;
	}
	
	public function loadLanguage(url : String, params : Dynamic = null) : Void
	{
		if (url != "") 
		{
			_laURL = Constant.prepare_url(url);
			var wr : WebRequest = new WebRequest(_laURL, e_languageLoad);
			wr.load(params);
			Logger.log(this, Logger.INFO, "Loading \"" + id + "\" Language: " + _laURL);
		}
	}
	
	private function e_languageLoad(e : URLLoader) : Void
	{
		Logger.log(this, Logger.INFO, "\"" + id + "\" Language Loaded!");
		_language = new EngineLanguage(id);
		_language.parseData(e.data);
		
		// Register Language if Valid
		if (_language.valid) 
		{
			_laIsLoaded = true;
			_core.registerLanguage(_language);
		}
		else 
		{
			_laURL = "";
			_laIsLoaded = false;
		}
		_doLoadCompleteInit();
	}
	
	private function _doLoadCompleteInit() : Void
	{
		// Language Only Load Check
		if (!loaded_info && loaded_language && !loaded_playlist) 
		{
			_isInit = true;
			return;
		}
		
		// Load Checks, check if things are loaded and playlist exist.
		if (!loaded_info || !loaded_language || !loaded_playlist || _playlist == null) 
			return;
		
		// Check Playlist is Valid and contains atleast one song.
		if (!_playlist.valid || _playlist.index_list.length <= 0) 
		{
			Logger.log(this, Logger.ERROR, "\"" + id + "\" - Load Init Failure - Playlist Invalid");
			_core.removeLoader(this);
			
			return;
		}
		
		// Playlist
		_playlist.total_songs = _playlist.total_public_songs = _playlist.index_list.length;
		_playlist.total_genres = ArrayUtil.count(_playlist.genre_list);
		
		if (_info != null) 
		{
			// Excluded Genres from Public count
			var nonpublic_genres : Array<Dynamic> = _info.getData("game_nonpublic_genres");
			if (nonpublic_genres != null) 
			{
				_playlist.total_public_songs = _playlist.index_list.filter(function(item : Dynamic) : Bool
					{
						return !ArrayUtil.in_array([item.genre], nonpublic_genres);
					}).length;
			}
		} 
		
		// Site
		
		// Language
		
		// Finished
		Logger.log(this, Logger.NOTICE, "Load Init: " + name + " (" + ((playlist != null) ? "P" : "-") + ((info != null) ? "I" : "-") + ((language != null) ? "L" : "-") + ")");
		Logger.log(this, Logger.NOTICE, "Total Songs: " + _playlist.total_songs);
		Logger.log(this, Logger.NOTICE, "Total Public Songs: " + _playlist.total_public_songs);
		Logger.log(this, Logger.NOTICE, "Total Genres: " + _playlist.total_genres);
		_isInit = true;
		_core.loaderInitialized(this);
	}
}