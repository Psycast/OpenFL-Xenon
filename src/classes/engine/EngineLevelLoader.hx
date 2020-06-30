package classes.engine;

import flash.events.EventDispatcher;

class EngineLevelLoader extends EventDispatcher
{
	private var core : EngineCore;
	private var loaded_levels : Dynamic = { };
	
	public function new(core : EngineCore)
	{
		super();
		this.core = core;
	}
	/*
	public function getSong(songData : EngineLevel) : Song
	{
		var key : String = songData.source + "_" + songData.id;
		if (Reflect.field(loaded_levels, key) != null && !Reflect.field(loaded_levels, key).load_failed) 
		{
			return Reflect.field(loaded_levels, key);
		}
		
		var song : Song = new Song(core, songData);
		
		Reflect.setField(loaded_levels, key, song);
		
		return song;
	}
	*/
}