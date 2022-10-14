#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

float circle(in vec2 _st, float radius, vec2 centre){

    vec2 dist = _st-centre;
	return (1.-smoothstep(radius,radius, dot(dist,dist)));
}

float circle_outline(in vec2 _st, float radius, vec2 centre){

    float funky_radius = radius;
    float dist = length(_st-centre);

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

    float top_height = pos.y;
    float left_width = pos.x;
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

    // SHAPES
    vec2 circle1_st = c;
    circle1_st = circle1_st * rotate2d(-u_time*0.5);
    color += circle(circle1_st, 0.002, vec2(0.1));

    vec2 circle2_st = c;
    circle2_st= circle2_st * rotate2d(u_time * 0.2);
    color += circle_outline(circle2_st, 0.02, vec2(0.3))*vec3(1.,0.,0.);

    vec2 circle3_st = c;
    circle3_st= circle3_st * rotate2d(-u_time * 0.2);
    color += circle(circle3_st, sin(0.002+u_time)/44., vec2(0.2))*vec3(0.,0.,1.);

    vec2 square_st = c;
    square_st = square_st * rotate2d(u_time);
    square_st += vec2(0.5);
    color += rectangle(square_st, vec2(0.25), vec2(0.39)) * vec3(0.,1.,0.);


    // ROTATE BACKGROUND (st, overall coordinates)
    st -= vec2(0.5);
    st = st * rotate2d(-u_time);
    st += vec2(0.5);

    // color += vec3(st.x, st.y, 0.); // <-- display st as color


    gl_FragColor = vec4(color,1.0);
}
