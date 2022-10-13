# Movement
To create movement and move around a shape in our canvas, we need to move the **coordinate system** rather than the shape itself.

 exemple of moving coordinate system

## Translate
 To translate we can apply a vec2 to the coordinate and create a translation movement on our canvas.

## Rotation
We can use matrices to apply movement to the coordinate system, it's especially useful for rotations. To do that we multiply the vec2 of coordinates by a matrix. GLSL supports mat2, mat3, mat4, matrix multiplication and matrixCompMult().

 ### Eigenvalues and eigenvectors
An eignenvector or characteristic vector of a linear transformation, is a nonzero vector that changes at most by a scalar factor when that linear transformation is applied.
This means that the vector changes without changing direction. Useful for scale