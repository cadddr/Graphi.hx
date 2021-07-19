package;

import kha.Assets;
import kha.Scheduler;
import kha.System;
import kha.Window;
import kha.Framebuffer;
import kha.input.Keyboard;
import kha.input.KeyCode;
import kha.Color;
import Sys;

import Scene;
import Render;
import RenderSampler.IRenderSampler;
import RenderSampler.SimpleRender;
import RenderSampler.AdaptiveRender;

import pgr.dconsole.DC;

import Math;

class Main {
	static var TITLE = "Grafikha";
	static var WIDTH = 512;
	static var HEIGHT = 512;
	static var REFRESH_RATE = 1 / 64;
	static var INPUT = "input.nff";

	static var scene: Scene;
	static var renderer: Render;
	static var sampler: IRenderSampler;

	public static function main() {
		// TODO: read resolution from file
		System.start({title: TITLE, width: WIDTH, height: HEIGHT}, function (window:Window) {
			Assets.loadBlobFromPath(INPUT, function (blob) {
				scene = Scene.readNff(blob.toString());
				renderer = new Render(scene);
				sampler = new AdaptiveRender(renderer);

				DC.init();
				DC.registerObject(renderer, "render");
				DC.registerClass(Main, "Main");

				System.notifyOnFrames(function (framebuffers) {
					DC.beginProfile("Render");
					sampler.render(framebuffers[0]);
					DC.endProfile("Render");
				});
			});
		});
	}
}