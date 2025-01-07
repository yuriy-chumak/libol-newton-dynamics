#!/usr/bin/env ol

(import
   (lib newton-dynamics)
   (lib gl-2) (lib GLU))

(gl:set-window-title "302. Hello World")

; create the "world"
(define world (or
   (NewtonCreate)
   (runtime-error "Can't create newton world")))
(NewtonSetSolverIterations world 1)

; opengl init
(glShadeModel GL_SMOOTH)
(glClearColor 0.11 0.11 0.11 1)
(glEnable GL_DEPTH_TEST)

(glMatrixMode GL_PROJECTION)
(glLoadIdentity)
(gluPerspective 45 (/ 854 480) 0.1 1000)

(glMatrixMode GL_MODELVIEW)
(glLoadIdentity)
(gluLookAt 15 10 20
   0 0 0
   0 1 0)

; utils
,load "cube.lisp"
,load "cube-shader.lisp"

(define sun [10 10 10 0])
; ------------------------------------
; newton body creation

; 1. create collision model (the cube)
;    "1 1 1" is box sizes
(define collision (NewtonCreateBox world  1 1 1  0  #f))

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
(define floor-obj-model (parse wavefront-obj-parser (file->list "floor.obj") #empty))

; 1. build static collision
(define collision (NewtonCreateTreeCollision world 0))
(NewtonTreeCollisionBeginBuild collision)

;; (NewtonTreeCollisionAddFace collision 4 '(
;;    -19 0.1  19
;;     19 0.1  19
;;     19 0.1 -19
;;    -19 0.1 -19) (* 3 4) 0) ; (* 3 4) is stride, where 4 is sizeof(float)

(define vertices (list->vector (floor-obj-model 'v)))
(define normals (list->vector (floor-obj-model 'vn)))

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

   ; clear frame
   (glClear (vm:ior GL_COLOR_BUFFER_BIT GL_DEPTH_BUFFER_BIT))

   ; get body matrix
   (define matrix [
      #i0 #i0 #i0 #i0
      #i0 #i0 #i0 #i0
      #i0 #i0 #i0 #i0
      #i0 #i0 #i0 #i0 ])
   (NewtonBodyGetMatrix cube matrix)

   (glUseProgram 0)

   ; apply matrix to the opengl cube
   (glPushMatrix)
   (glMultMatrixf matrix)
   (draw-Cube 1)
   (glPopMatrix)

   ; draw the "floor" cube
   (glColor3f 0.2 0.2 0.2)
   (glUseProgram shader-program)
   (glUniform4fv lightPosition 1 sun)

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