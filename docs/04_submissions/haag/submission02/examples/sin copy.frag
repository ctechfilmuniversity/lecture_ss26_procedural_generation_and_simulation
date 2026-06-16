#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

float CELLSIZE = 0.05; //relative, hence 0..1
vec2 OFFSET = vec2(0.2);


void main()
{

    vec2 coord = (2.0 * gl_FragCoord.xy - u_resolution.xy) / u_resolution.y;

    // Mirror horizontally
    coord.x = abs(coord.x);

    // Create Cells
    coord /= CELLSIZE;
    
    // Get into one cell
    coord -= sin(coord);

    // Modify value range from 0..1 to -1..1
    // and then taking the absolute to flip
    // all negative values to be positive again
    vec2 coord_remap = abs((coord - 0.26) * 2.0);

    // Ridges
    float d = distance(coord_remap, OFFSET);

    d *= 8.0;
    d = sin(d) * 0.3 + 0.5; // remap

    vec3 color = mix(vec3(0.9804, 0.6275, 0.298), vec3(0.9529, 0.0392, 0.3451), d);
    gl_FragColor = vec4(color, 1.0);
    // gl_FragColor = vec4(vec3(d), 1.0);
}

