package classes.engine;

class EngineLevel
{
	@:isVar public var author_with_url(get, never) : String;
	@:isVar public var stepauthor(get, set) : String;
	@:isVar public var stepauthor_with_url(get, never) : String;
	@:isVar public var time(get, set) : String;
	@:isVar public var time_secs(get, never) : Int;
	@:isVar public var notes(get, set) : Int;
	@:isVar public var score_raw(get, never) : Int;
	@:isVar public var score_combo(get, never) : Int;

	public var source : String;
	public var id : String;
	public var index : Int;
	public var genre : Int;
	
	public var name : String = "";
	public var author : String = "";
	public var author_url : String = "";
	private var _stepauthor : String = "";
	private var _stepauthor_with_url : String = "";
	
	public var style : String = "";
	public var release_date : Int = 0;
	private var _time : String = "0:00";
	private var _time_secs : Int = 0;
	public var order : Int = 0;
	public var difficulty : Int = 0;
	private var _notes : Int = 0;
	public var sync_frames : Int = 0;
	
	private var _score_raw : Int = 0;
	private var _score_combo : Int = 0;
	
	public var min_nps : Float = 0;
	public var max_nps : Float = 0;
	
	public var play_hash : String = "";
	public var preview_hash : String = "";
	public var prerelease : Bool = false;
	public var is_title_only : Bool = false;
	
	public function new()
	{
		
	}
	
	// Author
	private function get_author_with_url() : String
	{
		if (author_url != "" && author_url.length > 7) 
		{
			return "<a href=\"" + StringTools.htmlEscape(author_url) + "\">" + author + "</a>";
		}
		return author;
	}
	
	// Stepauthor and URL versions.
	private function set_stepauthor(auth : String) : String
	{
		_stepauthor = auth;
		
		//- Create URL
		// Multiple Step Authors
		if (auth != "" && source == Constant.GAME_ENGINE) 
		{
			if (auth.indexOf(" & ") >= 0) 
			{
				var stepAuthors : Array<String> = auth.split(" & ");
				_stepauthor_with_url = "<a href=\"http://www.flashflashrevolution.com/profile/" + StringTools.htmlEscape(stepAuthors[0]) + "\">" + stepAuthors[0] + "</a>";
				for (i in 1...stepAuthors.length){
					_stepauthor_with_url += " & <a href=\"http://www.flashflashrevolution.com/profile/" + StringTools.htmlEscape(stepAuthors[i]) + "\">" + stepAuthors[i] + "</a>";
				}
			}
			else 
			{
				_stepauthor_with_url = "<a href=\"http://www.flashflashrevolution.com/profile/" + StringTools.htmlEscape(auth) + "\">" + auth + "</a>";
			}
		}
		else 
		{
			_stepauthor_with_url = auth;
		}
		return auth;
	}
	
	private function get_stepauthor() : String
	{
		return _stepauthor;
	}
	
	private function get_stepauthor_with_url() : String
	{
		return _stepauthor_with_url;
	}
	
	// Time
	private function get_time() : String
	{
		return _time;
	}
	
	private function set_time(time : String) : String
	{
		_time = time;
		
		var pieces : Array<String> = time.split(":");
		if (pieces.length >= 2) {
			_time_secs = (Std.parseInt(pieces[0]) * 60) + Std.parseInt(pieces[1]);
		}
		else {
			_time_secs = Std.parseInt(pieces[0]);
		}
		return time;
	}
	
	private function get_time_secs() : Int
	{
		return _time_secs;
	}
	
	// Notes
	private function get_notes() : Int
	{
		return _notes;
	}
	
	private function set_notes(total : Int) : Int
	{
		_notes = total;
		_score_raw = total * 50;
		_score_combo = total * 1550;
		return total;
	}
	
	// Scores
	private function get_score_raw() : Int
	{
		return _score_raw;
	}
	
	private function get_score_combo() : Int
	{
		return _score_combo;
	}
}