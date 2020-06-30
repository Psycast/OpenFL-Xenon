package scenes.home;


import assets.menu.FFRDudeCenter;
import assets.menu.FFRName;
import classes.engine.EngineCore;
import classes.ui.BoxButton;
import classes.ui.UIAnchor;
import classes.ui.UIComponent;
import classes.ui.UICore;
import classes.ui.UISprite;
import com.flashfla.utils.ArrayUtil;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import motion.Actuate;
import scenes.songselection.SceneSongSelection;
//import scenes.songselection.SceneSongSelection;

class SceneTitleScreen extends UICore
{
	private var ffrlogo : UISprite;
	private var ffrname : UISprite;
	
	private var btnsText : Array<String> = ["Single Player", "Multiplayer", "Tutorial", "Settings"];
	private var selectedIndex : Int = 0;
	private var menuButtons : Array<BoxButton>;
	
	//------------------------------------------------------------------------------------------------//
	
	public function new(core : EngineCore)
	{
		super(core);
	}
	
	override public function onStage() : Void
	{
		stage.addEventListener(KeyboardEvent.KEY_DOWN, e_keyDown);
		
		// FFR Dude
		ffrlogo = new UISprite(this, new FFRDudeCenter(), -125, -150);
		ffrlogo.anchor = UIAnchor.MIDDLE_CENTER;
		ffrlogo.scaleX = ffrlogo.scaleY = 0.4;
		ffrlogo.alpha = 0.85;
		
		// FFR Name
		ffrname = new UISprite(this, new FFRName(), -75, -150);
		ffrname.anchor = UIAnchor.MIDDLE_CENTER;
		ffrname.scaleX = ffrname.scaleY = 0.5;
		ffrname.alpha = 0.85;
		
		_createMenu();
		
		super.onStage();
	}
	
	override public function destroy() : Void
	{
		stage.removeEventListener(KeyboardEvent.KEY_DOWN, e_keyDown);
	}
	
	//------------------------------------------------------------------------------------------------//
	
	///////////////////////////////////
	// private methods
	///////////////////////////////////
	
	/**
	 * Creates the menu buttons.
	 */
	private function _createMenu() : Void
	{
		// Setup Menu Buttons
		menuButtons = [];
		var btn : BoxButton;
		for (i in 0...btnsText.length){
			btn = new BoxButton(this, -75, ((i * 65) - 20), btnsText[i], e_menuClick);
			btn.setSize(250, 45);
			btn.tag = i;
			btn.anchor = UIAnchor.MIDDLE_CENTER;
			//btn.enabled = (i == 0);
			btn.alpha = 0;
			menuButtons.push(btn);
			Actuate.tween(btn, 1.5, { x : -125, alpha : 1 }, false).delay(((i + 1) * 0.15));
		}
		selectedIndex = ArrayUtil.find_next_index(false, 0, menuButtons, function(n : BoxButton) : Bool
			{
				return n.enabled;
			});
		menuButtons[selectedIndex].highlight = true;
	}
	
	/**
	 * Transitions the menu to closed state and jumps to the menu index UI scene.
	 * @param	menuIndex	Selected Menu Index
	 */
	private function _closeScene(menuIndex : Int) : Void
	{
		INPUT_DISABLED = true;
		
		// Animate Menu Close
		Actuate.tween(ffrlogo, 0.75, { alpha : 0 } );
		Actuate.tween(ffrname, 0.75, { alpha : 0 } );
		
		for (i in 0...btnsText.length) {
			Actuate.tween(menuButtons[i], 1.5, { x : -175, alpha : 0 }, false).delay(i * 0.15);
		}
		Actuate.timer(1.5 + (btnsText.length * 0.15)).onComplete(_switchScene, [menuIndex]);
	}
	
	/**
	 * Changes scenes based on ID from menu.
	 * @param	menuIndex Scene ID to change to.
	 */
	private function _switchScene(menuIndex : Int) : Void
	{
		// Switch to Intended UI scene
		switch (menuIndex)
		{
			case 0:
				core.scene = new SceneSongSelection(core);
		}
	}
	
	//------------------------------------------------------------------------------------------------//
	
	///////////////////////////////////
	// event handlers
	///////////////////////////////////
	
	/**
	 * Event: KEY_DOWN
	 * Used to navigate the menu using the arrow keys or user set keys
	 * @param	e Keyboard Event
	 */
	private function e_keyDown(e : KeyboardEvent) : Void
	{
		if (INPUT_DISABLED) 
			return;
		
		var newIndex : Int = selectedIndex;
		
		// Menu Selection
		if (e.keyCode == Keyboard.ENTER) 
		{
			_closeScene(menuButtons[selectedIndex].tag);
		}
		// Menu Navigation
		else if (e.keyCode == core.user.settings.key_down || e.keyCode == Keyboard.DOWN || e.keyCode == Keyboard.NUMPAD_2) 
		{
			newIndex++;
		}
		// New Index
		else if (e.keyCode == core.user.settings.key_up || e.keyCode == Keyboard.UP || e.keyCode == Keyboard.NUMPAD_8) 
		{
			newIndex--;
		}
		
		if (newIndex != selectedIndex) 
		{
			// Find First Menu Item
			newIndex = ArrayUtil.find_next_index(newIndex < selectedIndex, newIndex, menuButtons, function(n : BoxButton) : Bool
				{
					return n.enabled;
				});
			
			// Set Highlight
			menuButtons[selectedIndex].highlight = false;
			menuButtons[newIndex].highlight = true;
			selectedIndex = newIndex;
		}
	}
	
	/**
	 * Event: CLICK
	 * Handles the click event for menu buttons.
	 * @param	e	Click Event
	 */
	private function e_menuClick(e : Event) : Void
	{
		if (INPUT_DISABLED) 
			return;
		
		var menuIndex : Int = cast(e.target, UIComponent).tag;
		
		_closeScene(menuIndex);
	}
}

