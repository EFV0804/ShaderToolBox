---
layout: page
title:  "HSL Polar Coordinates"
date:   2022-11-22 15:08:55 +0100
categories: jekyll update
nav_order: 2
parent: "Color"
child_nav_order: asc
has_children: true
---
# HSL Polar Coordinates
How to map HSL colors

<script type="text/javascript" src="https://rawgit.com/patriciogonzalezvivo/glslCanvas/master/dist/GlslCanvas.js"></script>

<div style="text-align:center" >
<canvas class="glslCanvas" data-fragment-url="rgb2hsl_polarCoordinates.frag" width="500" height="500"></canvas>
</div>

Still under construction.


<link type="text/css" rel="stylesheet" href="https://rawgit.com/patriciogonzalezvivo/glslEditor/gh-pages/build/glslEditor.css">
<script type="application/javascript" src="https://rawgit.com/patriciogonzalezvivo/glslEditor/gh-pages/build/glslEditor.js"></script>

<body>
    <div id="glsl_editor"></div>
</body>
<script type="text/javascript">
    const glslEditor = new GlslEditor('#glsl_editor', { 
        canvas_size: 500,
        canvas_draggable: true,
        theme: 'monokai',
        multipleBuffers: true,
        watchHash: true,
        fileDrops: true,
        menu: true
    });
</script>