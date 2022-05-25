#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

float random (in vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

// Based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
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

#define OCTAVES 10
float fbm(in vec2 st) {
    // Initial values
    float value = 0.;
    float amplitude = 0.5;
    // float frequency = 2.;
    vec2 shift = vec2(100.);
    mat2 rot = mat2(cos(0.5), sin(0.5),
                -sin(0.5), cos(0.50));

    // Loop of octaves
    for (int i = 0; i < OCTAVES; i++) {
        value += amplitude * noise(st);
        st = rot * st * 2. + shift;
        amplitude *= 0.420;
    }
    return value;
}
float fbm_wrap(in vec2 st) {
    // Initial values
    float value = 0.;
    float amplitude = 0.5;
    float frequency = 2.;
    vec2 shift = vec2(100.);
    mat2 rot = mat2(cos(0.5), sin(0.5),
                -sin(0.5), cos(0.50));

    // Loop of octaves
    for (int i = 0; i < OCTAVES; i++) {
        value += amplitude * noise(st);
        st *= 2.192;
        amplitude *= 0.420;
    }
    return value;
}

float fbm_ridge(in vec2 st) {
    // Initial values
    float value = 0.;
    float amplitude = .5;
    float frequency = 2.;
    //
    // Loop of octaves
    for (int i = 0; i < OCTAVES; i++) {
        value += amplitude * abs(noise(st));
        st *= 2.;
        amplitude *= .5;
    }
    return value;
}

float pattern(in vec2 p, out vec2 q, out vec2 r){
    q.x = fbm(p + vec2(0.));
    q.y = fbm(p + vec2(5.2,1.3));

    r.x = fbm(p + 4.0*q + vec2(1.7,9.2));
    r.y = fbm(p + 4.*q + vec2(8.3,2.8));

    return fbm(p +4.0+r); 
}
void main(){
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    // st.x *= u_resolution.x/u_resolution.y;

    vec3 color = vec3(0.0);

    //static color split V1
    // color.r += fbm(st+ 20.*(fbm(st+fbm(st))));
    // color.g += fbm(st+ 4.*(fbm(st+fbm(st))));
    // color.b += fbm(st+ 15.*(fbm(st+fbm(st))));


    //"folded" texture
    vec2 q = vec2(0.);
    q.x = fbm_wrap( st + 0.05*u_time);
    q.y = fbm_wrap( st);

    vec2 r = vec2(0.);
    r.x = fbm_wrap( st + 1.0*q + vec2(50.7,9.2)+ 0.09*u_time );
    r.y = fbm_wrap( st + 1.0*q + vec2(15.3,2.8)+ 0.0126*u_time);

    //split colors with "ridges"
    color.r = fbm_wrap(st+r*20.);
    color.g = fbm_wrap(st+r*1.);
    color.b = fbm_wrap(st+r*13.);

    //cloudy sin anim, one direction
    // color.r = fbm(vec2(st+20.+u_time*0.15));
    // color.g = fbm(vec2(st+4.+u_time*0.15));
    // color.b = fbm(vec2(st+15.+u_time*0.15));

    //f based colox mix for folded textures
    // float f = fbm(st+r);

    // color = mix(vec3(0.0392, 0.902, 0.9333),
    //             vec3(0.5686, 0.4118, 0.4118),
    //             clamp(f,0.0,1.0));

                
    // color = mix(vec3(0.6784, 0.5137, 0.5137),
    //             vec3(1.0, 1.0, 1.0),
    //             clamp((f*f)*1.0,0.0,1.0));

    // color = mix(color,
    //             vec3(0.0431, 0.5294, 0.9255),
    //             clamp(length(q)*0.5,.0,1.0));

    // color = mix(color,
    //             vec3(0.666667,1,1),
    //             clamp(length(r.x)*50.,0.0,.0));

    // gl_FragColor = vec4((f*f*f+.6*f*f+.5*f)*color,1.);


    //regular color mapping
    gl_FragColor = vec4(color,1.0);
}