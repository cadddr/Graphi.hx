import kha.math.Vector3;
import Std.parseInt;
import Std.parseFloat;
import Utils.parseVector3;
import Surface;
import Surface.Sphere;
import Surface.Face;

class Scene {
  public var RENDER_DIFFUSE_SHADING = true;
	public var RENDER_SPECULAR_SHADING = true;
	public var RENDER_REFLECTIONS = true;
	public var RENDER_TRANSPARENCY = false;

  public var hither = 0.01;
	public var fov = Math.PI / 3;
  public var default_color = 0xffffa500;

  public var from: Vector3;
	public var up: Vector3;
	public var at: Vector3;
	public var surfs: Array<Surface> = [];
  public var lights: Array<Vector3> = [];

  public var ambient = 0.1;
  public var kd = 0.25;
  public var ks = 0.5;
  public var shininess = 10;
  public var epsilon = 0.00000001;
  public var MAX_HOPS = 5;
  public var ir = 0.5;

  public function new() {}

  public function screenSpaceToWorldSpace(x: Float, y: Float, width: Float, height: Float): Vector3 {
    var off = Math.tan(fov / 2) * hither;
    var view = at.sub(from).normalized();
    var left = view.cross(up).normalized();
    var to = view.mult(hither)
      .add(left.mult(off - 2 * off * x / width))
      .add(up.mult(off - 2 * off * y / height))
      .normalized();

    return to;
  }

  public static function readNff(input:String): Scene {
    var scene = new Scene();
		for (line in input.split('\n')) {
      trace (line);
			if (line.charAt(0) == '#' || line.length == 0) continue;
			var vals = line.split(' ');
			switch vals[0] {
				case 'up': scene.up = parseVector3(vals.slice(1, 4));
				case 'from': scene.from = parseVector3(vals.slice(1, 4));
				case 'at': scene.at = parseVector3(vals.slice(1, 4));
				case 's': {
					scene.surfs.push(new Sphere(
						parseVector3(vals.slice(1, 4)),
						parseFloat(vals[4]),
						parseInt(vals[5])));
				}
				case 'l': scene.lights.push(parseVector3(vals.slice(1, 4)));
				case 't': scene.surfs.push(new Face(
					parseVector3(vals.slice(1, 4)),
					parseVector3(vals.slice(4, 7)),
					parseVector3(vals.slice(7, 10)),
					parseInt(vals[10])
				));
			}
		}
    return scene;
	}
}
