#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
#define BRICKWIDTH 0.8
#define BRICKHEIGHT 0.2
#define MORTARTHICKNESS 0.1
#define BMWIDTH (BRICKWIDTH+MORTARTHICKNESS)
#define BMHEIGHT (BRICKHEIGHT+MORTARTHICKNESS)
#define MWF (MORTARTHICKNESS*0.5/BMWIDTH)
#define MHF (MORTARTHICKNESS*0.5/BMHEIGHT)

vec3 brick(in vec2 st, in vec3 brick_color, in vec3 mortar_color){

    vec2 mortar_thickness = vec2(0.01, 0.05);
    //create normalised brick tiling coordinates
    float ss = st.s / BMWIDTH;
    float tt = st.t / BMHEIGHT;

    
    if(fract(tt*0.5) > 0.5)
    {
        ss += 0.5;
    }

    float s_brick = floor(ss);
    float t_brick = floor(tt);

    ss -= s_brick;
    tt -= t_brick;

    float w = step(MWF, ss) - step(1.-MWF, ss);
    float h = step(MHF, tt) - step(1.-MHF, tt);

    vec3 color = mix(mortar_color, brick_color, w*h);

    return color;

}

void main(){
    vec2 st = gl_FragCoord.xy/u_resolution.xy;

    gl_FragColor = vec4(brick(st, vec3(0.4784, 0.0627, 0.0627), vec3(0.6314, 0.6314, 0.6314)),1.);
}