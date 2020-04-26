import kha.Framebuffer;
import kha.math.Vector3;
import kha.Color;
import kha.Scheduler;
import Math;
import kha.Window;
import kha.WindowOptions.WindowFeatures;

import Utils.vec2col;
import Utils.col2vec;

class Render {
  private var scene: Scene;
  private var window: Window;
  public function new(scene: Scene, window: Window) {
    this.scene = scene;
    this.window = window;
    trace(window.title);
  }

  private function diffuse(normal: Vector3, to_light: Vector3): Float {
    return Math.max(0, normal.dot(to_light));
  }

  private function specular(normal: Vector3, to_view: Vector3, to_light: Vector3): Float {
    var half = to_view.add(to_light).normalized();
    return Math.pow(Math.max(0, normal.dot(half)), scene.shininess);
  }

  private function reflected(ray:Ray, point: Vector3, normal: Vector3, from: Vector3): Vector3 {
    return getColorAlongRayDirection(ray.bounce(point, normal, from));
  }

  private function computeShadingAtPoint(ray: Ray, point: Vector3, normal: Vector3, from: Vector3, color: Vector3): Vector3 {
    var result = color;

    if (scene.RENDER_DIFFUSE_SHADING || scene.RENDER_SPECULAR_SHADING) {
      var luminance = scene.ambient;

      for (light in scene.lights) {
        var to_light = light.sub(point).normalized();

        if (new Ray(scene.elevateByEpsilon(point, normal), to_light).miss(scene.surfs)) {
          if (scene.RENDER_DIFFUSE_SHADING) {
            luminance += scene.kd * diffuse(normal, to_light);
          }
          if (scene.RENDER_SPECULAR_SHADING) {
            var to_view = from.sub(point).normalized();
            luminance += scene.ks * specular(normal, to_view, to_light);
          }
        }
      }
      result = color.mult(Math.min(1, luminance));
    }

    if (scene.RENDER_REFLECTIONS) {
      result = result.add(reflected(ray, scene.elevateByEpsilon(point, normal), normal, from).mult(scene.ir));
    }

    return result;
  }

  private function getColorAlongRayDirection(ray: Ray): Vector3 {
    if (ray != null) {
      var intersection = ray.intersection(scene.surfs, true);
  		if (intersection.target != null) {
        var point = intersection.ray.getPointAt(intersection.t);
        var normal = intersection.target.norm(point);
        var albedo = intersection.target.color;
  			return computeShadingAtPoint(ray, point, normal, ray.origin, albedo);
  		}
    }
		return col2vec(scene.default_color);
  }

  private function getPixelColor(x: Float, y: Float, width: Float, height: Float): Color {
    // var samples = [];
    // var color:Vector3 = null;
    // for (i in 0...scene.numSamples) {
      var to = scene.screenSpaceToWorldSpace(x, y, width, height);
      var ray = new Ray(scene.from, to);
      var color = getColorAlongRayDirection(ray);
      return vec2col(color);
    //   samples.push(color);
    // }
    //
    // var averagedColor = color;
    // for (i in 0...scene.numSamples - 1) {
    //   averagedColor = averagedColor.add(samples[i]);
    // }
    // averagedColor = averagedColor.mult(1 / scene.numSamples);
    // return vec2col(averagedColor);
  }

  public function update(): Void {
    // window.changeWindowFeatures(WindowFeatures.FeatureBorderless);
    // trace(window.title);
    // window.resize(400, 400);
    // this.window.title = 'number: ${Math.random()}';
  }


  public function render(fb: Framebuffer): Void {
    // return;
    var lastTime = Scheduler.realTime();

    // Scene.numRays = 0;
    fb.g1.begin();
    for (y in 0...fb.height) {
      for (x in 0...fb.width) {
          fb.g1.setPixel(x, y, getPixelColor(x, y, fb.width, fb.height));
      }
    }
    fb.g1.end();
    // trace ('Rays per pixel: ${Scene.numRays / (fb.height * fb.width)}');
    var currentTime = Scheduler.realTime();
    var deltaTime = currentTime - lastTime;
    // trace('Frame time: $deltaTime');
  }
}
