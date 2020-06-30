package scenes.loader;

import assets.menu.FFRDudeCenter;
import assets.menu.FFRName;
import classes.engine.EngineCore;
import classes.engine.EngineLoader;
import classes.ui.Label;
import classes.ui.UIAnchor;
import classes.ui.UICore;
import classes.ui.UISprite;
import flash.events.Event;
import motion.Actuate;
import motion.easing.Elastic;
import motion.easing.Quad;
import scenes.home.SceneTitleScreen;
import scenes.loader.SceneGameLogin;


class SceneGameLoader extends UICore
{
	private var langLoader : EngineLoader;
	private var ffrlogo : UISprite;
	private var ffrname : UISprite;
	private var ffrstatus : Label;
	
	public function new(core : EngineCore)
	{
		super(core);
	}
	
	override public function onStage() : Void
	{
		// FFR Dude
		ffrlogo = new UISprite(this, new FFRDudeCenter());
		ffrlogo.anchor = UIAnchor.MIDDLE_CENTER;
		ffrlogo.scaleX = ffrlogo.scaleY = 0.65;
		ffrlogo.alpha = 0;
		
		// FFR Name
		ffrname = new UISprite(this, new FFRName(), -125, 0);
		ffrname.anchor = UIAnchor.MIDDLE_CENTER;
		ffrname.scaleX = ffrname.scaleY = 0.5;
		ffrname.alpha = 0;
		
		// Loading Text
		ffrstatus = new Label(this, 0, 0);
		ffrstatus.anchor = UIAnchor.MIDDLE_CENTER;
		ffrstatus.alpha = 0;
		
		// Logo Animation
		if (!core.flags.get(Flag.LOGIN_SCREEN_SHOWN))
		{
			Actuate.tween(ffrlogo, 1, { alpha : 0.85 }, false).delay(0.5);
			Actuate.tween(ffrlogo, 1.75, { scaleX : 0.4, scaleY : 0.4 }, false).ease(Elastic.easeOut).delay(0.5);
			Actuate.tween(ffrlogo, 1.5, { x : -125 }, false).delay(1.25);
			Actuate.tween(ffrname, 1, { alpha : 0.85 }, false).delay(1.5);
			Actuate.tween(ffrname, 1, { x : -75 }, false).ease(Quad.easeOut).delay(1.5);
			Actuate.tween(ffrlogo, 1.25, { y : -150 }, false).delay(2.5);
			Actuate.tween(ffrname, 1.25, { y : -150 }, false).delay(2.5).onComplete(e_timelineComplete);
		}
		else
		{
			ffrlogo.move(-125, -150);
			ffrlogo.scaleX = ffrlogo.scaleY = 0.4;
			ffrlogo.alpha = 0.85;
			ffrname.move(-75, -150);
			ffrname.scaleX = ffrname.scaleY = 0.5;
			ffrname.alpha = 0.85;
			e_timelineComplete();
		}
		super.onStage();
	}
	
	function e_comboChange(e:Dynamic) 
	{
		trace(e);
	}
	
	/**
	 * Event: TIMELINE_COMPLETE
	 * Logo Animation timeline completion event.
	 */
	private function e_timelineComplete() : Void
	{
		ffrstatus.move(ffrname.x + 30, ffrname.y + 30);
		Actuate.tween(ffrstatus, 1, { alpha : 0.85 } );
		addEventListener(Event.ENTER_FRAME, e_frameLoadingCheck);
	}
	
	//------------------------------------------------------------------------------------------------//
	/**
	 * Event: ENTER_FRAME:
	 * Handles the progress bar and load checks.
	 * @param	e Frame Event
	 */
	private function e_frameLoadingCheck(e : Event) : Void
	{
		// Update Status Text
		if ((core.flags.get(Flag.LOGIN_SCREEN_SHOWN) == true && !core.user.isLoaded) || (core.user.isLoaded && !core.user.permissions.isGuest)) 
		{
			ffrstatus.text = "Loading Game Data...";
		}
		// Check User Loaded.
		else if (!core.user.isLoaded) 
		{
			ffrstatus.text = "Loading User Data...";
		}
		
		if (core.user.isLoaded) 
		{
			// Check for Guest and never attempted Login.
			if (core.user.permissions.isGuest && !core.flags.get(Flag.LOGIN_SCREEN_SHOWN)) 
			{
				// Load Language
				if (langLoader == null) 
				{
					// Load Basic Language
					Logger.log(this, Logger.WARNING, "Loading temporary FFR Language.");
					langLoader = new EngineLoader(core, Constant.GAME_ENGINE, Constant.GAME_NAME);
					langLoader.loadLanguage(Constant.LANGUAGE_URL);
					return;
				}
				
				// Wait Till Language Loaded
				if (core.getLanguage(Constant.GAME_ENGINE) == null) 
					return;
				
				Logger.log(this, Logger.INFO, "User is guest, showing login.");
				removeEventListener(Event.ENTER_FRAME, e_frameLoadingCheck);
				core.scene = new SceneGameLogin(core);
			}
			// Engine Loading
			else 
			{
				var el : EngineLoader = core.getCurrentLoader();
				if (el == null) 
				{
					Logger.log(this, Logger.NOTICE, "Loading FFR Core Engine.");
					core.flags.set(Flag.LOGIN_SCREEN_SHOWN, true);
					_loadEngines();
				}
				else if (el.loaded) 
				{
					Logger.log(this, Logger.NOTICE, "FFR Core Engine Loaded.");
					removeEventListener(Event.ENTER_FRAME, e_frameLoadingCheck);
					core.scene = new SceneTitleScreen(core);
				}
				if (el != null) 
				{
					if (el.playlist == null && el.loaded_playlist) 
						ffrstatus.htmlText = "Loading Game Config..."
					else 
						ffrstatus.htmlText = "Loading Game Data... (<font face=\"Consolas\">" + ((el.loaded_playlist) ? "P" : "-") + ((el.loaded_info) ? "I" : "-") + ((el.loaded_language) ? "L" : "-") + "</font>)";
				}
			}
		}
	}
	
	//------------------------------------------------------------------------------------------------//
	/**
		 * Loads the default engines used for the game engine.
		 */
	private function _loadEngines() : Void
	{
		// Load FFR Playlist, Site Data, Language Text
		var requestParams : Dynamic = {
			session : Session.SESSION_ID,
			ver : Constant.VERSION,
		};  // "debugLimited": true  
		var canonLoader : EngineLoader = new EngineLoader(core, Constant.GAME_ENGINE, Constant.GAME_NAME);
		canonLoader.isCanon = true;
		canonLoader.loadFromConfig(Constant.SITE_CONFIG_URL, requestParams);
		
		//var os1Loader:EngineLoader = new EngineLoader(core);
		//os1Loader.loadFromConfig("http://keysmashingisawesome.com/r3.xml");
		
		//var os2Loader : EngineLoader = new EngineLoader(core);
		//os2Loader.loadFromConfig("http://104.236.179.121/r3.xml");
	}
}