#ifdef GL_ES
precision mediump float;
#endif
#define PI 3.14159265359

// Width and height of the preview window
uniform vec2 u_resolution;
uniform float u_time;

//Draw a line: 
// pixelPosition = current pixel
// lineStart = start point of line
// lineEnd = End point of line

float lineDistance(vec2 pixelPosition, vec2 lineStart, vec2 lineEnd)
{
    //Vector from line start to current pixel
    vec2 pixelToStart =
    pixelPosition - lineStart;

    //Vector describing the line segment itself
    vec2 startToEnd =
    lineEnd - lineStart;

    //project pixel onto the line
    float projection =
    dot(pixelToStart, startToEnd) / dot(startToEnd, startToEnd);
    
    //Keep projection inside the segment //0 = start point //1 = end point
    projection = clamp(projection, 0.0, 1.0);

    //Closest point on the segment
    vec2 closestPoint =
    lineStart + startToEnd * projection;

    //Return distane from pixel to line
    return length(pixelPosition - closestPoint);
    
}

   


float motif(vec2 p){

    //width of fall lines
    float thickness = 0.01;

    //segment 1
    float d1 = lineDistance(p, vec2(-0.2, -0.2), vec2(0.0, 0.2));

    //segment 2
    float d2 = lineDistance(p, vec2(0.0, 0.2), vec2(0.25, -0.2));

    //segment 3
    float d3 = lineDistance(p, vec2(0.25, -0.2), vec2(0.7, -0.2));

//convert distances into visible lines

    float line1 = 1.0 - step(thickness, d1);
    float line2 = 1.0 - step(thickness, d2);
    float line3 = 1.0 - step(thickness, d3);

//Merge all segments

    return max(line1, max(line2, line3));
}


//rotate
 mat2 rotate(float angle)
    {
    //cosine and sine of angle
    float c = cos(angle);
    float s = sin(angle);

    //standard 2D rotation matrix

    return mat2(c,-s, s,c);
    }



void main()
{
// Move origin to screen center
// normalize coordinates
 vec2 uv = (2.0 * gl_FragCoord.xy - u_resolution.xy)/u_resolution.y;


//combining both lines
float shape = motif(uv);

shape = max(shape, motif(rotate(1.5708)*uv));

shape = max(shape, motif(rotate(3.14159) * uv));

shape = max(shape, motif(rotate(4.71239) * uv));




vec3 color = vec3(shape);
gl_FragColor = vec4(color, 1.0);
 

}