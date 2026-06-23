---
layout: default
title: Session
nav_exclude: true
---

**Procedural Generation and Simulation**  


Prof. Dr. Lena Gieseke \| l.gieseke@filmuniversitaet.de  

---

# Session 03 - 20 Points

This session is due on **Wednesday, June 24th** before class.

This assignment should take <= 6h. As this assignment is open-ended, it is up to you to manage your time.

* [Tilings](#tilings)
    * [Task 03.01 - Script (Optional)](#task-0301---script-optional)
* [Algorithmic Designs and Procedural Setups](#algorithmic-designs-and-procedural-setups)
    * [Task 03.02.01 Option A - A Tutorial Fancy Cubes - 12 Points](#task-030201-option-a---a-tutorial-fancy-cubes---12-points)
    * [Task 03.02.02 Option A - Your Fancy Cubes - 5 Points](#task-030202-option-a---your-fancy-cubes---5-points)
    * [Task 03.02. Option B - Algorithmic Scene Setup \& Rendering - 17 Points](#task-0302-option-b---algorithmic-scene-setup--rendering---17-points)
    * [Task 03.01. Option C - Function Design - 17 Points](#task-0301-option-c---function-design---17-points)
* [Learnings](#learnings)
    * [Task 03.03 - 3 Points](#task-0303---3-points)
* [How To Submit](#how-to-submit)
    * [CTech](#ctech)
    * [VFX](#vfx)



## Tilings

### Task 03.01 - Script (Optional)

If you are interested, read [Chapter 05 - Tilings & the Universe](../../02_scripts/pgs_05_tilings_script.md). 


## Algorithmic Designs and Procedural Setups


<span style="color: #ff00cc; font-weight: bold;">Please choose between option A, B or C. You only need to do one of the three tasks!</span>


### Task 03.02.01 Option A - A Tutorial Fancy Cubes - 12 Points

![finalresultcubes](./tutorial_dancing_cubes/img/finalresultcubes.gif)

Complete [Tutorial *Fancy Cubes*](./tutorial_dancing_cubes/pgs_tutorial_dancing_cubes.md). If you want to do a different tutorial or scene setup you can do so, but the submission must be mainly created with Blueprints.

This time, you also have to create a rendering from the scene. For that you can use the [Tutorial Rendering](./tutorial_rendering/tutorial_rendering_rendering.md) (the section about Postprocessing Effects is optional for additional stylization, see Task 03.02).

*Submission:*

![Tutorial Fancy Cubes](img/0203_fancyCubes_tutorial-3.png)

![Tutorial Fancy Cubes](img/0203_fancyCubes_tutorial-2.png)

link to video:

### Task 03.02.02 Option A - Your Fancy Cubes - 5 Points

Try to make some changes to the result to make it your own. In the end, you must have a good looking result!

*Submission:* At least one preview image and one animation, e.g. as gif, of your scene, linked in your markdown submission file.

<span style="color: #ff00cc; font-weight: bold;">OR</span>

*Submission:*

![Tutorial Fancy Cubes](img/0203_fancyCubes_scene-1.png)

![Tutorial Fancy Cubes](img/0203_fancyCubes_scene-2.png)

link to video:


## Learnings

### Task 03.03 - 3 Points

Summarize your learnings in whole sentences. What was challenging for you in this session? How did you challenge yourself?

*Submission*: 

While rebuilding the tutorial scene, I finally had a proper workflow with Blueprints for the first time. I learned how to build the node tree with different event actions (eventBeginPlay, Event Tick and Custom events), how to create and execute custom functions, and implemented external components, like assigned material and particle systems. On of the most interesting parts of this was creating the for-loop. Even if I had worked with node based feedbackloops in touchdesigner before this gave me a new hands on experience how loops are created in node enviroments. Especially in the seconds part of the task I experimented with different parameters in that loop to change size, rotation and location of specific instances individually.
Besides this I stepped deeper into Unreals Lightening possibilities and Render Settings and erxperimented a lot with the interaction of enviroment lightening and material attributes.



