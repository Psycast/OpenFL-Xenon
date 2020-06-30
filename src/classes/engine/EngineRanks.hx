package classes.engine;

import classes.engine.EngineRanksLevel;

class EngineRanks
{
	public var id : String;
	public var ranks : Dynamic = { };
	
	public function new(id : String)
	{
		this.id = id;
	}
	
	public function getRank(level : String) : EngineRanksLevel
	{
		return Reflect.field(ranks, level);
	}
	
	public function setRank(data : EngineRanksLevel) : Void
	{
		Reflect.setField(ranks, data.level, data);
	}
}