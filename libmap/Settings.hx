package libmap;

enum Format {
	Quake;
	Quake2;
}

class Settings {
	/** 
		Used to scale down the entities.
		Ideally this should be set to 32 (like in Doom), where each 32 Trenchbroom units represent one meter.
	**/
	public static var unitsPerMeter:Int = 32;

	public static var format:Format = Quake2;

	public static inline function scale(v:Float):Float {
		return v / unitsPerMeter;
	}

	public static inline function scaleInverse(v:Float):Float {
		return -v / unitsPerMeter;
	}
}
