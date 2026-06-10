---
layout: default
title: Tutorial
nav_exclude: true
---

# Tutorial - Setting Up a Studio Environment


* [Studio Setup](#studio-setup)
* [1. An Empty Level](#1-an-empty-level)
* [2. Studio Geometry](#2-studio-geometry)
* [3. Basic Lighting](#3-basic-lighting)
    * [Studio Lighting](#studio-lighting)
    * [Ambient Light](#ambient-light)
    * [Three Point Light](#three-point-light)
* [4. Materials](#4-materials)
* [5. Camera](#5-camera)

---

> The Unreal Documentation, Unreal's AI Assistant, Claude and Claude Code assisted with the setup and text generation of this tutorial. All concepts, structures, and content decisions were made solely by me. Generated material was reviewed and thoroughly adjusted. However, documentation and tools should be considered reference material throughout.

---


## Studio Setup

In the following we will create a simple studio environment for rendering well-lit elements in front of a uniform background.

For that we want to start with an empty scene. Start Unreal and create a new blank project under `Games` -> `Blank`. 


## 1. An Empty Level

Unless you have set a custom start level, Unreal will start with a level, which has a bunch of stuff inside already. But we want to have a clean start for learning how to setup everything needed.

Hence, we will now create a new, empty level.

A **Level** is all or part of your game's "world". Levels contain everything a player can see and interact with, like environments, usable objects, other characters, and so on. Unreal Engine saves each Level as a separate .umap file, which is why you will sometimes see Levels referred to as **Maps**.

As Unreal is a complex environment, being organized helps a lot to navigate and also for creating robust setups. Start with proper [folder structures and naming conventions](https://dev.epicgames.com/community/learning/courses/qEl/unreal-engine-technical-guide-to-linear-content-creation-pipeline-development/mX6b/unreal-engine-project-structure-naming-conventions) right away! You will thank yourself (and me ;)) later.

The Content Browser is the primary area of the Unreal Editor for creating, importing, organizing, viewing, and managing content Assets within your Unreal project. 

* Create one main folder named after your project (e.g., `StudioEnvironment`) inside the Content folder. All of your custom work should reside inside this directory. If you are building a large project I recommend another subfolder per asset type (level, materials, etc.). But as we are building only a simple scene, I put everything in this folder.
* Create a new, empty level, either
    * In the Content Browser, in the project folder, `right click` -> `Level`
    * OR in the main menu under `File` -> `New Level` -> `Empty` 
* Give it a name with the prefix `L_`, e.g. `L_studio`
* If not yet open, double-click the level in the Content Browser to open the newly created level.

## 2. Studio Geometry

Similar to coding, one essential approach to working with Unreal is to re-use assets as much as you can. In that spirit, we will use as studio geometry an asset that comes with the [`Motion Design` plugin](https://dev.epicgames.com/documentation/en-us/unreal-engine/motion-design-quickstart-guide-in-unreal-engine).
  
To access that geometry we have to load the plugin even though we are not using it just yet (later we might, it is fun system!). To install a plugin:

* In the main menu under `Edit` -> `Plugins` -> Search for `Motion Design` -> Check its box and restart Unreal

To add the actual mesh to our level, we need to find the mesh in the Content Browser. The display settings of the browser might be set to not show all available assets. To see the Engine Content to which the assets of the Motion Designer plugins are saved, we have to make sure that we see the Engine Content:

* `Content Browser` -> `Settings` (at the top right corner of the browser) -> `Show Engine Content`


Add the Mesh For Studio Background:
* Search field (top left corner of the browser) -> click `All`
* Type in `sm_`, select `SM_Cyc_02`, and drag & drop it from the Content Browser into the scene
* Rename it to SM_studio and reset its position to `0,0,0`.

## 3. Basic Lighting

We can't see anything, as we don't have any lighting.

As a common basic lighting people use Unreal's sky environment. For many cases this is just fine but its look is recognizable as default and it looks gamey. If you want that you could do (we are not using it in this scene, just as starter info here):

* In the main menu select `Window` -> `Env. Light Mixer`
* Hit all the buttons (they do what their names say): `Create Sky Light`, `Create Directional Light`, `Create Sky Atmosphere`, `Create Volumetric Cloud`. Now you have a fully functional environmental light setup.
* In the `Env. Light Mixer` you can make adjustments to the setup
* Also, there is a gizmo available while holding `Ctrl + L` (Mac: Command) and then dragging your mouse.
    * The directional gizmo (a white arrow and circle) represents the sun’s angle.
    * Moving the mouse updates the rotation of the Directional Light in real-time.
    * The Sky Atmosphere and a Sky Light (with “Real Time Capture” enabled), the atmosphere’s colors, shadows, and ambient lighting will update automatically to reflect the new time of day.

Let's delete all lights from that setup again. We don't want a cheap outside lighting but a studio light setup based on the (somewhat old school) [Three Point Light](https://en.wikipedia.org/wiki/Three-point_lighting).

*On a Side Note:* Before you do any kind of fine tuning of your lighting, you should have your final materials and camera set! We start with a rough setup of the lights, setup the scene and then fine tune.


### Studio Lighting

A classical light setup is the [Three Point Light](https://en.wikipedia.org/wiki/Three-point_lighting) studio setup, which includes a Key Light, a Fill Light and a Backlight. However, we are going to cheat a little with some global ambient light coming from an HDRI Background.


### Ambient Light

As ambient light we are using an HDR image. 

HDRI stands for High Dynamic Range Image. It is a panoramic photograph (typically 360 degrees) that captures a much wider range of light intensity than a standard image, from very dark shadows to very bright highlights. The key difference from a regular photo is that each pixel stores the actual luminance value of the light source it captured, rather than clamping it to a 0-255 range. This means a sun in an HDRI is genuinely brighter than a shadow, which the renderer can use to cast accurate light.

In 3D rendering and Unreal Engine, HDRIs are used as environment maps to light a scene. Because the image stores real-world light data, placing a 3D object inside an HDRI-lit environment produces realistic reflections, shadows, and ambient light that match an actual physical location or studio setup.

In case you want to use an HDRI for lighting and as background in your scene, I recommend doing that with the plugin `HDRIBackdrop` (same steps as installing the MotionDesign plugin). HDRIBackdrop provides a dedicated actor for placing an HDRI in your scene as both a visible background and a light source in one step. You place an HDRIBackdrop actor in the level, assign an HDRI texture to it, and it handles for you:
* A dome mesh that displays the panorama as the visible sky and surroundings
* Sky light contribution so the HDRI actually illuminates objects in the scene
* Correct scaling and projection so the backdrop looks like an infinite environment rather than a sphere

However, as we only want the light, not any background, we can simply add an HDRI to a Skylight as follows.
* For finding a suitable HDRI, there are various sites, e.g. [Polyhaven](https://polyhaven.com/) -> [Browse HDRIs](https://polyhaven.com/hdris). Search for `studio` and select something with soft, even light. Download it as HDR (this is important for the correct import in Unreal).
* In the Content Browser, click `Import` and import the file, rename it to `HDR_studio`. Only if the import file has the `.hdr` extension, the file is correctly imported as `TextureCube`, which we need to work for the SkyLight. 
A `Texture` will not be compatible!
* Verify that you have a `TextureCube`.
* Create a SkyLight under `Quick Add` -> `Lights` -> `Sky Light`
* In the Details of the SkyLight, change `Source Type` to `SLS Specified Cubemap` and drag and drop `HDR_studio` to the `Cubemap` slot (or load it any other way there). Now we have a nice soft ambient lighting.


### Three Point Light

In an analog studio setting often soft lights and diffusers are used. We simulate that with an area light (called `RectLight` in Unreal). To have a reference point for targeting the lighting, create a cube and place it in the middle of the studio.

Key Light
* The main source of illumination
* Positioned 30–45° to the side and slightly above the object
* It creates shadows and contrast
* For example
    * position = -650, -650, 650
    * rotation = 0, -30, 45
    * Intensity = 1000
    * Attenuation Radius = 2000
    * Width = 1000
    * Height = 500

Fill Light
* A soft light
* Fills in the shadows caused by the key light
* Positioned on the opposite side of the key light, with lower intensity
* In the analog world, this is sometimes done with a reflector in 3D sometimes simply with an ambient light
* For example
    * position = 650, -650, 650
    * rotation = 0, 30, 120
    * Intensity = 200
    * Attenuation Radius = 2000
    * Width = 1000
    * Height = 500

Back Light (Rim or Hair Light)
* Placed behind and above the subject
* It creates a rim of light on the edges
* Adds depth and separation from the background
* For example
    * position = 50, 600, 800
    * rotation = 0, -30, -90
    * Intensity = 200
    * Attenuation Radius = 2000
    * Width = 500
    * Height = 250
    * Barn Door Angle: 10
    * Barn Door Length: 150

## 4. Materials

Let's create a more even material for the geometries.

* `Content Browser` -> in the materials folder -> right-click -> Material -> `M_studio`
* Apply the material to the studio
* Open the `Material Editor`
* 3 -> click, new v3 Node, connect RGB to `Base Color`

Assign studio and cube the material.


## 5. Camera

In order to render, we need to add a camera to our scene:

* In the quick add menu, select `Place Actor Panel`.
* Click the small Film icon on the top and then drag a `Cine Camera Actor` into your scene. 
* Select the camera object and place it to create the desired framing. You can see the view from your camera on the right side of your scene. 
* To create a camera frame, you can also right click the `CineCameraActor` in the Outliner and select `Pilot CineCameraActor`. Now what you see in your Level Viewport, is what the camera sees as well. This means, you can set up the camera view by moving around the viewport with the navigation tools you normally use. Once you have found a view of your object that you like, you can stop piloting by pressing the Stop button in the top left of your viewport. 



