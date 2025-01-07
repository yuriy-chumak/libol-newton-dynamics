(define lighting-program (gl:create-program
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

(setq lightPosition (glGetUniformLocation lighting-program "lightPosition"))

; --------------------------------------------------------------------------
; shadows support
;
(define depth2d-program (gl:create-program
; сложим все в gl_ModelViewMatrix чтобы забрать ее из OpenGL за один заход
;  и использовать в шейдере с тенями
" #version 120 // OpenGL 2.1
   void main() {
      gl_Position = gl_ModelViewMatrix * gl_Vertex;
   }"
" #version 120 // OpenGL 2.1
   void main() {
      // nothing to do
   }"))

(define shading-program (gl:create-program
"  #version 120 // OpenGL 2.1

varying vec4 vertexPosition;
varying vec3 vertexNormal;

uniform mat4 shadowMatrix;
varying vec4 fragPosLightSpace;

void main()
{
   vec4 vertex = gl_Vertex;
   vec3 normal = gl_Normal;

   vertexPosition = gl_ModelViewMatrix * vertex;
   vertexNormal = mat3(gl_ModelViewMatrix) * normal;

   fragPosLightSpace = shadowMatrix * vertex;

   gl_Position = gl_ProjectionMatrix * vertexPosition;
   gl_FrontColor = gl_Color;
}"

"  #version 120 // OpenGL 2.1
#define PI 3.1415927410125732421875 // IEEE754 Pi Approximation

varying vec4 vertexPosition;
varying vec3 vertexNormal;
uniform vec4 lightPosition;

uniform sampler2D tex0;
varying vec4 fragPosLightSpace;

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

   // shadows:
   // perform perspective divide (не надо, если glOrtho, тогда w = 1.0)
   vec3 projCoords = fragPosLightSpace.xyz / fragPosLightSpace.w;
   // transform to [0,1] range
   projCoords = projCoords * 0.5 + 0.5;
   // get closest depth value from light's perspective (using [0,1] range fragPosLight as coords)
   float closestDepth = texture2D(tex0, projCoords.xy).r;
   // get depth of current fragment from light's perspective
   float currentDepth = projCoords.z;

   // check whether current frag pos is in shadow
   float bias = 0.0005;
   //float bias = max(0.05 * (1.0 - dot(normal, lightDirection)), 0.005);
   float shadow = (currentDepth - bias) > closestDepth ? 0.2 : 1.0;
   float less = currentDepth > closestDepth ? 0.2 : 1.0;

   gl_FragColor = vec4(diffuseTex.rgb * min(shadow, diffuseIntensity), 1.0);
}"))

; prepare depthmap
(import (OpenGL EXT framebuffer_object))

(define TEXW 512)
(define TEXH 512)
; depth 2d map framebuffer
(define depthmap2d (box 0))
(glGenTextures (length depthmap2d) depthmap2d)
(print "depthmap2d: " depthmap2d)
(glBindTexture GL_TEXTURE_2D (car depthmap2d))
(glTexParameteri GL_TEXTURE_2D GL_TEXTURE_WRAP_S GL_REPEAT)
(glTexParameteri GL_TEXTURE_2D GL_TEXTURE_WRAP_T GL_REPEAT)
(glTexParameteri GL_TEXTURE_2D GL_TEXTURE_MAG_FILTER GL_NEAREST)
(glTexParameteri GL_TEXTURE_2D GL_TEXTURE_MIN_FILTER GL_NEAREST)
(glTexImage2D GL_TEXTURE_2D 0 GL_DEPTH_COMPONENT TEXW TEXH 0 GL_DEPTH_COMPONENT GL_FLOAT #f)
(glBindTexture GL_TEXTURE_2D 0)

(define depthfbo2d (box 0))
(glGenFramebuffers (length depthfbo2d) depthfbo2d)
(print "depthfbo2d: " depthfbo2d)
(glBindFramebuffer GL_FRAMEBUFFER (car depthfbo2d))
(glFramebufferTexture2D GL_FRAMEBUFFER GL_DEPTH_ATTACHMENT GL_TEXTURE_2D (car depthmap2d) 0)
(glDrawBuffer GL_NONE)
(glReadBuffer GL_NONE)
(glBindFramebuffer GL_FRAMEBUFFER 0)

(define shadowmatrix [
   #i1 #i0 #i0 #i0
   #i0 #i1 #i0 #i0
   #i0 #i0 #i1 #i0
   #i0 #i0 #i0 #i1
])

(define (prepare-shadows renderer)
   ; render sun depth buffer
   (glBindFramebuffer GL_FRAMEBUFFER (unbox depthfbo2d))
   (glViewport 0 0 TEXW TEXH)
   (glClear GL_DEPTH_BUFFER_BIT)

   (glMatrixMode GL_MODELVIEW)
   (glLoadIdentity)
   (glOrtho -10 10 -10 10 0 40)
   (gluLookAt
      (ref sun 1) ; x
      (ref sun 2) ; y
      (ref sun 3) ; z
      0 0 0 ; sun is directed light
      0 1 0) ; up is 'z'
   (glGetDoublev GL_MODELVIEW_MATRIX shadowmatrix)

   (glDisable GL_CULL_FACE)

   (glUseProgram depth2d-program)
   (renderer)

   ; done
   (glBindFramebuffer GL_FRAMEBUFFER 0))

(define (apply-shadowmap)
   (define tex0 (glGetUniformLocation shading-program "tex0"))
   (define lightPosition (glGetUniformLocation shading-program "lightPosition"))
   (define shadowMatrix (glGetUniformLocation shading-program "shadowMatrix"))

   (glUniform4fv lightPosition 1 sun)
   (glUniformMatrix4fv shadowMatrix 1 #f shadowmatrix)

   (glActiveTexture GL_TEXTURE0)
   (glBindTexture GL_TEXTURE_2D (car depthmap2d))
   (glUniform1i tex0 0))
