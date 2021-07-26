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
import RenderSampler.AdaptiveRender;

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
	static var REFRESH_RATE = 1 / 64;

	static var scene: Scene;
	static var renderer: Render;
	static var sampler: IRenderSampler;
	static var viewSampler: RandomViewSampler;

	public static function main() {
		var frame: Array<Color>;

		System.start({title: TITLE, width: WIDTH, height: HEIGHT}, function (window:Window) {
			Assets.loadBlobFromPath('config.json', function (blob) {
				var config: Config = Json.parse(blob.toString());
				trace (config);

				Assets.loadBlobFromPath(config.INPUT, function (blob) {
					scene = Scene.readNff(blob.toString());
					
					renderer = new Render(scene);
					
					sampler = new AdaptiveRender(renderer);
					// DC.init();
					// DC.registerObject(renderer, "render");
					// DC.registerClass(Main, "Main");

					System.notifyOnFrames(function (framebuffers) {
						// DC.beginProfile("Render");
						sampler.render(framebuffers[0]);
						frame = sampler.backbuffer;
						// DC.endProfile("Render");
					});
				});
			});
		});
		        // #if sys
		// // sys.io.File.saveBytes(config.outputDir + 'output.txt', new haxe.io.Bytes(WIDTH, sampler.backbuffer[0]));
		// #end
		// var file: StorageFile = (Storage.defaultFile());
		// var bytes: Bytes = Bytes.alloc(WIDTH * HEIGHT * 4);
		// for (i in 0...WIDTH * HEIGHT) {
		// 	bytes.setInt32(i * 4, frame[i]);
		// }
		// file.write(Blob.fromBytes(bytes));
	}
}