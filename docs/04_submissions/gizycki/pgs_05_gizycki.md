nav_exclude: true

# Final Project & Course Wrap-Up - Assignment 05

---

## Task 05.01 - Final Project

### Summary
For the final project, I created a 5-second, 24 fps vertical (1080x1920) cinematic render in Unreal Engine 5. The project heavily focuses on **procedural generation and real-time simulation**, featuring a character ("Eora") undergoing a procedural disintegration and particle transition into a clean environment. The core goal was to take the procedural Niagara simulation setups covered in the lecture, develop them further, and achieve 100% visual parity between the real-time viewport and the Movie Render Queue (MRQ) output.

### Concept
The concept follows a stylized digital narrative: Eora represents an "error girly" breaking out of a constrained desktop world into a new system. 
* **Visuals & Simulation:** A procedural disintegration effect ("Infinity Space Burst" & character dissolve) paired with dynamic glass-shattering simulations and vibrant color fields.
* **Format:** Vertical format tailored for modern short-form video/cinematic reels.
* **Goal:** Expand upon course concepts of procedural generation to build a polished, high-end VFX sequence while overcoming complex real-time simulation and rendering limitations.

### Implementation
1. **Procedural Niagara Simulations:**
   * Built upon the particle simulation techniques taught by the professor during the course.
   * Extended the base course systems using **Curl Noise**, **Drag**, and **Deterministic Physics** to control procedural particle trajectories and pacing.
   * Fine-tuned **Spawn Rates**, **Velocity Scales**, and lifetime distributions to achieve a punchy, responsive procedural burst.
2. **Sequencer & Timeline Setup:**
   * Structured a strict 120-frame (5-second) timeline at 24 fps.
   * Synchronized character movement and procedural simulation triggers precisely around frame 63.
3. **Materials & Procedural Shading:**
   * Designed custom glass and dissolve shader logic to react dynamically to the simulation.
   * Configured blending modes (including Additive passes) and refraction parameters to maintain material highlights under Deferred Rendering.
4. **Cinematic Rendering (Movie Render Queue):**
   * Exported as a 2160x3840 PNG sequence (cropped/scaled to 1080x1920 vertical).
   * Resolved viewport-vs-render discrepancies in Niagara simulations by enforcing fixed deterministic ticks, correcting warm-up counts, and removing default Game Overrides.

### Results
A fully polished, 120-frame cinematic sequence exported as a high-quality PNG sequence and finalized in DaVinci Resolve. The final output showcases advanced procedural particle behaviors with 100% editor viewport accuracy, crisp refraction, and precise simulation timing.

*(Wanna Include links/paths to your rendered PNG sequence, MP4 video, and project source files somewhere here!)*

### Project Reflection & Discussion
The project successfully demonstrated how procedural simulation techniques can be integrated into a complete real-time VFX pipeline. The primary technical challenge was managing how Movie Render Queue handles procedural ticks and sub-stepping compared to the real-time editor. Offline rendering initially altered the procedural force calculations and particle velocity. Enforcing deterministic simulation ticks and removing default MRQ overrides solved these discrepancies, preserving the exact simulation behavior designed in the editor.

### Lessons Learned
* **Deterministic Real-Time Simulations:** Enabling deterministic timing in Niagara is essential when aligning complex procedural simulations with keyframed Sequencer timelines.
* **Viewport $\neq$ Render Parity by Default:** MRQ settings (like `Game Overrides` or sub-sampling) can drastically alter procedural simulation steps and material refractions if not carefully configured.
* **Building on Course Foundations:** Extending pre-built lecture setups into custom procedural assets requires a deep understanding of force fields, noise functions, and render pipeline behaviors.

---

## Task 05.02 - Wrap-Up (Feedback)

1. **Difficulty Rating:** `3/5` – Well-balanced; challenging when debugging procedural particle behavior and render pipeline settings, but very rewarding.
2. **Workload Rating:** `3/5` – Realistic time allocation, though fine-tuning simulations and MRQ exports took additional iteration time.
3. **Time Estimates:** Matched well overall. Experimenting with procedural parameters and troubleshooting MRQ took the most time.
4. **Unreal for CTech & VFX:** Highly valuable. Real-time procedural generation, Niagara simulations, and immediate feedback are essential tools for modern VFX workflows.
5. **Unreal in Class:** Excellent choice. It provides a strong framework for understanding real-time graphics, shading, and procedural simulation.
6. **Other Tools/Packages:** Introducing Houdini or Blender alongside UE5 for advanced procedural generation concepts.
7. **Hints for Future Students:**
   * Set your Niagara simulations to *Deterministic* early if you bind them to Sequencer.
   * Be careful with MRQ `Game Overrides` as they can affect your custom procedural materials and lighting.
   * Test-render short sequences frequently to verify simulation timing early.
8. **Practical Exercises:**
   * *Fit to theory:* Fitted exceptionally well, especially regarding procedural generation and simulation concepts.
   * *Enjoyment:* Very enjoyable and engaging to see procedural systems come to life.
   * *Learning benefit:* Crucial. Implementing procedural concepts directly in class builds a much deeper understanding than theory alone.
9. **Favorite & Least Favorite Chapter:**
   * *Favorite:* Procedural Generation & Niagara Particle Simulations.
   * *Least Favorite:* Initial lighting and post-processing setup details.
10. **Missing Topics:** Advanced procedural workflows (like PCG / Procedural Content Generation in UE5) or multi-pass EXR rendering.
11. **Other Artists:** @pwnisher – great reference for community challenge workflows and cinematic simulation breakdowns. I combined my PGS Final Project with his 'Gauntlet of Gods' 1-month community challenge, as it provided a concrete, deadline-driven framework to apply and test Niagara particle systems in a real production context.
12. **For VFX Students:**
    * *Suitability:* Very suitable for modern real-time VFX and simulation focus.
    * *Improvements:* Expand slightly on procedural simulation theory and high-end render pass setups (AOVs/Stencils).

---

## Task 05.03 - Learnings & Reflection

### Task 05.03.01 - Course Learnings
Throughout this course, my primary focus was mastering **procedural generation and real-time simulation** within Unreal Engine 5. My main challenge was understanding how procedural particle systems (Niagara) calculate force fields and ticks across different frame rates, especially when transitioning from the real-time editor to offline rendering (Movie Render Queue). I challenged myself by taking the core particle simulation setups provided in the lectures, customizing and pushing their procedural logic further, and ensuring the final simulation rendered with complete visual accuracy.

### Task 05.03.02 - Skillset Reflection & Next Steps

* **Procedural Generation:**
  * *Sense:* Absolutely. Procedural generation is a cornerstone skill for modern tech artists and VFX creators. I want to work with **Unreal PCG** and **Houdini** in the future.
  * *Desired Output:* Dynamic, environment-aware procedural particle simulations and automated asset scattering.
* **Unreal Engine Skillset:**
  * *Sense:* Yes, central to my VFX toolkit.
  * *Next Topic:* Advanced Niagara HLSL module creation, custom simulation forces, and procedural material shaders.
  * AI tools (Claude, Gemini) were used for debugging support and workflow guidance throughout the project.
* **Next Steps:** Deepen my knowledge in procedural content generation, explore real-time fluid/cloth simulations, and continue participating in 3D community rendering challenges.
