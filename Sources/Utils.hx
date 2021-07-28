import Std.parseFloat;
import kha.math.Vector3;
import kha.Color;
import kha.math.Matrix4;
import kha.math.Vector4;
import haxe.io.Bytes;

class Utils {

  public static function multvec3(mat:Matrix4, vec:Vector3):Vector3 {
		var temp = new Vector4(vec.x, vec.y, vec.z, 1);
		temp = mat.multvec(temp);
		return new Vector3(temp.x, temp.y, temp.z);
	}

	public static function rotmat(angle:Float): Matrix4 {
		var c = Math.cos(angle);
		var s = Math.sin(angle);
		return new Matrix4(
			c, 0,-s, 0, 
			0, 1, 0, 0, 
			s, 0, c, 0,
			0, 0, 0, 1
		);
	}

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

  public static function printPixels(pixels: Array<Array<Color>>): Void {
    for (y in 0...pixels.length) {
      haxe.Log.trace (pixels[y], null);
    }
  }

  public static function pixelsToBytes(pixels: Array<Color>, WIDTH: Int, HEIGHT: Int): Bytes {
    var bytes: Bytes = Bytes.alloc(WIDTH * HEIGHT * 4);
    for (i in 0...WIDTH * HEIGHT) {
      bytes.setInt32(i * 4, pixels[i]);
    }
        return bytes;
    }
}
