#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

void main(){
    // OVERALL COORDINATES
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    // CENTER COORDINATES
    vec2 c = gl_FragCoord.xy/u_resolution.xy-.5;

    vec3 color = vec3(0.0);

    gl_FragColor = vec4(color,1.0);
}
