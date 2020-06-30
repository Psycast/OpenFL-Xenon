package classes.engine;

class EngineRanksLevel
{
	public var results(get, set) : String;
	public var raw_score(get, never) : Int;

	public var level : String = "";
	public var genre : Int = 0;  // Used to calculate average rank.  
	
	public var rank : Int = 0;
	public var score : Int = 0;
	
	public var amazing : Int = 0;
	public var perfect : Int = 0;
	public var good : Int = 0;
	public var average : Int = 0;
	public var miss : Int = 0;
	public var boo : Int = 0;
	public var combo : Int = 0;
	
	public function new(level : String)
	{
		this.level = level;
	}
	
	// Results - Format [0]'perfect' - [1]'good' - [2]'average' - [3]'miss' - [4]'boo' - [5]'maxcombo'
	// Optional prefix [0]'amazing'
	private function set_results(results : String) : String
	{
		// Do nothing if empty.
		if (results == "")
			return results;
			
		// Split Results
		var scoreResults : Array<Int> = Lambda.array(Lambda.map(results.split("-"), function(v) { return Std.parseInt(v); } ));

		// Set Variables
		var off : Int = 0;
		if (scoreResults.length == 7)   // Includes Amazings  
		{
			amazing = scoreResults[off++];
		}
		perfect = scoreResults[off++];
		good = scoreResults[off++];
		average = scoreResults[off++];
		miss = scoreResults[off++];
		boo = scoreResults[off++];
		combo = scoreResults[off++];
		return results;
	}
	
	private function get_results() : String
	{
		return (amazing > (0) ? amazing + "-" : "") + perfect + "-" + good + "-" + average + "-" + miss + "-" + boo + "-" + combo;
	}
	
	private function get_raw_score() : Int
	{
		return ((amazing + perfect) * 50) + (good * 25) + (average * 5) - (miss * 10) - (boo * 5);
	}
}