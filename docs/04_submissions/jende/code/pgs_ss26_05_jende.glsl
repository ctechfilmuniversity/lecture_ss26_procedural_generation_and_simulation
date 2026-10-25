#ifdef GL_ES
precision highp float;
#endif

uniform vec2 u_resolution;// Retrieving screen resolution
uniform vec2 u_mouse;//Retrieving mouse position on screen
uniform float u_time;//Retrieving elapsed time

//-------------------------------------------------
// Grid Settings for 2D and 3D flowers
//-------------------------------------------------
const float cell=.6;// cell size in world
const float cam=2.5;// camera distance from origin
const float focal=2.;// focal length of camera

//-------------------------------------------------
// Size Settings for 3D flower
//-------------------------------------------------
const float f3=.42;//size of 3D flower
const float f3_scale=cell*f3;// uniform scale of the 3D flower in world units
const float f3_slab=.27*f3_scale;// half of length of a zone in which the 3D flower can be placed; improve performance for SDF calculation

//-------------------------------------------------
// Tiling of screen
//-------------------------------------------------
vec2 tiling(vec2 corner){
    vec2 xy=corner/cell;
    xy-=floor(xy);//Activates tiling, x,y resets to 0/1
    return abs(xy-.5);// mirror across both axes
}

//-------------------------------------------------
// 3D flower edge and SDF setup
//-------------------------------------------------
float sdFlower(vec2 p,float beat){//approximates a signed distance to the 3D flowers outline
    
    float r=length(p);//Length/radius of leaves/distance of point from flower center.
    float a=atan(p.y,p.x);//Angle for leaf
    float f=cos(a*11.);//petal count; Swings between -1 and +1 eleven times around the circle, which creates 11 petals
    
    float breathe=1.+2.25*sin(beat);// petals scale according to wobble
    
    return r-(.4+.15*f*breathe);//returns leaves radius substracted from current edge, resulting in signed distance value
}

//-------------------------------------------------
// Extrusion and bevel function for 3D flower
//-------------------------------------------------
float opExtrude(vec3 p,float dist2d,float height,float bevel){
    vec2 w=vec2(dist2d,abs(p.z)-height);// w.x = distance to the 2D outline; w.y = how far the point is beyond the top/bottom faces (abs(p.z) mirrors both faces).
    float baseDist=min(max(w.x,w.y),0.)+length(max(w,0.));//first part is the (negative) distance inside, the second is the distance outside
    return baseDist-bevel;//apply bevel
}
//-------------------------------------------------
// Set 3D flower at center of every cell
//-------------------------------------------------
float map(in vec3 pos){
    vec2 center=(floor(pos.xy/cell)+.5)*cell;//World-space center of the cell this point is in
    float beat=u_time*2./3.-length(center)*2.;//time is delayed by the cells distance from the screen center so pulse travels outward
    
    float f3_s=f3_scale*(1.+.1*sin(-beat));//Current flower scale; sin(-beat) is opposite in phase to the flower breathe, so body shrinks while the petals grow
    vec3 q=vec3(pos.xy-center,pos.z)/f3_s;// offset from this cell's center
    
    float d2d=sdFlower(q.xy,beat);//Signed distance to the 2D petal outline in flower units
    float d=opExtrude(q,d2d,.005,.15);//Extrude the flower outline, including bevel (.15)
    return d*f3_s;//Multiply back by s to convert the distance to world units, so the ray marcher steps correctly.
}

