#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

vec3 rgb2hsb( in vec3 c ){
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz),
                 vec4(c.gb, K.xy),
                 step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r),
                 vec4(c.r, p.yzx),
                 step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)),
                d / (q.x + e),
                q.x);
}
vec3 ref_function( in vec3 c ){
    vec3 rgb = clamp(abs(mod(c.x*6.0+vec3(0.0,4.0,2.0),6.0)-3.0)-1.0,0.0,1.0 );
    rgb = rgb*rgb*(3.0-2.0*rgb);
    return c.z * mix(vec3(1.0), rgb, c.y);
}

//  Function from Iñigo Quiles
//  https://www.shadertoy.com/view/MsS3Wc
vec3 hsb2rgb( in vec3 c ){
    vec3 rgb = clamp(abs(mod(c.x*6.0+vec3(0.0,4.,2.),6.)-3.)-1.0, 0.0,1.0);
    // link to this^ curve broken down into 4 steps: 
    //original: https://graphtoy.com/?f1(x,t)=x*6+(0,4,2)&v1=true&f2(x,t)=mod(x*6+(0,4,2),6.0)&v2=true&f3(x,t)=abs(mod(x*6+(0,4,2),6.0)-3.0)&v3=true&f4(x,t)=clamp(abs(mod(x*6+(0,4,2),6.0)-3.0)-1.0,0.0,1.0)&v4=true&f5(x,t)=&v5=false&f6(x,t)=&v6=false&grid=true&coords=6.1892659587121575,2.7526734631722625,8.969999932434147
    //simplified: https://graphtoy.com/?f1(x,t)=x&v1=true&f2(x,t)=mod(x,6.0)&v2=true&f3(x,t)=abs(mod(x,6.0)-3.0)&v3=true&f4(x,t)=clamp(abs(mod(x,6.0)-3.0)-1.0,0.0,1.0)&v4=true&f5(x,t)=&v5=false&f6(x,t)=&v6=false&grid=true&coords=6.1892659587121575,2.7526734631722625,8.969999932434147
    //rgb = rgb*rgb*(2.936-2.096*rgb); //Doesn't make sens because it doesn't change anything, and a 
    //vector multiplied by itself is 0.
    return c.z /*c.z is st.y*/ * mix(vec3(1.0), rgb, 5.0); // this mixes either white or a color times st.y, which is used as brightness here
}

void main(){
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    vec3 color = vec3(0.0);

    // We map x (0.0 - 1.0) to the hue (0.0 - 1.0)
    // And the y (0.0 - 1.0) to the brightness
    color = hsb2rgb(vec3(st.x,1.0,st.y));

    gl_FragColor = vec4(color,1.0);
}
