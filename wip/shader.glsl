#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;
float circle2(vec2 uv, vec2 center, float radius, float width)
{
    float r = length(uv - center);
    return 1.-smoothstep(radius-1.,radius+1., r-width/20.) - 1.-smoothstep(radius-1.,radius+1., r+width/20.);
    // return SMOOTH(r-width/2.0,radius)-SMOOTH(r+width/2.0,radius);
}
float circle(in vec2 _st, float radius, vec2 centre){

    vec2 dist = _st-centre;
    //if we want to draw a full circle, we need to translate the origin to the middle of the screen
    //to calculate if a point in on a circle not on origin: (x-h)^2+(y-k)^2 = r^2
    //h and k being the x and y of the center's translation, they are substracted from the point
    //to place it back at the origin
    // 
	return (1.-smoothstep(radius,radius, dot(dist,dist)));
}
float circle_outline(in vec2 _st, float radius, vec2 centre){

    float funky_radius = radius;
    // funky_radius += sin(funky_radius*u_time);
    float dist = length(_st*sin(u_time)-centre);
    //if we want to draw a full circle, we need to translate the origin to the middle of the screen
    //to calculate if a point in on a circle not on origin: (x-h)^2+(y-k)^2 = r^2
    //h and k being the x and y of the center's translation, they are substracted from the point
    //to place it back at the origin
    // 
	float outline = (1.-smoothstep(funky_radius,funky_radius, dist-0.005/2.)) - (1.-smoothstep(funky_radius,funky_radius, dist+0.005/2.));

    return outline;
}

mat2 scale(vec2 _scale){
    return mat2(_scale.x,0.0,
                0.0,_scale.y);
}

mat2 rotate2d(float _angle){

    return mat2(cos(_angle), -sin(_angle), sin(_angle), cos(_angle));
}

float rectangle(vec2 st, vec2 size, vec2 pos){

    // A rectangle is formed by making 4 "strips" of "non-rectangle" around the desired rectangle.
    // We are deducting from the user's input what isn't a rectangle, and coloring that black
    
    //We start by using the size input to determine the top height and the left width. The rect's
    //point of origin is therefore it's top left corner.
    float top_height = pos.y;
    float left_width = pos.x;

    // Once the first "strips" are set, we need to deduct what size the other 2 "strips" should be.
    // First the position of the rectangle is substracted from the normalised max coordinate, this
    // gives us the remaining space, and matches all strips, to begin where the others end.
    // we substract the size of the rect, to know how much room to leave "open"

    float bottom_height = ((1.-pos.y)-size.y);
    float right_width = ((1.-pos.x)-size.x);

    //Bottom Left
    vec2 bl = step(vec2(left_width, bottom_height),st);
    float color = bl.x * bl.y;

    //Top Right
    vec2 tr = step(vec2(right_width, top_height),1.0-st);
    color *= tr.x * tr.y;

    return color;
}

void main(){
    // OVERALL COORDINATES
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    // CENTER COORDINATES
    vec2 c = gl_FragCoord.xy/u_resolution.xy-.5;

    vec3 color = vec3(0.0);



    // CIRCLE
    vec2 circle1_st = c;                                     // <-- centre the circle coordinates
    // vec2 radius = vec2(0.004) * scale(vec2(10.));
    // vec2 radius = vec2(0.004);
    // circle1_st = circle1_st * scale(vec2(0.005));             // <-- scale circle coordinates
    // circle1_st += vec2(0.5);
    circle1_st = circle1_st * rotate2d(-u_time*0.5);    // <-- rotate circle coordinates
    // circle1_st += vec2(0.5);
    color += circle(circle1_st, 0.002, vec2(0.1));

    // color += circle_outline(circle1_st, .05, vec2(0.));      // <-- make circle using circle coordinates

    // color -= rectangle(circle1_st, vec2(0.25), vec2(0.39));


    vec2 circle2_st = c;
    circle2_st= circle2_st * rotate2d(u_time * 0.2);
    color += circle(circle2_st, 0.002, vec2(0.3));

    vec2 square_st = c;
    square_st = square_st * rotate2d(u_time);
    square_st += vec2(0.5);
    color += rectangle(square_st, vec2(0.25), vec2(0.39));


// ROTATE BACKGROUND (st, overall coordinates)
    st -= vec2(0.5);
    st = st * rotate2d(-u_time);
    st += vec2(0.5);

    color += vec3(st.x, st.y, 0); // <-- display st as color


    gl_FragColor = vec4(color,1.0);
}
