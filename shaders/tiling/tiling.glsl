#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

vec2 random2( vec2 p )
{
    return fract(sin(vec2(dot(p,vec2(127.1,311.7)),dot(p,vec2(269.5,183.3))))*43758.5453);
}

float dots(in vec2 f_st, in vec2 i_st){

    float m_distP = 1.;

    for (int y= -1; y <= 1; y++) {
        for (int x= -1; x <= 1; x++) {
            vec2 neighbor = vec2(x,y);
            vec2 point = random2(i_st + neighbor );
            point = 0.5 + 0.5*sin(u_time + 6.2831*point);
            vec2 diff = neighbor + point - f_st;
            float dist = 1.-smoothstep(.0055,.0054, dot(diff,diff));
            if(dist *m_distP < m_distP)
            {
                m_distP = dist*m_distP;
            }
        }
    }

    return m_distP;
}
void main(){
	vec2 st = gl_FragCoord.xy/u_resolution.xy;

 
    st *= 3.;
    
    // Get the factal part of the coordinates, to have normalised coordinates for each tile
    vec2 f_st = fract(st);
    //vec2 f_st = mod(st,1.0); //---> We could also use a modulo to achieve the same effect
    
    // Get the integral part of the coordinates, we can use this number to identify a tile
    vec2 i_st = floor(st);

    // Circles in each tile
    vec3 color = vec3(dots(f_st,i_st));    
    
    // Grid lines
    color.r -= step(.98, f_st.x) + step(.98, f_st.y);
    
    

	gl_FragColor = vec4( color, 1.0 );
}
