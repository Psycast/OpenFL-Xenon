package com.flashfla.utils;
import haxe.Constraints.Function;

class ArrayUtil
{
	/**
	 *	Remove first of the specified value from the array,
	 *
	 * 	@param arr The array from which the value will be removed
	 *
	 *	@param value The object that will be removed from the array.
	 *
	 * 	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@tiptext
	 */
	public static function remove(value : Dynamic, arr : Array<Dynamic>) : Bool
	{
		if (arr == null || arr.length == 0)
			return false;

		var ind : Int;
		if ((ind = Lambda.indexOf(arr, value)) != -1)
		{
			arr.splice(ind, 1);
			return true;
		}
		return false;
	}

	/**
	 *	Remove all instances of the specified value from the array,
	 *
	 * 	@param arr The array from which the value will be removed
	 *
	 *	@param value The object that will be removed from the array.
	 *
	 * 	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@tiptext
	 */
	public static function removeValue(value : Dynamic, arr : Array<Dynamic>) : Void
	{
		var len : Int = arr.length;

		var i : Int = len;
		while (i > -1)
		{
			if (arr[i] == value)
			{
				arr.splice(i, 1);
			}
			i--;
		}
	}

	public static function count(ar : Array<Dynamic>) : Int
	{
		var len : Int = 0;
		for (item in Reflect.fields(ar))
		{
			len++;
		}
		return len;
	}

	/**
	 * This method reigns in a value to keep it between
	 * the supplied minimum and maximum limits.
	 * Useful for wrapping number values
	 * (particularly paginated interfaces).
	 * Returns the reigned-in result.
	 */
	public static function index_wrap(value : Int, min : Int, max : Int) : Int
	{
		return (value > max ? min : (value < min ? max : value));
	}

	/**
	 * Randomizes an array by changing the indexes. Returns new array.
	 * @param	ar Input Array
	 * @return	array Randomized Array
	 */
	public static function randomize(ar : Array<Dynamic>) : Array<Dynamic>
	{
		var newarr : Array<Dynamic> = new Array<Dynamic>();

		var randomPos : Int = 0;
		for (i in 0...newarr.length)
		{
			randomPos = Std.random(ar.length);
			newarr.push(ar.splice(randomPos, 1)[0]);
		}

		return newarr;
	}

	public static function in_array(inAr : Array<Dynamic>, items : Array<Dynamic>) : Bool
	{
		for (y in 0...items.length)
		{
			for (x in 0...inAr.length)
			{
				if (inAr[x] == items[y])
				{
					return true;
				}
			}
		}
		return false;
	}

	/**
	 * Provides a way to find the next valid index within an array that follows certain conditions.
	 * @param	dir (true) Search towards 0 index. (false) Search towards array.length index.
	 * @param	startIndex Starting Index to start searching from, inclusive.
	 * @param	searchArray Array to search through.
	 * @param	condition Condition for index to be found valid.
	 * @return 	int Next Valid Index in array or startIndex if none found.
	 */
	public static function find_next_index(dir : Bool, startIndex : Int, searchArray : Array<Dynamic>, condition : Function) : Int
	{
		var indexMove : Int = (dir) ? -1 : 1;
		var indexTotal : Int = searchArray.length - 1;
		var toCheck : Int = searchArray.length;  // Prevents Hangs if no valid items found.
		var newIndex : Int = index_wrap(startIndex, 0, indexTotal);
		while (toCheck-- > 0)
		{
			if (searchArray[newIndex] != null && condition(searchArray[newIndex]))
				break;
			newIndex = index_wrap(newIndex + indexMove, 0, indexTotal);
		}
		return newIndex;
	}
}
