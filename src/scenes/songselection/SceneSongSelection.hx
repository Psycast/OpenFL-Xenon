package scenes.songselection;

import TypeDefinitions;
import assets.menu.FFRDude;
import classes.engine.EngineCore;
import classes.engine.EngineLevel;
import classes.engine.EngineLoader;
import classes.engine.EnginePlaylist;
import classes.ui.Box;
import classes.ui.BoxButton;
import classes.ui.BoxCombo;
import classes.ui.BoxInput;
import classes.ui.Label;
import classes.ui.ScrollPaneBars;
import classes.ui.UICore;
import classes.ui.UISprite;
import classes.ui.UIStyle;
import com.flashfla.utils.ArrayUtil;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.ui.Keyboard;
import motion.Actuate;
import openfl.geom.Rectangle;
import scenes.songselection.ui.SongButton;
import scenes.songselection.ui.filtereditor.FilterEditor;
import scenes.songselection.ui.filtereditor.FilterIcon;

class SceneSongSelection extends UICore
{
	public var SEARCH_OPTIONS : Array<String> = ["name", "author", "stepauthor", "style"];
	public var DM_STANDARD : String = "normal";
	public var DM_ALL : String = "all";
	public var DM_SEARCH : String = "search";
	
	// Data Elements
	/** Engine Playlist Reference */
	private var _playlist : EnginePlaylist;
	
	// UI Elements
	/** Contains all child elements for easy horizontal movement */
	private var shift_plane : UISprite;
	
	private var ffr_logo : UISprite;
	
	/** Genre Selection Scroll Pane */
	private var genre_scrollpane : ScrollPaneBars;
	private var genre_songButtons : Array<Label>;
	
	/** Song Selection Background */
	private var top_bar_background : Box;
	
	private var search_input : BoxInput;
	private var search_button : BoxButton;
	private var search_type_combo : BoxCombo;
	private var filters_button : BoxButton;
	
	/** Song Selection */
	private var ss_background : Box;
	private var ss_scrollpane : ScrollPaneBars;
	private var ss_songButtons : Array<SongButton>;
	
	/** Bottom Area */
	private var bottom_bar_background : Box;
	private var bottom_user_info : Label;
	
	/** Sidebar */
	private var side_bar_background : Box;
	private var options_button : BoxButton;
	
	// UI Variables
	public var DISPLAY_MODE : String = "";
	public var SELECTED_GENRE : Int = 1;
	public var SELECTED_GENRE_TAB : Label;
	public var SELECTED_SONG : SongButton;
	public var CURRENT_PAGE : Int = 0;
	public var SEARCH_TEXT : String = "";
	public var SEARCH_TYPE : String = "";
	
	//------------------------------------------------------------------------------------------------//
	
	public function new(core : EngineCore)
	{
		DISPLAY_MODE = DM_STANDARD;
		SEARCH_TYPE = SEARCH_OPTIONS[0];
		
		super(core);
	}
	
	override public function init() : Void
	{
		super.init();
		INPUT_DISABLED = true;
	}
	
