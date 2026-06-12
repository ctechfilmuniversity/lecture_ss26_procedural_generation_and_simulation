#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359
uniform vec2 u_resolution;

void main() {

    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;


    // Increase frequency to fit more sin waves 
    float verti = sin(8.0 * PI * uv.x);
    float hori = sin(8.0 * PI * uv.y);


    // vec3 color = vec3(hori+verti);
    vec3 color = mix(vec3(1.0, 1., 0.0), vec3(0.5, 0.0, 0.5), hori+verti);
    
    // Assign frag color with alpha
    gl_FragColor = vec4(color,1.0);
}
