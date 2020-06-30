package classes.engine;

import flash.errors.Error;

class EngineLanguage
{
	
	public var data : Map<String, Map<String, String>> = new Map<String, Map<String, String>>();
	public var indexed : Array<Dynamic>;
	
	public var id : String;
	public var valid : Bool = false;
	
	public function new(id : String)
	{
		this.id = id;
	}
	
	public function parseData(input : String) : Void
	{
		input = StringTools.trim(input);
		
		var xml:Xml;
		
		// Parse XML
		try
		{
			xml = Xml.parse(input);
		}
		catch (e : Error)
		{
			Logger.log(this, Logger.ERROR, "\"" + id + "\" - Malformed XML Language");
			return;
		}
		
		if (xml == null)
		{
			Logger.log(this, Logger.ERROR, "\"" + id + "\" - XML Language is null");
			return;
		}
		
		// Create Language Data
		for (root in xml.elements())
		{
			for (nodes in root.elements())
			{
				if (nodes.nodeName == "Language")
				{
					var id : String = nodes.get("id");
					
					// Create Language Map
					var language:Map<String, String> = data.get(id);
					if (language == null)
					{
						language = new Map<String, String>();
						data.set(id, language);
					}
					
					// Set Attributes
					for (attr in nodes.attributes())
					{
						language.set("_" + attr, nodes.get(attr));
					}
					
					// Set Data
					for (messageNodes in nodes.elements())
					{
						if (messageNodes.nodeName == "Message")
						{
							var nid = messageNodes.get("id");
							for (textNodes in messageNodes.elements())
							{
								if (textNodes.nodeName == "text")
								{
									language.set(nid, textNodes.firstChild().nodeValue);
									break;
								}
							}
						}
					}
				}
			}
		}
		valid = true;
	}
	
	public function getString(id : String, lang : String = "us") : String
	{
		if (data.exists(lang) && data.get(lang).exists(id)) 
		{
			return data.get(lang).get(id);
		}
		
		return "";
	}
}

