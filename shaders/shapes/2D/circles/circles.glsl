// Author @patriciogv - 2015
// http://patriciogonzalezvivo.com

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

float quarterCircle(in vec2 _st, float radius){

	return 1.-smoothstep(radius,radius, dot(_st,_st));

    //dot(_st,_st): for every 'point' on the screen, we get the magnitude of the vector at origin 0
    //Knowing that (V).(V) = |V|^2 = sqrt(x^2+y^2)^2 = x^2+y^2
    //and the equation for the radius of a circle is x^2 + y2 = r^2 or sqrt(x^2+y^2)=r
    //so for every position on screen, we get the magnitude of the vector squared
    // then through a smoothstep function we give that point a value from 0 to 1
    //depending on wether it is shorter or longer than the radius of the circle we want
}

float circle(in vec2 _st, float radius){

    vec2 dist = _st-vec2(0.5);
    //if we want to draw a full circle, we need to translate the origin to the middle of the screen
    //to calculate if a point in on a circle not on origin: (x-h)^2+(y-k)^2 = r^2
    //h and k being the x and y of the center's translation, they are substracted from the point
    //to place it back at the origin
    // 
	return 1.-smoothstep(radius,radius, dot(dist,dist));
}

float fadedCricle(in vec2 _st, float radius){
    vec2 dist = _st-vec2(0.5);
    return 1.-smoothstep(radius-0.05,radius, dot(dist,dist));

    //to fade the edges of the circle we need to increase the difference between
    //the minimu value and the max value of the smoothstep function
    //so that the points on the edge of the radius can have color values between
    //0 and 1 rather than 0 OR 1
    //first param of smoothstep makes the outside grow inside and seconde is the oppisite
}
float circle_outline(in vec2 _st, float radius, vec2 centre){

    float funky_radius = radius;
    float dist = length(_st-centre);
    // Substract a circle inside a first circle to create an outline
	float outline = (1.-smoothstep(funky_radius,funky_radius, dist-0.005/2.)) - (1.-smoothstep(funky_radius,funky_radius, dist+0.005/2.));

    return outline;
}
void main(){
	vec2 st = gl_FragCoord.xy/u_resolution.xy;
    vec2 c = gl_FragCoord.xy/u_resolution.xy-.5;
    //vec3 color = vec3(quarterCircle(st,0.3));
	//vec3 color = vec3(circle(st,0.1));
    vec3 color = vec3(fadedCricle(st,0.1));
    vec3 color = vec3(circle_outline(st, 0.1,c));

	gl_FragColor = vec4( color, 1.0 );
}
