package;

import kha.Assets;
import kha.Scheduler;
import kha.System;

import Scene;
import Render;

class Main {
	static var TITLE = "Grafikha";
	static var WIDTH = 600;
	static var HEIGHT = 600;
	static var REFRESH_RATE = 1 / 60;
	static var INPUT = "input.nff";

	public static function main() {
		// TODO: read resolution from file
		System.start({title: TITLE, width: WIDTH, height: HEIGHT}, function (_) {
			// Just loading everything is ok for small projects
			Assets.loadBlobFromPath(INPUT, function (blob) {
				var scene = Scene.readNff(blob.toString());
				var render = new Render(scene);
				// Avoid passing update/render directly,
				// so replacing them via code injection works
				Scheduler.addTimeTask(function () { render.update(); }, 0, REFRESH_RATE);
				System.notifyOnFrames(function (framebuffers) { render.render(framebuffers[0]); });
			});
		});
	}
}
