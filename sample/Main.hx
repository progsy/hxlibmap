class Main extends hxd.App {
	var graph:libmap.schema.Graph = new libmap.schema.Graph();

	static function main() {
		#if sys
		hxd.Res.initLocal();
		#else
		hxd.Res.initEmbed();
		#end
		h3d.mat.PbrMaterialSetup.set();
		new Main();
	}

	public function load(entry:hxd.fs.FileEntry):Array<h3d.scene.Mesh> {
		var meshes:Array<h3d.scene.Mesh> = [];
		var input = entry.open();
		var parser =  new libmap.MapParser(input);
		var data = parser.parse();
		input.close();

		for (tex in data.textures) {
			var size = hxd.Res.load(tex.name + ".jpg").toImage().getSize();
			tex.width = size.width;
			tex.height = size.height;
		}

		var generator = new libmap.Generator(data);
		generator.generate(graph);

		var definitions = graph.findAll(libmap.schema.SolidDefinition);
		for (d in definitions) {
			var primitive = d.getPrimitive();
			var mesh = new h3d.scene.Mesh(primitive, null, null);
			meshes.push(mesh);
		}
		return meshes;
	}

	override public function init() {
        var window = hxd.Window.getInstance();
        window.title = "libmap";
        
		var root = new h3d.scene.Object(s3d);
		var tex = hxd.Res.grass.toTexture();
		tex.wrap = Repeat;
		var material = h3d.mat.Material.create(tex);
		material.shadows = false;

		function loadAndAdd() {
			root.removeChildren();
			var meshes = load(hxd.Res.map.entry);
			for (mesh in meshes) {
				mesh.material = material;
				root.addChild(mesh);
			}
			var bounds = root.getBounds();
			s3d.camera.pos = new h3d.Vector(bounds.xMin - 8.0, bounds.yMin - 8.0, bounds.zMax + 5.0);
			s3d.camera.target = new h3d.Vector((bounds.xMin + bounds.xMax) / 2, (bounds.yMin + bounds.yMax) / 2, bounds.zMin + 2.0);
		}
		loadAndAdd();
		#if (debug && sys)
		hxd.Res.map.watch(loadAndAdd);
		#end
	}
}
