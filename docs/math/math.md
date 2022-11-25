---
layout: page
title:  "Math"
date:   2022-11-22 15:08:55 +0100
categories: jekyll update
nav_order: 2
child_nav_order: asc
has_children: true
---
# Math
I can't seem to get used to the traditional math syntax, everything seems a lot simpler in code form in my eyes. So I made this page as quick reference to look up formulas and what the code form looks like.
# Vectors
## Vector Magnitude
How to calculate a vector's magnitude, or its length.
$$
\left \| \vec{v} \right \| = \sqrt{v.x^{2}+v.y^{2}}\\$$

In code form:
~~~glsl
    vec3 v;
    float v_length = sqrt(v.x*v.x + v.y*v.y);
~~~

in GLSL:
~~~glsl
    vec3 v;
    float v_length = length(v);
~~~
## Vector normalisation
A normalised, or unit, vector, is a vector with the same direction as the given vector but with a length of 1.
How to get a normlised, or unit, vector from a given vector:
$$
\hat{v} = \frac{\vec{v}}{\left \| \vec{v} \right \|}
$$
Or to put it in a more code friendly way:
~~~ glsl
    vec3 normalised_v = v/v_length;
~~~
 and in GLSL:

 ~~~ glsl
    vec3 normalised_v = normlize(v);
 ~~~