	override public function onStage() : Void
	{
		stage.addEventListener(KeyboardEvent.KEY_DOWN, e_keyboardDown);
		stage.addEventListener(Event.ENTER_FRAME, e_frameFadeIn);
		core.addEventListener(EngineCore.LOADERS_UPDATE, e_loadersUpdate);
		
		// Overall Background
		shift_plane = new UISprite(this);
		shift_plane.alpha = 0;
		
		// Game Logo
		ffr_logo = new UISprite(shift_plane, new FFRDude(), 22, 12);
		ffr_logo.scaleX = ffr_logo.scaleY = 0.3;
		
		// Setup Genre Selection Pane/Bar
		genre_scrollpane = new ScrollPaneBars(shift_plane, 5, 125);
		genre_scrollpane.setSize(135, Constant.GAME_HEIGHT - 130);
		genre_scrollpane.addEventListener(MouseEvent.CLICK, e_genreSelectionPaneClick);
		
		// Search / Filter Box
		top_bar_background = new Box(shift_plane, 145, -1);
		
		search_input = new BoxInput(top_bar_background, 5, 5);
		search_input.textField.tabEnabled = false;
		search_button = new BoxButton(top_bar_background, 105, 5, core.getString("song_selection_menu_search"), e_searchClick);
		search_type_combo = new BoxCombo(core, top_bar_background, 105, 5, "---", e_searchTypeClick);
		search_type_combo.options = createSearchOptions();
		search_type_combo.title = core.getString("song_selection_menu_search_type");
		search_type_combo.selectedIndex = SEARCH_TYPE;
		filters_button = new BoxButton(top_bar_background, 205, 5, core.getString("song_selection_filters"), e_filtersClick);
		
		search_button.fontSize = filters_button.fontSize = search_type_combo.fontSize = UIStyle.FONT_SIZE - 3;
		
		// Setup Song Selection Pane/Bar
		ss_background = new Box(shift_plane, 145, 40);
		ss_scrollpane = new ScrollPaneBars(ss_background, 10, 10);
		ss_scrollpane.addEventListener(MouseEvent.CLICK, e_songSelectionPaneClick);
		
		// Search / Filter Box
		bottom_bar_background = new Box(shift_plane, 145, Constant.GAME_HEIGHT - 36);
		bottom_user_info = new Label(bottom_bar_background, 5, 5, "User Info");
		/*bottom_user_info = new Label(bottom_bar_background, 5, 5, sprintf(core.getString("main_menu_userbar"), {
			player_name : core.user.name,
			games_played : NumberUtil.numberFormat(core.user.info.games_played),
			grand_total : NumberUtil.numberFormat(core.user.info.grand_total),
			rank : NumberUtil.numberFormat(core.user.info.game_rank),
			avg_rank : NumberUtil.numberFormat(core.user.levelranks.getAverageRank(core.canonLoader), 3, true),
		}));*/
		bottom_user_info.autoSize = TextFieldAutoSize.CENTER;
		bottom_user_info.fontSize = UIStyle.FONT_SIZE - 1;
		
		// Sidebar
		side_bar_background = new Box(shift_plane, Constant.GAME_WIDTH - 40, -1);
		options_button = new BoxButton(side_bar_background, 5, 5);
		options_button.setSize(31, 31);
		(new FilterIcon(options_button, 3, 3, FilterIcon.ICON_GEAR, false)).setSize(options_button.width - 4, options_button.width - 4);
		
		// Draw All Game List
		drawGameList();
		
		super.onStage();
	}
	
	override public function destroy() : Void
	{
		stage.removeEventListener(KeyboardEvent.KEY_DOWN, e_keyboardDown);
		core.removeEventListener(EngineCore.LOADERS_UPDATE, e_loadersUpdate);
	}
	
	override public function position() : Void
	{
		// Update Genre Scrollbar Size + Position
		genre_scrollpane.setSize(135, Constant.GAME_HEIGHT - 130);
		
		// Top Bar
		top_bar_background.setSize(Constant.GAME_WIDTH - 190, 36);
		filters_button.setSize(75, top_bar_background.height - 11);
		filters_button.x = top_bar_background.width - filters_button.width - 5;
		search_button.setSize(75, top_bar_background.height - 11);
		search_button.x = filters_button.x - search_button.width - 5;
		search_type_combo.setSize(115, top_bar_background.height - 11);
		search_type_combo.x = search_button.x - search_type_combo.width - 5;
		search_input.setSize(search_type_combo.x - 10, top_bar_background.height - 11);
		
		// Update Song Scroll Pane
		ss_background.setSize(top_bar_background.width, Constant.GAME_HEIGHT - 80);
		ss_scrollpane.setSize(ss_background.width - 20, ss_background.height - 20);
		
		// Update Song Button Widths
		for (item in ss_songButtons)
		{
			item.width = ss_scrollpane.paneWidth;
		}
		
		// Scroll Pane Size
		bottom_bar_background.setSize(top_bar_background.width, 36);
		bottom_bar_background.y = Constant.GAME_HEIGHT - 35;
		bottom_user_info.setSize(bottom_bar_background.width - 10, bottom_bar_background.height - 11);
		
		// Sidebar
		side_bar_background.setSize(41, Constant.GAME_HEIGHT + 2);
		side_bar_background.x = Constant.GAME_WIDTH - 40;
		options_button.y = 5;
	}
	
