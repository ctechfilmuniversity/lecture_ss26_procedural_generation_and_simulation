---
layout: default
title: Session
nav_exclude: true
---

**Procedural Generation and Simulation**  


Prof. Dr. Lena Gieseke \| l.gieseke@filmuniversitaet.de  

---

# Session 05



## Final Project - 80 Points

### Summary

*Herzschlag-Organismus* (Heartbeat Organism) is a real-time, audio-reactive scene in Unreal Engine 5 that shows an abstract organism world at a microscopic scale. Its skin is defined by mathematical functions, a Voronoi vein network runs through it, and music provides its heartbeat: every kick sends a pulse of light through the veins, while high frequencies make the hairs stand up, glow and release spores. TouchDesigner analyses the audio live and sends the values to Unreal via OSC, where they drive the materials and three GPU particle systems (pearls, hairs, spores).

| | |
|---|---|
| **Software** | Unreal Engine 5.8 (Material Editor, Niagara, Blueprints, Remote Control, OSC), TouchDesigner |
| **Data flow** | Audio → TouchDesigner (bass, highs, kick, shape sliders) → OSC → Remote Control → `BP_Organism` → `MPC_Organism` / `NPC_Organism` → materials & Niagara |
| **Total time** | 65h |
| **Lexture Topics** | `Formulas` · `Function Design` · `Noise – Cellular` · `Noise – Function` · `Forces` · `Particles `| 




### Concept

The idea is a living organism seen through a microscope, whose heartbeat is the music. Inspired by macro photography of organic tissue, the scene shows a soft, skin-like surface with veins, pearls, hairs and spores, which dissolves into darkness at its edges, so it appears as an endless body.

Every element of the organism reacts to a different part of the music:

| Input | Response of the organism |
|---|---|
| **Kick** | Heartbeat: two alternating hearts send pulses of light through the veins; the pearls are pushed away and swell briefly |
| **Highs** | The hairs straighten up, tremble and glow; after a few seconds of sustained highs, the large tufts release rising spores |
| **Sliders** (frequency, amplitude, warp, blend) | The shape of the body changes live between three mathematical functions |

This way the organism can be played like an instrument: the music gives it its pulse, while the performer shapes its body in real time. Technically, the same field function is evaluated in the materials and in all particle systems, so the skin, veins, pearls and hairs always move as one body.

---

## Implementation

### *1. TouchDesigner → Unreal Engine: Audio-Reactive Light Control via OSC – 8h*


I connected TouchDesigner to Unreal Engine via OSC so that audio analysis values (bass, highs, kick) control the intensity of three lights in real time through Remote Control.


**Problems**

1. Unreal Engine 5 received no OSC signals from TouchDesigner; the REC learn test returned `None`.
2. Once the connection worked, all three audio values arrived as the same signal.

**Solution**

1. The signal was blocked on `127.0.0.1` (localhost), and the OSC Data Format was set to `Time Slice` instead of `Sample`. Switched the IP to the IPv4 address (`192.168.178.131`), the port to `9000` and the Data Format to `Sample`.
2. All three TouchDesigner channels were internally named `low`, so they sent identical `/low` addresses. Renamed the channels to `low`, `high` and `kick` to generate distinct OSC paths (`/low`, `/high`, `/kick`).

![OSC Connection](img/Doc_impl_OSC-Connection.png)

<hr style="height:1px; border:none; color:currentColor; background-color:currentColor; opacity:0.2;">

### *2. Concept Refinement & Unreal Engine Bridge for Material Parameters – 6h*

I refined my concept after seeing some mood images of abstract organic macro surfaces on Pinterest, inspired by microscopic tissue. Its shape is defined by a mathematical function, Voronoi veins run through it, and every kick acts as a heartbeat that sends a pulse of light through the veins.

On the technical side, I built the bridge between my existing OSC setup and the materials. I created a Material Parameter Collection (`MPC_Organism`) as a central place for all values and a Blueprint (`BP_Organism`) whose variables receive the OSC values via Remote Control. Every frame, the Blueprint writes them into the collection. It also detects each new kick (rising edge) and stores its timestamp as `PulseStart`, which the materials will later use to animate the heartbeat pulse.


