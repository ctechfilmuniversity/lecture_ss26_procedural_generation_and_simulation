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
### Concept

---

## Implementation

### *1. TouchDesigner → Unreal Engine: Audio-reactive light control via OSC – 8h*


I connected TouchDesigner to Unreal Engine via OSC so that audio analysis values (bass, highs, kick) control the intensity of three lights in real time through Remote Control.


**Problems**

* Unreal Engine 5 received no OSC signals from TouchDesigner; REC learn test returned `None`.

**Causes**

1. Signal blocked by `127.0.0.1` (Localhost) & incorrect OSC Data Format (`Time Slice` instead of `Sample`).
2. All three TouchDesigner channels were internally named `low`, sending identical `/low` addresses.

**Solution**

* Switched IP to IPv4 (`192.168.178.131`), port to `9000`, and Data Format to `Sample`.
* Renamed channels in TouchDesigner to `low`, `high`, and `kick` to generate distinct OSC paths (`/low`, `/high`, `/kick`).

![OSC Connection](img/Doc_impl_OSC-Connection.png)

<hr style="height:1px; border:none; color:currentColor; background-color:currentColor; opacity:0.2;">

### *2. Concept refinement & Unreal Engine bridge for material parameters – 4h*

I refined my concept after seeing some mood images of abstract organic macro surfaces on pinterest, inspired by microscopic tissue. Its shape is defined by a mathematical function, Voronoi veins run through it, and every kick acts as a heartbeat that sends a pulse of light through the veins.

On the technical side, I built the bridge between my existing OSC setup and the materials. I created a Material Parameter Collection (`MPC_Organism`) as a central place for all values and a Blueprint (`BP_Organism`) whose variables receive the OSC values via Remote Control. Every frame, the Blueprint writes them into the collection. It also detects each new kick (rising edge) and stores its timestamp as `PulseStart`, which the materials will later use to animate the heartbeat pulse.


<div align="center">
<table>
  <tr>
    <td align="center"><img src="img/Doc_impl_Inspo-01.jpg" width="300" height="450" style="object-fit:cover;"></td>
    <td align="center"><img src="img/Doc_impl_Inspo-02.jpg" width="300" height="450" style="object-fit:cover;"></td>
    <td align="center"><img src="img/Doc_impl_Inspo-03.jpg" width="300" height="450" style="object-fit:cover;"></td>
  </tr>
</table>
</div>

![BP_Organism](img/Doc_impl_BP-Organism.png)

