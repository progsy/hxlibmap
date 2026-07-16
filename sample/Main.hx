class Main extends hxd.App {
	var graph:phxmap.schema.Graph = new phxmap.schema.Graph();
	var cameraPos:h3d.Vector = new h3d.Vector();

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
		var parser = new phxmap.MapParser(input);
		var data = parser.parse();
		input.close();

		for (tex in data.textures) {
			var size = hxd.Res.load(tex.name + ".jpg").toImage().getSize();
			tex.width = size.width;
			tex.height = size.height;
		}

		var generator = new phxmap.Generator(data);
		generator.generate(graph);

		var definitions = graph.findAll(phxmap.schema.SolidDefinition);
		for (d in definitions) {
			var primitive = d.getPrimitive();
			var mesh = new h3d.scene.Mesh(primitive, null, null);
			meshes.push(mesh);
		}
		return meshes;
	}

	override public function init() {
		var window = hxd.Window.getInstance();
		window.title = "phxmap";
		window.addEventTarget((event) -> {
			switch (event.kind) {
				case EWheel:
					cameraPos.x = hxd.Math.clamp(cameraPos.x - event.wheelDelta * 1.5, -24.0, -6.0);
					cameraPos.y = hxd.Math.clamp(cameraPos.y - event.wheelDelta * 1.5, -24.0, -6.0);
				default:
			}
		});

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
			s3d.camera.pos = new h3d.Vector(bounds.xMin - 14.0, bounds.yMin - 14.0, bounds.zMax + 14.0);
			s3d.camera.target = new h3d.Vector((bounds.xMin + bounds.xMax) / 2, (bounds.yMin + bounds.yMax) / 2, bounds.zMin + 2.0);
			cameraPos = s3d.camera.pos.clone();
		}
		loadAndAdd();

		#if (debug && sys)
		var text = new h2d.Text(hxd.res.DefaultFont.get(), s2d);
		text.setPosition(5, 3);
		text.text = "Hot reload is enabled.";
		hxd.Res.map.watch(loadAndAdd);
		#end
	}

	override function update(dt:Float) {
		s3d.camera.pos.lerp(s3d.camera.pos, cameraPos, dt * 15.0);
	}
}
