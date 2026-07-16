package libmap.schema;

@:point @:standard
class PointDefinition implements Definition {
	public var id:Int;
	public var group:GroupDefinition;
	@:a(origin, 0) @:f(#if (heaps || libmap_lefthanded) Settings.scaleInverse #else Settings.scale #end) public var x:Float;
	@:a(origin, 1) @:f(Settings.scale) public var y:Float;
	@:a(origin, 2) @:f(Settings.scale) public var z:Float;
	@:p public var angle:Float;

	function new() {}

	public function load(mapData:libmap.MapData, index:Int) {}
}
