#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;


float BRICK_W = 0.3;  
float BRICK_H = 0.1; 
float MORTAR =  0.0; 

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
    // vec3 color = mix(vec3(0.2, 0.15, 0.15), vec3(0.5, 0.25, 0.2), getBias(w * h, 0.2));


    float brick_mask = w * h; // 1 only where both w and h are 1 (inside the brick)

    //START CIRCLES

    // The sizing of the cell we want to create now
    float a = 0.5 - mortar_half_norm_w; 
    float b = 1.0 - mortar_half_norm_h; 


    // VERSION 1 - The long and windy road ;)
    // Translate so the ellipse center (0.5, 1.0) becomes the origin
    float dx = x - 0.5;
    float dy = y - 1.0;

    // Scale to map the ellipse to a unit circle
    float sx = dx / a;
    float sy = dy / b;

    // Square each component
    float sx2 = sx * sx;
    float sy2 = sy * sy;

    // Sum them — this is the left side of ((x-cx)/a)^2 + ((y-cy)/b)^2
    float ellipse_eq = sx2 + sy2;

    // Inside the ellipse when ellipse_eq < 1.0, on the boundary when == 1.0
    float ellipse = ellipse_eq < 1.0 ? 1.0 : 0.0;

     // VERSION 2 - The fancy version
    // vec2 p = vec2((x - 0.5) / a, (y - 1.0) / b);

    // length(p) -> computes sqrt(p.x^2 + p.y^2), which is sqrt(ellipse_eq) 
    // and sqrt(sx2 + sy2) < 1.0 equals sx2 + sy2 < 1.0
    // step(1.0, ...) returns 1 when length is greater than or equal 
    // to 1 (outside the ellipse) and 0 when it is less than 1 (inside)
    // The 1.0 - ... flips it so the inside is 1 and the outside is 0.
    // float ellipse = 1.0 - step(1.0, length(p));
    
    // Restrict the ellipse to the brick area so it never bleeds into the mortar
    float shape = ellipse * brick_mask;


    vec3 mortar_color  = vec3(1.0, 0.0, 0.0); // red mortar gap
    vec3 brick_color   = vec3(0.0, 0.8, 1.0); // cyan brick background
    vec3 ellipse_color = vec3(0.0, 1.0, 0.8); // teal ellipse fill

    vec3 color = mortar_color;

    // Alternate the brick/ellipse color assignment between even and odd rows
    if (mod(y_index, 2.0) == 0.0) {
        color = mix(color, brick_color,   brick_mask); // paint the brick area
        color = mix(color, ellipse_color, shape);      // paint the ellipse on top
    } else {
        color = mix(color, ellipse_color, brick_mask); // swap: ellipse color fills the brick
        color = mix(color, brick_color,   shape);      // swap: brick color fills the ellipse
    }

    gl_FragColor = vec4(color, 1.0);

    // gl_FragColor = vec4(vec3(x*y), 1.0);
    // gl_FragColor = vec4(vec3(abs(p.x)), 1.0);
    // gl_FragColor = vec4(vec3(abs(p.x * p.y)), 1.0);
    // gl_FragColor = vec4(vec3(ellipse), 1.0);
}
