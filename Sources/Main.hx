package;

import kha.Assets;
import kha.Scheduler;
import kha.System;
import kha.Window;
import Sys;

import Scene;
import Render;



class Main {
	static var TITLE = "Grafikha";
	static var WIDTH = 600;
	static var HEIGHT = 600;
	static var REFRESH_RATE = 1 / 60;
	static var INPUT = "balls-2.nff";

	public static function main() {
		trace(Sys.stdin().readLine());

		// TODO: read resolution from file
		System.start({title: TITLE, width: WIDTH, height: HEIGHT}, function (window:Window) {
			// Just loading everything is ok for small projects
			Assets.loadBlobFromPath(INPUT, function (blob) {
				var scene = Scene.readNff(blob.toString());
				trace(window.title);
				var render = new Render(scene, window);
				// Avoid passing update/render directly,
				// so replacing them via code injection works
				Scheduler.addTimeTask(function () { render.update(); }, 0, REFRESH_RATE);
				System.notifyOnFrames(function (framebuffers) { render.render(framebuffers[0]); });
			});
		});
	}
}
