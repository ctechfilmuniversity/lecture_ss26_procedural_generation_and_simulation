---
layout: default
title: Session
nav_exclude: true
---

**Procedural Generation and Simulation**  


Prof. Dr. Lena Gieseke \| l.gieseke@filmuniversitaet.de  

---

# Session 02  - 20 Points

This session is due on **Wednesday, June 17th** before class.

This assignment should take <= 6h. As this assignment is open-ended, it is up to you to manage your time.

* [Function Designs](#function-designs)
    * [Task 02.01 - Inspiration - 4 Points](#task-0201---inspiration---4-points)
    * [Task 02.02 - Function Design - 13 Points](#task-0202---function-design---13-points)
        * [GLSL Fragment Shader](#glsl-fragment-shader)
        * [Unreal Materials](#unreal-materials)
* [Learnings](#learnings)
    * [Task 02.03 - 3 Points](#task-0203---3-points)
* [How To Submit](#how-to-submit)
    * [CTech](#ctech)
    * [VFX](#vfx)

## Function Designs

* [Slides Function Designs](../../03_slides/pgs_03_functions_slides.html)
* [Script Function Designs](../../02_scripts/pgs_04_functions_script.md)  
  
*Please note the we haven't covered all topics in slides and script yet.*



### Task 02.01 - Inspiration - 4 Points

Go to the [shadertoy](https://www.shadertoy.com/browse) site and browse the examples a bit. Submit the link to at least one example you like (you don't have to understand the code). Think about *what* you like about the example and *why*. You don't have to write anything about that in your submission but be able to explain it in class.

*On a side note*: shadertoy code does not directly run within the glsl-canvas environment (see Task 2.2).

*Submission:* 

Sunflower Fields 
- https://www.shadertoy.com/view/NXlXD4

Snail
- https://www.shadertoy.com/view/ld3Gz2

tm gyroid 2 
- https://www.shadertoy.com/view/tXtyW8

Trailing the Twinkling Tunnel .. 
- https://www.shadertoy.com/view/WfcGWj

Octagrams (reminds me a bit of my pattern)
- https://www.shadertoy.com/view/tlVGDt

Escher-cat tiling 
- https://www.shadertoy.com/view/NXlSz7

### Task 02.02 - Function Design - 13 Points

Create a 2D pattern of your liking, e.g. the one you designed for the last homework by hand (Task 01.03) - but this is entirely up to you. The result should be polished. You can do this task either as fragement shader in VS Code or in Unreal as material.

Show different versions of the pattern by changing some parameters (sizing, colors, etc.), while maintaining the gist of the pattern.
  
With this task, I want you to practice **understanding and building individual function designs**. You are free to choose any design and environment you want, as long as it includes the building of a somewhat complex function, which has a visual outcome. Choose one environment you are interested in and which fits your overall learning path best (also feel free to learn both environment 😊). You can use the given start scenes and examples as basis. 

#### GLSL Fragment Shader

* If you are a beginner, see this [short introduction to GLSL with the glsl-canvas extension](./glsl/pgs_tutorial_glslintro.md).
* Examples: [start scene](./glsl/examples/functiondesign_startscene.glsl), [sin](./glsl/examples/sin.frag), [circle pattern](./glsl/examples/pattern_circles.glsl) (also see the [explanations in the script](../../02_scripts/pgs_04_functions_script.md#example-circle-pattern)), [kishimisu](./glsl/examples/kishimisu_commented_01.glsl)

#### Unreal Materials
* If you are a beginner, see this [short introduction to Unreal's material editor](./unreal/pgs_tutorial_materialsintro/pgs_tutorial_materialsintro.md).
* There are two example materials in the [Unreal Project `pgs_functiondesigns`](https://github.com/ctechfilmuniversity/lecture_ss26_procedural_generation_and_simulation/blob/main/docs/01_sessions/02_functions/unreal/pgs_functiondesigns.zip) (inside of the project in the `Content Browser` under `All/Content/pgs_functionsdesigns` -> level `LV_functiondesigns`)
    1. Function design with nodes in `M_pattern_circles_nodes`
    2. Function design with code (HLSL) in `M_pattern_circles_hlsl` .

 

*Submission:* 

asjföife



## Learnings

### Task 02.03 - 3 Points

Summarize your learnings in whole sentences. What was challenging for you in this session? How did you challenge yourself?

*Submission*: 
- I challenged myself with not directly starting to jump into the exersice but rather go through resources and ask AI for step by step introductions of different topics, trying to understand the different parts of the system und to remember terminology. I also found an image with general funcitons that I tried to implement and visualize the function as a curve but also as a fuction value as a gradient, to improve my understanding of the connection  


---
## How To Submit

### CTech

Answer all questions directly in a copy of this file and **also link and display all of your images in that file**. Submit your copy as `pgs_XX_lastname.md` in your submissions folder (replace the XX with the number of the session). 

Please add `nav_exclude: true` to the header of your submission file that it is not added to the navigation bar of the overall website.

### VFX

To hand in your homework assignment, you submit images and texts in your OwnCloud document:

* [The OwnCloud Folder](https://owncloud.gwdg.de/index.php/s/CSVXtrxMNDyER3T)
* Open your file, add your text, links, etc. If have multiple files, create a folder for your submission.
  



---

**Happy Functioning!**
