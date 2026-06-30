/*
ZUSAMMENFASSUNG - Was dieser Shader macht:

1. GRUNDIDEE
   Ein roter, körniger Sprühnebel-Effekt (inspiriert von Sébastien Fraysse's 
   Spraydosen-Foto), bei dem die Maus wie eine Hand wirkt, die den Spray 
   wegdrückt und eine Aussparung erzeugt.

2. NOISE / RANDOMNESS
   - hash() ist eine Pseudo-Zufallsfunktion: aus einer Koordinate wird eine 
     zufällig aussehende Zahl zwischen 0 und 1 berechnet.
   - Diese Zufallszahl pro Pixel entscheidet ob dort ein "Sprühpunkt" 
     gezeichnet wird oder nicht -> erzeugt die körnige Textur.

3. ORGANISCHE FORM (statt Kreis)
   - Mehrere sin()-Wellen werden auf den Radius der Form addiert (wobble),
     dadurch entsteht eine wabernde, nicht-perfekt-runde Blob-Form.
   - Über u_time animiert, verändert die Form langsam ihre Gestalt.

4. SPRÜHDICHTE-VERLAUF
   - density steuert wie viele Punkte pro Bereich gezeichnet werden.
   - Im Zentrum der Form ist density hoch (viele Punkte, sattes Rot),
     nach außen hin nimmt sie smooth ab (weniger Punkte, ausgefranster Rand)
     - wie ein Sprühnebel.

5. MAUS-INTERAKTION
   - distToMouse berechnet den Abstand jedes Pixels zur Maus.
   - Innerhalb eines Radius um die Maus wird der Spray ausgeblendet 
     (mouseClear) wie eine Hand, die den Nebel wegdrückt.
   - Zusätzlich werden die Koordinaten VOR der Noise-Berechnung leicht 
     von der Maus weg verschoben (displacedCoord) das lässt den Spray 
     sichtbar "ausweichen" statt einfach nur ausgeblendet zu werden.
   - Per Dot-Produkt (towardsCenter) wird die Aussparung asymmetrisch 
     gemacht: zur Bildmitte hin ist der Übergang weicher/größer als 
     auf der Seite die von der Mitte wegzeigt.

6. FARBE
   - mix() blendet zwischen weißem Hintergrund und rotem Spray, 
     gesteuert durch den finalen spray-Wert (0 = weiß, 1 = rot).
*/

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;
uniform vec2 u_mouse;

float hash(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

void main() {
    vec2 coord = gl_FragCoord.xy / u_resolution.xy;
    coord.x *= u_resolution.x / u_resolution.y;
    
    vec2 mouse = u_mouse / u_resolution.xy;
    mouse.x *= u_resolution.x / u_resolution.y;
    
    vec2 center = vec2(0.5 * (u_resolution.x / u_resolution.y), 0.5);
    
    // Maus drückt den Spray weg
    vec2 toMouse = coord - mouse;
    float distToMouse = length(toMouse);
    vec2 displacedCoord = coord - normalize(toMouse + 0.0001) * smoothstep(0.25, 0.0, distToMouse) * 0.15;
    
    // Organische Blob-Form um die Mitte
    vec2 toCenter = displacedCoord - center;
    float wobble = sin(toCenter.x * 8.0 + u_time * 0.3) * 0.02
                 + sin(toCenter.y * 6.0 - u_time * 0.2) * 0.02;
    float blobRadius = 0.2 + wobble;
    
    // Sprühdichte fällt vom Zentrum nach außen ab
    float density = 1.0 - smoothstep(0.0, blobRadius * 1.8, length(displacedCoord - center - vec2(0.05, 0.04)));
    density *= smoothstep(blobRadius * 2.2, blobRadius * 1.5, length(toCenter));
    density = clamp(density, 0.0, 1.0);
    
    // Noise erzeugt die körnige Spray-Textur
    float n = hash(displacedCoord * 50.0 + sin(u_time * 0.0005) * 0.01);
    float spray = step(pow(1.0 - density, 1.5), n);
    
    // Maus-Aussparung, asymmetrisch zur Bildmitte
    float towardsCenter = dot(normalize(toMouse + 0.0001), normalize(center - mouse + 0.0001));
    float mouseClear = smoothstep(0.04 + towardsCenter * 0.03, 0.1 + towardsCenter * 0.03, distToMouse);
    spray *= mouseClear;
    
    vec3 color = mix(vec3(1.0), vec3(0.9, 0.1, 0.15), spray);
    gl_FragColor = vec4(color, 1.0);
}
