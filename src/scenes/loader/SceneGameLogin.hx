package scenes.loader;

import Session;
import assets.menu.FFRDudeCenter;
import assets.menu.FFRName;
import classes.engine.EngineCore;
import classes.ui.Box;
import classes.ui.BoxButton;
import classes.ui.BoxCheck;
import classes.ui.BoxInput;
import classes.ui.Label;
import classes.ui.UIAnchor;
import classes.ui.UICore;
import classes.ui.UISprite;
import classes.user.User;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.net.SharedObject;
import flash.ui.Keyboard;
import motion.Actuate;
import motion.easing.Quad;
import openfl.display.Sprite;


class SceneGameLogin extends UICore
{
	private var guest_btn : BoxButton;
	private var login_btn : BoxButton;
	private var input_user : BoxInput;
	private var input_pass : BoxInput;
	private var save_checkbox : BoxCheck;
	private var loginBox : Box;
	
	//------------------------------------------------------------------------------------------------//
	
	public function new(core : EngineCore)
	{
		super(core);
		core.flags.set(Flag.LOGIN_SCREEN_SHOWN, true);
	}
	
	override public function onStage() : Void
	{
		stage.addEventListener(KeyboardEvent.KEY_DOWN, e_keyboardDown);
		
		// FFR Dude
		var ffrlogo : UISprite = new UISprite(this, new FFRDudeCenter(), -125, -150);
		ffrlogo.anchor = UIAnchor.MIDDLE_CENTER;
		ffrlogo.scaleX = ffrlogo.scaleY = 0.4;
		ffrlogo.alpha = 0.85;
		
		// FFR Name
		var ffrname : UISprite = new UISprite(this, new FFRName(), -75, -150);
		ffrname.anchor = UIAnchor.MIDDLE_CENTER;
		ffrname.scaleX = ffrname.scaleY = 0.5;
		ffrname.alpha = 0.85;
		
		// Login Box
		loginBox = new Box(this, -75, -70);
		loginBox.setSize(300, 140);
		loginBox.alpha = 0;
		loginBox.anchor = UIAnchor.MIDDLE_CENTER;
		
		//- Text
		// Username
		new Label(loginBox, 5, 5, core.getString("login_name"));
		
		input_user = new BoxInput(loginBox, 5, 25);
		input_user.setSize(290, 20);
		
		// Password
		new Label(loginBox, 5, 55, core.getString("login_pass"));
		
		input_pass = new BoxInput(loginBox, 5, 75);
		input_pass.setSize(290, 20);
		input_pass.password = true;
		
		// Save Login
		new Label(loginBox, 110, 108, core.getString("login_remember"));
		
		save_checkbox = new BoxCheck(loginBox, 92, 113);
		
		//- Buttons
		guest_btn = new BoxButton(loginBox, 6, loginBox.height - 36, core.getString("login_guest"), e_playAsGuest);
		guest_btn.setSize(75, 30);
		
		login_btn = new BoxButton(loginBox, loginBox.width - 81, loginBox.height - 36, core.getString("login_text"), e_playAsUser);
		login_btn.setSize(75, 30);
		
		// Load Saved Login Data
		var SO : Array<Dynamic> = _loadLoginDetails();
		if (SO != null && SO[2] == true) 
		{
			input_user.text = SO[0];
			input_pass.text = SO[1];
			save_checkbox.checked = true;
		}
		
		stage.focus = input_user.textField;
		input_user.textField.setSelection(input_user.text.length, input_user.text.length);
		
		_setFields(true);
		Actuate.tween(loginBox, 1, { x : -150, alpha : 1 } ).ease(Quad.easeIn);
		
		super.onStage();
	}
	
	override public function destroy() : Void
	{
		stage.removeEventListener(KeyboardEvent.KEY_DOWN, e_keyboardDown);
	}
	
	//------------------------------------------------------------------------------------------------//
	
	///////////////////////////////////
	// private methods
	///////////////////////////////////
	
	/**
	 * Changes Username/Password UI fields.
	 * @param	enabled		Sets enabled status on relevent UI fields.
	 * @param	isError		Sets colour indicators on password field.
	 */
	private function _setFields(enabled : Bool, isError : Bool = false) : Void
	{
		input_user.enabled = input_pass.enabled = login_btn.enabled = guest_btn.enabled = enabled;
		
		if (isError) 
		{
			input_pass.text = "";
			//input_pass.textColor = 0xFFDBDB;
			input_pass.color = 0xFF0000;
			input_pass.borderColor = 0xFF0000;
		}
	}
	
