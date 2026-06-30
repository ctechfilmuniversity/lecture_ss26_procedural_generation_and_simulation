#ifdef GL_ES
precision mediump float;
#endif
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

float random(vec2 coord,float mx,float my){
    return fract(sin(dot(coord.xy,vec2(10.1,0.)))*(2.*(mx*1.8)));
}

vec4 valueNoise(vec2 pos,float rnd){
    float cell=.1+rnd*5.;
    vec2 xy=pos/cell;
    xy-=floor(xy);
    vec2 xy_remap=abs(xy-.5)*2.;
    float d=distance(xy_remap,vec2(.7));
    return vec4(mix(vec3(.4157,.6902,.7373),vec3(.0588,.4863,.8902),d),1.);
}

float randomParticle(vec2 p){
    return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453123);
}

float particles(vec2 particlePos,float cellSize,float dotSize){
    vec2 grid=particlePos/(cellSize/8.);
    vec2 cellId=floor(grid);// Cell number
    vec2 cellPos=fract(grid);// position within the cell, 0..1
    
    // random position for the dot inside this cell
    vec2 randomPoint=vec2(randomParticle(cellId),randomParticle(cellId));
    
    float dist=distance(cellPos,randomPoint);
    return smoothstep(dotSize,0.,dist);// 1.0 near the point, 0.0 away from it
}

void main(){
    vec2 coord=gl_FragCoord.xy/u_resolution.y;
    vec2 pos=coord+.5*u_time;
    vec2 particlePos=coord+vec2(0.,.4*u_time);
    float mx=(u_mouse.x/u_resolution.x);
    float my=(u_mouse.y/u_resolution.y);
    
    float rnd=random(coord,mx,my);
    vec4 texColor=valueNoise(pos,rnd);
    
    float dots=particles(particlePos,.1,(1.-mx)*.1);// adjust cellSize/dotSize to taste
    
    vec3 finalColor=mix(texColor.rgb,vec3(1.),dots);
    gl_FragColor=vec4(finalColor,1.);
}