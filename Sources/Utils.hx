import Std.parseFloat;
import kha.math.Vector3;
import kha.Color;

class Utils {

  public static function col2vec(col:Color) :Vector3 {
		return new Vector3(col.R, col.G, col.B);
	}

public static function vec2col(vec:Vector3): Color {
  return Color.fromFloats(Math.min(1, vec.x), Math.min(1, vec.y), Math.min(1, vec.z), 1.);
}

  public static function parseVector3(arr: Array<String>): Vector3 {
    var p = arr.map(parseFloat);
    return new Vector3(p[0], p[1], p[2]);
  }
}