<div align="center">
<table>
  <tr>
    <td align="center"><img src="img/Doc_impl_Inspo-05.jpg" alt="Mood image" width="300" height="450" style="object-fit:cover;"></td>
    <td align="center"><img src="img/Doc_impl_Inspo-06.jpg" alt="Mood image" width="300" height="450" style="object-fit:cover;"></td>
    <td align="center"><img src="img/Doc_impl_Inspo-03.jpg" alt="Mood image" width="300" height="450" style="object-fit:cover;"></td>
  </tr>
</table>
</div>

![BP_Organism](img/Doc_impl_BP-Organism.png)

![MPC_Organism](img/Doc_impl_MPC_Organism.png)

<hr style="height:1px; border:none; color:currentColor; background-color:currentColor; opacity:0.2;">

### *3. Material Functions & Live Control of the Function Parameters – 5h*

Next was building the mathematical core of the scene as reusable Material Functions in Unreal Engine. `MF_Field` calculates the height of the organic surface from three blended functions (crossed sine waves, a five-petal polar "flower" and ring waves), including domain warping and a soft fade towards the edges. `MF_FieldNormal` derives the surface normals from the field, so the lighting follows the deformation. `MF_Mask` creates a soft circular region mask that later limits where the veins appear.

I also added a shared clock (`Now`), which the Blueprint writes into the Material Parameter Collection every frame, so that materials and particles stay in sync with the heartbeat. Finally, I set up live control: a Constant CHOP in TouchDesigner sends the function parameters (`freq`, `amp`, `warp`, `funcblend`) as values from 0 to 1 via OSC, and `BP_Organism` scales them to their actual ranges and passes them on to `MPC_Organism` (see Step 4).

![MF_Field](img/Doc_impl_MF_Field.png)

![MF_FieldNormal](img/Doc_impl_MF_FieldNormal.png)

![MF_Mask](img/Doc_impl_MF_Mask.png)

<hr style="height:1px; border:none; color:currentColor; background-color:currentColor; opacity:0.2;">

### *4. Organic Surface with Live Deformation – 3h*

I created a subdivided plane (2000 × 2000 units, 256 × 256 subdivisions) in Unreal's Modeling Mode and built the material `M_Surface` for it. The material uses the Subsurface shading model for a soft, skin-like look. It deforms the plane with World Position Offset based on `MF_Field` and gets its lighting from the normals of `MF_FieldNormal`. The surface now moves in real time and can be reshaped live with the sliders in TouchDesigner (frequency, amplitude, warp and blending between the three functions).

**Problems**

1. The valleys of the surface appeared black with flickering, hard edges.
2. In Play mode the surface was completely flat, although it was deformed in the editor.

**Solution**

1. Everything below the original height of the plane was darkened: first the default level floor cut through the valleys, then Lumen still treated the area below the flat plane as "inside" the mesh, because its software ray tracing does not support World Position Offset. Deleted the default `Floor` and lifted the whole surface by `Amp` (`MF_Field` + `Amp`), so the valleys never sink below the original height.
2. The range mapping in Remote Control (0–1 → 0–100) did not convert the values, so `Amp` arrived as 0.4 instead of 40. Removed the Remote Control ranges and scaled the values in `BP_Organism` with Multiply nodes instead (`Freq` × 5, `Amp` × 100, `Warp` × 2, `FuncBlend` × 2).

![M_Surface](img/Doc_impl_M_Surface.png)

![Lumen error in the valleys](img/Doc_impl_LumenError.png)

![Deformed surface (result of Step 4)](img/Doc_impl_Step4_finished.png)

<hr style="height:1px; border:none; color:currentColor; background-color:currentColor; opacity:0.2;">

### *5. Voronoi Veins with Growth and Heartbeat Pulse – 9h*

I generated an organic vein network directly in the surface material using a Voronoi algorithm in a Custom HLSL node (`MF_Voronoi`). The cell edges form the veins, a finer second Voronoi layer adds capillaries, and domain warping makes the cells look grown rather than geometric. The veins are colored, slightly raised from the skin, and limited to a circular zone by `MF_Mask`.

The heart of the step is `MF_Pulse`: on every kick, the Blueprint stores the current time as `PulseStart`, and the material sends a ring of light from the heart outwards through the network, cell by cell, fading over time. A `Growth` parameter lets the network grow outwards from the heart. Two hearts alternate on every kick (`UseA` toggle in `BP_Organism`), so the waves overlap and the rhythm feels more alive. To make the veins look truly raised, I added a bump-mapping Custom node (`VeinBump`) that bends the surface normals along the veins, so they catch light and cast shading.


