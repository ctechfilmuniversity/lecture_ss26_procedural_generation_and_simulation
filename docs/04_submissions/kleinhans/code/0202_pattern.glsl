#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;
uniform vec2 u_mouse;

const float PI = 3.14159265359;
const int nSides = 12;
const float radius = 0.5;
float size = 0.0;
const float speed = 0.2;

//TILING
const float tiles = 2.0;

//MOUSE INTERACTION
const float mouse = 0.8;
const float dis = 2.0;

// Circles merged from shadertoy
const float orbitR = 0.1;
float centerRadius = 0.05;
const float encloseR = 0.1;
const float encloserRadius = 0.005;
float orbitSize = 1.0;


void main() {
    
    //coordinate system between -1..1, with 0,0 at the center
    vec2 uv = (gl_FragCoord.xy / u_resolution) - 0.5;
    vec2 center = vec2(0.0);

    //mouse interaction
     vec2 mouse = u_mouse / u_resolution;
    //float dist = distance(uv, mouse);
    float dist = distance(vec2(0.5, 0.5), mouse);

    float result = 0.0;

    vec2 tiledUV = uv;

    for(float t = 0.; t < tiles; t++)
    {    

        // for creating repetition
        tiledUV = fract(tiledUV * 2.0) - 0.5;

         // ridges
        float d = length(tiledUV);
        d *= 4.0;
        d -= floor(d); // oder: d = fract(d * 4.0);

        result += d *0.2;

        //circles
        for (int i = 0; i < nSides; i++) {
            
            
            float size =  0.2 * (mouse.y * 0.15);
            float angle = (float(i) / float(nSides)) * (PI * 2.0);

            vec2 pos = center + radius * vec2(cos(angle), sin(angle)) * sin(u_time * speed) * (1.0 - dist * dis);

            result += float(length(pos - tiledUV) < size); //draw dot


        vec2 bulb = vec2(
            orbitR * cos(u_time), 
            orbitR * sin(u_time)
        );

        if (length(tiledUV - bulb) < size * orbitSize) {
            result += 1.0;
        }

        centerRadius = 0.008 + 0.008 * sin(u_time * speed * 150.0); //pulsating circle
        result += float(length(tiledUV) < centerRadius);
             
        }
       
    }

    vec3 color = mix(vec3(1.0, 0.6784, 0.3804), vec3(0.0275, 0.0, 0.2941), 1.0 - result);
    gl_FragColor = vec4(color, 1.0);


    // PATTERN

     vec2 uv_original = uv;
}