	//------------------------------------------------------------------------------------------------//
	
	///////////////////////////////////
	// public methods
	///////////////////////////////////
	
	/**
	 * Draws all the important game list that need refreshing.
	 */
	public function drawGameList() : Void
	{
		// Get Updated Playlist Reference
		_playlist = core.getCurrentPlaylist();
		
		drawGenreList();
		drawSongList();
		
		// Size / Position
		position();
	}
	
	/**
	 * Creates the Genre Buttons.
	 */
	public function drawGenreList() : Void
	{
		genre_scrollpane.removeChildren();
		genre_scrollpane.content.graphics.clear();
		genre_songButtons = [];
		
		var genreLabel : Label;
		var genreYPosition : Float = 0;
		var drawPosition : Rectangle = new Rectangle(0, 0, 0, 10);
		var displayAltEngines : Bool = (core.loaderCount > 1 && core.user.settings.display_alt_engines);
		
		// Get Engine Sources
		var engineSources : Array<Array<String>> = [];
		if (displayAltEngines) 
		{
			for (item in core.engineLoaders)
			{
				if (item.isCanon || !item.loaded) 
					continue;  // Skip FFR/Non-loaded engines for now.
				engineSources.push(item.infoArray);
			}
			engineSources.sort(function(a,b) return Reflect.compare(a[0].toLowerCase(), b[0].toLowerCase()) );
		}
		engineSources.unshift(core.canonLoader.infoArray);  // Place FFR first.  
		
		// Draw Search Tag / Engine Label
		if (DISPLAY_MODE == DM_SEARCH) 
		{
			genreLabel = new Label(genre_scrollpane, 0, genreYPosition, "Search");
			genreLabel.tag = {
				engine : core.source,
				genre : "search",
			};
			genreLabel.setSize(genre_scrollpane.paneWidth, 0);
			genreLabel.fontSize = UIStyle.FONT_SIZE + 4;
			drawPosition = new Rectangle(0, genreYPosition, 1, genreLabel.height);
			genreYPosition += genreLabel.height + 2;
		}
		
		// Draw Genre Labels
		var engineSource : Array<String>;
		for (engine in 0...engineSources.length){
			engineSource = engineSources[engine];
			
			// Draw Diving Border
			if (genreYPosition != 0) 
			{
				genre_scrollpane.content.graphics.lineStyle(UIStyle.BORDER_SIZE, 0xFFFFFFF, 0.5);
				genre_scrollpane.content.graphics.moveTo(0, genreYPosition + 1);
				genre_scrollpane.content.graphics.lineTo(genre_scrollpane.paneWidth, genreYPosition + 1);
			}
			
			// Engine Label
			if (displayAltEngines) 
			{
				genreLabel = new Label(genre_scrollpane, 0, genreYPosition, "<font color=\"" + UIStyle.ACTIVE_FONT_COLOR + "\">" + engineSource[1] + "</font>", true);
				genreLabel.setSize(genre_scrollpane.paneWidth, 0);
				genreLabel.fontSize = UIStyle.FONT_SIZE + 4;
				genreYPosition += genreLabel.height + 2;
			}
			
			// All Genre 
			genreLabel = new Label(genre_scrollpane, 0, genreYPosition, core.getStringSource(engineSource[2], "genre_-1"), true);
			genreLabel.tag = {
				engine : engineSource[2],
				genre : "all",
			};
			genreLabel.setSize(genre_scrollpane.paneWidth, 20);
			genreLabel.mouseEnabled = true;
			
			if (core.source == engineSource[2] && DISPLAY_MODE == DM_ALL) 
			{
				genreLabel.fontSize = UIStyle.FONT_SIZE + 2;
				SELECTED_GENRE_TAB = genreLabel;
				drawPosition = new Rectangle(0, genreYPosition, 1, genreLabel.height);
			}
			genreYPosition += genreLabel.height + 5;
			genre_songButtons.push(genreLabel);
			
			// Genre Labels
			for (genre_id in Reflect.fields(core.getPlaylist(engineSource[2]).genre_list))
			{
				var genre_int : Int = Std.parseInt(genre_id);
				genreLabel = new Label(genre_scrollpane, 0, genreYPosition, core.getStringSource(engineSource[2], "genre_" + (genre_int - 1)), true);
				genreLabel.tag = {
					engine : engineSource[2],
					genre : genre_id,
				};
				genreLabel.setSize(genre_scrollpane.paneWidth, 20);
				genreLabel.mouseEnabled = true;
				if (core.source == engineSource[2] && genre_int == SELECTED_GENRE) 
				{
					genreLabel.fontSize = UIStyle.FONT_SIZE + 2;
					SELECTED_GENRE_TAB = genreLabel;
					drawPosition = new Rectangle(0, genreYPosition, 1, genreLabel.height);
				}
				
				genreYPosition += genreLabel.height + 5;
				genre_songButtons.push(genreLabel);
			}
		}
		
		// Draw Active Genre
		genre_scrollpane.content.graphics.lineStyle(UIStyle.BORDER_SIZE, 0xFFFFFFF, 0.5);
		genre_scrollpane.content.graphics.beginFill(0xFFFFFF, 0.25);
		genre_scrollpane.content.graphics.drawRect(0, drawPosition.y, genre_scrollpane.paneWidth, drawPosition.height);
		genre_scrollpane.content.graphics.endFill();
		
		// Reset Scroll
		genre_scrollpane.scrollReset();
	}
	
