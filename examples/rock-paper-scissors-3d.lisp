#!/usr/bin/env ol

; options
(define S 4)
(define-values (W H D) (values (* S 12) (* S 12) (* S 12)))
(define speed 12)

(define N 10)


; gl
(import (lib gl))
(gl:set-window-title "Rock Paper Scissors")
(let ((ws 80))
   (gl:set-window-size (* ws 16) (* ws 9)))
(import (OpenGL 1.0))

(import (lib GLU))
(import (lib newton-dynamics))
(import (lib soil))
(import (scheme inexact))

(define world (or
   (NewtonCreate)
   (runtime-error "Can't create newtonian world" #f)))
(print "NewtonGetMemoryUsed = " (NewtonGetMemoryUsed))

; создадим "пол"
(define collision (or
   (NewtonCreateTreeCollision world 0)
   (runtime-error "Can't create background" #f)))
(NewtonTreeCollisionBeginBuild collision)

; пол
(NewtonTreeCollisionAddFace collision 4 [
   0 0 0
   W 0 0
   W H 0
   0 H 0 ] (* 3 4) 0) ; (* 3 4) is a stride

(NewtonTreeCollisionAddFace collision 4 [
   0 0 D
   0 H D
   W H D
   W 0 D] (* 3 4) 0)

; стены
(for-each (lambda (a b)
      (vector-apply a (lambda (ax ay)
      (vector-apply b (lambda (bx by)
         (NewtonTreeCollisionAddFace collision 4 [
            ax ay 0
            ax ay D
            bx by D
            bx by 0 ] (* 3 4) 0))))))
   (list [0 0] [W 0] [W H] [0 H])
   (list [W 0] [W H] [0 H] [0 0]) )

(NewtonTreeCollisionEndBuild collision 1)
(define cell
(NewtonCreateDynamicBody world collision [
   1 0 0 0
   0 1 0 0
   0 0 1 0
   0 0 0 1]))
(NewtonBodySetLinearDamping cell 0)
(NewtonBodySetAngularDamping cell [0 0 0])
(NewtonDestroyCollision collision)

; default gravity callback
(define ApplyGravityCallback (NewtonApplyForceAndTorque
   (lambda (body timestep threadIndex)
      ;; (NewtonBodySetForce body [0 0 -9.8])

      (define v [#i0 #i0 #i0])
      (NewtonBodyGetVelocity body v)
      (vector-apply v (lambda (x y z)
         (define q (/ speed (sqrt (inexact (+ (* x x) (* y y) (* z z))))))
         (if (finite? q)
            (NewtonBodySetVelocity body [(* x q) (* y q) (* z q)]) )))

      (NewtonBodySetOmega body [0 0 0])
      (NewtonBodySetTorque body [0 0 0])

   1)))

(define OnBodyAABBOverlap (NewtonOnAABBOverlap
   (lambda (contact timestep threadIndex)
      (call/cc (lambda (return)
         (define body1 (NewtonJointGetBody0 contact))
         (define body2 (NewtonJointGetBody1 contact))

         (define sphere1 (vm:deref (NewtonBodyGetUserData body1)))
         (define sphere2 (vm:deref (NewtonBodyGetUserData body2))) ))

   1)))

(define OnContactCollision (NewtonContactsProcess
   (lambda (joint timestep threadIndex)
      (define body1 (NewtonJointGetBody0 joint))
      (define body2 (NewtonJointGetBody1 joint))

      (define sphere1 (vm:deref (NewtonBodyGetUserData body1)))
      (define sphere2 (vm:deref (NewtonBodyGetUserData body2)))

      (when (and sphere1 sphere2)
         (define new (cond
            ((and (eq? (sphere1 'state #f) 'rock   ) (eq? (sphere2 'state #f) 'paper  )) 'paper)
            ((and (eq? (sphere1 'state #f) 'rock   ) (eq? (sphere2 'state #f) 'scissor)) 'rock)
            ((and (eq? (sphere1 'state #f) 'paper  ) (eq? (sphere2 'state #f) 'rock   )) 'paper)
            ((and (eq? (sphere1 'state #f) 'paper  ) (eq? (sphere2 'state #f) 'scissor)) 'scissor)
            ((and (eq? (sphere1 'state #f) 'scissor) (eq? (sphere2 'state #f) 'rock   )) 'rock)
            ((and (eq? (sphere1 'state #f) 'scissor) (eq? (sphere2 'state #f) 'paper  )) 'scissor)))

         (when new
            (put! sphere1 'state new)
            (put! sphere2 'state new)))

      1)))


(import (srfi 27))
(define d 3)
(define w (- W d))
(define h (- H d))
(define s 3)

(define collision (NewtonCreateSphere world 0.5 0 #f))
(define defaultMaterialID (NewtonMaterialGetDefaultGroupID world))

(define dx (/ W (+ N 1)))
(define dy (/ H (+ N 1)))
(define dz (/ D (+ N 1)))

(define spheres
   (fold append '()
   (map (lambda (x)
      (fold append '()
      (map (lambda (y)
            (map (lambda (z)
                  (define body (NewtonCreateDynamicBody world collision [
                     1 0 0 0
                     0 1 0 0
                     0 0 1 0
                     x y z 1 ]))
                  (NewtonBodySetMassProperties body 1.0 collision)
                  (NewtonBodySetForceAndTorqueCallback body ApplyGravityCallback)
                  (NewtonMaterialSetCollisionCallback world defaultMaterialID defaultMaterialID OnBodyAABBOverlap OnContactCollision)

                  (NewtonBodySetLinearDamping body 0)
                  (NewtonBodySetAngularDamping body [0 0 0])

                  (define sphere {
                     'body body
                     'state (vector-ref ['rock 'paper 'scissor] (random-integer 3))
                  })
                  (NewtonBodySetUserData body (vm:pin sphere))
                  sphere)
            (iota N dz dz)))
         (iota N dy dy))))
      (iota N dx dx))))
(print 1)
(NewtonDestroyCollision collision)

; draw spheres
(define gl-sphere (gluNewQuadric))
(gluQuadricDrawStyle gl-sphere GLU_FILL)
;(gluQuadricDrawStyle gl-sphere GLU_SILHOUETTE)
(define (glSphere)
   (gluSphere gl-sphere 0.5 16 8))

(import (lib keyboard))
(gl:set-keyboard-handler (lambda (key)
   (if (eq? key KEY_ESC)
      (for-each (lambda (sphere)
            (define u (* s (- (random-real) 0.5)))
            (define v (* s (- (random-real) 0.5)))
            (define w (* s (- (random-real) 0.5)))
            (NewtonBodySetVelocity (getf sphere 'body) [u v w]))
         spheres))))

; init
(glShadeModel GL_SMOOTH)
(glClearColor 0.11 0.11 0.11 1)

(glEnable GL_DEPTH_TEST)

(glEnable GL_LIGHTING)
(glLightModelf GL_LIGHT_MODEL_TWO_SIDE GL_TRUE)
(glEnable GL_NORMALIZE)
(glEnable GL_LIGHT0)
(glLightfv GL_LIGHT0 GL_DIFFUSE '(0.7 0.7 0.7 1.0))
(glEnable GL_COLOR_MATERIAL)

; draw
(gl:set-renderer (lambda (mouse)
   (glClear (bor GL_COLOR_BUFFER_BIT GL_DEPTH_BUFFER_BIT))

   (glMatrixMode GL_PROJECTION)
   (glLoadIdentity)
   ;(glOrtho 0 W  0 H  -10 1)
   (gluPerspective 45.0 16/9 0.1 1000)


   (glMatrixMode GL_MODELVIEW)
   (glLoadIdentity)
   (gluLookAt (* W 2) (* W 2) (* W 2)
               0 0 0 0 1 0)

   (glBegin GL_QUADS)
      (glColor3f 183/255 179/255 161/255)
      (glVertex3f 0 0 0)
      (glVertex3f W 0 0)
      (glVertex3f W H 0)
      (glVertex3f 0 H 0)

      (glVertex3f 0 0 0)
      (glVertex3f 0 W 0)
      (glVertex3f 0 W H)
      (glVertex3f 0 0 H)

      (glVertex3f 0 0 0)
      (glVertex3f W 0 0)
      (glVertex3f W 0 H)
      (glVertex3f 0 0 H)
   (glEnd)
   (glBegin GL_LINES)
      (glColor3f 1 1 1)
      (glVertex3f 0 0 0)
      (glVertex3f W 0 0)
      (glVertex3f 0 0 0)
      (glVertex3f 0 H 0)
      (glVertex3f 0 0 0)
      (glVertex3f 0 0 D)
   (glEnd)

   (for-each (lambda (sphere)
         (define matrix [
            #i1 #i0 #i0 #i0
            #i0 #i1 #i0 #i0
            #i0 #i0 #i1 #i0
            #i0 #i0 #i0 #i1 ])
         (NewtonBodyGetMatrix (getf sphere 'body) matrix)

         (glPushMatrix)
         (glMultMatrixd matrix)
         (glColor3f 1 1 1)
         (case (getf sphere 'state)
            ('rock (glColor3f 1 0 0))
            ('paper (glColor3f 0 1 0))
            ('scissor (glColor3f 0 0 1)))
         (glSphere)
         (glPopMatrix))
      spheres)
))

(import (scheme dynamic-bindings))
(define time (make-parameter (time-ms)))
; physics
(gl:set-calculator (lambda ()
   ; delta_t - дельта по времени (seconds)
   (define now (time-ms)) ; (print-to stderr now)
   (define old (time now))
   ; временной интервал с прошлой математики
   (define delta_t (/ (- now old) #i1000))
   (if (< delta_t 0)
      (print "DEPTA_T !!! " delta_t " / " now " - " old))
   (if (> delta_t 0.1)
      (print "DEPTA_T !!! " delta_t " / " now " - " old))

   (NewtonUpdate world (min 1/60 (max 1/200 delta_t)))
))

(print "NewtonGetMemoryUsed = " (NewtonGetMemoryUsed))
