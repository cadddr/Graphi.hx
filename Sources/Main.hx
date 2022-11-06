package;

import ViewSampler.RandomViewSampler;
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
import RenderSampler.BufferedRenderer;
import RenderSampler.AdaptiveRender;
import RenderSampler.NewAdaptiveRender;

import pgr.dconsole.DC;

import Math;

import haxe.Json;
import Config;

import kha.Storage;
import kha.StorageFile;

import Utils;

import kha2d.Sprite;

import haxe.io.Bytes;
import kha.Blob;
import ViewSampler.RandomViewSampler;

class Main {
	static var TITLE = "Grafikha";
	static var WIDTH = 512;
	static var HEIGHT = 512;
	static var REFRESH_RATE = 1 / 1;

	static var scene: Scene;
	static var renderer: Render;
	static var sampler: IRenderSampler;
	static var viewSampler: RandomViewSampler;

	static var framebuffer: Framebuffer;

	public static function main() {
		

		System.start({title: TITLE, width: WIDTH, height: HEIGHT}, function (window:Window) {
			Assets.loadBlobFromPath('config.json', function (blob) {
				var config: Config = Json.parse(blob.toString());
				trace (config);

				Assets.loadBlobFromPath(config.INPUT, function (blob) {
					if (StringTools.endsWith(config.INPUT, '.nff')) {
						scene = Scene.readNff(blob.toString());
					}
					else if (StringTools.endsWith(config.INPUT, '.obj')) {
						scene = Scene.readObj(blob.toString());
					}
					
					renderer = new Render(scene);
					// sampler = new NewAdaptiveRender(renderer, function() {System.removeFramesListener(Main.render);});
					sampler = new BufferedRenderer(renderer);
					viewSampler = new RandomViewSampler(scene, sampler);

					DC.init();
					DC.registerObject(renderer, "render");
					DC.registerClass(Main, "Main");

					System.notifyOnFrames(Main.render);
				});
			});
		});

		// viewSampler.sampleAndSave(framebuffer, 1);
	}

	static function render(framebuffers: Array<Framebuffer>): Void {
		DC.beginProfile("Render");
		sampler.render(framebuffers[0]);
		DC.endProfile("Render");
		framebuffer = framebuffers[0];
	}
}