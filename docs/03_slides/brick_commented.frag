#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;


float BRICK_W = 0.3;  
float BRICK_H = 0.1; 
float MORTAR =  0.02; 

// HELPER FUNCTIONS
// (no need to comment these)

float getBias(float t, float bias)
{
  return (t / ((((1.0 / bias) - 2.0) * (1.0 - t)) + 1.0));
}

float getGain(float t, float gain)
{
  if(t < 0.5)
    return getBias(t * 2.0, gain) / 2.0;
  else
    return getBias(t * 2.0 - 1.0, 1.0 - gain) / 2.0 + 0.5;
}

void main()
{

    vec2 coord = gl_FragCoord.xy/u_resolution;
    

    // All parameter values between 0..1
    float brick_mortar_w = BRICK_W + MORTAR;
    float brick_mortar_h = BRICK_H + MORTAR;
    float mortar_half_norm_w = (MORTAR * 0.5) / brick_mortar_w;
    float mortar_half_norm_h = (MORTAR * 0.5) / brick_mortar_h;

    // BRICK PATTERN

    // Create the tiling
    // The value range is converted from 0..1.0
    // 0.0..number_of_tiles, where one tile
    // runs from n_tile..n_tile + 1
    float x = coord.x / brick_mortar_w;
    float y = coord.y / brick_mortar_h;

    // Shift the brick x position in 
    // every other row
    float y_index = floor(y);
    if( mod(y_index, 2.0 ) == 0.0)
    {
        x += 0.5;
    }

    // x,y should run now between 0..1 on a single brick
    // (including one-half of the mortar around the brick)
    x -= floor(x);
    y -= y_index;

    // Simplified versions:
    float w = step(mortar_half_norm_w, x) - step(1.0 - mortar_half_norm_w, x);
    float h = step(mortar_half_norm_h, y) - step(1.0 - mortar_half_norm_h, y);


    // or
    // Smooth transition at the mortar/brick boundary
    // float w = smoothstep(0.0, mortar_half_norm_w, x) 
    //            - smoothstep(1.0 - mortar_half_norm_w, 1.0, x);
    // float h = smoothstep(0.0, mortar_half_norm_h, y) 
    //            - smoothstep(1.0 - mortar_half_norm_h, 1.0, y);


    // Modify the curve with bias for a shorter white
    // and a longer darker transition
    // float w = getBias(smoothstep(0.0, mortar_half_norm_w, x), 0.3) 
    //             - getBias(smoothstep(1.0 - mortar_half_norm_w, 1.0, x), 0.7);
    // float h = getBias(smoothstep(0.0, mortar_half_norm_h, y), 0.3) 
    //             - getBias(smoothstep(1.0 - mortar_half_norm_h, 1.0, y), 0.7);
    

    // vec3 color = vec3(w*h);
    vec3 color = mix(vec3(0.2, 0.15, 0.15), vec3(0.5, 0.25, 0.2), getBias(w * h, 0.2));



    gl_FragColor = vec4(color, 1.0);

}