	/**
	 * Creates the Song Buttons
	 */
	public function drawSongList() : Void
	{
		ss_scrollpane.removeChildren();
		ss_songButtons = [];
		
		var i : Int;
		var list : Array<EngineLevel>;
		
		// Search Mode
		if (DISPLAY_MODE == DM_SEARCH) 
		{
			// Filter
			list = _playlist.index_list.filter(function(item : EngineLevel) : Bool
				{
					return Reflect.field(item, SEARCH_TYPE).toLowerCase().indexOf(SEARCH_TEXT) != -1;
				});
			list.sort(function(a, b) return Reflect.compare(a.name.toLowerCase(), b.name.toLowerCase()) );
		}
		// Display All
		else if (DISPLAY_MODE == DM_ALL) 
		{
			list = _playlist.index_list;
			
			// User Filter
			if (core.variables.active_filter != null) 
			{
				list = list.filter(function(item : EngineLevel) : Bool
					{
						return core.variables.active_filter.process(item, core.user);
					});
			}
			list = list.slice(CURRENT_PAGE * 500, (CURRENT_PAGE + 1) * 500);
		}
		
		// Standard Display
		else 
		{
			list = _playlist.genre_list[SELECTED_GENRE];
		}
		
		// User Filter
		if (core.variables.active_filter != null && list != null && DISPLAY_MODE != DM_ALL) 
		{
			list = list.filter(function(item : EngineLevel) : Bool
				{
					return core.variables.active_filter.process(item, core.user);
				});
		}
		
		// Display
		if (list != null && list.length > 0) 
		{
			for (i in 0...list.length) {
				ss_songButtons.push(new SongButton(ss_scrollpane, 0, i * 31, core, list[i]));
			}
			
			// Select First Song
			_changeSelectedSong(ss_songButtons[0]);
		}
		
		updateSongPosition();
		
		// Reset Scroll
		ss_scrollpane.verticalBar.scroll = 0;
	}
	
	private function updateSongPosition() : Void
	{
		var songButtonYPosition : Float = 0;
		for (i in 0...ss_songButtons.length){
			ss_songButtons[i].y = songButtonYPosition;
			songButtonYPosition += ss_songButtons[i].height + 5;
		}
	}
	
	//------------------------------------------------------------------------------------------------//
	
	///////////////////////////////////
	// private methods
	///////////////////////////////////
	
	/**
	 * Returns the genre tag for the next genre.
	 * @param	dir Next index direction. True is previous, False is next.
	 * @return tag object from Genre label.
	 */
	private function _getNextGenreTag(dir : Bool) : Dynamic
	{
		if (genre_songButtons == null) 
			return null;
		
		var index : Int = ArrayUtil.index_wrap(Lambda.indexOf(genre_songButtons, SELECTED_GENRE_TAB) + ((dir) ? -1 : 1), 0, genre_songButtons.length - 1);
		var genre : Label = genre_songButtons[index];
		
		return genre.tag;
	}
	
