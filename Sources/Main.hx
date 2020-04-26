package;

import kha.Assets;
import kha.Scheduler;
import kha.System;
import kha.Window;
import Sys;

import Scene;
import Render;

import pgr.dconsole.DC;

import Math;

class Main {
	static var TITLE = "Grafikha";
	static var WIDTH = 600;
	static var HEIGHT = 600;
	static var REFRESH_RATE = 1 / 60;
	static var INPUT = "input.nff";

	// static function notifyOnFrames(func:function): Void {
	//
	// }


	public static function main() {
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

				DC.init();
				DC.registerObject(render, "render");
			});
		});
	}
}
