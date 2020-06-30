import classes.engine.EngineCore;
import classes.engine.EngineLevel;
import classes.engine.EngineRanks;
import classes.engine.EngineRanksLevel;
class Constant
{
	//- URLs
	public static inline var ROOT_URL : String = "http://www.flashflashrevolution.com/game/r3/";
	public static var SITE_CONFIG_URL : String = ROOT_URL + "r3-gameConfig.php";
	public static var SITE_LOGIN_URL : String = ROOT_URL + "r3-siteLogin.php";
	public static var SITE_REPLAY_URL : String = ROOT_URL + "r3-siteReplay.php";
	public static var USER_INFO_URL : String = ROOT_URL + "r3-userInfo.php";
	public static var USER_SMALL_INFO_URL : String = ROOT_URL + "r3-userSmallInfo.php";
	public static var USER_SETTINGS_URL : String = ROOT_URL + "r3-userSettings.php";
	public static var USER_FRIENDS_URL : String = ROOT_URL + "r3-userFriends.php";
	public static var USER_REPLAY_URL : String = ROOT_URL + "r3-userReplay.php";
	public static var USER_RANKS_URL : String = ROOT_URL + "r3-userRanks.php";
	//public static const USER_AVATAR_URL:String = "http://www.flashflashrevolution.com/avatar_imgembedded.php";
	public static var HISCORES_URL : String = ROOT_URL + "r3-hiscores.php";
	public static var LANGUAGE_URL : String = ROOT_URL + "r3-language.php";
	public static var NOTESKIN_URL : String = ROOT_URL + "r3-noteSkins.xml";
	public static var NOTESKIN_SWF_URL : String = ROOT_URL + "/noteskins/";
	public static var SONG_DATA_URL : String = ROOT_URL + "r3-songLoad.php";
	public static var SONG_START_URL : String = ROOT_URL + "r3-songStart.php";
	public static var SONG_SAVE_URL : String = ROOT_URL + "r3-songSave.php";
	//public static const MULTIPLAYER_SUBMIT_URL:String = "http://www.flashflashrevolution.com/game/ffr-legacy_multiplayer.php";
	//public static const MULTIPLAYER_SUBMIT_URL_VELOCITY:String = "http://www.flashflashrevolution.com/game/ffr-velocity_multiplayer.php";
	//public static const LEVEL_STATS_URL:String = "http://www.flashflashrevolution.com/levelstats.php?level=";
	
	//- Other
	public static inline var LOCAL_SO_NAME : String = "90579262-509d-4370-9c2e-564667e511d7";
	public static inline var VERSION : Int = 3;
	public static inline var GAME_ENGINE : String = "ffr";
	public static inline var GAME_NAME : String = "FlashFlashRevolution";
	public static var GAME_WIDTH : Int = 800;
	public static var GAME_WIDTH_CENTER : Int = Math.floor(GAME_WIDTH / 2);
	public static var GAME_HEIGHT : Int = 600;
	public static var GAME_HEIGHT_CENTER : Int = Math.floor(GAME_HEIGHT / 2);
	
	public static function prepare_url(url:String):String
	{
		return url + (url.indexOf("?") != -1 ? "&d=" : "?d=") + Date.now().getTime();
	}
	
	
	//- Functions
	public static function getSongIconIndex(song : EngineLevel, rank : EngineRanksLevel) : Int{
		var songIcon : Int = 0;
		if (song != null && rank != null) {
			// No Score
			if (rank.score == 0)
				songIcon = 0;
			
			// No Score
			if (rank.score > 0)
				songIcon = 1;
			
			// FC
			if (rank.amazing + rank.perfect + rank.good + rank.average == song.notes && rank.miss == 0 && rank.combo == song.notes)
				songIcon = 2;
			
			// SDG
			if (song.score_raw - rank.raw_score < 250)
				songIcon = 3;
			
			// BlackFlag
			if (rank.perfect == song.notes - 1 && rank.good == 1 && rank.average == 0 && rank.miss == 0 && rank.boo == 0 && rank.combo == song.notes)
				songIcon = 4;
			
			// BooFlag
			if (rank.perfect == song.notes - 1 && rank.good == 0 && rank.average == 0 && rank.miss == 0 && rank.boo == 1 && rank.combo == song.notes)
				songIcon = 5;
			
			// AAA
			if (rank.raw_score == song.score_raw)
				songIcon = 6;
		}
		return songIcon;
	}
	
	public static var SONG_ICON_TEXT : Array<String> = ["<font color=\"#C6C6C6\">UNPLAYED</font>", "", "<font color=\"#00FF00\">FC</font>", 
		"<font color=\"#f2a254\">SDG</font>", "<font color=\"#2C2C2C\">BLACKFLAG</font>", 
		"<font color=\"#473218\">BOOFLAG</font>", "<font color=\"#FFFF38\">AAA</font>"];
	
	public static function getSongIcon(core : EngineCore, song : EngineLevel) : String{
		return SONG_ICON_TEXT[getSongIconIndex(song, getSongRank(core, song))];
	}
	
	public static function getSongRank(core : EngineCore, song : EngineLevel) : EngineRanksLevel
	{
		var eng_ranks : EngineRanks = core.user.levelranks.getEngineRanks(song.source);
		if (eng_ranks != null) 
		{
			return eng_ranks.getRank(song.id);
		}
		return null;
	}
}
