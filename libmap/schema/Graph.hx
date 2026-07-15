package libmap.schema;

class Graph {
	var definitions:Map<Int, Definition> = [];
	var groups:Map<String, GroupDefinition> = [];

	public function new() {}

	public inline function getDefinition(id:Int):Null<Definition> {
		return definitions.get(id);
	}

	public inline function getGroupDefinition(name:String):Null<GroupDefinition> {
		return groups.get(name);
	}

	@:generic public function find<T:Definition>(cls:Class<T>):Null<T> {
		var definition:T = null;
		for (d in definitions) {
			var td = Std.downcast(d, cls);
			if (td != null) {
				definition = td;
				break;
			}
		}
		return definition;
	}

	@:generic public function findGuarded<T:Definition>(cls:Class<T>, guard:(T) -> Bool):Null<T> {
		var definition:T = null;
		for (d in definitions) {
			var tsc = Std.downcast(d, cls);
			if (tsc != null) {
				if (guard(tsc)) {
					definition = tsc;
					break;
				}
			}
		}
		return definition;
	}

	@:generic public function findAll<T:Definition>(cls:Class<T>, ?base:Array<T>):Array<T> {
		var array = base ?? [];
		for (d in definitions) {
			var td = Std.downcast(d, cls);
			if (td != null) {
				array.push(td);
			}
		}
		return array;
	}

	@:generic public function findAllGuarded<T:Definition>(cls:Class<T>, guard:(T) -> Bool, ?base:Array<T>):Array<T> {
		var array = base ?? [];
		for (d in definitions) {
			var td = Std.downcast(d, cls);
			if (td != null) {
				if (guard(td)) {
					array.push(td);
				}
			}
		}
		return array;
	}
}
