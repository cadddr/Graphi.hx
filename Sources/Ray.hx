import kha.math.Vector3;

class Ray {
  var origin: Vector3;
  var direction: Vector3;

  public function new(origin: Vector3, direction: Vector3) {
    this.origin = origin;
    this.direction = direction;
  }

  public function getPointAt(t: Float): Vector3 {
      return origin.add(direction.mult(t));
  }

  public function intersection(surfaces: Array<Surface>, findClosest: Bool): Intersection {
    var result = new Intersection(this, null, Math.POSITIVE_INFINITY);
    for (target in surfaces) {
      var t = target.ray(origin, direction);
      if (t > 0 && t < result.t) {
        result = new Intersection(this, target, t);
        if (!findClosest) {
          break;
        }
      }
    }
    return result;
  }
}

class Intersection {
  public var ray: Ray;
  public var t: Float;
  public var target: Surface;

  public function new(ray: Ray, target: Surface, t: Float) {
    this.ray = ray;
    this.target = target;
    this.t = t;
  }
}

// class LightSource {
//   var origin: Vector3;
//   public function new(origin: Vector3) {
//     this.origin = origin;
//   }
//
//   public function illuminate(point: Vector3, normal: Vector3, from: Vector3): Float {
//     var to_light = origin.sub(point);
//     to_light.normalize();
//
//     var to_view = from.sub(point);
//     to_view.normalize();
//
//     var intersection = new Ray(point, to_light).intersection(scene.surfs, false);
//     if (intersection.target != null) {
//       illum = Math.min(1, illum
// 			+ kd * diffuse(normal, to_light) / lights.length
// 			+ ks * specular(normal, to_view, to_light)
// 			);
//     }
//
//   }
// }
