# Ray Marching / Sphere Marching
WIP obviously
## Ray marching
### Definition
Ray marching is a rendering method, where a ray is cast from a point of origin in a direction, and is subdivided into smaller segments until an intersection with a surface is detected. 
The segmentation is often done using spheres, hence the other name for ray marching: sphere marching. It can also be achieved using cubes, but that won't be covered here.
The surface that the ray intersects with is defined [signed distance functions](https://en.wikipedia.org/wiki/Signed_distance_function).

---
### How it works
Ray marching is very litteraly named. We are trying to move along a ray to find a surface. The movement along the ray is done in steps. For each step we check the distance from our current position to the closest surface, add that distance to the total distance traveled along the ray, and update our current position for the next step.


In the following stunning GIF, the steps are represented by the orange circles, the current position is the red circles, and the green line is the distance to the closest surface.

![A beautiful GIF should show up](ray_marching_steps.gif)

 We repeat that process until one of three things happen:

    1. We exceed the set maximum number of steps.

    2. The distance we measure is smaller than the minimum distance to a surface. In other words: we are close enough.

    3. The distance traveled along the ray exceeds the set maximum distance.

Once one of those conditions is met, we return the distance traveled along the ray, which corresponds to the distance from the camera to the surface. Then we move on to another ray, and repeat the whole process.

---

### Implementation
1. Casting Rays

The first thing we have to do is to cast rays that we can march along. This is the equivalent of a camera, it is placed in the world and points at something, or in other terms is has a position and a direction.
```glsl
    vec3 ray_origin = vec3(0,1,0);
    vec3 ray_direction = normalize(vec3(st.s, st.t, 1.));
```
The _ray_origin_ vector is quite simple, it's at the center of the world, slightly elevated to look down on the scene.
The _ray_direction_ vector is a normalised, or unit vector. The first two parameters are the canvas coordinates, which means that we cast a ray for each fragment on screen. The last is the distance to the "image", the focal lentgh so to speak __ADD BETTER EXPLANATION__.

And with these two variables we have our camera, or rays.

2. Marching along the rays

The next step is to define the ray marching function. 

First we define three variables.
-  MAX_STEPS, the maximum number of steps to take along the ray. It will greatly determine how precise the ray marching will be. Can give cool morphing effects when set low.
- MAX_DIST the maximum distance we want to travel along our ray.
- SURFACE_DIST, which is the threshold for the minimum distance between the distance traveled so far along the ray and the surface of the primitive. A higher value will give more jagged edged because the rey marching will be less precise.

``` c
#define MAX_STEPS 100
#define MAX_DIST 100.
#define SURFACE_DIST 0.01
```

The we define the ray marching function, that we creativly call "raymarch".

``` glsl
        float raymarch(vec3 ro, vec3 rd){
            float distance_traveled = 0.;
            for(int i = 0; i<MAX_STEPS; i++){
                vec3 current_pos = ro +distance_traveled*rd;
                float distance_closest = sdSphere(current_pos);
                distance_traveled += distance_closest;
                if(distance_closest<SURFACE_DIST || distance_traveled>MAX_DIST){break;}
            }

            return distance_traveled;
        }
```
The raymarch function takes in the ray's origin _ro_ and the ray's direction _rd_


---
## Signed distance functions
definition
## Basic shapes
Using distance functions, basic shapes can easily be drawn. inogo Quilez has a a lot of them listed on his [website](https://iquilezles.org/articles/distfunctions/). However he doesn't give explanations for them, so below are explanations on how to come up with some of these functions.
### Sphere
### Box
### Capsule
### Torus
---
# Credits
- [Ray Marching for Dummies](https://www.youtube.com/watch?v=PGtv-dBi2wE) by [The Art of Code](https://www.youtube.com/c/TheArtofCodeIsCool): explains the basic concepts simply and implements them in ShaderToy.
- [Ray Marching Primitives](https://www.shadertoy.com/view/wdf3zl) by [The Art of Code](https://www.youtube.com/c/TheArtofCodeIsCool): Explains the signed distance functions for some basic shapes, and does an implementation of them in ShaderToy.
- [Distance functions](https://iquilezles.org/articles/distfunctions/) by Inigo Quilez: A very useful reference that lists signed distance functions for basic primitive shapes.
- [Ray marching scene exemple](https://www.shadertoy.com/view/Xds3zN) by Inigo Quilez: A useful and complete exemple on how to use the distance functions, ray marching operators, camera transformations.