	/**
	 * Changes the current genre using the provided tag for information.
	 * @param	tag
	 */
	private function _changeGenreByTag(tag : Dynamic) : Void
	{
		if (tag.engine != core.source) 
		{
			core.source = tag.engine;
		}
		
		// All Genre
		if (tag.genre == "all") 
		{
			DISPLAY_MODE = DM_ALL;
			SELECTED_GENRE = -1;
		}
		// Normal Genres
		else 
		{
			DISPLAY_MODE = DM_STANDARD;
			SELECTED_GENRE = Std.parseInt(tag.genre);
		}
		drawGameList();
	}
	
	/**
	 * Changes the selected/highlighted song to the provided song button.
	 * @param	songButton Song to set as active.
	 */
	private function _changeSelectedSong(songButton : SongButton) : Void
	{
		if (SELECTED_SONG != null) 
			SELECTED_SONG.highlight = false;
		if (songButton == null) 
			return;
		(SELECTED_SONG = songButton).highlight = true;
		
		updateSongPosition();
	}
	
	/**
	 * Adds the currently selected song
	 * @param	goToLoader Jump to song loader scene after adding to queue.
	 */
	private function _addSelectedSongToQueue(goToLoader : Bool = false) : Void
	{
		if (SELECTED_SONG != null) 
		{
			core.variables.song_queue.push(SELECTED_SONG.songData);
			if (goToLoader) 
			{
				_closeScene(0);
			}
		}
	}
	
	/**
	 * Does the scene closing animation before switching scene.
	 * @param	sceneIndex Scene Index to jump to.
	 */
	private function _closeScene(sceneIndex : Int) : Void
	{
		INPUT_DISABLED = true;
		Actuate.tween(shift_plane, 0.5, { alpha: 0 } ).onComplete(function() : Void { _switchScene(sceneIndex); } );
	}
	
	/**
	 * Changes scenes based on ID.
	 * @param	menuIndex Scene ID to change to.
	 */
	private function _switchScene(sceneIndex : Int) : Void
	{
		/*
		// Switch to Intended UI scene
		switch (sceneIndex)
		{
			case 0:
				core.scene = new SceneSongLoader(core);
		}
		*/
	}
	
	/**
	 * Creates the search type options for the BoxCombo
	 * @return Array of options with correct language strings.
	 */
	private function createSearchOptions() : Array<ComboOptionDef>
	{
		var options : Array<ComboOptionDef> = [];
		for (i in 0...SEARCH_OPTIONS.length){
			options.push( {
				label: core.getString("song_value_" + SEARCH_OPTIONS[i]), 
				value: SEARCH_OPTIONS[i]
			});
		}
		
		return options;
	}
	
	//------------------------------------------------------------------------------------------------//
	
	///////////////////////////////////
	// event handlers
	///////////////////////////////////
	
	/**
	 * Event: Event.ENTER_FRAME
	 * Called by the initial fade-in one frame after init to avoid the lag caused
	 * by the creation of the song list.
	 */
	private function e_frameFadeIn(e : Event) : Void
	{
		stage.removeEventListener(Event.ENTER_FRAME, e_frameFadeIn);
		Actuate.tween(shift_plane, 0.5, { alpha : 1 } ).delay(0.25).onComplete(function() : Void { INPUT_DISABLED = false; } );
	}
	
	/**
	 * Event: EngineCore.LOADERS_UPDATE
	 * Called when a engine loader is added or removed from the core.
	 */
	private function e_loadersUpdate(e : Event) : Void
	{
		// Current Playlist got removed.
		if (!core.engineLoaders.exists(_playlist.id))
		{
			SELECTED_GENRE = 1;
		}
		drawGameList();
	}
	
