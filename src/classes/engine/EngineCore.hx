package classes.engine;

import classes.engine.EngineLanguage;
import classes.engine.EngineLevelLoader;
import classes.engine.EngineLoader;
import classes.engine.EnginePlaylist;
import classes.engine.EngineSiteInfo;
import classes.engine.EngineVariables;

import classes.ui.ResizeListener;
import classes.ui.UICore;
import classes.user.User;
import com.flashfla.utils.ObjectUtil;
import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.EventDispatcher;

class EngineCore extends EventDispatcher
{
    public var source(get, set) : String;
    public var loaderCount(get, never) : Int;
    public var canonLoader(get, never) : EngineLoader;
    public var engineLoaders(get, never) : Map<String, EngineLoader>;
    public var scene(get, set) : UICore;

    //
    public static inline var LOADERS_UPDATE : String = "loadersUpdate";
    
    // Engine Source
    private var _source : String;
    
    // Engine Loaders
    private var _loaders : Map<String, EngineLoader> = new Map<String, EngineLoader>();
    private var _loaderCount : Int = 0;
    
    // Indexed List of Components
    private var _playlists : Map<String, EnginePlaylist> = new Map<String, EnginePlaylist>();
    private var _info : Map<String, EngineSiteInfo> = new Map<String, EngineSiteInfo>();
    private var _languages : Map<String, EngineLanguage> = new Map<String, EngineLanguage>();
    
    // Active User
    public var user : User;
    
    // Active UI
    public var ui : UI;
    
    // Engine Flags
    public var flags : Map<String, Bool> = new Map<String, Bool>();
    
    /** Engine Variables */
    public var variables : EngineVariables;
    public var song_loader : EngineLevelLoader;
    
    public function new()
    {
        super();
        this._source = Constant.GAME_ENGINE;
        variables = new EngineVariables();
        song_loader = new EngineLevelLoader(this);
    }
    
    ///- Engine Content Source
    // Set Engine Source for Content.
    private function set_source(gameEngine : String) : String
    {
        if (_loaders.exists(gameEngine)) 
        {
            _source = gameEngine;
            Logger.log(this, Logger.INFO, "Changed Default Engine: " + gameEngine);
        }
        return gameEngine;
    }
    
    private function get_source() : String
    {
        return _source;
    }
    
    ///- Engine Loader
    private function get_loaderCount() : Int
    {
        return _loaderCount;
    }
    
    // Get Active Engine Loader.
    public function getCurrentLoader() : EngineLoader
    {
        if (_loaders.exists(_source)) 
        {
            return _loaders.get(_source);
        }
        return _loaders.get(Constant.GAME_ENGINE);
    }
    
    private function get_canonLoader() : EngineLoader
    {
        return _loaders.get(Constant.GAME_ENGINE);
    }
    
    public function registerLoader(loader : EngineLoader) : Void
    {
		_loaders.set(loader.id, loader);
        _loaderCount = ObjectUtil.count(_loaders);
        Logger.log(this, Logger.INFO, "Registered EngineLoader: " + loader.id);
    }
    
    public function removeLoader(loader : EngineLoader) : Void
    {
        // Remove Playlist, Info and Language First
        removePlaylist(loader.playlist);
        removeInfo(loader.info);
        removeLanguage(loader.language);
        
		// Remove Loader itself.
		_loaders.remove(loader.id);
		
		// Reset Source if active source was removed.
		if (source == loader.id)
		{
			source = Constant.GAME_ENGINE;
		}
		
        _loaderCount = ObjectUtil.count(_loaders);
        
        if (loader.loaded) 
            dispatchEvent(new Event(LOADERS_UPDATE));
        
        Logger.log(this, Logger.INFO, "Removed EngineLoader: " + loader.id);
    }
    
    public function loaderInitialized(loader : EngineLoader) : Void
    {
        dispatchEvent(new Event(LOADERS_UPDATE));
    }
    
