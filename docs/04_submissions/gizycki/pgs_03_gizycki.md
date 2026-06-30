---
layout: default
title: Session
nav_exclude: true
---

# Task 03.02.01 Option A - A Tutorial Fancy Cubes - 12 Points
## Task 03.02.02 Option A - Your Fancy Cubes - 5 Points

I made the following changes to make the result my own: changed the particle color, particle velocity and gravity, and the emission glow color. Also I added a bloom via a post process volume.
![preview picture](img/task03_img.jpeg)
![Animation](img/task03.gif)

---
# Task 03.03 - Learnings - 3 Points

- Learned how to build recursive spawning in Blueprints, with events, generation counters, and physics.
- Learned how to set up materials with Hue Shift and Emission, and control them from Blueprints.
- Learned how to render with Sequencer and Movie Render Queue, and turn the frames into a GIF with ffmpeg.

### Challenging:

- The biggest problem was a repeated Unreal crash (a Metal/Mac rendering bug) every time I tried to create a color node in the Material Editor
- This was not my mistake, it was a known engine bug on Apple Silicon
- I spent a lot of time trying to fix it

### How I challenged myself:

- I researched the crash log and found out it was a Mac-specific rendering bug
- I tried several fixes before finding that moving the Blueprint to a new, simpler project solved the problem
- I finished the tutorial on my own and changed the colors, gravity, particle speed, and hue shift to make it my own