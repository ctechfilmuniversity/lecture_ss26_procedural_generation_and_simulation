#ifdef GL_ES
precision mediump float;
#endif
#define PI 3.14159265359

uniform vec2 u_resolution;
uniform float u_time;
uniform vec2 u_mouse;

float polygon(vec2 uv, vec2 center, float radius, float sides) {
    vec2 p = uv - center;
    float a = atan(p.y, p.x);
    float r = 6.28318 / sides;
    float d = cos(floor(0.5 + a / r) * r - a) * length(p);
    return d - radius;
}
void main() {
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;
    vec2 bigUV = uv;
    uv = uv * 5.0;
    uv = fract(uv);
    uv = uv - 0.5;

 vec2 mouse = (u_mouse * 2.0 - u_resolution.xy) / u_resolution.y;
    //float d = polygon(uv, vec2(0.0,0.0), 0.4, 2.0 + 2.0 * u_time);
   // float shape = 1.0 - smoothstep(0.0, 0.2, d);

float circleDist = distance(bigUV, vec2(mouse));
    float circle = 1.0 - smoothstep(0.7, 0.2, circleDist);
    float r = mix(0.2,1.45, circle); 

    float d = polygon(uv*abs(sin(u_time)), vec2(0.0,0.0), r*0.3, 3.0 + 3.0* abs(sin(u_time)));
            float shape = 1.0 - smoothstep(0.0, 0.2, d);
    float blended = shape + circle;
    vec3 color = mix(vec3(1.0, 0.702, 0.0549), vec3(1.0, 0.5686, 0.0), shape);
    color = mix (color,vec3(0.2196, 0.4275, 0.298), shape*circle);
    
    gl_FragColor = vec4(color, 1.0);
}

