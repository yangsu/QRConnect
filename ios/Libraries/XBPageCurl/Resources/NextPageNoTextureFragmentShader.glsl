precision mediump float;

varying vec2 v_position;

uniform vec2 u_cylinderPosition;
uniform vec2 u_cylinderDirection;
uniform float u_cylinderRadius;

#define M_PI 3.14159265358979323846264338327950288

void main()
{
    vec2 dir = vec2(u_cylinderDirection.y, -u_cylinderDirection.x);
    vec2 v = v_position - u_cylinderPosition;
    float d = dot(v, dir);
    float l = 0.0;

    if (d < 2.0*u_cylinderRadius) {
        float a = (d/(2.0*u_cylinderRadius))*M_PI;
        l = (cos(a) + 1.0)*0.5;
    }

    gl_FragColor = vec4(0.0, 0.0, 0.0, l);
}
