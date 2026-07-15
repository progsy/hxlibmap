package libmap.schema;

typedef Geometry = {
	vertices:Array< #if heaps hxd.impl.Float32 #else Float #end>,
	indices:Array<Int>,
	texcoords:Array<Float>
};

@:solid @:standard
class SolidDefinition implements Definition {
	public static inline final DEFAULT_TAG:String = "default";

	public var id:Int;
	public var group:GroupDefinition;
	@:c(mapData.entities[index].center.x) @:f(#if heaps Settings.scaleInverse #else Settings.scale #end) public var x:Float;
	@:c(mapData.entities[index].center.y) @:f(Settings.scale) public var y:Float;
	@:c(mapData.entities[index].center.z) @:f(Settings.scale) public var z:Float;
	@:p public var angle:Float;

	/**
		Each piece of geometry is associated with a determined tag.
		Use **libmap.SolidDefinition.DEFAULT_TAG** to fetch the default geometry.
	**/
	public var geometries(default, null):Map<String, Geometry> = [];

	function new() {}

	public function load(mapData:libmap.MapData, index:Int) {
		var indexOffsets:Map<Geometry, Int> = [];
		var entity = mapData.entities[index];
		var i = index;
		for (j in 0...entity.brushes.length) {
			var brush = entity.brushes[j];
			for (k in 0...brush.faces.length) {
				var geo = mapData.entitiesGeo[i][j][k];
				var tags = determineTags(geo.contentFlags, geo.surfaceFlags);
				for (tag in tags) {
					var geometry:Geometry = geometries.get(tag);
					if (geometry == null) {
						geometry = {vertices: [], indices: [], texcoords: []};
						geometries.set(tag, geometry);
						indexOffsets.set(geometry, 0);
					}

					var indexOffset = indexOffsets.get(geometry);
					for (v in geo.vertices) {
						geometry.vertices.push(#if heaps Settings.scaleInverse(v.vertex.x - entity.center.x) #else Settings.scale(v.vertex.x - entity.center.x) #end);
						geometry.vertices.push(Settings.scale(v.vertex.y - entity.center.y));
						geometry.vertices.push(Settings.scale(v.vertex.z - entity.center.z));
						geometry.texcoords.push(v.uv.u);
						geometry.texcoords.push(v.uv.v);
					}

					var u = 0;
					while (u < (geo.vertices.length - 2) * 3) {
						geometry.indices.push(geo.indices[u] + indexOffset);
						geometry.indices.push(geo.indices[u + 2] + indexOffset);
						geometry.indices.push(geo.indices[u + 1] + indexOffset);
						u += 3;
					}
					indexOffsets.set(geometry, indexOffset + geo.vertices.length);
				}
			}
		}
	}

	/**
		This is meant to be overriden to specify geometry tags based on content and surface flags.
	**/
	function determineTags(contentFlags:Int, surfaceFlags:Int):Array<String> {
		return [DEFAULT_TAG];
	}

	#if heaps
	public var primitiveCache:Map<String, h3d.prim.Polygon> = [];
	public var colliderCache:Map<String, h3d.col.Polygon> = [];

	public function getPrimitive(tag:String = DEFAULT_TAG):Null<h3d.prim.Polygon> {
		var primitive = primitiveCache.get(tag);
		if (primitive == null) {
			var geometry = geometries.get(tag);
			if (geometry == null || geometry.vertices.length == 0) {
				return primitive;
			}

			var idxs = new hxd.IndexBuffer(geometry.indices.length);
			var verts:Array<h3d.col.Point> = [];
			var uvs:Array<h3d.prim.UV> = [];
			verts.resize(Std.int(geometry.vertices.length / 3));
			uvs.resize(Std.int(geometry.texcoords.length / 2));

			var j = 0;
			for (i in 0...verts.length) {
				verts[i] = new h3d.col.Point(geometry.vertices[j++], geometry.vertices[j++], geometry.vertices[j++]);
			}
			for (i in 0...idxs.length) {
				idxs[i] = geometry.indices[i];
			}
			j = 0;
			for (i in 0...uvs.length) {
				uvs[i] = new h3d.prim.UV(geometry.texcoords[j++], geometry.texcoords[j++]);
			}

			primitive = new h3d.prim.Polygon(verts, idxs);
			primitive.uvs = uvs;
			primitive.addNormals();
			primitive.addTangents();
			primitiveCache.set(tag, primitive);
		}
		return primitive;
	}

	public function getCollider(tag:String = DEFAULT_TAG):Null<h3d.col.Polygon> @:privateAccess {
		var collider = colliderCache.get(tag);
		if (collider == null) {
			var geometry = geometries.get(tag);
			if (geometry == null || geometry.vertices.length == 0) {
				return collider;
			}
			collider = new h3d.col.Polygon();
			collider.addBuffers(cast geometry.vertices, cast geometry.indices);
			colliderCache.set(tag, collider);
		}
		return collider;
	}
	#end
}
