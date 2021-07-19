# Graphi.hx
Pronounced ***grae:fi/h/ks***, alternatively Grafikha -- a nod to either Haxe language or Kha graphics backend or whatever.

A hobby ray tracer from scratch in Haxe using Kha as a low-level graphics API (for vector maths and putting pixels on the screen).

* The initial goal was an obscure minimal business card-style implementation, but with more features added and for better flexibility some modularization became necessary.

* Supports either .nff (view frustum, spheres, triangles and lights only) or .obj format input. I am not aiming, at any point, to support the complete zoo of nff primitives so it's gonna be either universal triangles or some interesting smooth surfaces.

* Interactive, qweasd moves/rotates camera around the focal point. Plan to support on the fly nff input, think it'll be cool.

* Rendering: diffuse and specular shading (read: hard shadows and simple highlights), raytraced reflections and at this point somewhat broken refraction/transparency. Plan to rework it as a modular pipeline allowing to turn stages on/off change parameters such as bounce count, etc. on the fly.

* Planning some optimizations with compute shaders and perhaps adaptive resolution scaling/sampling rate (there is none as of now), also perhaps log frame times [Giga]rays per-pixel, etc.

* Stretch goals: some depth of field and motion blur would be sweet.

* No plans whatsoever of making it into usable game engine or anything like that. Intend to perform zero modeling as well.

### Roadmap:

* Restore existing features (triangles, obj format, camera movement)

* <del>Figure out Electron HTML5 target in Atom</del>

* Interface: <del>Interactive manipulation of render parameters</del> (also read from nff)
  * mouse dragging input values

* Interface: input model file from command line; <del>log info to window title</del>

* Feature: Refraction

* Feature: sampled/temporal AA

* Optimization: adaptive resolution/caching
  * multithreading or round robin

* Optimization: Offload ray calculations onto compute shaders

* Optimization: Rasterized visibility

* Optimization: further modularization
