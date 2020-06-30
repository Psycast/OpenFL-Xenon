package com.flashfla.net;


import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;

class WebRequest
{
    private var _loader : URLLoader;
    
    private var _url : String;
    private var _funOnComplete : Null<Dynamic>;
    private var _funOnError : Null<Dynamic>;
    
    public var active : Bool = false;
    public var loaded : Bool = false;
    
	/**
	 * Creates a new WebRequest loader to make calss to the internet.
	 * @param	url URL wanting to load.
	 * @param	funOnComplete Function to be called when the load is complete.
	 * @param	funOnError Function to be called when the load fails.
	 */
    public function new(url : String, funOnComplete : Null<Dynamic> = null, funOnError : Null<Dynamic> = null)
    {
        this._url = url;
        this._funOnComplete = funOnComplete;
        this._funOnError = funOnError;
    }
    
    public function load(params : Dynamic = null, type : String = "POST") : Void
    {
        _loader = new URLLoader();
        _addListeners();
		
        var req : URLRequest = new URLRequest(_url);
        if (params != null) 
        {
            var variables : URLVariables = new URLVariables();
            for (key in Reflect.fields(params))
            {
                Reflect.setField(variables, key, Std.string(Reflect.field(params, key)));
            }
            req.data = variables;
        }
        req.method = type;
        _loader.load(req);
    }
    
    private function e_loadComplete(e : Event) : Void
    {
        _removeListeners();
        if (_funOnComplete != null) 
        {
            _funOnComplete(e.currentTarget);
        }
    }
    
    private function e_loadError(e : Event) : Void
    {
        _removeListeners();
        if (_funOnError != null) 
        {
            _funOnError(e.currentTarget);
        }
    }
    
    //- Listeners
    private function _addListeners() : Void
    {
        active = true;
        loaded = false;
        _loader.addEventListener(Event.COMPLETE, e_loadComplete);
        _loader.addEventListener(IOErrorEvent.IO_ERROR, e_loadError);
        _loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, e_loadError);
    }
    
    private function _removeListeners() : Void
    {
        active = false;
        loaded = true;
        _loader.removeEventListener(Event.COMPLETE, e_loadComplete);
        _loader.removeEventListener(IOErrorEvent.IO_ERROR, e_loadError);
        _loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, e_loadError);
    }
}
