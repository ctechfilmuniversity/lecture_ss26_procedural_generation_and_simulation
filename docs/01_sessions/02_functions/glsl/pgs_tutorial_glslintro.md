---
layout: default
title: Session
nav_exclude: true
---


**Procedural Generation and Simulation**  

Prof. Dr. Lena Gieseke \| l.gieseke@filmuniversitaet.de  


# Introduction To Working with GLSL Fragment Shaders in VS Code

* [Setting Up](#setting-up)
* [The Minimal Shader](#the-minimal-shader)
    * [Language Basics](#language-basics)
* [Sine Stripe Example](#sine-stripe-example)


*Written for the glsl-canvas VS Code extension. Behavior may differ in other GLSL environments.*

> Claude and Claude Code assisted with the setup and text generation of this tutorial. All concepts, structures, and content decisions were made solely by me. Generated material was reviewed and thoroughly adjusted. However, documentation and tools should be considered reference material throughout.

---

A fragment shader is a small program that runs once per pixel and decides what color that pixel should be. There is no explicit loop coding needed from us. The GPU runs the shader in parallel for every pixel at once, which makes it very efficient. We write these shaders in GLSL (OpenGL Shading Language) and preview them directly in VS Code using the glsl-canvas extension.

## Setting Up

Install the [glsl-canvas extension](https://marketplace.visualstudio.com/items?itemName=circledev.glsl-canvas) in VS Code. Create a new file with the extension `.glsl`. Open the command palette with `Cmd+Shift+P` (macOS) or `Ctrl+Shift+P` (Windows/Linux), search for **Show glslCanvas** and select it. A live preview panel opens next to the editor and updates every time you save the file.

## The Minimal Shader

```glsl
#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;

void main() {

    // Normalize pixel coordinate to 0..1
    vec2 coord = (2.0 * gl_FragCoord.xy - u_resolution.xy) / u_resolution.y;

    vec3 color = vec3(0.5, 0.0, 0.0);

    gl_FragColor = vec4(color, 1.0);
}
```

`gl_FragCoord.xy` is a built-in variable that holds the current pixel's position in screen space, measured in pixels from the bottom-left corner. Dividing by `u_resolution` (the canvas width and height in pixels, provided automatically by glsl-canvas) normalises the coordinate to the range -1..1 across the canvas with `0,0` at the center.

`gl_FragColor` is the built-in output variable. It expects a `vec4` with red, green, blue and alpha components, each in the range 0..1.

The `#ifdef GL_ES` block sets floating point precision and is required by the glsl-canvas extension. You can treat it as a fixed header and ignore it otherwise.

### Language Basics

**All numbers must be written with a decimal point.** GLSL treats `1` as an integer and `1.0` as a float, and most operations require floats. Writing `vec3(1, 0, 0)` will cause a type error, write `vec3(1.0, 0.0, 0.0)` instead. The same applies to any arithmetic: use `2.0`, `0.5`, `6.28318` and so on throughout.

`vec2`, `vec3` and `vec4` are the main vector types for 2, 3 and 4 component float values. Components are accessed with `.x .y` (or equivalently `.r .g`). For example, `coord.x` reads the horizontal component of a `vec2`.

`uniform` variables are values passed into the shader from outside. The glsl-canvas extension provides `u_resolution` (canvas size as `vec2`) and `u_time` (elapsed seconds as `float`) automatically.

## Sine Stripe Example

```glsl
#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;

void main() {

    vec2 coord = (2.0 * gl_FragCoord.xy - u_resolution.xy) / u_resolution.y;

    float frequency = 10.0;
    float stripe = sin(coord.x * frequency * 6.28318) * 0.5 + 0.5;

    vec3 colorA = vec3(0.0, 1.0, 1.0);
    vec3 colorB = vec3(0.0, 0.03, 1.0);
    vec3 color = mix(colorA, colorB, stripe);

    gl_FragColor = vec4(color, 1.0);
}
```

*On a Side Note:* For the input of the `sin()` you can use any number you like and just see what happens. However, if you want a more controlled behavior, understand the following. `coord.x` is centered at 0 and its range depends on the canvas aspect ratio, which is approximately -1..1 on a square canvas and wider on a landscape canvas. `coord.y` always runs from -1..1. Multiplying by `frequency` controls how many stripes appear across that range. The `* 6.28318` converts the frequency into radians so that one unit of frequency equals one full sine cycle. Without it a much higher frequency value would be needed for the same visual result. The `* 0.5 + 0.5` remaps the sine output from -1..1 to 0..1 so it drives the `mix` between the two colors cleanly. Change `coord.x` to `coord.y` for horizontal stripes.
