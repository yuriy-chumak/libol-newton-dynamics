#!/usr/bin/env ol

(import
   (lib newton-dynamics-4)
   (lib gl-2) (lib GLU))

(gl:set-window-title "402. Hello World")

; create the "world"
(define world (or
   (Newton:CreateWorld)
   (runtime-error "Can't create newtonian world.")))

; Two sub-steps per time step is the recommended default. It should provide
; stable simulations for most standard scenarios including those with joints.
(NewtonWorld:SetSubSteps world 2)

; opengl init
(glShadeModel GL_SMOOTH)
(glClearColor 0.11 0.11 0.11 1)
(glEnable GL_DEPTH_TEST)

; draw
(define old (inexact 0.0))

(gl:set-renderer (lambda (mouse)
   ; let's calculate newtonian world
   (define now (/ (time-ms) #i1000))

   ; Trigger an asynchronous(!) physics step.
   ; NOTE: this function will return immediately.
   (NewtonWorld:Update world (min (- now old) 1/60))
   (vm:set! old now)

   ; Explicitly wait until Newton has finished its physics step.
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
   (gluLookAt 15 20 30
      0 0 0
      0 1 0)

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
   (glEnd)))
