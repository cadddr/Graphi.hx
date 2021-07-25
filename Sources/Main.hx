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

import haxe.Json;
import Config;

import kha.Storage;
import kha.StorageFile;

import Utils;

import kha2d.Sprite;

class Main {
	static var TITLE = "Grafikha";
	static var WIDTH = 512;
	static var HEIGHT = 512;
	static var REFRESH_RATE = 1 / 64;

	static var scene: Scene;
	static var renderer: Render;
	static var sampler: IRenderSampler;

	public static function main() {
		System.start({title: TITLE, width: WIDTH, height: HEIGHT}, function (window:Window) {
			Assets.loadBlobFromPath('config.json', function (blob) {
				var config: Config = Json.parse(blob.toString());
				trace (config);

				// var file = new StorageFile();
				// Storage.namedFile("test").write(new kha.Blob(haxe.io.getBytes(0, new haxe.io.BytesData())));

				Assets.loadBlobFromPath(config.INPUT, function (blob) {
					scene = Scene.readNff(blob.toString());
					
					renderer = new Render(scene);
					
					sampler = new SimpleRender(renderer);
					DC.init();
					// DC.registerObject(renderer, "render");
					// DC.registerClass(Main, "Main");

					
	
					System.notifyOnFrames(function (framebuffers) {
						// DC.beginProfile("Render");
						sampler.render(framebuffers[0]);
						// DC.endProfile("Render");
					});
				});

				// #if sys
				// // sys.io.File.saveBytes(config.outputDir + 'output.txt', new haxe.io.Bytes(WIDTH, sampler.backbuffer[0]));
				// #end
			});
		});
		// var file: StorageFile = (Storage.defaultFile());

		// // file.writeString("testtesttest");
		// trace(file.readString());

		// trace(StringTools.hex(65546));

		
	}
}