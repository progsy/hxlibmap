package libmap.schema;

#if !macro @:autoBuild(libmap.schema.Macro.Loader.build()) #end
interface Definition {
	public var id:Int;
	public var group:GroupDefinition;

	public function load(mapData:libmap.MapData, index:Int):Void;
}
