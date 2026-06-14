#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

float CELLSIZE = 0.1;

void main()
{
    //Convert screen coordinates
    vec2 coord = (2.0 * gl_FragCoord.xy - u_resolution.xy) / u_resolution.y;

    //create Grid
    vec2 xy = coord / CELLSIZE;

    //Keep only the local coordinates inside each cell
    //  I CHANGED THE - TO A + BELOW
    
    xy += floor(xy) ;

    //CHANGED REMAP COORDINATES
    vec2 xy_remap = abs((xy * 0.08) * 1.0);

    //Flower shaped Distance field
    float angle = atan(xy_remap.y - 0.5,
                   xy_remap.x - 0.5);

    float radius = distance(xy_remap, vec2(0.5));
    float d = radius + 0.5 * sin(angle * 5.0);  

    //Repeat the distance Value
    d = d - floor(d);

    //animate
    d = fract(d - u_time * 0.5);


    //convert to color
    vec3 color = mix(vec3(0.6392, 0.0784, 0.0588), vec3(1.0, 0.1373, 0.8), d);

    gl_FragColor = vec4(color, 1.0);

}