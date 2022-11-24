//based on tutorial by Michael Walczyk https://michaelwalczyk.com/blog-ray-marching.html
precision mediump float;
uniform vec2 u_resolution;
uniform float u_time;
uniform vec2 u_mouse;

#define MAX_STEPS 100
#define MAX_DIST 10000000.
#define SURFACE_DIST 0.0001

mat2 rotate(float a){
    float s = sin(a);
    float c = cos(a);
    return mat2(c, -s, s, c);
}
float getDistSphere(vec3 p, vec3 sphere_pos, float radius){
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
    return length(max(abs(p)-s,0.));
}
float getSceneDist(vec3 p){
    float sphere = getDistSphere(p, vec3(0,0,0.), 1.);
    float capsule = sdfCapsule(p, vec3(0,1,0.5), vec3(0,2,0.5), .2);
    float torus = sdftorus(p-vec3(1,2,2), vec2(1,0.2));
    float cube = sdfCube(p-vec3(-2,0.2,1), vec3(0.5));
    float plane = p.y+1.5;
    float d = min(torus, plane);
    d = min(d, sphere);
    d = min(d, cube);
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
    float diffuse = getLight(p, vec3(0.,8.,6.));


//sdf visualation
    // col = vec3(d)/10.;
//Normal visualisation
    // col = getNormal(p);
//Light visualisation
    col += diffuse;


    gl_FragColor = vec4(col, 1.);

}