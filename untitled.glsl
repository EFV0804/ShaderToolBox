#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
vec3 BRICK_COLOR = vec3(192.0 / 255.0, 106.0 / 255.0, 59.0 / 255.0);
vec3 BRICK_COLOR_VARIATION = vec3( 30.0 /255.0, 20.0/255.0, 20.0/255.0);

vec3 MORTAR_COLOR = vec3(232.0 / 255.0, 216.0 / 255.0, 195.0 / 255.0);

vec2 BRICK_SIZE = vec2(.08, .03);

vec2 BRICK_PCT = vec2(.9);


vec2 tiling(vec2 _st, vec2 scaling){
    _st.x *= scaling.x; //scale x coord by scale.x
    _st.y *= scaling.y; //scale y coord by scale.y

    //_st is no longer normalized between 0 and 1, so we use fract() or mod(_st,1.0)
    //to reset the coords to zero for every unit (+1)
    _st = fract(_st);
    //st = mod(st,1.0); //We could alos wrap around every x unit with a modulo

    return _st;
}


void main( )
{
	vec2 st = gl_FragCoord.xy / u_resolution.xy;
    
    vec2 position = tiling(st, vec2(2.0));
    
    if(fract(position.y *0.5) > 0.5)
    {
     	position.x += 0.5;   
    }
    

    position = fract(position);

    vec2 useBrick = step(position, BRICK_PCT);
    
    vec3 color = mix(MORTAR_COLOR, BRICK_COLOR, useBrick.x * useBrick.y);
    
    
    
	gl_FragColor = vec4(color,1.0);
}