![MPC Organism](img//Doc_impl_MPC_Organism.png)

<hr style="height:1px; border:none; color:currentColor; background-color:currentColor; opacity:0.2;">

### *3. Material Functions & live control of the function parameters – 4h*

I built the mathematical core of the scene as reusable Material Functions in Unreal Engine. `MF_Field` calculates the height of the organic surface from three blended functions (crossed sine waves, a five-petal polar "flower" and ring waves), including domain warping and a soft fade towards the edges. `MF_FieldNormal` derives the surface normals from the field, so the lighting follows the deformation. `MF_Mask` creates a soft circular region mask that later limits where the veins appear.

I also added a shared clock (`Now`), which the Blueprint writes into the Material Parameter Collection every frame, so that materials and particles stay in sync with the heartbeat. Finally, I set up live control: a Constant CHOP in TouchDesigner sends the function parameters (`freq`, `amp`, `warp`, `funcblend`) via OSC, Remote Control maps them from 0–1 to their actual ranges, and `BP_Organism` passes them on to `MPC_Organism`.

![MF Field](img/Doc_impl_MF_Field.png)

![MF Field Normal](img/Doc_impl_MF_FieldNormal.png)

![MF Mask](img/Doc_impl_MF_Mask.png)

<hr style="height:1px; border:none; color:currentColor; background-color:currentColor; opacity:0.2;">

### *4. Organic surface with live deformation – 2h*

I created a subdivided plane (2000 × 2000 units, 256 × 256 subdivisions) in Unreal's Modeling Mode and built the material `M_Surface` for it. The material uses the Subsurface shading model for a soft, skin-like look. It deforms the plane with World Position Offset based on `MF_Field` and gets its lighting from the normals of `MF_FieldNormal`. The surface now moves in real time and can be reshaped live with the sliders in TouchDesigner (frequency, amplitude, warp and blending between the three functions).


**Problems**

* The valleys of the surface appeared black with flickering, hard edges.
* In Play mode the surface was completely flat, although it was deformed in the editor.

**Causes**

1. Everything below the original height of the plane was darkened: first the default level floor cut through the valleys, then Lumen still treated the area below the original flat plane as "inside" the mesh (Lumen's software ray tracing does not support World Position Offset).
2. The range mapping in Remote Control (0–1 → 0–100) did not convert the values, so `Amp` arrived as 0.4 instead of 40.

**Solution**

* Deleted the default `Floor` and lifted the whole surface by `Amp` (`MF_Field` + `Amp`), so the valleys never sink below the original height.
* Removed the Remote Control ranges and scaled the values in `BP_Organism` with Multiply nodes instead (`Freq` × 5, `Amp` × 100, `Warp` × 2, `FuncBlend` × 2).

![M_Surface](img/Doc_impl_M_Surface.png)

![Surface Lumen Error](img/Doc_impl_LumenError.png)

![Surface Lumen Error](img/Doc_impl_Step4_finished.png)

---

### Resources:

#### Step 1:
- [YouTube Tutorial by Nils Gallist – TouchISC x Unreal Engine 5 ](https://www.youtube.com/watch?v=YjEBCUAO7ec)
- [YouTube Tutorial by The interactive & Immersive HG – Controlling Lights in Unreal Engine via OSC from TouchDesigner](https://www.youtube.com/watch?v=PQAeUkcykVo&list=PLpuCjVEMQha_EVqrQeiuCi5HGBbtsrkJk)
- [Bug fixing Gemini](https://gemini.google.com/app)
- [Bug fixing and guiding with Claude](https://claude.ai/new)


#### Step 2:
- [Bug fixing and guiding with Claude](https://claude.ai/new)
- [Unreal Engine Docs – Using Material Parameter Collections](https://dev.epicgames.com/documentation/unreal-engine/using-material-parameter-collections-in-unreal-engine)
- [Unreal Engine Docs – Blueprint Variables](https://dev.epicgames.com/documentation/en-us/unreal-engine/blueprint-variables-in-unreal-engine)
- [Unreal Engine Docs – Flow Control (Branch, Sequence)](https://dev.epicgames.com/documentation/en-us/unreal-engine/flow-control-in-unreal-engine)
- [Unreal Engine Docs – Getting Started with Remote Control Presets](https://dev.epicgames.com/documentation/en-us/unreal-engine/getting-started-with-remote-control-presets-in-unreal-engine)



#### Step 3:
- [Bug fixing and guiding with Claude](https://claude.ai/new)
- [Unreal Engine Docs – Material Functions](https://dev.epicgames.com/documentation/en-us/unreal-engine/material-functions-in-unreal-engine)
- [Unreal Engine Docs – Custom Material Expressions (HLSL)](https://dev.epicgames.com/documentation/en-us/unreal-engine/custom-material-expressions-in-unreal-engine)
- [Unreal Engine Docs – Using Material Parameter Collections](https://dev.epicgames.com/documentation/unreal-engine/using-material-parameter-collections-in-unreal-engine)
- [Unreal Engine Docs – Material Parameter Expressions (Collection Parameter)](https://dev.epicgames.com/documentation/en-us/unreal-engine/material-parameter-expressions-in-unreal-engine)
- [Unreal Engine Docs – Remote Control Protocols (OSC)](https://dev.epicgames.com/documentation/unreal-engine/remote-control-protocols-in-unreal-engine?lang=en-US)
- [TouchDesigner Docs – Constant CHOP](https://derivative.ca/UserGuide/Constant_CHOP)
- [TouchDesigner Docs – OSC Out CHOP](https://derivative.ca/UserGuide/OSC_Out_CHOP)
- [The Book of Shaders – Cellular Noise (Voronoi)](https://thebookofshaders.com/12/)
- [Concept development and step-by-step guide with Claude](https://claude.ai/new)

#### Step 4
- [Unreal Engine Docs – Modeling Mode](https://dev.epicgames.com/documentation/en-us/unreal-engine/modeling-mode-in-unreal-engine)
- [Unreal Engine Docs – Material Inputs (World Position Offset, Normal)](https://dev.epicgames.com/documentation/en-us/unreal-engine/material-inputs-in-unreal-engine)
- [Unreal Engine Docs – Subsurface Shading Model](https://dev.epicgames.com/documentation/en-us/unreal-engine/subsurface-shading-model-in-unreal-engine)
- [Unreal Engine Docs – Lumen Technical Details](https://dev.epicgames.com/documentation/en-us/unreal-engine/lumen-technical-details-in-unreal-engine)
- [Bug fixing and guiding with Claude](https://claude.ai/new)

### Results
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

For VFX only:
* How suitable do you rate this class overall for VFX students?
* What can be changed or improved to make the class fit to VFX students' needs?

*Submission*: Answer in your submission file.  



## Learnings - 10 Points

### Task 05.03.01

Summarize your learnings within the course in whole sentences. What was challenging for you during this course? How did you challenge yourself?

*Submission*: Answer in your submission file.  

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
## How To Submit

### CTech

Answer all questions directly in a copy of this file and **also link and display all of your images in that file**. Submit your copy as `pgs_XX_lastname.md` in your submissions folder (replace the XX with the number of the session). 

Please add `nav_exclude: true` to the header of your submission file so that it is not added to the navigation bar of the overall website.

### VFX

To hand in your homework assignment, you submit images and texts in your OwnCloud document:

* [The OwnCloud Folder](https://owncloud.gwdg.de/index.php/s/CSVXtrxMNDyER3T)
* Open your file, add your text, links, etc.
  


---

That's it. It was a pleasure!

![tom](img/tom.gif)  
[[pinterest]](https://id.pinterest.com/pin/290271138471721193/)


---

**Happy Finalizing!**
