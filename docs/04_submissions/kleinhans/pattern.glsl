#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;
uniform vec2 u_mouse;

const float PI = 3.14159265359;
const int nSides = 12;
const float radius = 0.3;
float size = 0.0;
const float speed = 0.2;

//TILING
const float tiles = 4.0;

//mouse interaction
const float mouse = 0.5;
const float dis = 2.0;

// big circle


uniform float circleRadius;
uniform vec2 circlePosition;
uniform vec4 borderColor;
uniform float borderThickness;


void main() {
    //coordinate system between -1..1, with 0,0 at the center
    vec2 uv = (gl_FragCoord.xy / u_resolution) - 0.5;
    vec2 center = vec2(0.0);

    float result = 0.0;

    vec2 mouse = u_mouse / u_resolution;
    //float dist = distance(uv, mouse);
    float dist = distance(vec2(0.5, 0.5), mouse);
   

    for(float i = 0.; i < tiles; i++)
    {    

        // for creating repetition
        uv = fract(uv * 2.0) - 0.5;

        //circles
        for (int i = 0; i < nSides; i++) {
            float size =  0.2 * (mouse.y * 0.1);
            float angle = (float(i) / float(nSides)) * (PI * 2.0);

            vec2 pos = center + radius * vec2(cos(angle), sin(angle)) * sin(u_time * speed) * (1.0 - dist * dis);

            result += float(length(pos - uv) < size); //draw dot


            // circle big

             
        }
    }

    vec3 color = mix(vec3(1.0, 1.0, 1.0), vec3(0.0, 0.0, 0.0), 1.0 - result);
    gl_FragColor = vec4(color, 1.0);


    // PATTERN

     vec2 uv_original = uv;
}

/*

layout(location=0) out vec4 frag_colour;

in vec4 color;

uniform float circleRadius;
uniform vec2 circlePosition;
uniform vec4 borderColor;
uniform float borderThickness;

void main()
{
    vec2 uv = gl_FragCoord.xy - circlePosition;

    float d = sqrt(dot(uv,uv));

    float t = 1.0 - smoothstep(0.0, borderThickness, abs(circleRadius-d));

    frag_colour = vec4(color.rgb,color.a*t);
}
*/