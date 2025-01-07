(define shader-program (gl:create-program
"  #version 120 // OpenGL 2.1

varying vec4 vertexPosition;
varying vec3 vertexNormal;

void main()
{
   vec4 vertex = gl_Vertex;
   vec3 normal = gl_Normal;

   vertexPosition = gl_ModelViewMatrix * vertex;
   vertexNormal = mat3(gl_ModelViewMatrix) * normal;

   gl_Position = gl_ProjectionMatrix * vertexPosition;
   gl_FrontColor = gl_Color;
}"

"  #version 120 // OpenGL 2.1
#define PI 3.1415927410125732421875 // IEEE754 Pi Approximation

varying vec4 vertexPosition;
varying vec3 vertexNormal;
uniform vec4 lightPosition;

void main()
{
   vec3 vertex = vertexPosition.xyz;
   vec3 normal = normalize(vertexNormal);

	vec3 eyeDirection = normalize(-vertex); // in the modelview space eye direction is just inverse of position

   vec4 diffuseTex = gl_Color;

   // vec4 lightPosition = gl_LightSource[0].position;
   vec3 lightDirection = lightPosition.xyz - vertex * lightPosition.w;

   vec3 unitLightDirection = normalize(lightDirection);

   float diffuseIntensity = max(0.2, dot(normal, unitLightDirection));

   gl_FragColor = vec4(diffuseTex.rgb * diffuseIntensity, 1.0);
}"))

(setq lightPosition (glGetUniformLocation shader-program "lightPosition"))
