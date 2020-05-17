package;

import kha.Assets;
import kha.Scheduler;
import kha.System;
import kha.Window;
import kha.Framebuffer;
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

	static var renderer: Render;

	public static function main() {
		// TODO: read resolution from file
		System.start({title: TITLE, width: WIDTH, height: HEIGHT}, function (window:Window) {
			Assets.loadBlobFromPath(INPUT, function (blob) {
				var scene = Scene.readNff(blob.toString());
				renderer = new Render(scene);

				DC.init();
				DC.registerObject(renderer, "render");
				DC.monitorField(Scene, "numRays", "numRays");
				DC.monitorField(renderer.scene, "numSamples", "numSamples");

				Scheduler.addTimeTask(update, 0, REFRESH_RATE);
				System.notifyOnFrames(function (framebuffers) {
					DC.beginProfile('SampleName');
					render(framebuffers[0]);
					DC.endProfile('SampleName');
				});
			});
		});
	}

	static function update(): Void {}

	static function render(fb: Framebuffer): Void {
			fb.g1.begin();
			for (y in 0...fb.height) {
				for (x in 0...fb.width) {
						fb.g1.setPixel(x, y, renderer.getPixelColor(x, y, fb.width, fb.height));
				}
			}
			fb.g1.end();
	}
}
