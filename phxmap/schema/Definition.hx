package phxmap.schema;

#if !macro @:autoBuild(phxmap.schema.Macro.Loader.build()) #end
interface Definition {
	public var id:Int;
	public var group:GroupDefinition;

	public function load(mapData:phxmap.MapData, index:Int):Void;
}