**Problems**

1. After reopening the project, `Amp` could no longer be controlled from TouchDesigner, although all other sliders still worked.
2. The veins looked flat, even with a higher `VeinHeight`.

**Solution**

1. The Remote Control preset contained two OSC bindings for `Amp` that blocked each other. Deleted the duplicate binding and saved the preset separately.
2. The lighting only used the normals of the large field, and the mesh (256 × 256 subdivisions) was too coarse to displace such thin lines geometrically. Added the vein height to the normals with a bump-mapping Custom node (screen-space derivatives of the vein height), so the veins get their own highlights and shadows.

![Voronoi veins on the skin](img/Doc_impl_VoronoiSkin.png)

![MF_Voronoi](img/Doc_impl_MF_Voronoi.png)

![M_Surface with Voronoi veins](img/Doc_impl_M_Surface_Voronoi.png)

<hr style="height:1px; border:none; color:currentColor; background-color:currentColor; opacity:0.2;">

### *6. Pearls in Niagara with Forces and Heartbeat Push – 5h*

I created a GPU particle system (`NS_Pearls`) that places around 3,000 pearl-like spheres on the organic surface. Each pearl remembers its starting position (`RestPos`) when it spawns. All movement happens in a single Scratch Pad module with a Custom HLSL node written by Claude: it evaluates the same field function as the surface material, so every pearl sits exactly on the moving skin. A spring pulls the pearls back to their rest position, drag calms the motion, and pearls are only visible in the valleys of the surface. On every kick, the heartbeat wave pushes the pearls away from the heart and makes them swell briefly, perfectly in sync with the light pulse in the veins. The values come from the shared `MPC_Organism` via a Niagara Parameter Collection (`NPC_Organism`). The pearls use a clear-coat material with a Fresnel-based shimmer from pink to green, similar to mother-of-pearl, and cast shadows onto the skin.

![NS_Pearls](img/Doc_impl_NS_Pearls.png)

![NS_Pearls Scratch Pad module](img/Doc_impl_NS_Pearls_ScratchModule.png)

![NS_Pearls Custom HLSL code](img/Doc_impl_NS_Pearls_CustomHLSL.png)

![Pearls on the surface](img/Doc_impl_Pearls.png)

<hr style="height:1px; border:none; color:currentColor; background-color:currentColor; opacity:0.2;">

### *7. Organic Voronoi and Two Material Zones – 8.5h*

The vein net now reacts to the function's height. Dense small cells sit in the valleys and merge into a few large cells on the hills, so a large cell borders many small ones. This is done with two Voronoi networks (fine + coarse) in one Custom HLSL node. Each fine cell merges based on the height at its centre, and its walls fade out once both neighbours have merged. The coarse network only shows where cells have merged. The material was split into dark red valleys and light blue hills, joined by a long, soft gradient with a red halo along the large veins. The pearls are now pushed by both hearts. I then had the ~140-node material graph rebuilt by Claude as copy-paste text (Unreal's T3D format), grouped into labelled comment boxes with adjustable Constants and colour pickers. This kept the graph readable and made it much faster to try out different visual options.

**Problems**
1. Blending three Voronoi layers, and later a weighted single Voronoi, produced broken veins, straight seams, sliver cells and hectic motion.
2. Fading veins by height created a visible straight boundary between red and light, with dangling vein ends.
3. Shader compile errors ("DerivCoarseX not valid in shader model vs_6_6", "return float2 p = …").
4. Patchy colours and jagged edges in the red–blue gradient.

**Solution**
1. and 2. Separate layers can't connect, distance weights let far-away cells leak into pixels, and fading only hid veins instead of changing the network. Replaced all of this with two plain, unweighted Voronoi networks and a per-cell merge value: walls thin out and fade, so every visible wall stays closed.
3. `ddx`/`ddy` don't exist in the vertex shader that computes World Position Offset, and quotation marks in a code comment cut off the pasted code. Removed both.
4. Per-cell values jumped at invisible walls and red→blue blending passed through purple. Switched to a single light blue, averaged cell states smoothly, limited the halo to large veins, and used a three-stop gradient (red → light warm tone → light blue).

![M_Surface rebuilt by Claude](img/Doc_impl_M_Surface_Rebuild.png)

