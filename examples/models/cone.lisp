; cone
(import (scheme inexact))

(define (normalize a)
   (define lv (/ #i1 (sqrt (vector-fold + 0 (vector-map * a a)))))
   (vector-map (lambda (x) (* x lv)) a))

(define (draw-Cone radius height)
   (glPushMatrix)

   (define h (/ height 2))
   (define -h (- h))
   (define DIVISIONS 10)

   ; wall
   (glColor3f 1 1 0)
   (glBegin GL_TRIANGLE_STRIP)
      (for-each (lambda (angle)
            (define y (cos angle))
            (define z (sin angle))
            (define normal (normalize [
               radius
               (* y height)
               (* z height)]))
            (glNormal3fv normal)
            (glVertex3f -h (* radius y) (* radius z))
            (glVertex3f h 0 0))
         (iota (+ DIVISIONS 1) 0 (/ -6.2831 DIVISIONS)))
   (glEnd)
   ; bottom
   (glColor3f 1 1 0)
   (glBegin GL_TRIANGLE_FAN)
      (glNormal3f -1 0 0)
      (glVertex3f -h 0 0)
      (for-each (lambda (angle)
            (define y (* radius (cos angle)))
            (define z (* radius (sin angle)))
            (glVertex3f -h y z))
         (iota (+ DIVISIONS 1) 0 (/ -6.2831 DIVISIONS)))
   (glEnd)
   (glPopMatrix))
