package phxmap.schema;

@:solid @:standard @:name(worldspawn)
class WorldDefinition extends SolidDefinition {
	@:p @:n(_tb_name) public var name:String;

	public function new() {
		super();
	}

	override function load(mapData:phxmap.MapData, index:Int) {
		super.load(mapData, index);
	}
}