![M_Surface compile errors](img/Doc_impl_M_Surface_Errors.png)

![Two material zones (result of Step 7)](img/Doc_impl_Step_07.png)

<hr style="height:1px; border:none; color:currentColor; background-color:currentColor; opacity:0.2;">

### *8. Hairs on the Hills – 4h*

To give the hills a soft, furry texture, I added a second Niagara system (NS_Hair), derived from the pearl system. Thin cone meshes grow only on the hills, gathering in tufts with a few single hairs in between. At rest they curve in a slowly shifting direction like combed fur; high frequencies from TouchDesigner make them straighten up and tremble. A Custom HLSL module in the scratch pad calculates each hair's position, length, orientation and bend, while the material M_Hair performs the curvature via World Position Offset: each ring of the cone rotates slightly further along an arc, preserving the hair's length so the tips can droop. A first attempt that only shifted vertices sideways stretched the hairs instead, so I replaced it with this approach. Finally, a subtle emissive gradient, increasing towards the tip and strongest in the core, gives the hairs depth rather than a flat glow.

**Problems**
1. The bend values calculated in Niagara could not be passed directly to the material.
2. The arc bend requires each hair's actual length, which varies per hair and was not available in the material.

**Solution**
1. As the material's Dynamic Parameter cannot be written to in the Map Set node, I stored the values in custom particle attributes (Particles.BendX, Particles.BendY) and forwarded them with the "Dynamic Material Parameters" module.
2. The material determines the length itself by transforming the cone axis (0, 0, 100) from local to world space and taking the vector's length, which already includes the particle and Mesh Renderer scale.


![Hairs on the hills](img/Doc_impl_Hair.png)

![M_Hair](img/Doc_impl_M_Surface_M_Hair.png)

![NS_Hair Scratch Pad](img/Doc_impl_NS_Hair_ScratchPad.png)
 
![NS_Hair Scratch Pad code](img/Doc_impl_NS_Hair_ScratchPad_Code.png)


<hr style="height:1px; border:none; color:currentColor; background-color:currentColor; opacity:0.2;">

### *9. Hiding the Edges – 1.5h*

So far, the surface ended in a visible straight edge, which broke the illusion of an endless organism. To hide it, I enlarged the plane to 4000 × 4000 units and added an edge mask to M_Surface: starting at a set distance from the centre (FadeStart 1300, FadeEnd 1900), the surface gradually flattens and fades to black, as do its colour, specular, subsurface and emission. Beneath it, a black ground plane continues the darkness, so the organism appears to dissolve into the void. The vein area and growth radius in the Material Parameter Collection were extended to match the new size.

**Problems**
1. The larger surface noticeably increased the rendering cost, even in areas that end up completely black.
2. The pearls and hairs ignored the fading edge: pearls floated above the sunken surface, and hairs kept growing in the black area.

**Solution**
1. Hiding the edge with fog would not have reduced the cost, as everything behind it is still calculated. Instead, the Voronoi calculation stops early outside the edge mask, and I kept the plane's resolution moderate (512 subdivisions).
2. I added the same mask with identical values to both Niagara modules, so the pearls sink together with the surface and the hairs shrink to nothing towards the edge.

![Surface fading into darkness at the edge](img/Doc_impl_HidingEdge.png)

<hr style="height:1px; border:none; color:currentColor; background-color:currentColor; opacity:0.2;">

### *10. Lighting, Material Look and Camera – 7h*
In this step I refined the overall atmosphere of the scene. The valleys now appear wet and slimy through very low roughness, high specular and a stronger red subsurface scattering with reduced opacity, while the bright shells received a slightly rougher, waxy finish. The pearls were corrected so that they rest on the surface instead of floating above it. For the lighting, I combined Rect Lights with an exponential height fog to create depth, and used bloom to make the pulsing veins glow beyond their edges. Beyond the planned changes, the hairs now also light up in response to high frequencies. Instead of an animated camera, I built a free-flying camera that keeps the cinematic depth of field, allowing me to move through the organism live.

**Problems**
1. The Sky Light made the edges of the black ground visible, and it cannot be restricted to individual objects.
2. In the fog, the light sources appeared as bright, clearly visible spots.
3. The default play camera offered neither depth of field nor the ability to look around freely with a cinematic lens.
4. The high-frequency value had to reach the hair material per particle, but the dynamic parameters were already in use and unreliable.

