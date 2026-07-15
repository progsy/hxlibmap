package libmap.schema;

@:solid @:standard @:name(func_group)
class GroupDefinition extends SolidDefinition {
	@:p @:n(_tb_name) public var name:String;

	// @:a(_tb_transformation, 0) var m00:Float;
	// @:a(_tb_transformation, 1) var m01:Float;
	// @:a(_tb_transformation, 2) var m02:Float;
	// @:a(_tb_transformation, 3) @:f(#if heaps Settings.scaleInverse #else Settings.scale #end) var m03:Float;
	// @:a(_tb_transformation, 4) var m10:Float;
	// @:a(_tb_transformation, 5) var m11:Float;
	// @:a(_tb_transformation, 6) var m12:Float;
	// @:a(_tb_transformation, 7) @:f(Settings.scale) var m13:Float;
	// @:a(_tb_transformation, 8) var m20:Float;
	// @:a(_tb_transformation, 9) var m21:Float;
	// @:a(_tb_transformation, 10) var m22:Float;
	// @:a(_tb_transformation, 11) @:f(Settings.scale) var m23:Float;
	// @:a(_tb_transformation, 12) var m30:Float;
	// @:a(_tb_transformation, 13) var m31:Float;
	// @:a(_tb_transformation, 14) var m32:Float;
	// @:a(_tb_transformation, 15) var m33:Float;

	public function new() {
		super();
	}

	override function load(mapData:libmap.MapData, index:Int) {
		super.load(mapData, index);
	}

	// #if heaps
	// public inline function getTransformation() {
	// 	var m = new h3d.Matrix();
	// 	m._11 = m00;
	// 	m._12 = m01;
	// 	m._13 = m02;
	// 	m._14 = m03;
	// 	m._21 = m10;
	// 	m._22 = m11;
	// 	m._23 = m12;
	// 	m._24 = m13;
	// 	m._31 = m20;
	// 	m._32 = m21;
	// 	m._33 = m22;
	// 	m._34 = m23;
	// 	m._41 = m30;
	// 	m._42 = m31;
	// 	m._43 = m32;
	// 	m._44 = m33;
	// 	return m;
	// }
	// #end
}
