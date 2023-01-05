(import
      (lib gl-2)
      (lib GLU))
(import (lib newton-dynamics-4))

(gl:set-window-title "402. The floor, sphere and OpenGL")

; newton-dynamics
(define world (or
   (NewtonWorldCreate)
   (runtime-error "Can't create newton world" #f)))

(let ((ver (NewtonWorldGetEngineVersion world)))
   (display "newton-dynamics version ")
   (display (div ver 100))
   (display ".")
   (display (mod ver 100)))
(newline)

; init
(glEnable GL_BLEND)
(glBlendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA)
(glEnable GL_DEPTH_TEST)

; floor
(define floor (map inexact '(
   -100  0  100
    100  0  100
    100 30 -100
   -100 30 -100)))

; draw
(gl:set-renderer (lambda ()
   (glViewport 0 0 (gl:get-window-width) (gl:get-window-height))
   (glClearColor 0.2 0.2 0.2 1)
   (glClear (vm:ior GL_COLOR_BUFFER_BIT GL_DEPTH_BUFFER_BIT))

   (define FOVY 45.0)
   (define ASPECT (/ (gl:get-window-width) (gl:get-window-height)))

   (glMatrixMode GL_PROJECTION)
   (glLoadIdentity)
   (gluPerspective FOVY ASPECT 0.01 1000.0)

   (glMatrixMode GL_MODELVIEW)
   (glLoadIdentity)
   (gluLookAt 300 60 300
      0 0 0
      0 1 0)

   ; floor
   (glColor3f 0.8 0.8 0.8)
   (glBegin GL_QUADS)
      (glVertex3f (lref floor 0) (lref floor 1) (lref floor 2))
      (glVertex3f (lref floor 3) (lref floor 4) (lref floor 5))
      (glVertex3f (lref floor 6) (lref floor 7) (lref floor 8))
      (glVertex3f (lref floor 9) (lref floor 10) (lref floor 11))
   (glEnd)
   ; draw sphere and floor
   #true
))

; think
(import (scheme dynamic-bindings))
(define time (make-parameter (time-ms))) ; время последнего рендеринга

(gl:set-calculator (lambda ()
   (define now (time-ms))
   (define old (time now))

   (define delta_t (/ (- now old) #i1000))

   (NewtonWorldUpdate world delta_t)
))

