#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;

void main(){
    vec2 coord=(2.*gl_FragCoord.xy-u_resolution.xy)/u_resolution;
    
    //Initialise Mouse
    vec2 uv=gl_FragCoord.xy/u_resolution;
    vec2 m=u_mouse/u_resolution;
    float b=length(uv-m);
    float influence=smoothstep(.35,0.,b*1.2);//Adjust mouse radius
    
    //Tiling
    float CELLSIZE=.5;
    vec2 xy=coord/CELLSIZE;
    xy-=floor(xy);//Activate tiling
    vec2 xy_remap=abs(xy-.5)*2.;
    
    //Flower Shape
    vec2 pos=-xy_remap;
    float a=atan(pos.y,pos.x);
    float r=length(pos)*1.;//length of leaves
    float f=cos(a*9.);//First Flower
    float f2=cos(a*20.);//Second Flower
    
    //Initial circle pattern
    float d=distance(xy_remap,vec2(.7));
    d*=1.9;
    d-=floor(d/(3.*influence));
    
    //Colors
    vec3 color=mix(vec3(.9569,.5804,.5804),vec3(.8902,.5569,.0588),d);
    vec3 color2=vec3(.99-smoothstep(f,f*.9,r*1.25));
    vec3 color3=vec3(.4-smoothstep(f2,f2*.99,r*3.));
    
    gl_FragColor=vec4(mix(color,color2,color3),1.);
}
