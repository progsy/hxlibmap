package libmap;

import hxmath.math.*;

typedef VertexUV = {
	var u:Float;
	var v:Float;
}

typedef VertexTangent = Vector4;

typedef FaceVertex = {
	var vertex:Vector3;
	var normal:Vector3;
	var uv:VertexUV;
	var tangent:VertexTangent;
}

typedef FaceGeometry = {
	var vertices:Array<FaceVertex>;
	var indices:Array<Int>;
	var contentFlags:Int;
	var surfaceFlags:Int;
}

typedef BrushGeometry = Array<FaceGeometry>;
typedef EntityGeometry = Array<BrushGeometry>;
