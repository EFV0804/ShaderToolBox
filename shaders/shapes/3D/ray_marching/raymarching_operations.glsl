//based on tutorial by Michael Walczyk https://michaelwalczyk.com/blog-ray-marching.html
precision mediump float;
uniform vec2 u_resolution;
uniform float u_time;
uniform vec2 u_mouse;

#define MAX_STEPS 100
#define MAX_DIST 10000000.
#define SURFACE_DIST 0.0001

mat2 rotate(float _angle){

    return mat2(cos(_angle), -sin(_angle), sin(_angle), cos(_angle));
}
float sdfSphere(vec3 p, vec3 sphere_pos, float radius){
    vec4 sphere = vec4(sphere_pos,radius);

    return length(p-sphere.xyz)-sphere.w;
}
float sdfCapsule(vec3 p, vec3 a, vec3 b, float r){
    vec3 ap = p-a;
    vec3 ab = b-a;

    //project of ap on ab
    float t = dot(ab, ap)/ dot(ab,ab);
    t = clamp(t, 0., 1.);
    //c is point on the ab vector starting from a
    vec3 c = a + t*ab;
    return length(p-c)-r;

}
float sdftorus(vec3 p, vec2 r){
    //First get the distance from p.xz to the inner circle of the torus
    float x = length(p.xz)-r.x;
    float y = p.y;
    // Get the distance from the inner circle to p
    float d = length(vec2(x,y));
    //Distance to the outer circle of torus
    d -= r.y;
    return d;
}
float sdfCube(vec3 p, vec3 s){
    vec3 q = abs(p)-s;
    return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);
}
float getSceneDist(vec3 p){

    float plane = p.y+1.5;
// TRANSLATION + ROTATION
    // Cube 1 spins on itself
    vec3 cube_pos = p-vec3(0,-.3,0);
    cube_pos.xz *= rotate(u_time);
    float cube1 = sdfCube(cube_pos, vec3(.7));
    
    // Cube two spins around the center pivot
    vec3 cube2_pos = p;
    cube2_pos.xz *= rotate(u_time);
    cube2_pos -= vec3(-2,0.5,1);
    cube2_pos.xz *= rotate(u_time*2.5);

    float cube2 = sdfCube(cube2_pos, vec3(0.5));

    // Cube3 spins around cube 2
    vec3 cube3_pos = p;
    cube3_pos.xz *= rotate(u_time*3.5);
    cube3_pos = cube2_pos-vec3(-1.5,0.5,0);
    cube3_pos.xz *= rotate(u_time*1.8);

    float cube3 = sdfCube(cube3_pos, vec3(0.2));
    float d = min(cube1, plane);
    d = min(d, cube2);
    d = min(d, cube3);

// BOOLEAN OPERATIONS

    float sphere = sdfSphere(p, vec3(0.5,2.,-2.),.5);
    float sphere2 = sdfSphere(p, vec3(0.1,2.,-2.5),.5);
    float boolSubstract = max(-sphere2, sphere);
    d = min(d, boolSubstract);

    float sphere3 = sdfSphere(p, vec3(-1.2,2.,-2.),.5);
    float sphere4 = sdfSphere(p, vec3(-1.8,2.,-2),.5);
    float boolIntersection = max(sphere3, sphere4);

    d = min(d, boolIntersection);


    float sphere5 = sdfSphere(p, vec3(-1.2,2.,-2.),.5);
    float sphere6 = sdfSphere(p, vec3(-1.8,2.,-2),.5);
    float boolUnion = max(sphere5, sphere6);

    d = min(d, boolUnion);

    return d;
}

float raymarch(vec3 ro, vec3 rd){
    float distance_traveled = 0.;
    for(int i = 0; i<MAX_STEPS; i++){
        vec3 current_pos = ro +distance_traveled*rd;
        float distance_closest = getSceneDist(current_pos);
        distance_traveled += distance_closest;
        if(distance_closest<SURFACE_DIST || distance_traveled>MAX_DIST) break;
    }

    return distance_traveled;
}

vec3 getNormal(vec3 p){
    vec3 e = vec3(.001,0.,0.);
    float d = getSceneDist(p);
    vec3 n = d - vec3(
    getSceneDist(p-e.xyy),
    getSceneDist(p-e.yxy),
    getSceneDist(p-e.yyx));
    
    return normalize(n);
}

float getLight(vec3 p, vec3 lightPos){
    vec3 l = normalize(lightPos-p);
    vec3 n = getNormal(p);
    float diffuse = clamp(dot(n,l),0.,1.);

    // shadow
    float d = raymarch(p+n, l);
    if(d<length(lightPos-p)){
        diffuse *= .1;
    }

    return diffuse;

}

mat3 setCamera( in vec3 ro, in vec3 ta, float cr )
{
    //https://www.shadertoy.com/view/Xds3zN
	vec3 cw = normalize(ta-ro);
	vec3 cp = vec3(sin(cr), cos(cr),0.0);
	vec3 cu = normalize( cross(cw,cp) );
	vec3 cv =          ( cross(cu,cw) );
    return mat3( cu, cv, cw );
}

vec3 R(vec2 st, vec3 p, vec3 l, float z) {
    //https://www.shadertoy.com/view/3ssGWj
    //camera to world transformation
    vec3 f = normalize(l-p),
        r = normalize(cross(vec3(0,1,0), f)),
        u = cross(f,r),
        c = p+f*z,
        i = c + st.x*r + st.y*u,
        d = normalize(i-p);
    return d;
}

void main(){
    vec2 st = (gl_FragCoord.xy-0.5*u_resolution.xy)/u_resolution.y;
    vec2 mo = u_mouse.xy/u_resolution.xy;

    vec3 col = vec3(0.);

    vec3 ro = vec3(0,0,-9);
    ro.yz *= rotate(mo.y);
    ro.xz *= rotate(mo.x*6.);

    vec3 rd = R(st, ro, vec3(0,0,0), 0.9);

    float d = raymarch(ro, rd);

    //Light
    vec3 p  = ro + rd * d;
    float diffuse = getLight(p, vec3(2.,5.,-6.));


//sdf visualation
    // col = vec3(d)/10.;
//Normal visualisation
    // col = getNormal(p);
//Light visualisation
    col += diffuse;


    gl_FragColor = vec4(col, 1.);

}