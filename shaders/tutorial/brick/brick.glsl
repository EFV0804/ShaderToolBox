#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;



vec3 brick(in vec2 st){

    vec3 BRICK_COLOR = vec3(0.5451, 0.1804, 0.0353);
    vec3 MORTAR_COLOR = vec3(0.8784, 0.8667, 0.7373);
    vec2 BRICK_TILE_SIZE = vec2(.08, .03);
    vec2 BRICK_PCT = vec2(.9);
    vec3 color = vec3(0.);

    vec2 position = st/ BRICK_TILE_SIZE;

    position.x += step(fract(position.y * 0.5),0.5)/2.;
    
    vec2 norm_position= fract(position);

    vec2 isBrick = step(norm_position, BRICK_PCT);

    color = mix(MORTAR_COLOR, BRICK_COLOR, isBrick.x * isBrick.y);

    return color;
}
void main( )
{
	vec2 st = gl_FragCoord.xy / u_resolution.xy;
	gl_FragColor = vec4(brick(st),1.0);
}