**Solution**
1. I made the ground material unlit, so it ignores all light, and turned off the Sky Light entirely. To keep the studio reflections on the pearls, I sample the HDRI directly in their material using the reflection vector and a Fresnel mask.
2. Each light's Volumetric Scattering Intensity was set to zero, which removes its presence in the fog without changing how it illuminates the surface.
3. I created a custom pawn based on the DefaultPawn with an attached CineCamera and set it as the default pawn via a game mode. Enabling "Use Pawn Control Rotation" lets the camera follow the mouse in all directions.
4. The value is written into the particle colour in Niagara, which the material reliably reads through the Particle Color node and uses to scale the existing emissive gradient.

![Final material look and lighting](img/Doc_impl_MaterialResult-05.png)


<hr style="height:1px; border:none; color:currentColor; background-color:currentColor; opacity:0.2;">

### *11. Rising Spores and Final Touches – 4h*

As a last addition, the large tufts of hair now release subtle glowing spores once high frequencies have been playing for a while. The spores are a second emitter inside NS_Hair, rendered as small additive sprites that fade in quickly and slowly dissolve over their lifetime. A scratch module places each spore inside a tuft, using the same grouping logic as the hair roots, and only keeps spores from the largest, densest tufts on top of the hills.

As final touches, I reshaped the tufts themselves from square patches into round, slightly irregular clusters, which looks more organic. I also placed free mushroom models from the Fab library in the fog around the surface. They only appear as faint silhouettes and create depth beyond the edge of the organism. Finally, I attached the free-flying camera to a spring arm with rotation lag, which smooths out the mouse movement and makes camera pans feel more cinematic.

**Problems**
1. After copying the hair module into the spore emitter, both emitters shared the same script. Every change affected the hairs, and the spores ran the hair code, rising in two narrow beams.
2. The spores only appeared at the very beginning and then stopped.
3. Spores were supposed to come only from large tufts, but appeared everywhere on the hills.

**Solution**
1. In Niagara, copying a module only creates a second reference to the same script. I created a new, separate scratch module and copied only its nodes, which are independent. The spore position is now generated from each particle's unique ID.
2. The spore emitter inherited the system's life cycle, which runs only once because the hairs spawn in a single burst. Setting the spore emitter's life cycle to "Self" and "Infinite" keeps it running.
3. The module calculates the size of each tuft at its centre, using the same formula as the hair length, and only lets spores survive above a minimum size.


![Spore emitter errors](img/Doc_impl_Particle-Errors.png)

![Spores and background mushrooms](img/Doc_impl_ParticleFinal_Mushrooms.png)

![M_Spore](img/Doc_impl_M_Spore.png)

![SporeSpawn Scratch Pad code](img/Doc_impl_NS_HairSporeSpawn_ScratchPad_Code.png)


<hr style="height:1px; border:none; color:currentColor; background-color:currentColor; opacity:0.2;">

### *Documentation and Preparing Submission – 5h*
### Total time: 66h

<hr style="height:1px; border:none; color:currentColor; background-color:currentColor; opacity:0.2;">



<details markdown="1">
<summary style="font-size: 1.5em; font-weight: bold; cursor: pointer;">Resources</summary>

