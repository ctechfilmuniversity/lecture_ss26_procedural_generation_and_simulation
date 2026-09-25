---
layout: default
title: Session
nav_exclude: true
---

# Final Project & Course Wrap-Up - Assignment 05

---

## Task 05.01 - Final Project

### Summary
For the final project I created a 5-second, 24 fps vertical (1080x1920) cinematic render in Unreal Engine 5. The project focuses on procedural generation and real-time simulation. It features a character called Eora who goes through a procedural particle disintegration from a Grass field inspired by the Windows XP Background (by Charles O'Rear) to a clean digital environment. The goal was to take the Niagara simulation concepts from the lecture, push them further, and make sure the real-time viewport and the final Movie Render Queue output looked exactly the same.

### Concept
The concept is a stylized digital story: Eora is an "error girly" (her name is basically inspired by the word Error) breaking out of a desktop world into a new empty white system. It's like breaking out into the "blank paper" not fearing but longing it.

Visuals and Simulation: A procedural disintegration effect paired with dynamic glass-shattering simulations and vibrant reflection fields.

Format: Vertical format made for modern short-form video and cinematic reels.

Goal: Build a polished sequence by expanding on course concepts, while solving complex real-time simulation and rendering challenges.

### Implementation
1. **Procedural Niagara Simulations:**
   Built on top of the particle simulation techniques from the course. Extended the base systems using Curl Noise, Drag, and Deterministic Physics to control particle movement and timing. Fine-tuned Spawn Rates, Velocity Scales, and lifetime settings to get a punchy and responsive procedural burst.
2. **Sequencer & Timeline Setup:**
   Set up a strict 120-frame (5-second) timeline at 24 fps. Synchronized character movement and simulation triggers precisely around frame 63.
3. **Materials & Procedural Shading:**
   Built custom glass and dissolve shader logic that reacts to the simulation. Configured blending modes and refraction settings to keep material highlights clean under Deferred Rendering.
4. **Cinematic Rendering (Movie Render Queue):**
   Exported as a 2160x3840 PNG sequence, then scaled to 1080x1920. Fixed viewport-to-render discrepancies in Niagara by enforcing deterministic ticks, correcting warm-up counts, and removing default Game Overrides.

### Results
A finished 120-frame cinematic sequence exported as a high-quality PNG sequence and finalized in DaVinci Resolve. The output shows advanced procedural particle behavior with accurate simulation timing and clean refraction.

*(Will hier noch "links to rendered PNG sequence, MP4 video, and project source files" hier einfügen!)*

### Project Reflection & Discussion
A major technical challenge during the project was setting up mesh-based particle spawning, specifically getting particles to spawn on precise, predefined areas of the character's body.

To achieve this, I had to:
1. **Define Target Areas:** Create custom vertex colors and body masks on the skeletal mesh to mark the exact emission zones on the character.
2. **Configure Niagara Mesh Sampling:** Set up Niagara to sample the character's Skeletal Mesh directly and restrict particle creation exclusively to those masked regions using dynamic material parameters and density masks.
3. **Control Simulation Timing:** Synchronize the procedural burst so the particles leave the character's body seamlessly at frame 63, matching the animation timing.

One unexpected challenge early in the project was getting MetaHuman to work at all. The MetaHuman Assembly in UE 5.7.4 had two separate bugs that combined to block the whole process.

First, Unreal Engine on macOS with Apple Silicon miscalculates available RAM, which caused the internal Texture Graph to refuse generating and baking certain LOD textures during assembly.

Second, the original project folder path was too long. Unreal could no longer write out the full filename T_Head_LOD5to7_Scatter in the Content Browser, and manually added files in Finder were ignored entirely. The result was a missing texture, a failed assembly, and a Blueprint that stayed invisible in the viewport.

The fix required two steps: moving the project folder to a shorter path directly on the Desktop, and then manually duplicating an existing texture (T_Head_Scatter) in the Content Browser via Cmd+D and renaming it exactly to T_Head_LOD5to7_Scatter. With the shorter path, Unreal could properly index the manually created asset, skip the broken texture baking step, and successfully complete the Blueprint assembly.

This was a big learning moment about working with beta and experimental Unreal features, and about how file system details can silently break engine workflows.

AI tools (Claude and Gemini) were used throughout the project for debugging support and workflow guidance.

### Lessons Learned
Deterministic Real-Time Simulations: Setting Niagara to deterministic mode early is essential when syncing particle simulations with Sequencer timelines.

Viewport vs Render: MRQ settings like Game Overrides and sub-sampling can completely change how procedural simulations and materials look. Always test-render early and often.

Beta Features Have Real Costs: The MetaHuman Assembly bug in UE 5.7.4 cost significant time. Always check Known Issues pages before committing to experimental tools in a deadline-driven project.

Building on Course Foundations: Extending lecture setups into custom procedural assets requires understanding force fields, noise functions, and render pipeline behavior in depth.

---

## Task 05.02 - Feedback
Difficulty: 3/5. The theoretical concepts like Mandelbrot, complex numbers, and noise functions were hard to grasp at first. Understanding the math behind procedural generation took a lot of effort, especially without a strong math background. But I had the impression that it was totally fine that we do not understand everything in its mathematical complexity.

Workload: 3/5. Each session took time, especially the GLSL shader sessions and the final project. But for me it worked well.

Time Estimates: The estimates were often too optimistic. I mostly needed longer for the homework, but it was also motivating to streamline my workflow, make faster decisions, and account for potential bugs during the planning stage to avoid getting trapped in debugging spirals.

Unreal for CTech: It is valuable to know, but the learning curve is steep, especially on Mac with Apple Silicon. There were many engine-specific bugs like the MetaHuman Assembly crash that had nothing to do with the actual learning goals and cost a lot of time. But I had fun and I will definitely use Unreal in the future.

Unreal in Class: It works well for showing real-time simulation and procedural generation.

Other Tools: TouchDesigner would be a great addition, especially for audio-reactive and real-time generative visuals. GLSL in VS Code was actually a very accessible starting point and I enjoyed it a lot.

Hints for Future Students: Use GLSL Canvas early to understand shaders before jumping into Unreal materials. On Mac, check the Known Issues page before using experimental features like MetaHuman Creator. Use AI tools for debugging but make sure you understand each step yourself.

Practical Exercises: They fit the theory well. Seeing procedural concepts actually work in code or in Unreal was more motivating than just reading about them. The GLSL shader exercises were my favorites because the feedback was immediate and visual.

Favorite Chapter: My favorite chapter was Noise and Randomness, because it directly connected math to visual art in a way I had never experienced before. My least favorite was the initial Unreal setup, mostly because of technical issues on Mac.

Missing Topics: TouchDesigner for audio-reactive visuals would have fit perfectly into the course content given the intersection with music and generative art.

Other Artists: Ezequiel Pini for 3D plant growing simulations, Sage Jenson for organic generative art.

Additional Feedback: I would love to see more sessions that connect procedural generation to sound and music.

---

## Learnings

### Task 05.03.01 - Course Learnings
During this course I learned how procedural generation works both mathematically and visually. Starting with the Mandelbrot set and complex numbers helped me understand how simple rules can create infinitely complex results. The GLSL sessions taught me how to write fragment shaders from scratch, build Voronoi patterns, and use noise functions to create organic, animated visuals. The biggest challenge was translating visual ideas into mathematical functions. I often knew what I wanted to see but struggled to find the right formula. I challenged myself by not just following tutorials but experimenting with parameters and combining techniques like metaballs and Voronoi. For the final project I combined everything into a real production pipeline in Unreal, which meant solving problems I had never encountered before, like getting MetaHuman to assemble on a buggy engine version and making Niagara simulations render identically in the viewport and in Movie Render Queue.

### Task 05.03.02 - Skillset Reflection & Next Steps
Procedural Generation: Yes, this makes sense for me. Procedural generation is a core skill for creative technologists. I want to work with Unreal, TouchDesigner, GLSL, and Houdini in the future, in addition to Blender of course. My goal is to create dynamic, audio-reactive visuals, organic particle simulations, and generative patterns that respond to music and input.

Unreal Engine: It is useful to know. I am not sure what my next projects will look like, but I am interested in advanced Niagara systems, custom simulation forces, and procedural material shaders. I will decide based on what projects come up.

Next Steps: Deepen my knowledge in procedural content generation, explore ASCII art overlays and blob tracking in code, maybe look into real-time fluid simulations, and continue taking part in 3D community challenges.
