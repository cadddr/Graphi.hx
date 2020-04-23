import kha.Framebuffer;
import kha.math.Vector3;
import kha.Color;

import Utils.vec2col;
import Utils.col2vec;

class Render {
  private var scene: Scene;
  public function new(scene: Scene) {
    this.scene = scene;
  }

  public function update(): Void {}

  private function diffuse(normal: Vector3, to_light: Vector3): Float {
    return Math.max(0, normal.dot(to_light));
  }

  private function specular(normal: Vector3, to_view: Vector3, to_light: Vector3): Float {
    var half = to_view.add(to_light).normalized();
    return Math.pow(Math.max(0, normal.dot(half)), scene.shininess);
  }

  private function computeShadingAtPoint(point: Vector3, normal: Vector3, from: Vector3, color: Vector3, numHops: Int): Vector3 {
    var result = color;
    var luminance = scene.ambient;

    if (scene.RENDER_DIFFUSE_SHADING || scene.RENDER_SPECULAR_SHADING) {
      for (light in scene.lights) {
        var to_light = light.sub(point).normalized();
        var to_view = from.sub(point).normalized();
        var intersection = new Ray(point.add(normal.mult(scene.epsilon)), to_light).intersection(scene.surfs, false);

        if (intersection.target == null) {
          if (scene.RENDER_DIFFUSE_SHADING) {
            luminance += scene.kd * diffuse(normal, to_light);
          }
          if (scene.RENDER_SPECULAR_SHADING) {
            luminance += scene.ks * specular(normal, to_view, to_light);
          }
        }
      }
      result = color.mult(Math.min(1, luminance));
    }

    if (scene.RENDER_REFLECTIONS) {
      var reflected = col2vec(scene.default_color);

      if (numHops < scene.MAX_HOPS) {
        var to_view = point.sub(from).normalized();
        var to = to_view.sub(normal.mult(2 * to_view.dot(normal)));

        reflected = getColorAlongDirection(point.add(normal.mult(scene.epsilon)), to, ++numHops);
      }
      result = result.add(reflected.mult(scene.ir));
    }

    return result;
  }

  private function getColorAlongDirection(from, to, numHops): Vector3 {
    var intersection = new Ray(from, to).intersection(scene.surfs, true);
		if (intersection.target != null) {
      var point = intersection.ray.getPointAt(intersection.t);
      var normal = intersection.target.norm(point);
      var albedo = intersection.target.color;
			return computeShadingAtPoint(point, normal, from, albedo, numHops);
		}

		return col2vec(scene.default_color);
  }

  private function getPixelColor(x: Float, y: Float, width: Float, height: Float): Color {
    var to = scene.screenSpaceToWorldSpace(x, y, width, height);
    var color = getColorAlongDirection(scene.from, to, 0);
    return vec2col(color);
  }

  public function render(fb: Framebuffer): Void {
    fb.g1.begin();
    for (y in 0...fb.height) {
      for (x in 0...fb.width) {
          fb.g1.setPixel(x, y, getPixelColor(x, y, fb.width, fb.height));
      }
    }
    fb.g1.end();
  }
}
