import kha.math.Vector3;
import Utils.col2vec;

class Surface {
	public var color:Vector3;
	public function new(color: Int) {this.color = col2vec(color);}
	public function norm(point:Vector3):Vector3 {throw 1;}
	public function ray(orig: Vector3, dir: Vector3): Float {throw 1;}
}

class Sphere extends Surface {
	var center:Vector3;
	var radius:Float;
	public function new(center:Vector3, radius:Float, color: Int) {
		super(color);
		this.center = center;
		this.radius = radius;
	}
	public override function norm(point:Vector3): Vector3 {
		var normal = point.sub(center).normalized();
		return normal;
	}
	public override function ray(orig: Vector3, dir: Vector3): Float {
		var b = dir.dot(orig.sub(center));
		var a = dir.dot(dir);
		var c = orig.sub(center).dot(orig.sub(center)) - radius * radius;

		var discriminant =  b * b - a * c;

		if (discriminant == 0) {
			var t = -b / a;
			if (t >= 0) return t;
		}
		if (discriminant > 0) {
			var t1 = (-b - Math.sqrt(discriminant)) / a;
			var t2 = (-b + Math.sqrt(discriminant)) / a;
			if(t1 >= 0 && t1 < t2)
				return t1;
			else if(t2 >= 0 && t2 < t1)
				return t2;
		}
		return -1.;
	}
}

class Face extends Surface {
	var a:Vector3;
	var b:Vector3;
	var c:Vector3;
	var normal:Vector3;

	public function new (a:Vector3, b:Vector3, c:Vector3, color: Int, normal:Vector3=null) {
		super(color);
		this.a = a;
		this.b = b;
		this.c = c;
		if (normal == null) {
			normal = b.sub(a).cross(c.sub(a)).normalized();
		}
		this.normal = normal;
	}
	public override function norm(point:Vector3): Vector3 {return normal;}
	// public override function ray(orig: Vector3, dir: Vector3): Float {
	// 	var dir = dir.sub(orig); dir.normalize();

	// 	var nd = normal.dot(dir);
	// 	if (nd >= 0) return -1.; // if not it self reflects

	// 	var t = (normal.dot(a) - normal.dot(orig)) / nd;

	// 	if (t <= 0) return t;
	// 	var point = orig.add(dir.mult(t));
	// 	if (b.sub(a).cross(point.sub(a)).dot(normal) >= 0) {
	// 		if (c.sub(b).cross(point.sub(b)).dot(normal) >= 0) {
	// 			if (a.sub(c).cross(point.sub(c)).dot(normal) >= 0) {
	// 				return t;
	// 			}
	// 		}
	// 	}
	// 	return -1;
	// }

	public override function ray(orig: Vector3, dir: Vector3): Float {
       var edge1 = b.sub(a);
       var edge2 = c.sub(a);
       // Find the cross product of edge2 and the ray direction
       var s1 = dir.cross(edge2);
       // Find the divisor, if its zero, return false as the triangle is
       // degenerated
       var divisor = s1.dot(edge1) ;
       if (divisor == 0.0) return -1.;

       // A inverted divisor, as multipling is faster then division
       var invDivisor = 1./ divisor;
       // Calculate the first barycentic coordinate. Barycentic coordinates
       // are between 0.0 and 1.0
       var distance = orig.sub(a);
       var barycCoord_1 = distance.dot(s1) * invDivisor;
       if (barycCoord_1 < 0.0 || barycCoord_1 > 1.0) return -1.;
       // Calculate the second barycentic coordinate
       var s2 = distance.cross(edge1);
       var barycCoord_2 = dir.dot(s2) * invDivisor;
       if (barycCoord_2 < 0.0 || (barycCoord_1 + barycCoord_2) > 1.0) return -1.;
       // After doing the barycentic coordinate test we know if the ray hits or
       // not. If we got this far the ray hits.
       // Calculate the distance to the intersection point
       var intersectionDistance = edge2.dot(s2) * invDivisor;
       return intersectionDistance;
	}
}
