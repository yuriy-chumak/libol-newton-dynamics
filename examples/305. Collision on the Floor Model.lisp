#!/usr/bin/env ol

(import
   (lib newton-dynamics)
   (lib gl-2) (lib GLU))

(gl:set-window-title "305. Cube Collision on the Floor")

; create the "world"
(define world (or
   (NewtonCreate)
   (runtime-error "Can't create newton world")))
(NewtonSetSolverIterations world 1)

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
,load "models/compound.lisp"

(define primitive (cond
   ((zero? (length *command-line*))     'cube)
   ((= (car *command-line*) "cube")     'cube)
   ((= (car *command-line*) "brick")    'brick)
   ((= (car *command-line*) "sphere")   'sphere)
   ((= (car *command-line*) "cone")     'cone)
   ((= (car *command-line*) "capsule")  'capsule)
   ((= (car *command-line*) "cylinder") 'cylinder) ; todo: add chamfer cylinder
   ((= (car *command-line*) "convex")   'convex)
   ((= (car *command-line*) "compound") 'compound)
   (else
      (runtime-error (string-append "Unknown primitive type " (car *command-line*))
         (list "Only cube, brick, sphere, cone, capsule, cylinder, convex, and compound are allowed.")))))

; ------------------------------------
; newton body creation

; 1. create collision model (the cube)
(define collision (case primitive
   ;                                    box sizes
   ('cube  (NewtonCreateBox world       1 1 1      0 #f))
   ('brick (NewtonCreateBox world       0.5 1 2    0 #f))
   ;                                    radius
   ('sphere (NewtonCreateSphere world   0.5        0 #f))
   ;
   ('cone (NewtonCreateCone world       0.5 1      0 #f))
   ;
   ('capsule (NewtonCreateCapsule world 0.2 0.5 1  0 #f))
   ;
   ('cylinder (NewtonCreateCapsule world 0.2 0.5 1 0 #f))
   ;
   ('convex (let ((vertices (monkey 'v)))
      (NewtonCreateConvexHull world (length vertices)
         (foldr (lambda (l r) (append (vector->list l) r)) #n vertices)
         (* 3 4)
         0.0 0 #f)))
   ('compound (begin
      (define O (NewtonCreateSphere world   0.5        0 #f))
      (define H1 (NewtonCreateSphere world   0.3       0 [
         1 0 0 0
         0 1 0 0
         0 0 1 0
         (* 0.60 (sin +0.5235)) (* 0.60 (cos +0.5235)) 0 1
      ]))
      (define H2 (NewtonCreateSphere world   0.3       0 [
         1 0 0 0
         0 1 0 0
         0 0 1 0
         (* 0.60 (sin -0.5235)) (* 0.60 (cos -0.5235)) 0 1
      ]))

      (define collision (NewtonCreateCompoundCollision world 0))
      (NewtonCompoundCollisionBeginAddRemove collision)
      (NewtonCompoundCollisionAddSubCollision collision O)
      (NewtonCompoundCollisionAddSubCollision collision H1)
      (NewtonCompoundCollisionAddSubCollision collision H2)
      (NewtonCompoundCollisionEndAddRemove collision)

      collision))

))

(define draw-Primitive
   (case primitive
      ('cube     (lambda () (draw-Box 1 1 1)))
      ('brick    (lambda () (draw-Box 0.5 1 2)))
      ('sphere   (lambda () (draw-Sphere 0.5)))
      ('cone     (lambda () (draw-Cone 0.5 1)))
      ('capsule  (lambda () (draw-Capsule 0.2 0.5 1)))
      ('cylinder (lambda () (draw-Cylinder 0.2 0.5 1)))
      ('convex   (lambda () (draw-Convex)))
      ('compound (lambda () (draw-Compound)))
))

; 2. create a dynamic body (body than can move)
(define cube (NewtonCreateDynamicBody world collision
      ; column-major body matrix: "all-in-one" location and rotation
      `( 1 0 0 0
         0 1 0 0
         0 0 1 0
         0 10 0 1; x y z w
      )))

; 3. set body mass
(NewtonBodySetMassProperties cube 1.0 collision)

; 4. set "apply-gravity" callback to body
;    (Oy is "up")
(define ApplyGravityCallback (NewtonApplyForceAndTorque
   (lambda (body timestep threadIndex)
      (NewtonBodySetForce body '(0 -9.8 0 0)))))

(NewtonBodySetForceAndTorqueCallback cube ApplyGravityCallback)

; 5. delete collision, we don't need it anymore
(NewtonDestroyCollision collision)


; -- floor --------------------
; reed floor model from the OBJ file
(import (owl parse))
(import (file wavefront obj))
(define floor-obj-model (parse wavefront-obj-parser (file->list "models/floor.obj") #empty))

; 1. build static collision
(define collision (NewtonCreateTreeCollision world 0))
(NewtonTreeCollisionBeginBuild collision)

;; use this for manual faces (these can be either triangles or multiangles)
;; (NewtonTreeCollisionAddFace collision 4 '(
;;    -19 0.1  19
;;     19 0.1  19
;;     19 0.1 -19
;;    -19 0.1 -19) (* 3 4) 0) ; (* 3 4) is stride, where 4 is sizeof(float)

(define vertices (list->vector (floor-obj-model 'v)))
(define normals (list->vector (floor-obj-model 'vn)))

; get triangles from the OBJ model file
(for-each (lambda (object)
      (for-each (lambda (facegroup)
            (for-each (lambda (face)
                  (define triangle (vector-map (lambda (v) (ref vertices (ref v 1))) face))
                  (define flat (foldr (lambda (tri a) (append (vector->list tri) a))
                        #null (vector->list triangle)))
                  (NewtonTreeCollisionAddFace collision 3 flat (* 3 4) 0))
               (cdr facegroup)))
         (object 'facegroups)))
   (floor-obj-model 'o))

(NewtonTreeCollisionEndBuild collision 1)
(NewtonCreateKinematicBody world collision '(1 0 0 0  0 1 0 0  0 0 1 0  0 0 0 1))
(NewtonDestroyCollision collision)

; keyboard handler
(import (lib keyboard))
(gl:set-keyboard-handler (lambda (key)
   (case key
      (KEY_ESC
         (NewtonBodySetVelocity cube [0 0 0]) ; stop moving
         (NewtonBodySetMatrix cube            ; move to start location
               ; column-major body matrix: location and rotation
               `( 1 0 0 0
                  0 1 0 0
                  0 0 1 0
                  0 10 0 1; x y z w
               )))
   )))


; draw
(define old (inexact 0.0))

(gl:set-renderer (lambda (mouse)
   ; let's calculate newtonian world
   (define now (/ (time-ms) #i1000))
   (NewtonUpdate world (min (- now old) 0.05))
   (vm:set! old now)

   ; get body matrix
   (define matrix [
      #i0 #i0 #i0 #i0
      #i0 #i0 #i0 #i0
      #i0 #i0 #i0 #i0
      #i0 #i0 #i0 #i0 ])
   (NewtonBodyGetMatrix cube matrix)

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

   ; draw the "floor" cube
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
