#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

vec3 colorA = vec3(0.264,0.051,1.000);
vec3 colorB = vec3(0.950,0.028,0.064);


float plot (vec2 st, float pct){
  return  smoothstep( pct-0.01, pct, st.y) -
          smoothstep( pct, pct+0.01, st.y);
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    

    vec3 color = vec3(0.0);

    vec3 pct = vec3(st.x);

    //Create 3 curves, one per channel, so that we can control how much r,g,b are passed at x position
    pct.r = 1.0-pow(sin(st.x*PI+u_time),2.0);
    pct.g = pow(sin(st.x*PI+-0.5+u_time),2.0);
    pct.b = pow(sin(st.x*PI+0.5+u_time),2.0);
    
    //each curve is mapped to a color channel
    color = vec3(pct.r, pct.g, pct.b);

    // Plot transition lines for each channel. Use to visualise each channel
    //color = mix(color,vec3(1.0,0.0,0.0),plot(st,pct.r));
    //color = mix(color,vec3(0.0,1.0,0.0),plot(st,pct.g));
    //color = mix(color,vec3(0.0,0.0,1.0),plot(st,pct.b));

    gl_FragColor = vec4(color,1.0);
}