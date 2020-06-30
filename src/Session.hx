
import com.flashfla.net.WebRequest;
import haxe.Json;
import openfl.events.Event;
import openfl.net.URLLoader;

typedef LoginResultJsonDef = {
	var result : Null<Int>;
	var session : String;
}

class Session
{
	public static var SESSION_ID : String = "0";
	
	private var _funOnComplete : Null<Dynamic>;
	private var _funOnError : Null<Dynamic>;
	
	private var wr : WebRequest;
	
	public function new(cbc : Null<Dynamic> = null, cbf : Null<Dynamic> = null)
	{
		wr = new WebRequest(Constant.SITE_LOGIN_URL, e_loginComplete, e_loginFailure);
		_funOnComplete = cbc;
		_funOnError = cbf;
	}
	
	private function e_loginFailure(e : Event) : Void
	{
		Logger.log(this, Logger.ERROR, "Login Failure");
		if (_funOnError != null) 
		{
			_funOnError(e);
		}
	}
	
	private function e_loginComplete(e : Event) : Void
	{
		var _data : LoginResultJsonDef = Json.parse(cast(e.target,URLLoader).data);
		if (_data.session != null && _data.result == 1) 
		{
			Logger.log(this, Logger.NOTICE, "Login Success! - Session ID: " + _data.session);
			SESSION_ID = _data.session;
			if (_funOnComplete != null) 
			{
				_funOnComplete(e);
			}
		}
		else 
		{
			e_loginFailure(e);
		}
	}
	
	public function login(uname : String, upass : String) : Void
	{
		if (!wr.active) 
		{
			Logger.log(this, Logger.INFO, "Attempted Login: " + uname);
			wr.load({
				username : uname,
				password : upass,
				ver : Constant.VERSION
			});
		}
	}
}
