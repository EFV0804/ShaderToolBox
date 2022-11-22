precision mediump float;
uniform vec2 u_resolution;
uniform float u_time;
uniform vec2 u_mouse;

#define MAX_STEPS 100
#define MAX_DIST 100.
#define SURFACE_DIST 0.01

float getDist(vec3 p){
    vec4 sphere = vec4(0, 1, 6,1);
    float ds = length(p-sphere.xyz)-sphere.w;
    float dp = p.y;
    float d = min(ds, dp);
    return d;
}

float raymarch(vec3 ro, vec3 rd){
    float distance_traveled = 0.;
    for(int i = 0; i<MAX_STEPS; i++){
        vec3 current_pos = ro +distance_traveled*rd;
        float ds = getDist(current_pos);
        distance_traveled += ds;
        if(ds<SURFACE_DIST || distance_traveled>MAX_DIST){break;}
    }

    return distance_traveled;
}

vec3 getNormal(vec3 p){
    float d = getDist(p);
    vec2 e = vec2(.01,0.);
    vec3 n = d - vec3(
        getDist(p-e.xyy),
        getDist(p-e.yxy),
        getDist(p-e.yyx));
    
    return normalize(n);
}

float getLight(vec3 p){
    vec3 lightPos = vec3(1,5,1);
    lightPos.xy += vec2(sin(u_time), cos(u_time))*2.;
    vec3 l = normalize(lightPos-p);
    vec3 n = getNormal(p);
    float diffuse = clamp(dot(n,l),0.,1.);

    //shadow
    float d = raymarch(p+n*SURFACE_DIST*1.001, l);
    if(d<length(lightPos-p)){
        diffuse *= .1;
    }

    return diffuse;

}
void main(){
    vec2 st = (gl_FragCoord.xy-0.5*u_resolution.xy)/u_resolution.y;

    vec3 col = vec3(0.);

    vec3 ro = vec3(0,1,0);
    vec3 rd = normalize(vec3(st.s, st.t, 1.));

    float d = raymarch(ro, rd);

    //Light
    vec3 p  = ro + rd * d;
    float diffuse = getLight(p);

//raymarched sphere visualisation
    // col = vec3(d)/10.;
//Normal visualisation
    // col = getNormal(p);
//Light visualisation
    col = vec3(diffuse);

    gl_FragColor = vec4(col, 1.);

}