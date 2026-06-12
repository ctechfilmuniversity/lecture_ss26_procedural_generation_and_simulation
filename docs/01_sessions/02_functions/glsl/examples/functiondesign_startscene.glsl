#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;


void main() {

    // Normalization of the incoming
    // screen coordinate
    vec2 coord = (2.0 * gl_FragCoord.xy - u_resolution.xy) / u_resolution.y;

    // r, g, b channels from 0..1
    vec3 color = vec3(0.3765, 0.0, 0.502);

    float wave = sin(u_time) * 0.5 + 0.5;
    color[0] = wave;

    // Set the final "pixel" color, with alpha a fourth value
    gl_FragColor = vec4(color, 1.0);

}