//Based on tutorial by Martijn Steinrucken:  https://www.shadertoy.com/view/XlGBW3
precision mediump float;
uniform vec2 u_resolution;
uniform float u_time;

#define MAX_STEPS 100
#define MAX_DIST 100.
#define SURFACE_DIST 0.01

float getDist(vec3 p){
    //For a sphere
    vec4 sphere = vec4(0, 1, 6,1);
    //distance from p (camera or latest marched point) and sphere centre - radius
    float ds = length(p-sphere.xyz)-sphere.w;
    // distance from axis aligned plane to camera pos
    float dp = p.y;
    //return whatever is close
    float d = min(ds, dp);
    return d;
}

float raymarch(vec3 ro, vec3 rd){
    float distance_traveled = 0.;
    for(int i = 0; i<MAX_STEPS; i++){
        vec3 current_pos = ro +distance_traveled*rd;
        float distance_closest = getDist(current_pos);
        distance_traveled += distance_closest;
        if(distance_closest<SURFACE_DIST || distance_traveled>MAX_DIST){break;}
    }

    return distance_traveled;
}

void main(){
    vec2 st = (gl_FragCoord.xy-0.5*u_resolution.xy)/u_resolution.y;

    vec3 col = vec3(0.);

// ray origin
    vec3 ray_origine = vec3(0,1,0);
// ray direction
    vec3 ray_direction = normalize(vec3(st.s, st.t, 1.));
//raymarched distance
    float d = raymarch(ray_origin,ray_direction);
    // divide distance because everything further than max dist and therefor ignored.
    col = vec3(d)/10.;
    gl_FragColor = vec4(col, 1.);

}