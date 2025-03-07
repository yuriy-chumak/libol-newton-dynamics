#!/usr/bin/env ol

(import
   (lib newton-dynamics-4)
   (lib gl-2) (lib GLU))

(gl:set-window-title "404. Cube Collision")

; create the "world"
(define world (or
   (Newton:CreateWorld)
   (runtime-error "Can't create newtonian world.")))
(NewtonWorld:SetSubSteps world 2)

; opengl init
(glShadeModel GL_SMOOTH)
(glClearColor 0.11 0.11 0.11 1)
(glEnable GL_DEPTH_TEST)

(define sun [3 10 10 0])

; primitive types and drawing
,load "cube-shader.lisp"
,load "models/box.lisp"
,load "models/sphere.lisp"
,load "models/cone.lisp"
,load "models/capsule.lisp"
,load "models/cylinder.lisp"
,load "models/convex.lisp"

(define primitive (cond
   ((zero? (length *command-line*))     'cube)
   ((= (car *command-line*) "cube")     'cube)
   ((= (car *command-line*) "brick")    'brick)
   ((= (car *command-line*) "sphere")   'sphere)
   ((= (car *command-line*) "cone")     'cone)
   ((= (car *command-line*) "capsule")  'capsule)
   ((= (car *command-line*) "cylinder") 'cylinder) ; todo: add chamfer cylinder
   ((= (car *command-line*) "convex")   'convex)
   (else
      (runtime-error (string-append "Unknown primitive type " (car *command-line*))
         (list "Only cube, brick, sphere, cone, capsule, cylinder, convex, and compound are allowed.")))))

; ------------------------------------
; newton body creation

; 1. create shape model
(define shape (case primitive
   ;                                 box sizes
   ('cube  (Newton:CreateBox         1.0 1.0 1.0))
   ('brick (Newton:CreateBox         0.5 1.0 2.0))
   ;                                 radius
   ('sphere (Newton:CreateSphere     0.5))
   ;                                 radius height
   ('cone (Newton:CreateCone         0.5    1.0))
   ;
   ('capsule (Newton:CreateCapsule   0.3 0.5 1))
   ;
   ('cylinder (Newton:CreateCylinder 0.3 0.5 1))
   ;
   ('convex (let ((vertices (monkey 'v)))
      (Newton:CreateConvexHull (length vertices) (* 3 4) 0
         (foldr (lambda (l r) (append (vector->list l) r)) #n vertices))))

))

(define draw-Primitive
   (case primitive
      ('cube     (lambda () (draw-Box 1.0 1.0 1.0)))
      ('brick    (lambda () (draw-Box 0.5 1.0 2.0)))
      ('sphere   (lambda () (draw-Sphere 0.5)))
      ('cone     (lambda () (draw-Cone 0.5 1)))
      ('capsule  (lambda () (draw-Capsule 0.3 0.5 1)))
      ('cylinder (lambda () (draw-Cylinder 0.3 0.5 1)))
      ('convex   (lambda () (draw-Convex)))
))

; 2. create a dynamic body (body than can move) TODO: rename "cube" to "object" or smth
(define cube (Newton:CreateDynamicBody shape 1.0))

; 3. set body location and rotation
(NewtonBody:SetMatrix cube [
   1 0 0 0
   0 1 0 0
   0 0 1 0
   0 9 0 1 ; x y z w
])

; 4. set "apply-gravity" callback to body
;    (Oy is "up")
(define ApplyGravityCallback (ApplyExternalForceCallback
   (lambda (body timestep threadIndex)
      (NewtonBody:SetForce body '(0 -9.8 0 0))
   )))
(NewtonBody:SetApplyExternalForceCallback cube ApplyGravityCallback)

; 5. delete shape, we don't need it anymore
;; (NewtonDestroyCollision collision)

; 6. add our body to the world !
(NewtonWorld:AddBody world cube)

; -- floor --------------------
; reed floor model from the OBJ file
(import (owl parse))
(import (file wavefront obj))
(define floor-obj-model (parse wavefront-obj-parser (file->list "models/floor.obj") #empty))
(define vertices (list->vector (floor-obj-model 'v)))
(define normals (list->vector (floor-obj-model 'vn)))

; get triangles from the OBJ model file
(define builder (Newton:CreatePolygonSoupBuilder))

(PolygonSoupBuilder:Begin builder)
(for-each (lambda (object)
      (for-each (lambda (facegroup)
            (for-each (lambda (face)
                  (define triangle (vector-map (lambda (v) (ref vertices (ref v 1))) face))
                  (define flat (foldr (lambda (tri a) (append (vector->list tri) a))
                        '() (vector->list triangle)))
                  (PolygonSoupBuilder:AddFace builder flat (* 3 4) 3 0))
               (cdr facegroup)))
         (object 'facegroups)))
   (floor-obj-model 'o))
(PolygonSoupBuilder:End builder #f)

(define shape (Newton:CreateStatic builder))
(define floor (Newton:CreateKinematicBody shape))
(NewtonBody:SetMatrix floor [
      1 0 0 0
      0 1 0 0
      0 0 1 0
      0 0 0 1; x y z w
   ])
(NewtonWorld:AddBody world floor)
;; (NewtonDestroyCollision collision)


; keyboard handler
(import (lib keyboard))
(gl:set-keyboard-handler (lambda (key)
   (case key
      (KEY_ESC
         (NewtonBody:SetVelocity cube [0 0 0 0]) ; stop moving
         (NewtonBody:SetMatrix cube              ; move to start location
               ; column-major body matrix: location and rotation
               `( 1 0 0 0
                  0 1 0 0
                  0 0 1 0
                  0 9 0 1; x y z w
               )))
   )))


; draw
(define old (inexact 0.0))

(gl:set-renderer (lambda (mouse)
   ; let's calculate newtonian world
   (define now (/ (time-ms) #i1000))
   (NewtonWorld:Update world (min (- now old) 0.05))
   (vm:set! old now)

   (NewtonWorld:Sync world)

   ; get body matrix
   (define matrix [
      #i0 #i0 #i0 #i0
      #i0 #i0 #i0 #i0
      #i0 #i0 #i0 #i0
      #i0 #i0 #i0 #i0 ])
   (NewtonBody:GetMatrix cube matrix)

   ; --- depth support -----
   (prepare-shadows (lambda ()
      (glPushMatrix)
      (glMultMatrixf matrix)
      (draw-Primitive)
      (glPopMatrix)
   ))

   ;; ---------------------------------
   ;; scene rendering
   (glViewport 0 0 (gl:get-window-width) (gl:get-window-height))
   (glClear (vm:ior GL_COLOR_BUFFER_BIT GL_DEPTH_BUFFER_BIT))
   (glEnable GL_CULL_FACE)

   (glMatrixMode GL_PROJECTION)
   (glLoadIdentity)
   (gluPerspective 45.0
      (/ (gl:get-window-width) (gl:get-window-height))
      0.1 1000)

   (glMatrixMode GL_MODELVIEW)
   (glLoadIdentity)
   (gluLookAt 15 10 20
      0 0 0
      0 1 0)

   ; apply matrix to the opengl cube
   (glUseProgram lighting-program)
   (glUniform4fv lightPosition 1 sun)

   (glPushMatrix)
   (glMultMatrixf matrix)
   (draw-Primitive)
   (glPopMatrix)

   ; draw the "floor" model
   (glColor3f 0.2 0.2 0.2)
   (glUseProgram shading-program)
   (apply-shadowmap)
   (glUniformMatrix4fv modelMatrix 1 #false [
      1  0  0  0
      0  1  0  0
      0  0  1  0
      0  0  0  1 ])

   (glBegin GL_TRIANGLES)
   (for-each (lambda (object)
         (for-each (lambda (facegroup)
               (for-each (lambda (face)
                     (vector-for-each (lambda (v)
                           (define vertex (ref vertices (ref v 1)))
                           (define normal (ref normals (ref v 3)))
                           (glNormal3fv normal)
                           (glVertex3fv vertex))
                        face))
                  (cdr facegroup)))
            (object 'facegroups)))
      (floor-obj-model 'o))
   (glEnd)

   ; draw xyz axis
   (glUseProgram 0)
   (glBegin GL_LINES)
      (glColor3f 1 0 0)
      (glVertex3f -1 0 0)
      (glVertex3f 10 0 0)
      (glColor3f 0 1 0)
      (glVertex3f 0 -1 0)
      (glVertex3f 0 10 0)
      (glColor3f 0 0 1)
      (glVertex3f 0 0 -1)
      (glVertex3f 0 0 10)
   (glEnd)
))

(print "Press [ESC] to reset cube position")
