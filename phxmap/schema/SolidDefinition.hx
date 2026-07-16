package phxmap.schema;

typedef Geometry = {
	vertices:Array< #if heaps hxd.impl.Float32 #elseif kha kha.FastFloat #else Float #end>,
	indices:Array<Int>,
	texcoords:Array< #if heaps hxd.impl.Float32 #elseif kha kha.FastFloat #else Float #end>,
	normals:Array< #if heaps hxd.impl.Float32 #elseif kha kha.FastFloat #else Float #end>,
	tangents:Array< #if heaps hxd.impl.Float32 #elseif kha kha.FastFloat #else Float #end>
};

@:solid @:standard
class SolidDefinition implements Definition {
	public static inline final DEFAULT_TAG:String = "default";

	public var id:Int;
	public var group:GroupDefinition;
	@:c(mapData.entities[index].center.x) @:f(#if (heaps || phxmap.lefthanded) Settings.scaleInverse #else Settings.scale #end) public var x:Float;
	@:c(mapData.entities[index].center.y) @:f(Settings.scale) public var y:Float;
	@:c(mapData.entities[index].center.z) @:f(Settings.scale) public var z:Float;
	@:p public var angle:Float;

	/**
		Each piece of geometry is associated with a determined tag.
		Use **phxmap.SolidDefinition.DEFAULT_TAG** to fetch the default geometry.
	**/
	public var geometries(default, null):Map<String, Geometry> = [];

	function new() {}

	public function load(mapData:phxmap.MapData, index:Int) {
		var indexOffsets:Map<Geometry, Int> = [];
		var entity = mapData.entities[index];
		var i = index;
		for (j in 0...entity.brushes.length) {
			var brush = entity.brushes[j];
			for (k in 0...brush.faces.length) {
				var geo = mapData.entitiesGeo[i][j][k];
				var tags = determineTags(geo.textureName, geo.contentFlags, geo.surfaceFlags);
				for (tag in tags) {
					var geometry:Geometry = geometries.get(tag);
					if (geometry == null) {
						geometry = {
							vertices: [],
							indices: [],
							texcoords: [],
							normals: [],
							tangents: []
						};
						geometries.set(tag, geometry);
						indexOffsets.set(geometry, 0);
					}

					var indexOffset = indexOffsets.get(geometry);
					for (v in geo.vertices) {
						geometry.vertices.push(#if (heaps || phxmap.lefthanded) Settings.scaleInverse(v.vertex.x - entity.center.x) #else Settings.scale(v.vertex.x
							- entity.center.x) #end);
						geometry.vertices.push(Settings.scale(v.vertex.y - entity.center.y));
						geometry.vertices.push(Settings.scale(v.vertex.z - entity.center.z));
						geometry.texcoords.push(v.uv.u);
						geometry.texcoords.push(v.uv.v);
						geometry.normals.push(#if (heaps || phxmap.lefthanded) -v.normal.x #else v.normal.x #end);
						geometry.normals.push(v.normal.y);
						geometry.normals.push(v.normal.z);
						geometry.tangents.push(#if (heaps || phxmap.lefthanded) -v.tangent.x #else v.tangent.x #end);
						geometry.tangents.push(v.tangent.y);
						geometry.tangents.push(v.tangent.z);
						geometry.tangents.push(#if (heaps || phxmap.lefthanded) -v.tangent.w #else v.tangent.w #end);
					}

					var u = 0;
					while (u < (geo.vertices.length - 2) * 3) {
						geometry.indices.push(geo.indices[u] + indexOffset);
						geometry.indices.push(geo.indices[u + #if (heaps || phxmap.lefthanded) 2 #else 1 #end] + indexOffset);
						geometry.indices.push(geo.indices[u + #if (heaps || phxmap.lefthanded) 1 #else 2 #end] + indexOffset);
						u += 3;
					}
					indexOffsets.set(geometry, indexOffset + geo.vertices.length);
				}
			}
		}
	}

	/**
		This is meant to be overriden to specify geometry tags based on texture name, content flags and surface flags.
	**/
	function determineTags(textureName:String, contentFlags:Int, surfaceFlags:Int):Array<String> {
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
			var norms:Array<h3d.col.Point> = [];
			var tans:Array<h3d.col.Point> = [];
			var uvs:Array<h3d.prim.UV> = [];
			verts.resize(Std.int(geometry.vertices.length / 3));
			norms.resize(Std.int(geometry.vertices.length / 3));
			tans.resize(Std.int(geometry.vertices.length / 3));
			uvs.resize(Std.int(geometry.texcoords.length / 2));

			var j = 0;
			for (i in 0...verts.length) {
				verts[i] = new h3d.col.Point(geometry.vertices[j], geometry.vertices[j + 1], geometry.vertices[j + 2]);
				norms[i] = new h3d.col.Point(geometry.normals[j], geometry.normals[j + 1], geometry.normals[j + 2]);
				tans[i] = new h3d.col.Point(geometry.tangents[j++], geometry.tangents[j++], geometry.tangents[j++]);
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
			primitive.normals = norms;
			primitive.tangents = tans;
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