    private function get_engineLoaders() : Dynamic
    {
        return _loaders;
    }
    
    ///- Engine Playlist
    // Get Active Engine Playlist.
    public function getCurrentPlaylist() : EnginePlaylist
    {
        if (_playlists.exists(_source)) 
        {
            return _playlists.get(_source);
        }
        return _playlists.get(Constant.GAME_ENGINE);
    }
    
    // Get Engine Playlist.
    public function getPlaylist(id : String) : EnginePlaylist
    {
        return _playlists.get(id);
    }
    
    public function registerPlaylist(engine : EnginePlaylist) : Void
    {
        _playlists.set(engine.id, engine);
        Logger.log(this, Logger.INFO, "Registered Playlist: " + engine.id);
    }
    
    public function removePlaylist(engine : EnginePlaylist) : Void
    {
        if (engine != null && _playlists.exists(engine.id)) 
        {
			_playlists.remove(engine.id);
            Logger.log(this, Logger.INFO, "Removed Playlist: " + engine.id);
        }
    }
    
    ///- Engine Info
    // Get Active Engine Language.
    public function getCurrentInfo() : EngineSiteInfo
    {
        if (_info.exists(_source)) 
        {
            return _info.get(_source);
        }
        return _info.get(Constant.GAME_ENGINE);
    }
    
    // Get Engine Playlist.
    public function getInfo(id : String) : EngineSiteInfo
    {
        return _info.get(id);
    }
    
    public function registerInfo(info : EngineSiteInfo) : Void
    {
        _info.set(info.id, info);
        Logger.log(this, Logger.INFO, "Registered SiteInfo: " + info.id);
    }
    
    public function removeInfo(info : EngineSiteInfo) : Void
    {
        if (info != null && _info.exists(info.id)) 
        {
			_info.remove(info.id);
            Logger.log(this, Logger.INFO, "Removed SiteInfo: " + info.id);
        }
    }
    
    ///- Engine Language
    // Get Active Engine Language.
    public function getCurrentLanguage() : EngineLanguage
    {
        if (_languages.exists(_source)) 
        {
            return _languages.get(_source);
        }
        return _languages.get(Constant.GAME_ENGINE);
    }
    
    // Get Engine Language.
    public function getLanguage(id : String) : EngineLanguage
    {
        return _languages.get(id);
    }
    
    public function registerLanguage(language : EngineLanguage) : Void
    {
        _languages.set(language.id, language);
        Logger.log(this, Logger.INFO, "Registered Language: " + language.id);
    }
    
    public function removeLanguage(language : EngineLanguage) : Void
    {
        if (language != null && _languages.exists(language.id)) 
        {
			_languages.remove(language.id);
            Logger.log(this, Logger.INFO, "Removed Language: " + language.id);
        }
    }
    
    public function getString(id : String, lang : String = "us") : String
    {
        return getStringSource(source, id, lang);
    }
    
    public function getStringSource(engineSource : String, id : String, lang : String = "us") : String
    {
        var out : String;
        var el : EngineLanguage;
        
        // Get Text for Source Language, Fall back to FFR.
        for (eid in [engineSource, Constant.GAME_ENGINE])
        {
            el = getLanguage(eid);
            if (el != null) 
            {
                for (s in [lang, "us"])
                {
                    if ((out = el.getString(id, lang)) != "") 
                    {
                        return out;
                    }
                }
            }
        }
		
        // No Text, Return ID
        return id;
    }
    
    // UI
    private function get_scene() : UICore
    {
        return ui.scene;
    }
    
    private function set_scene(scene : UICore) : UICore
    {
        ResizeListener.clear();
        ui.scene = scene;
        return scene;
    }
    
    public function addOverlay(overlay : DisplayObject) : Void
    {
        ui.addOverlay(overlay);
    }
    
    public function e_stageResize(e : Event) : Void
    {
        ui.updateStageResize();
    }
}