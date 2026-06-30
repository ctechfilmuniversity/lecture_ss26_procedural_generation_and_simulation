---
layout: default
title: Niagara Intro
nav_exclude: true
---

**Procedural Generation and Simulation**  

Prof. Dr. Lena Gieseke \| l.gieseke@filmuniversitaet.de  



# Intro to Niagara

This document accompanies live exploration and is not a self-contained tutorial.

* [The Niagara System](#the-niagara-system)
    * [UI Overview](#ui-overview)
    * [The System Node](#the-system-node)
* [Basic Setup](#basic-setup)
    * [The Emitter](#the-emitter)
    * [Spawning](#spawning)
    * [Adding Velocity](#adding-velocity)
* [Forces](#forces)
* [Colors \& Materials](#colors--materials)
* [Curl Scene](#curl-scene)
    * [Letter Setup](#letter-setup)
    * [Converting the Letter to a Static Mesh](#converting-the-letter-to-a-static-mesh)
    * [The Particle System](#the-particle-system)
    * [Spawn on the Letter](#spawn-on-the-letter)
    * [Scene Setup](#scene-setup)
    * [Curl Noise](#curl-noise)
    * [Glow Pass](#glow-pass)
    * [Shadows](#shadows)



## The Niagara System

* Right-click in the **Content Browser**, select **FX > Niagara System**
* Choose **Create Empty Niagara System**, name it `FX_basics`

### UI Overview

The Niagara editor opens with the following panels:

* **Viewport**: Real-time 3D preview of the effect.
* **System Overview** (Node View): Graph showing the system and its emitters as nodes. Selecting a node opens its stack in the central editing area.
* **Details**: Properties of the currently selected stack item.
* **Timeline**: Playback controls and the overall loop duration of the system.
* **Parameters** (User Parameters): Parameters exposed for override from external systems such as Blueprints.
  
### The System Node

The **System** node in the **System Overview** holds global settings for the entire effect: looping behavior, fixed duration, warm-up time, and fixed bounds. It is the root that all emitters belong to. Setting `Loop Behavior` to *Once*, for example, makes the effect play through once and stop.

## Basic Setup

### The Emitter

An emitter is a self-contained particle generator. It defines how particles are spawned, how they behave over their lifetime, and how they are rendered. A system can contain multiple emitters, each contributing a distinct element to the overall effect.

* In the **System Overview**, click **+** and select **Minimal Emitter**, name it `E_basics`


### Spawning

Niagara provides several modules for controlling when and how particles appear:

* **Spawn Rate**: Continuously spawns particles at a fixed number per second. Use for sustained effects like smoke or fire.
* **Spawn Burst Instantaneous**: Spawns a fixed count of particles all at once at a defined time. Use for one-shot bursts like explosions.
* **Spawn Per Unit**: Spawns particles based on the distance the emitter travels. Use for motion trails.

In **Emitter Spawn**:

* Click **+**, add **Spawn Rate**
    * `SpawnRate` 10


### Adding Velocity

The **Add Velocity** module applies an initial velocity to each spawned particle. The `Velocity Mode` parameter controls how that velocity is directed:

When **Add Velocity** is first added, Niagara flags a missing dependency. Clicking **Fix Issue** automatically inserts the **Solve Forces and Velocity** module, which integrates all accumulated forces and velocity into particle position each frame. Without it, velocity has no visible effect.

The **Initialize Particle** module (inserted automatically at emitter creation) sets initial per-particle values at spawn, e.g., lifetime, sprite size, and color.

In **Particle Spawn**:

* Click **+**, add **Add Velocity**
    * Click **Fix Issue** (inserts **Solve Forces and Velocity**)
* In **Add Velocity**, click the down arrow next to `Velocity` and select **Random Vector** (unit length — randomizes direction only)
* Set `Velocity Scale` to `100`
* Right-click `Velocity Scale`, select **Make Dynamic Input > Random Range Float** to randomize speed per particle




## Forces

**Gravity Force** applies a constant downward acceleration, causing particles to fall and gain speed over time. **Wind** pushes all particles in a fixed direction each frame. **Drag** resists particle motion proportional to speed, decelerating them over time. **Acceleration Force** applies a custom constant acceleration vector, useful for any directional push independent of gravity.

In **Particle Update**:

* Click **+**, add **Gravity Force**
    * `Velocity Speed Scale` 50–500
* Click **+**, add **Wind Force** and **Drag**
    * `Drag` 5
* Click **+**, add **Acceleration Force**
* Click **+**, add **Collision** (particles collide with scene geometry)


## Colors & Materials

The look of particles is defined as much by their material as by emitter settings - also material and particle settings might overwrite each other at times.

* Create material `M_basics`, assign a base color
* In **Render > Sprite Renderer**, set `Material` to `M_basics`
    * To soften hard-edged squares: in the material add a **Radial Gradient Exponential** node connected to **Opacity Mask**, set material **Blend Mode** to *Masked*

To color particles by speed, in the material:
* Add a **Particle Speed** node, divide output by `400`, pipe through **Saturate** (clamps to 0–1)
* Use the result as alpha in a **Lerp** between two colors, connect to **Base Color**


## Curl Scene

Open the studio scene as a background. The goal is a Niagara system that spawns particles across the surface of a 3D letter and drives them with curl noise.

### Letter Setup

The **Motion Design** plugin creates parametric text geometry. Install it if not yet active.

In the viewport mode dropdown, select **Motion Design**:

* In **Actor**, add a **Text Actor**, type a single letter
    * Under **Geometry**, enable **Extrude**, value `8`
    * Enable **Bevel**, value `1`

Exit Motion Design by clicking **Motion Design** in the viewport dropdown again. Compare the letter's scale to a unit cube and resize to match.

### Converting the Letter to a Static Mesh

The **Static Mesh Location** particle module requires a static mesh as its spawn surface, so the Motion Design text actor must be converted.

In the viewport mode dropdown, select **Modeling Mode**:

* **XForm > Convert**, set **Output Type** to *Static Mesh*, uncheck **Transfer Materials**
* Create and assign a dark gray material to the text

Switch to **Wireframe** view to inspect the topology — the auto-converted mesh is uneven. To fix it:

* Under **Mesh**, run **Remesh** with `5000` triangles

Name the mesh `SM_letter` in the **Content Browser** (use **Ctrl+B** to locate it). Return to **Lit** view and **Selection Mode**.

### The Particle System

Create a new empty Niagara System `FX_curl` with a new empty emitter.

With thousands of particles, GPU simulation is far more efficient than CPU. Switch in **Emitter Properties**:

* Set `Sim Target` to *GPU Sim*
* Enable **Fixed Bounds** and set a bounding box large enough to contain the full effect

Fixed Bounds are required for GPU simulation because particle positions are computed on the GPU and cannot be read back by the CPU to calculate bounds dynamically. Use GPU for large particle counts. Stay on CPU when particle counts are low, when Blueprints need to read individual particle data, or when precise world collision is required.

In **Emitter Spawn**:

* Click **+**, add **Spawn Rate**
    * `SpawnRate` 1000

In **Initialize Particle**:

* Set `Sprite Size Mode` to *Uniform*, size `1`
* Set `Color Mode` to *Direct Set*, choose a base color
* Set `Mesh Scale Mode` to *Uniform*, value `1`

In **Render**:

* Add **Mesh Renderer**, set mesh to `S-1_Unit_Sphere`
    * Enable **Material Override**, add a new material slot, assign a new material `M_curl`

In **Particle Update**:

* Click **+**, add **Scale Mesh Size**
    * Click the down arrow on the size parameter, select **Make Dynamic Input > Vector from Float**
    * Click the down arrow on that float, select **Float from Curve**
    * Shape the curve: start at `0`, rise to `1`, then slowly decrease — particles grow in and shrink as they age

### Spawn on the Letter

In **Particle Spawn**:

* Click **+**, add **Static Mesh Location**
    * Set `Preview Mesh` and `Default Mesh` to `SM_letter`
    * Click **Fix Now** to resolve the dependency error

### Scene Setup

* Place `FX_curl` in the scene
* In the **Outliner**, drag `FX_curl` onto the letter actor to parent it — particles now follow the letter's transform

To prevent particles from spawning inside the geometry:

* In **Static Mesh Location**, enable `Offset Position Along Sample Geometry` to push spawn points outward to the surface

In **Particle Update**:

* Click **+**, add **Color**
    * Click the down arrow on `Color`, select **Color from Curve**
    * Set opacity to `1` across the full curve

### Curl Noise

**Curl Noise Force** applies a turbulent, swirling velocity field derived from a noise function. Unlike random velocity, curl noise is divergence-free — particles flow smoothly around each other rather than scattering.

In **Particle Update**:

* Click **+**, add **Curl Noise Force**
    * Click **Fix Issue**
* Click the down arrow on `Noise Strength`, select **Random Range Float**
    * Min `2`, max `4`
* Set `Noise Pan` X to `0.2` to slowly shift the noise field over time, producing continuously changing flow patterns

### Glow Pass

A second emitter with an emissive material gives a subset of particles a glowing appearance without modifying the base emitter.

* Duplicate `M_curl` as `M_curl_emissive`
    * In the material, connect **Particle Color** to both **Base Color** and **Emissive Color**
* Duplicate the emitter, assign `M_curl_emissive`, reduce `SpawnRate`
    * In the **Color** module, click the down arrow on the color value and set `Color Scale` to `50` — this amplifies the color intensity, producing a bright glow through the emissive channel

### Shadows

* In the scene, select `FX_curl`, enable **Cast Shadows**