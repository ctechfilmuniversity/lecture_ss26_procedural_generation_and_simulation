#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

float CELLSIZE = 1.0;

void main()
{
    //Convert screen coordinates
    vec2 coord = (3.0 * gl_FragCoord.xy - u_resolution.xy) / u_resolution.y;

    //create Grid
    vec2 xy = coord - CELLSIZE;

    //Keep only the local coordinates inside each cell
    xy -= floor(xy) ;

    //Remap the coordinates 
    vec2 xy_remap = abs((xy * 1.0) * 1.0);

    //Compute the distance field (Manhatten instead of circle)(from current pixel to point (0.8, 0.8))
    //float d =
    //abs(xy_remap.x - 0.9) +
    //abs(xy_remap.y - 0.5);

    float angle = atan(xy_remap.y - 0.5,
                   xy_remap.x - 0.5);

    float radius = distance(xy_remap, vec2(0.5));

    float d = radius + 0.1 * sin(angle * 5.0);  

    //Repeat the distance Value
    d = d - floor(d);

    //animate
    d = fract(d - u_time * 0.5);


    //convert to color
    vec3 color = mix(vec3(0.949, 1.0, 0.0), vec3(1.0, 0.0, 1.0), d);

    gl_FragColor = vec4(color, 1.0);

}