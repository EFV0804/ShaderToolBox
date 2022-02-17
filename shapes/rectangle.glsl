#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;

float rectangle(vec2 st, vec2 size, vec2 pos){

    // A rectangle is formed by making 4 "strips" of "non-rectangle" around the desired rectangle.
    // We are deducting from the user's input what isn't a rectangle, and coloring that black
    
    //We start by using the size input to determine the top height and the left width. The rect's
    //point of origin is therefore it's top left corner.
    float top_height = pos.y;
    float left_width = pos.x;

    // Once the first "strips" are set, we need to deduct what size the other 2 "strips" should be.
    // First the position of the rectangle is substracted from the normalised max coordinate, this
    // gives us the remaining space, and matches all strips, to begin where the others end.
    // we substract the size of the rect, to know how much room to leave "open"

    float bottom_height = ((1.-pos.y)-size.y);
    float right_width = ((1.-pos.x)-size.x);

    //Bottom Left
    vec2 bl = step(vec2(left_width, bottom_height),st);
    float color = bl.x * bl.y;

    //Top Right
    vec2 tr = step(vec2(right_width, top_height),1.0-st);
    color *= tr.x * tr.y;

    return color;
}

void main(){
	vec2 st = gl_FragCoord.xy/u_resolution.xy;
    vec3 color = vec3(0.0, 0.0, 0.0);

    //white rectangle
    //color = vec3(rectangle(st, vec2(0.2,0.5), vec2(0.2,0.2)));

    //Colored rectangles
    //color = vec3(rectangle(st, vec2(0.2,0.5), vec2(0.2,0.2)), rectangle(st, vec2(0.2,0.5), vec2(0.35,0.25)), 
    //rectangle(st, vec2(0.2,0.5), vec2(0.5,0.3)));

    //Mondrian because you know... rectangles

    //Define colors
    vec3 white = vec3(0.9137, 0.8824, 0.7373);
    vec3 red = vec3(0.5255, 0.051, 0.051);
    vec3 blue = vec3(0.1451, 0.349, 0.7882);

    //Block positions and sizes
    // bl_* = black
    // b_* = blue
    // r_* = red
    // w_* = white

    vec2 bl1_size = vec2(1.,0.1);
    vec2 bl1_pos = vec2(0.,0.);

    vec2 b1_size = vec2(0.4,0.3);
    vec2 b1_pos = vec2(0.,bl1_size.y);

    vec2 r1_size = vec2(0.3, b1_size.y);
    vec2 r1_pos = vec2(b1_size.x, bl1_size.y);

    vec2 bl2_size = vec2(.1,1.);
    vec2 bl2_pos = vec2(r1_size.x+b1_size.x,0.);

    vec2 w1_size = vec2(0.2,b1_size.y);
    vec2 w1_pos = vec2(r1_size.x+b1_size.x+bl2_size.x, bl1_size.y);

    vec2 w2_size = vec2(b1_size.x+r1_size.x, 0.2);
    vec2 w2_pos = vec2(0., bl1_size.y+b1_size.y);

    color = vec3(rectangle(st, bl1_size, bl1_pos));
    color += vec3(rectangle(st, b1_size, b1_pos))*blue;
    color += vec3(rectangle(st, r1_size, r1_pos))*red;
    color += vec3(rectangle(st, bl2_size, bl2_pos));
    color += vec3(rectangle(st, w1_size, w1_pos))*white;
    color += vec3(rectangle(st, w2_size, w2_pos))*white;


	gl_FragColor = vec4(color, 1.0 );
}
