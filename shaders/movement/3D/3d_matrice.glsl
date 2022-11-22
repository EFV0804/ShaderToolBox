precision mediump float;
uniform vec2 u_resolution;
uniform float u_time;
uniform vec2 u_mouse;

mat3 rotate3dX(float _angle){

    return mat3(
        vec3(1,0,0),
        vec3(0,cos(_angle),-sin(_angle)),
        vec3(0, sin(_angle), cos(_angle))
    );
}
mat3 rotate3dY(float _angle){

    return mat3(
        vec3(cos(_angle),0,sin(_angle)),
        vec3(0,1,0),
        vec3(-sin(_angle),0, cos(_angle))
    );
}
mat3 rotate3dZ(float _angle){

    return mat3(
        vec3(cos(_angle),-sin(_angle),0),
        vec3(sin(_angle),cos(_angle),0),
        vec3(0, 0, 1)
    );
}


void main(){
    vec2 st = (gl_FragCoord.xy-0.5*u_resolution.xy)/u_resolution.y;
    vec3 col = vec3(1,0,0);

    gl_FragColor = vec4(col, 1);
}