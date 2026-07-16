# hxlibmap
Trenchbroom-compatible map loader for Haxe, forked from the [Haxe port](https://github.com/RollinBarrel/hxlibmap) of [libmap-cpp](https://github.com/EIRTeam/qodot/tree/e99e894aec5b1aea5abc9d8970ae8b364c327f2b/thirdparty/libmap_cpp/src) [(MIT License)](https://github.com/EIRTeam/qodot/blob/e99e894aec5b1aea5abc9d8970ae8b364c327f2b/LICENSE)<br>
This fork was made with the goal of streamlining the process of importing Quake-style maps with a handful of features and fixes.

# Integration
The library comes with first-class support for [Heaps](https://heaps.io). To see what it's like, check out the [sample](sample/Main.hx).<br>
You can define ``libmap_fgd=[path]`` in your hxml configuration file to enable FGD generation and specify where to save it. Check out [this](https://developer.valvesoftware.com/wiki/FGD) article to know more about FGDs. Here's an example of an entity definiiton written in Haxe: 
```haxe
package entity.definitions;

enum Skin {
	Casual;
	Veteran;
	Punk;
    SurfingBird;
}

@:name(Player) @:color(100, 255, 150) @:size(-8, -8, 0, 8, 8, 56)
class PlayerDefinition extends libmap.schema.PointDefinition {
	@:p public var health:Float;
	@:p public var immune:Bool;
	@:p public var skin:Skin;

	public function new() {
		super();
	}

	override function load(mapData:libmap.MapData, index:Int) {
		super.load(mapData, index);
	}
}
```

# Notes
Due to the unordered macro execution in Haxe, you might encounter issues related to graph generation. Make sure to include the package that contains your definitions as seen [here](sample/build_hl.hxml#l9).