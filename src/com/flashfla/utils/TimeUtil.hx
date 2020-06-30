package com.flashfla.utils;

class TimeUtil
{
	public static function getCurrentDate() : String
	{
		return getFormattedDate(Date.now());
	}

	public static function getFormattedDate(date : Date) : String
	{
		var cHH : Int = date.getHours();
		var cAM : String = "am";
		if (cHH > 12)
		{
			cHH -= 12;
			cAM = "pm";
		}
		else if (cHH == 12)
		{
			cAM = "pm";
		}
		return doubleDigitFormat(cHH) + ":" + doubleDigitFormat(date.getMinutes()) + ":" + doubleDigitFormat(date.getSeconds()) + cAM + ", " + date.getDate() + "/" + (date.getMonth() + 1) + "/" + date.getFullYear();
	}

	public static function convertToHHMMSS(_seconds : Int) : String
	{
		var s : Int = _seconds % 60;
		var m : Int = Math.floor((_seconds % 3600) / 60);
		var h : Int = Math.floor(_seconds / (60 * 60));

		var hourStr : String = ((h == 0)) ? "" : doubleDigitFormat(h) + ":";
		var minuteStr : String = doubleDigitFormat(m) + ":";
		var secondsStr : String = doubleDigitFormat(s);

		return hourStr + minuteStr + secondsStr;
	}

	private static function doubleDigitFormat(_num : Int) : String
	{
		if (_num < 10)
		{
			return ("0" + _num);
		}
		return Std.string(_num);
	}

	public function new()
	{
	}
}