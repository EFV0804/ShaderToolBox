// Author @patriciogv - 2015
// http://patriciogonzalezvivo.com

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;


float fadedCricle(in vec2 _st, float radius){
    vec2 dist = _st-vec2(0.5);
    return 1.-smoothstep(radius-0.05,radius, dot(dist,dist));
}

vec2 tiling(vec2 _st, vec2 scaling){
    _st.x *= scaling.x; //scale x coord by scale.x
    _st.y *= scaling.y; //scale y coord by scale.y

    //_st is no longer normalized between 0 and 1, so we use fract() or mod(_st,1.0)
    //to reset the coords to zero for every unit (+1)
    _st = fract(_st);
    //st = mod(st,1.0); //We could alos wrap around every x unit with a modulo

    return _st;
}

void main(){
	vec2 st = gl_FragCoord.xy/u_resolution.xy;

    st = tiling(st, vec2(3.0,3.0));

    vec3 color = vec3(fadedCricle(st,0.1));
    

	gl_FragColor = vec4( color, 1.0 );
}
