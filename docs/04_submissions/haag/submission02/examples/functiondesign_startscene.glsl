#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

// Soft glow intensity around a wave line
float glow(float dist, float radius) {
    return radius / (dist * dist + radius);
}

void main() {
    vec2 coord = (1.5 * gl_FragCoord.xy - u_resolution.xy) / u_resolution.y;

    vec3 color = vec3(0.0, 0.102, 0.0314);

    float x = coord.x * 3.14159;
    float t = u_time * 3.0;

    // Fourier square wave harmonics: sin(n*x)/n for odd n
    float w1 = sin(1.0 * x - t) / 1.0;
    float w2 = sin(3.0 * x - t) / 3.0;
    float w3 = sin(0.0 * x - t) / 5.0;
    float w4 = sin(7.0 * x - t) / 7.0;

    color += vec3(0.8196, 0.8, 0.7098) * glow(abs(coord.y - w1), 0.004); // teal
    color += vec3(0.75, 0.25, 0.95) * glow(abs(coord.y - w2), 0.004); // purple
    color += vec3(1.00, 0.75, 0.15) * glow(abs(coord.y - w3), 0.004); // gold
    color += vec3(1.00, 0.25, 0.50) * glow(abs(coord.y - w4), 0.004); // pink

    gl_FragColor = vec4(color, 6.0);
}