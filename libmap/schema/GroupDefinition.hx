package libmap.schema;

@:solid @:standard @:name(func_group)
class GroupDefinition extends SolidDefinition {
	@:p @:n(_tb_name) public var name:String;

	public function new() {
		super();
	}

	override function load(mapData:libmap.MapData, index:Int) {
		super.load(mapData, index);
	}
}