	/**
	 * Event: MOUSE_CLICK
	 * Genre Scrollpane Click
	 */
	private function e_genreSelectionPaneClick(e : MouseEvent) : Void
	{
		if (INPUT_DISABLED) 
			return;
		
		var target : Dynamic = e.target;
		if (Std.is(target, Label)) 
		{
			_changeGenreByTag(cast(target, Label).tag);
		}
	}
	
	/**
	 * Event: BoxCombo Change
	 * @param	e Object containing the selected option.
	 */
	private function e_searchTypeClick(e : Dynamic) : Void
	{
		SEARCH_TYPE = Reflect.field(e, "value");
	}
	
	/**
	 * Event: MOUSE_CLICK
	 * Search Button Click Event
	 */
	private function e_searchClick(e : Event) : Void
	{
		if (INPUT_DISABLED) 
			return;
		
		SEARCH_TEXT = StringTools.trim(search_input.text.toLowerCase());
		if (SEARCH_TEXT != "") 
		{
			DISPLAY_MODE = DM_SEARCH;
			SELECTED_GENRE = -1;
			
			drawGameList();
		}
	}
	
	/**
	 * Event: MOUSE_CLICK
	 * Search Button Click Event
	 */
	private function e_filtersClick(e : Event) : Void
	{
		if (INPUT_DISABLED) 
			return;
		
		core.addOverlay(new FilterEditor(core));
	}
	
	/**
	 * Event: MOUSE_CLICK
	 * Song Selection Scrollpane Click
	 */
	private function e_songSelectionPaneClick(e : MouseEvent) : Void
	{
		if (INPUT_DISABLED) 
			return;
		
		var target : Dynamic = e.target;
		if (Std.is(target, SongButton)) 
		{
			if (SELECTED_SONG != null && SELECTED_SONG == e.target) 
			{
				_addSelectedSongToQueue(true);
			}
			else 
			{
				_changeSelectedSong(cast(e.target, SongButton));
			}
		}
	}
	
	/**
	 * Event: KEY_DOWN
	 * Used to navigate the menu using the arrow keys or user set keys
	 */
	private function e_keyboardDown(e : KeyboardEvent) : Void
	{
		if (INPUT_DISABLED) 
			return;
			
		// Genre Navigation
		if (e.keyCode == Keyboard.TAB) 
		{
			_changeGenreByTag(_getNextGenreTag(e.shiftKey));
			genre_scrollpane.scrollChild(SELECTED_GENRE_TAB);
		}
		
		// Focus is Search Input
		if (stage.focus == search_input.textField) 
		{
			if (e.keyCode == Keyboard.ENTER) 
			{
				e_searchClick(e);
			}
			return;
		}
		
		// No Stage Focus
		if (stage.focus != null || !(Std.is(stage.focus, TextField))) 
		{
			// Song Navigation
			if (ss_songButtons.length > 0) 
			{
				var selectedIndex : Int = (SELECTED_SONG != null) ? Lambda.indexOf(ss_songButtons, SELECTED_SONG) : 0;
				var newIndex : Int = selectedIndex;
				
				// Select Song
				if (e.keyCode == Keyboard.ENTER) 
				{
					_addSelectedSongToQueue(true);
				}
				else if (e.keyCode == core.user.settings.key_down || e.keyCode == Keyboard.DOWN || e.keyCode == Keyboard.NUMPAD_2) 
				{
					newIndex++;
				}
				else if (e.keyCode == core.user.settings.key_up || e.keyCode == Keyboard.UP || e.keyCode == Keyboard.NUMPAD_8) 
				{
					newIndex--;
				}
				else if (e.keyCode == Keyboard.PAGE_DOWN) 
				{
					newIndex += 10;
				}
				else if (e.keyCode == Keyboard.PAGE_UP) 
				{
					newIndex -= 10;
				}
				
				// New Index
				if (newIndex != selectedIndex) 
				{
					// Find First Menu Item
					newIndex = ArrayUtil.find_next_index(newIndex < selectedIndex, newIndex, ss_songButtons, function(n : SongButton) : Bool
						{
							return !n.songData.is_title_only;
						});
					
					_changeSelectedSong(ss_songButtons[newIndex]);
					ss_scrollpane.scrollChild(SELECTED_SONG);
				}
				return;
			}
		}
	}
}