	/**
	 * Plays closing animation and switches back to GameLoader scene.
	 */
	private function _gotoLoader() : Void
	{
		Actuate.tween(loginBox, 1, { x : -225, alpha : 0}).ease(Quad.easeIn).onComplete(function() : Void
			{
				// Remove Placeholder Language Loader
				core.removeLoader(core.getCurrentLoader());
				
				// Jump back to Engine Loading
				core.scene = new SceneGameLoader(core);
			});
	}
	
	/**
	 * Guest Play, disables UI items and goes back to game loader.
	 */
	private function _asGuest() : Void
	{
		Logger.log(this, Logger.INFO, "Playing as Guest");
		_setFields(false);
		_gotoLoader();
	}
	
	/**
	 * Attempts to login as requested user through the use of temporary session.
	 * @param	username	Username of user to login as.
	 * @param	password	Password of user to login as.
	 */
	private function _loginUser(username : String = "", password : String = "") : Void
	{
		Logger.log(this, Logger.INFO, "Attempting Login: " + username);
		_setFields(false);
		
		// Login User
		var session : Session = new Session(_loginUserComplete, _loginUserError);
		session.login(username, password);
	}
	
	/**
	 * Callback for successful user login from "_loginUser".
	 * Creates new user using session details and goes back to loader.
	 * @param	e
	 */
	private function _loginUserComplete(e : Event) : Void
	{
		Logger.log(this, Logger.INFO, "User Login Success");
		
		// Save Login Details
		_saveLoginDetails(save_checkbox.checked, input_user.text, input_pass.text);
		
		// Load User using Session
		core.user = new User(true, true);
		
		// Jump back to Loading Screen
		_gotoLoader();
	}
	
	/**
	 * Callback for unsuccessful user login from "_loginUser".
	 * Reenables UI fields and informs user of incorrect/invalid login.
	 * @param	e
	 */
	private function _loginUserError(e : Event) : Void
	{
		Logger.log(this, Logger.ERROR, "User Login Error");
		_setFields(true, true);
	}
	
	/**
	 * Saves user information to players local storage.
	 * @param	saveLogin 	To save user information or clear user information.
	 * @param	username	Username to store.
	 * @param	password	Password to store.
	 */
	private function _saveLoginDetails(saveLogin : Bool = false, username : String = "", password : String = "") : Void
	{
		var gameSave : SharedObject = SharedObject.getLocal(Constant.LOCAL_SO_NAME);
		if (saveLogin) 
		{
			gameSave.data.uUsername = username;
		}
		else 
		{
			// TODO Remove Saved Info
		}
		gameSave.flush();
	}
	
	/**
	 * Loads saved local user information from local storage.
	 * @return array username,password,isLoaded
	 */
	private function _loadLoginDetails() : Array<Dynamic>
	{
		var gameSave : SharedObject = SharedObject.getLocal(Constant.LOCAL_SO_NAME);
		if (gameSave.data.uUsername != null) 
		{
			return [((gameSave.data.uUsername) ? gameSave.data.uUsername : ""), ((gameSave.data.uPassword) ? gameSave.data.uPassword : ""), true];
		}
		return ["", "", false];
	}
	
	//------------------------------------------------------------------------------------------------//
	
	///////////////////////////////////
	// event handlers
	///////////////////////////////////
	
	/**
	 * Event: CLICK
	 * Click Event for "Login" button.
	 * @param	e
	 */
	private function e_playAsUser(e : Event) : Void
	{
		_loginUser(input_user.text, input_pass.text);
	}
	
	/**
	 * Event: CLICK
	 * Click event for "Guest" button.
	 * @param	e
	 */
	private function e_playAsGuest(e : Event) : Void
	{
		_asGuest();
	}
	
	/**
	 * Event: KEY_DOWN
	 * Keyboard listener for enter key to login user or play as guest.
	 * @param	e
	 */
	private function e_keyboardDown(e : KeyboardEvent) : Void
	{
		if (e.keyCode == Keyboard.ENTER) 
		{
			if (input_user.text.length > 0) 
				e_playAsUser(e)
			else 
			e_playAsGuest(e);
		}
		e.stopPropagation();
	}
}