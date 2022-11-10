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

float getSceneDist(vec3 p){
    float sphere = getDistSphere(p, vec3(0,0,0.), 1.);
    float displacement = sin(5. * (p.x+cos(u_time))) * sin(5.* (p.y+cos(u_time))) * sin(5. * (p.z+sin(u_time)))*.25;
    float plane = p.y+1.5;
    float d = min(sphere+displacement, plane);
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

    vec3 ro = vec3(0,0,-5);
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