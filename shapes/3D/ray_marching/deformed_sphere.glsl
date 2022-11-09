//based on tutorial by Michael Walczyk https://michaelwalczyk.com/blog-ray-marching.html
precision mediump float;
uniform vec2 u_resolution;
uniform float u_time;
uniform vec2 u_mouse;

#define MAX_STEPS 100
#define MAX_DIST 10000000.
#define SURFACE_DIST 0.0001

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
    // vec3 lightPos = vec3(0,5,2);
    // lightPos.xy += vec2(cos(u_time), sin(u_time))*20.;
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

void main(){
    vec2 st = (gl_FragCoord.xy-0.5*u_resolution.xy)/u_resolution.y;
    vec2 mo = u_mouse.xy/u_resolution.xy;

    vec3 col = vec3(0.);

    vec3 ta = vec3( 0., 0., 0. );
    vec3 ro = ta + vec3(4.5*cos(7.0*mo.x), 2., 4.5*sin(7.0*mo.x));
    mat3 ca = setCamera( ro, ta, 0.0 );
    vec3 rd = ca *normalize(vec3(vec2(st.s, st.t), 1.));

    float d = raymarch(ro, rd);

    //Light
    vec3 p  = ro + rd * d;
    float diffuse = getLight(p, vec3(0.,8.,6.));

//sdf visualation
    // col = vec3(d)/10.;
//Normal visualisation
    // col = getNormal(p);
//Light visualisation
    col = vec3(diffuse);

    gl_FragColor = vec4(col, 1.);

}