//-------------------------------------------------
// Normal Calculation of 3D flower
//-------------------------------------------------
vec3 calcNormal(in vec3 pos){
    
    const float ep=.0001;
    vec2 e=vec2(1.,-1.)*.5773;
    return normalize(
        e.xyy*map(pos+e.xyy*ep)+
        e.yyx*map(pos+e.yyx*ep)+
        e.yxy*map(pos+e.yxy*ep)+
        e.xxx*map(pos+e.xxx*ep));
    }
    
    //Anti-aliasing
    #define anti_a 2//each pixel is rendered 2x2 = 4 times with sub-pixel offsets and averaged
    
    void main(){
        
        //coordinates
        vec2 center=.2*(2.*gl_FragCoord.xy-u_resolution)/u_resolution.y;//center of screen
        vec2 corner=(2.*gl_FragCoord.xy-u_resolution)/u_resolution.y*(cam/focal);//Same centered coordinates, multiplied by cam/focal to place 3d flowers on top of 2d flowers
        
        //animation/interaction parameters
        vec2 m=u_mouse/u_resolution;//mouse position in relation to screen resolution
        float t=u_time/3.;//animation time
        
        //Flower Shape (same tiling function as the 3D flower)
        vec2 pos=-tiling(corner);//Mirrored in-cell coordinate
        float a=atan(pos.y,pos.x);//Angle for leaf
        float r=length(pos);//Length/radius of leaves
        float noise=pow(10.,mix(1.,5.,clamp(m.y,0.,1.)));//mouse dependent petal count to create sleek or noisy look
        float f=cos(a*noise);//First Flower - cosine creates leaves, number is number of wave oscillation
        float f2=cos(a*15.);//Second Flower
        
        //2D flower 1 and 2 color
        vec3 colorf=vec3(.99-smoothstep(f,f*.9,r*1.25));//color of 2D flower 1
        vec3 colorf2=vec3(.4-smoothstep(f2,f2*.99,r*3.));//color of 2D flower 2
        
        //2D flowers color mix
        vec3 color=mix(colorf2,colorf,colorf2);
        
        //wobble variables
        float rota=-2.;//rotation influence for wobble animation
        vec3 c=vec3(0.);
        vec3 z=vec3(0,1.5,3.5);//influence values for every color channel(rgb) in wobble
        
        //wobble loop
        for(float i=0.;i<3.;i++)
        {
            t+=1.;//each iteration advanced by 1
            
            center=center*mat2(cos(a),sin(a*rota),-sin(a*rota),cos(a*rota));//Twist the coordinates by an angle based on the centers own angle
            center+=cos(5./exp(dot(center,center)*25.)+((t/.5)+20.));//wobble: exp makes the phase depend on distance from the center and time animates it
            
            c[int(i)]=.01*(t*5.)/length(mod(pos,1.)-1.);//color offset: i = 0 writes red, iteration 1 writes green, divided by the distance from the cell center
            
            color+=(cos(z/9.+m.x))/length((.25+i/dot(f,f2))*sin((r)*pos/(.4-dot(center,center))-.9*pos.yx+t));//Add wobble to the color; first part influences the channels tint, divided by the length creates glowing effect/multiplied by sin(...) applies ripples
        }
        
        vec3 colorfinal=color-c*vec3(1.,1.5,3.);//Subtract the darkening vlaues from c
        
        colorfinal=20./(min(colorfinal,601.)+200./colorfinal)-dot(f2,f)/20.;//compresses the color range with a reciprocal curve (capped at 601), then subtracts f*f2/20 (dot of two floats is just a product) for some extra variation.
        
        // 3D Flower Ray-Marching
        vec2 fragCoord=gl_FragCoord.xy;
        vec3 tot=vec3(0.);
        
        //Antialiasing
        #if anti_a>1//Perform anti-aliasing loops only when anti_a is greater than 1.
        for(int m=0;m<anti_a;m++)
        for(int n=0;n<anti_a;n++){
            vec2 o=vec2(float(m),float(n))/float(anti_a)-.5;
            vec2 p=(-u_resolution.xy+2.*(fragCoord+o))/u_resolution.y;
            #else
            vec2 p=(-u_resolution.xy+2.*fragCoord)/u_resolution.y;
            #endif
            
            // Camera setup
            vec3 cam_p=vec3(0.,0.,cam);//the camera position
            vec3 rd=normalize(vec3(p,-focal));//Ray direction: from the camera through p
            
            float r_max=(cam_p.z+f3_slab)/-rd.z;//Ray only needs to be marched from where it enters the flower slab and its end
            float rm=(cam_p.z-f3_slab)/-rd.z;//distance along ray, marching start
            bool hit=false;
            
            //Ray-Marching loop
            for(int i=0;i<96;i++){
                vec3 pos=cam_p+rm*rd;//Current 3D point on the ray
                float h=map(pos);//Distance from this point to the nearest flower.
                if(abs(h)<.001){hit=true;break;}//stop marching at threshold .001
                rm+=h*.5;
                if(rm>r_max)break;//stop marchging when hitting max threshold
            }
            
            vec3 col=colorfinal;//liquid flower pattern
            
            // Lighting/Coloring
            if(hit){//Only shade when the ray hit a flower.
                vec3 pos=cam_p+rm*rd;//hit point.
                vec3 nor=calcNormal(pos);//Surface normal at the hit point.
                
                //lighting
                float dif=clamp(dot(nor,normalize(colorfinal.rgb)),.0,1.);//lighting changes with animation color
                
                // Flower coloring: liquid color scaled by lighting
                col=colorfinal*(dif+.8);
            }
            
            col=sqrt(col);//Gamma correction
            tot+=col;
            #if anti_a>1
        }
        tot/=float(anti_a*anti_a);
        #endif
        
        gl_FragColor=vec4(tot,1.);
    }
    