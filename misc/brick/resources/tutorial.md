# Brick Shader

A 2D brick procedural shader for a brick wall.
This shader is based on this [tutorial](http://dl.lcg.ufrj.br/cg2/downloads/GPU/brick.html).

# Variable Declarations

    vec3 BRICK_COLOR = vec3(145./255., 37./255., 1./255.);
    vec3 MORTAR_COLOR = vec3(232./255., 216./255., 195./255.);
    vec3 color = vec3(0.);
    vec2 BRICK_TILE_SIZE = vec2(.08, .03);
    vec2 BRICK_PCT = vec2(.9);
First things first, we declare the different variables we'll need in order to build the brick wall. Some of these are pretty straight forward, **BRICK_COLOR** and **MORTAR_COLOR** which are vec3 describing the colors. The **color** variable is a vec3 that our function will return after we modify it.
Then the two variables that need a few explanations. First **BRICK_TILE_SIZE**. It describes the size of of a tile, containing a brick and the mortar on the top and right side around it. 

A picture to illustrate