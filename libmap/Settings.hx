package libmap;

class Settings {
	/** 
		Used to scale down the entities.
		Ideally this should be set to 32 (like in Doom), where each 32 Trenchbroom units represent one meter.
		For the sake of compatibilty this is set to 1.
	**/
	public static var unitsPerMeter:Int = 1 /*32*/;

	public static inline function scale(v:Float):Float {
		return v / unitsPerMeter;
	}

	public static inline function scaleInverse(v:Float):Float {
		return -v / unitsPerMeter;
	}
}
