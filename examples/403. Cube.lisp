#!/usr/bin/env ol

(import
   (lib newton-dynamics-4)
   (lib gl-2) (lib GLU))

(gl:set-window-title "403. Single Cube")

; create the "world"
(define world (or
   (Newton:CreateWorld)
   (runtime-error "Can't create newtonian world.")))
(NewtonWorld:SetSubSteps world 2)

; opengl init
(glShadeModel GL_SMOOTH)
(glClearColor 0.11 0.11 0.11 1)
(glEnable GL_DEPTH_TEST)

; utils
,load "cube.lisp"

; ------------------------------------
; newton body creation

; 1. create shape model (the cube)
;    "1 1 1" is box sizes
(define shape (Newton:CreateBox 1 1 1))

; 2. create a dynamic body (body than can move)
(define cube (Newton:CreateDynamicBody shape 1.0))

; 3. set "apply-gravity" callback to body
;    (Oy is "up")
(define ApplyGravityCallback (ApplyExternalForceCallback
   (lambda (body timestep threadIndex)
      (NewtonBody:SetForce body '(0 -9.8 0 0))
   )))
(NewtonBody:SetApplyExternalForceCallback cube ApplyGravityCallback)

; 4. set body location and rotation
(NewtonBody:SetMatrix cube [
   1 0 0 0
   0 1 0 0
   0 0 1 0
   0 9 0 1 ; x y z w
])

;; ; 5. delete collision, we don't need it anymore
;; (NewtonDestroyCollision collision)

; 6. add our body to the world
(NewtonWorld:AddBody world cube)

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

   ; clear frame
   (glClear (vm:ior GL_COLOR_BUFFER_BIT GL_DEPTH_BUFFER_BIT))

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

   ; get body matrix
   (define matrix [
      #i0 #i0 #i0 #i0
      #i0 #i0 #i0 #i0
      #i0 #i0 #i0 #i0
      #i0 #i0 #i0 #i0 ])
   (NewtonBody:GetMatrix cube matrix)

   ; apply matrix to the opengl cube
   (glPushMatrix)
   (glMultMatrixf matrix)
   (draw-Cube 1)
   (glPopMatrix)

   ; draw xyz axis
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
