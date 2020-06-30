package classes.ui;

import classes.ui.UIComponent;

import com.flashfla.utils.ArrayUtil;

/**
 * Simple stage resize listener and event propagator.
 */
class ResizeListener
{
	private static var items : Array<UIComponent> = [];
	
	/**
	 * Subscribes an item to the stage resize listener.
	 * @param	item Item to subscribe.
	 */
	public static function addObject(item : UIComponent) : Void
	{
		if (!(Lambda.has(items, item))) 
		{
			items.push(item);
		}
	}
	
	/**
	 * Unsubscribes an item from the stage resize listener.
	 * @param	item Item to unsubscribe.
	 */
	public static function removeObject(item : UIComponent) : Void
	{
		//ArrayUtil.remove(item, items);
	}
	
	/**
		 * Removes all items from the stage resize listener.
		 */
	public static function clear() : Void
	{
		var nItems : Array<UIComponent> = [];
		for (i in 0...items.length){
			if (Std.is(items[i], UIOverlay)) 
			{
				nItems.push(items[i]);
			}
		}
		items = nItems;
	}
	
	/**
	 * Signals all subscribed objects that the stage has been resized.
	 */
	public static function signal() : Void
	{
		for (i in 0...items.length){
			items[i].onResize();
		}
	}
}