#### Step 1:
- [YouTube – Tutorial by Nils Gallist on TouchOSC x Unreal Engine 5](https://www.youtube.com/watch?v=YjEBCUAO7ec)
- [YouTube – Tutorial by The interactive & Immersive HG on Controlling Lights in Unreal Engine via OSC from TouchDesigner](https://www.youtube.com/watch?v=PQAeUkcykVo&list=PLpuCjVEMQha_EVqrQeiuCi5HGBbtsrkJk)
- [Gemini – Bug fixing](https://gemini.google.com/app)
- [Claude – Bug fixing and guiding](https://claude.ai/new)

#### Step 2:
- [Claude – Bug fixing and guiding](https://claude.ai/new)
- [Unreal Engine Docs – Using Material Parameter Collections](https://dev.epicgames.com/documentation/unreal-engine/using-material-parameter-collections-in-unreal-engine)
- [Unreal Engine Docs – Getting Started with Remote Control Presets](https://dev.epicgames.com/documentation/en-us/unreal-engine/getting-started-with-remote-control-presets-in-unreal-engine)

#### Step 3:
- [Claude – Bug fixing and guiding](https://claude.ai/new)
- [Unreal Engine Docs – Material Functions](https://dev.epicgames.com/documentation/en-us/unreal-engine/material-functions-in-unreal-engine)
- [Unreal Engine Docs – Custom Material Expressions (HLSL)](https://dev.epicgames.com/documentation/en-us/unreal-engine/custom-material-expressions-in-unreal-engine)
- [Unreal Engine Docs – Material Parameter Expressions (Collection Parameter)](https://dev.epicgames.com/documentation/en-us/unreal-engine/material-parameter-expressions-in-unreal-engine)
- [Unreal Engine Docs – Remote Control Protocols (OSC)](https://dev.epicgames.com/documentation/unreal-engine/remote-control-protocols-in-unreal-engine?lang=en-US)
- [TouchDesigner Docs – OSC Out CHOP](https://derivative.ca/UserGuide/OSC_Out_CHOP)

#### Step 4:
- [Claude – Bug fixing and guiding](https://claude.ai/new)
- [Unreal Engine Docs – Lumen Technical Details](https://dev.epicgames.com/documentation/en-us/unreal-engine/lumen-technical-details-in-unreal-engine)

#### Step 5:
- [Claude – Bug fixing and guiding](https://claude.ai/new)
- [The Book of Shaders – Cellular Noise (Voronoi)](https://thebookofshaders.com/12/)
- [Unreal Engine Docs – Custom Material Expressions (HLSL)](https://dev.epicgames.com/documentation/en-us/unreal-engine/custom-material-expressions-in-unreal-engine)
- [Morten S. Mikkelsen – Bump Mapping Unparametrized Surfaces on the GPU](https://hgpu.org/?p=3263)

#### Step 6:
- [Claude – Bug fixing and guiding](https://claude.ai/new)
- [Unreal Engine Docs – Niagara Scratch Pad Modules](https://dev.epicgames.com/documentation/en-us/unreal-engine/niagara-scratch-pad-modules-in-unreal-engine)
- [Unreal Engine Docs – Render Module Reference for Niagara (Mesh Renderer)](https://dev.epicgames.com/documentation/en-us/unreal-engine/render-module-reference-for-niagara-effects-in-unreal-engine)
- [Unreal Engine API – Niagara Parameter Collection](https://dev.epicgames.com/documentation/unreal-engine/API/Plugins/Niagara/UNiagaraParameterCollection)

#### Step 7:
- [Claude – Bug fixing and guiding](https://claude.ai/new)
- [Unreal Engine Docs – Custom Material Expressions (HLSL)](https://dev.epicgames.com/documentation/en-us/unreal-engine/custom-material-expressions-in-unreal-engine)
- [Unreal Engine Docs – Material Attributes Expressions](https://dev.epicgames.com/documentation/en-us/unreal-engine/material-attributes-expressions-in-unreal-engine)
- [Inigo Quilez – Voronoi Edges](https://iquilezles.org/articles/voronoilines/)

#### Step 8:
- [Claude – Bug fixing and guiding](https://claude.ai/new)
- [Unreal Engine Docs – Niagara Scratch Pad Modules](https://dev.epicgames.com/documentation/en-us/unreal-engine/niagara-scratch-pad-modules-in-unreal-engine)
- [Unreal Engine Docs – Custom Material Expressions (HLSL)](https://dev.epicgames.com/documentation/en-us/unreal-engine/custom-material-expressions-in-unreal-engine)


#### Step 9:
- [Claude – Bug fixing and guiding](https://claude.ai/new)
- [Unreal Engine Docs – Using Material Parameter Collections](https://dev.epicgames.com/documentation/unreal-engine/using-material-parameter-collections-in-unreal-engine)


#### Step 10:
- [Claude – Bug fixing and guiding](https://claude.ai/new)
- [Poly Haven – Free HDRIs (studio HDRI used for the pearl reflections)](https://polyhaven.com/)
- [YouTube – UE5 Tutorial: Create a Flying Pawn using a Character Pawn (not raw pawn)](https://www.youtube.com/watch?v=FRwcxhF35Ig)

#### Step 11:
- [Claude – Bug fixing and guiding](https://claude.ai/new)
- [Unreal Engine Docs – Render Module Reference for Niagara (Sprite Renderer)](https://dev.epicgames.com/documentation/unreal-engine/render-module-reference-for-niagara-effects-in-unreal-engine)
- [Fab – "Mushroom on Tree_Baked Lighting Map" by Armored Interactive (free asset)](https://fab.com/s/ef35333cf42d)

</details>

<hr style="height:1px; border:none; color:currentColor; background-color:currentColor; opacity:0.2;">


### Results


![Spore emitter errors](img/Doc_Resu_FinalResault-01.png)
![M_Spore](img/Doc_Resu_FinalResault-03.png)


![Spores and background mushrooms](img/Doc_Resu_FinalResault-02.png)
![Spores and background mushrooms](img/Doc_Resu_FinalResault-04.png)
![Spores and background mushrooms](img/Doc_Resu_FinalResault-05.png)
![Spores and background mushrooms](img/Doc_Resu_FinalResault-06.png)

![Spores and background mushrooms](img/Doc_Resu_FinalGif.gif)


### Project Reflection & Discussion
### Lessons Learned


## Wrap-Up - 3 Points

### Task 05.02 - Feedback

Please answer the following questions briefly so that I can further improve the lecture for future students.

* How would you rate the difficulty of this lecture from 1 (far too easy) to 5 (far too difficult)?
* How would you rate the amount of work you had to put into this lecture so far from 1 (no work at all) to 5 (far too much work)?
* How well did the given time estimates for each session match the time you needed to complete the session?
* What do you think about Unreal as tool to learn for a CTecht & VFX student? Is it valuable?
* What do you think about Unreal as a tool for this class? 
* Do you have any other ideas reading which tools and software packages to use for this class?
* Do you have any useful hints to pass on to future students, e.g. utility tools, or further resources?
* What is your opinion regarding practical exercises in class? Did they fit? Did you enjoy working o
* How did the practical exercises fit the theoretical topics of the class? 
* Did you enjoy working on the practical exercises? If not, why not? 
* Do you think the practical exercises where beneficial for your learning?
* Which one was your favorite chapter, and which one was your least favorite?
* Was there a topic missing and if so which one?
* Are there any other artists that would fit to the class content and that would be worthwhile to discuss in class?
* Please feel free to add any feedback you want to give!



*Submission*: Answer in your submission file.  



## Learnings - 10 Points

### Task 05.03.01

Summarize your learnings within the course in whole sentences. What was challenging for you during this course? How did you challenge yourself?

Technisch

- I learned to think of a scene as a set of functions: the entire organism is based on one mathematical field, which I evaluate in the materials and in every particle system, so all elements move as one body.
- I gained a basic understanding of shader programming with HLSL, including the difference between vertex and pixel shaders, which became clear when ddx/ddy failed in World Position Offset.
- I learned how Niagara works internally: namespaces, scratch pad modules, emitter life cycles, and the fact that copied modules share one script.
- I learned how to build a real-time pipeline between two programs (TouchDesigner → OSC → Remote Control → Blueprint → Parameter Collections) and how to debug it step by step.
- I learned that randomness in procedural systems should be deterministic, for example a hash of the particle ID, so that results stay stable and reproducible.
- I started to consider performance, for example by stopping calculations early outside the visible area instead of hiding them with fog.

Methodisch

- Debugging became my most important skill: isolating one problem at a time, testing assumptions and making values visible, for example via colour.
- I learned to work with AI as a tool. Claude wrote large parts of the HLSL code, but I had to describe problems precisely, understand the code well enough to adjust values and recognise when a solution did not fit my concept.
- My concept developed iteratively. Many ideas, such as the merging Voronoi cells or the spores, only came up while working with the system.

Herausforderung

The biggest challenge was starting as a beginner in both Unreal Engine and TouchDesigner and combining them in a technically demanding project. I challenged myself by writing custom code instead of relying on ready-made modules, and by pursuing a specific visual idea even when it required solutions I did not know yet. 

### Task 05.03.02

To make the best possible use of the lecture, please reflect on the following questions.

Does it make sense for you

* ...to have procedural generation in your set of skills? If yes, 
    * with which tool do you want to work with?
    * which outputs / designs / setups are you aiming for?
* ...to have Unreal in your set of skills? If yes, 
    * which Unreal topic so you want to look into next?
    * which outputs / designs / setups are you aiming for?

Describe your next steps within the lecture topics depending on your answers.

*Submission*: Answer in your file.  

---

**Happy Finalizing!**