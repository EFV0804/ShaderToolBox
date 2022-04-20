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
float voronoi(vec2 i_stP, vec2 f_stP, vec2 stP, float scalarP)
{
    float m_distP = 1.;

    for (int y= -1; y <= 1; y++) {
        for (int x= -1; x <= 1; x++) {
            vec2 neighbor = vec2(x,y);
            vec2 point = random2(i_stP + neighbor );
            point = 0.5 + 0.5*sin(u_time + 6.2831*point);
            vec2 diff = neighbor + point - f_stP;
            float dist = dot(diff, diff);
            if(dist *m_distP < m_distP)
            {
                m_distP = dist*m_distP;
            }
        }
    }
//MOUSE INTERACTION
    vec2 mousePoint = u_mouse.xy/u_resolution.y*scalarP;
    vec2 diffMouse = mousePoint - stP;
    float distMouse = length(diffMouse);
    if(distMouse*m_distP  < m_distP)
    {
        m_distP = distMouse*m_distP ;
    }
    return m_distP;
}
void main()
{
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    st.x *= u_resolution.x/u_resolution.y;

    float scalar = 10.;
    st *= scalar;

    vec2 i_st = floor(st);
    vec2 f_st = fract(st);

    float m_dist = voronoi(i_st, f_st, st, scalar);


    vec3 color = vec3(0.0, 0.0, 0.0);
    color += m_dist/0.01;


    //Color tests
    
    // vec3 color = vec3(0.,.49,.5);
    // color -= m_dist/0.1;


    // vec3 color = vec3(0.,.4,0.5);
    // color.r = m_dist;
    

    // Draw grid
    //color.r += step(.98, f_st.x) + step(.98, f_st.y);

    gl_FragColor = vec4(color,1.0);
}
