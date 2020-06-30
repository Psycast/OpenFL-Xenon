package classes.user;


import classes.engine.EngineLevel;
import classes.engine.EngineLoader;
import classes.engine.EngineRanks;
import classes.engine.EngineRanksLevel;
import com.flashfla.utils.ArrayUtil;

/**
	 * User Level Ranks
	 * Stores User Engine Ranks.
	 */
class UserLevelRanks
{
	public var engines : Array<EngineRanks>;
	
	public function new()
	{
		this.engines = [];
		
		Reflect.setField(this.engines, Constant.GAME_ENGINE, new EngineRanks(Constant.GAME_ENGINE));
	}
	
	/**
	 * Returns the EngineRanks for the specified engine id.
	 * @param	engine		Engine ID
	 * @param	createNew	Create new EngineRanks for engine if not found.
	 * @return	EngineRanks, null
	 */
	public function getEngineRanks(engine : String, createNew : Bool = false) : EngineRanks
	{
		if (!Reflect.field(this.engines, engine) || createNew) 
		{
		   Reflect.setField(this.engines, engine, new EngineRanks(engine));
		}
		
		if (Reflect.field(this.engines, engine)) 
		{
			return Reflect.field(this.engines, engine);
		}
		
		return null;
	}
	
	public function getAverageRank(engine : EngineLoader) : Float
	{
		var engineRanks : EngineRanks = Reflect.field(this.engines, engine.id);
		var public_songs : Array<Dynamic> = engine.playlist.index_list;
		
		// Filter Out Non-public Genres
		if (engine.info != null) 
		{
			var nonpublic_genres : Array<Dynamic> = engine.info.getData("game_nonpublic_genres");
			if (nonpublic_genres != null) 
			{
				public_songs = public_songs.filter(function(item : EngineLevel) : Bool
					{
						return !ArrayUtil.in_array([item.genre], nonpublic_genres);
					});
			}
		}
		
		// Total Ranks
		var levelRank : EngineRanksLevel;
		var totalRanks : Float = 0;
		for (i in 0...public_songs.length){
			levelRank = engineRanks.getRank(public_songs[i].id);
			
			if (levelRank != null) 
				totalRanks += engineRanks.getRank(public_songs[i].id).rank;
		}
		
		return totalRanks / engine.playlist.total_public_songs;
	}
}

