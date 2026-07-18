package phxmap.schema;

@:solid @:standard @:name("worldspawn")
class WorldDefinition extends SolidDefinition {
	public function new() {
		super();
	}

	override function load(mapData:phxmap.MapData, index:Int) {
		super.load(mapData, index);
	}
}
