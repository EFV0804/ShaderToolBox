#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;



vec3 brick(in vec2 st){

    //-----------DECLARATIONS--------------
    vec3 BRICK_COLOR = vec3(145./255., 37./255., 1./255.);

    vec3 MORTAR_COLOR = vec3(232./255., 216./255., 195./255.);

    //BRICK_SIZE == size of brick+mortar, so brick tile size
    vec2 BRICK_TILE_SIZE = vec2(.08, .03);
    //BRICK_PCT == pourcentage of brick withing a brick tile
    //usesul to express in pourcentage, because it works well with the normalised tile coord
    //we'll have later on
    vec2 BRICK_PCT = vec2(.9);
    vec3 color = vec3(0.);

    //------------TILING-------------
    //create tiles the size of the bricks
    vec2 position = st;


    //creating the x offset on the tiles so that the bricks look laid out realistically
    //esentialluy it's creating a modulo, where everytime the fractional part of y/2 reaches over
    //0.5, we offset x by 0.5.
    //because fract(y/2) will only reach over 0.5 every 2 units, we get a modulo, a separation between
    //odd and even rows
    //exemples: 
    //fract(1.25/2) = 0.625--> offset
    //fract(1.75/2) = 0.875--> offset
    //fract(2.25/2) = 0.125 --> no offset
    //fract(2.75/2) = 0.25 --> no offset
    //fract(3.25/2) = 0.625 --> offset
    //fract(3.75/2) = 0.875--> offset

    if(fract(position.y *0.5) > 0.5)
    {
     	position.x += 0.5;   
    }
    
    //Normalise position var, so each tile goes from 0 to 1
    position = fract(position);

    //We can use the color channels to check x and y position values
    // color = vec3(position.x,position.y,0.);

    //-------------COLOR----------------
    //Using a step function to return a 0 or 1, a bool, to decide where to use a brick
    //color and where to use a mortar color
    //to get this bool value, we can use the step function and test the current position
    //against the brick dimension
    //So if position is superior to BRICK_PCT, step will return 1, else 0
    vec2 isBrick = step(position, BRICK_PCT);
    

    //now we can use this value as a way to choose the two colors
    // we multiply isBrick.x by isBrick.y because while isBrick.x might be 1, so it is 
    //within the size of the brick, isBrick.y might be 0, as it is the mortar
    // by multiplying the both together, we ensure that if any of them is 0, we will get 0

    //in black and white
    // color = vec3(isBrick.x * isBrick.y);
    //in technicolor
    color = mix(MORTAR_COLOR, BRICK_COLOR, isBrick.x * isBrick.y);

    return color;
}
void main( )
{
	vec2 st = gl_FragCoord.xy / iResolution.xy;

	gl_FragColor = vec4(brick(st),1.0);
}