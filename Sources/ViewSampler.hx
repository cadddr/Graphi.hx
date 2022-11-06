import kha.Framebuffer;
import kha.math.Random;
import kha.math.Vector3;
import RenderSampler.IRenderSampler;
import RenderSampler.AdaptiveRender;

import Scene;
import RenderSampler.IRenderSampler;
import kha.Storage;
import kha.StorageFile;
import haxe.io.Bytes;
import kha.Blob;
import kha.Color;
import kha.Framebuffer;
import Math;

import Utils.pixelsToBytes;
//Makes the renderer render a scene from multiple viewpoints.

class RandomViewSampler {
    private var scene: Scene;
    private var sampler: IRenderSampler;

    public function new(scene: Scene, sampler: IRenderSampler) {
        this.scene = scene;
        this.sampler = sampler;
    }

    public function sampleAndSave(fb:Framebuffer, numViews: Int): Void {
        var viewsBytes: Bytes = Bytes.alloc(numViews * fb.width * fb.height * 4);

        for (i in 0...numViews) {
            scene.rotateView(2 * Math.PI / numViews);
            sampler.render(fb);

            var viewBytes: Bytes = pixelsToBytes(sampler.backbuffer, fb.width, fb.height);
            viewsBytes.blit(i * fb.width * fb.height * 4, viewBytes, 0, fb.width * fb.height * 4);
        }

        saveBytes(viewsBytes);
    }

    public function saveBytes(bytes:Bytes): Void {
		var file: StorageFile = Storage.defaultFile();
		file.write(Blob.fromBytes(bytes));   
    }
}