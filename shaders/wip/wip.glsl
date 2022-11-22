#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

float Hash21 (in vec2 st) {

    st = fract(st*vec2(125.25,56.2));
    st += dot(st, st+45.32);
    return fract(st.x*st.y);
}
float random (in vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}
vec2 random2( vec2 p )
{
    return fract(sin(vec2(dot(p,vec2(127.1,311.7)),dot(p,vec2(269.5,183.3))))*43758.5453);
}
float star(in vec2 _st, in float flare_mult){

    float d = length(_st);
    float m = 0.13/d;
    float flare = max(0.,1.-abs(_st.x*_st.y*1000.));
    mat2 rot = mat2(cos(3.14/4.), -sin(3.14/4.), sin(3.14/4.), cos(3.14/4.));
    _st *= rot;
    flare += max(0.,1.-abs(_st.x*_st.y*1000.));
    m += flare * flare_mult;
    m *= smoothstep(0.5,0.2,d);
    return m;
}
vec3 star_layer(in vec2 st){
    float m;
    float size;
    vec3 color;

    vec2 i_st = floor(st);
    vec2 f_st = fract(st)-0.5;

    for (int y= -1; y <= 1; y++) {
        for (int x= -1; x <= 1; x++) {
            vec2 neighbor = vec2(x,y);
            vec2 point = random2(i_st + neighbor );

            // point = 0.5*sin(u_time + 6.2831*point);
            vec2 diff = neighbor + point - f_st;
            size = fract(Hash21(i_st+neighbor));
            float m = star(diff, smoothstep(0.8, 1., size));
            color += m*(vec3(.3*size,0.3*size,.5*size))*size;
        }
    }
    
    color *=vec3(0.2588, 0.2667, 0.2745);


    return color;
}
float noise (in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}
#define OCTAVES 7
float fbm(in vec2 st) {
    // Initial values
    float value = 0.;
    float amplitude = 0.5;
    // float frequency = 2.;

    // Loop of octaves
    for (int i = 0; i < OCTAVES; i++) {
        value += amplitude * noise(st);
        st = st * 2.;
        // st = rot*st * 2.9 + shift;

        amplitude *= 0.540;
    }
    return value;
}
float fbm_warp(in vec2 st, in mat2 rot) {
    // Initial values
    float value = 0.;
    float amplitude = 0.5;
    // float frequency = 2.;
    vec2 shift = vec2(100.);
    // mat2 rot = mat2(cos(1.), sin(0.4),
    //             -sin(0.4), cos(0.40));

    // Loop of octaves
    for (int i = 0; i < OCTAVES; i++) {
        value += amplitude * noise(st);
        st = rot * st * 2.1 + shift;
        amplitude *= 0.7;
    }
    return value;
}
void main(){

    vec2 st = (gl_FragCoord.xy-0.5*u_resolution.xy)/u_resolution.y;
        vec2 c = gl_FragCoord.xy/u_resolution.xy-.5;

    float scalar = 10.;
    st *= scalar;

    vec2 i_st = floor(st);
    vec2 f_st = fract(st)-0.5;
    vec2 g_st = fract(st)-0.5;


    vec3 color= vec3(0.0, 0.0, 0.0);

    color.r += step(.48, f_st.x) + step(.48, f_st.y);


    gl_FragColor = vec4(color,1.0);

}
