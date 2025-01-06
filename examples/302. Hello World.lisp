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

(glMatrixMode GL_PROJECTION)
(glLoadIdentity)
(gluPerspective 45 (/ 854 480) 0.1 1000)

(glMatrixMode GL_MODELVIEW)
(glLoadIdentity)
(gluLookAt 15 20 30
   0 0 0
   0 1 0)

; draw
(define old (inexact 0.0))

(gl:set-renderer (lambda (mouse)
   ; let's calculate newtonian world
   (define now (/ (time-ms) #i1000))
   (NewtonUpdate world (max (- now old)))
   (vm:set! old now)

   (glClear (vm:ior GL_COLOR_BUFFER_BIT GL_DEPTH_BUFFER_BIT))

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
