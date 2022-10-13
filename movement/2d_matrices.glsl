#ifdef GL_ES
precision mediump float;
#endif


#define PI 3.14159265359

uniform vec2 u_resolution;
uniform float u_time;
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

mat2 rotate2d(float _angle){

    return mat2(cos(_angle), -sin(_angle), sin(_angle), cos(_angle));
}

mat2 scale(vec2 _scale){
    return mat2(_scale.x,0.0,
                0.0,_scale.y);
}

void main(){
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    // vec2 c = u_resolution/2.0;
    vec3 color = vec3(0.0);

    //color -= vec3(rectangle(st, vec2(.5,.5), vec2(.25,.25)));
    //move st to center of coord system
    st -= vec2(0.5);
    //rotate
    st = rotate2d(-u_time*0.5)*st;
    //scale
    float scalar = 20.;
    // float scalar = sin(st.x+2.); // curves outer edge of square
    st = scale(vec2(scalar))*st;

    //move st back to original position
    st += vec2(0.5);

    color += vec3(rectangle(st, vec2(.5,.5), vec2(.25,.25)));

    // color += vec3(rectangle(st, vec2(.5,.5), vec2(.01,.01)));

    // color += vec3(st.x, st.y, 0.);
   
    gl_FragColor = vec4(color,1.0);
}