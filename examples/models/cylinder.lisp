; cylinder

(define (draw-Cylinder radius1 radius2 height)
   (glPushMatrix)

   (define h (/ height 2))
   (define -h (- h))
   (define dr (- radius2 radius1))
   (define len (sqrt (+ (* dr dr) (* height height))))
   (define DIVISIONS 16)

   (glColor3f 1 1 0)
   (glBegin GL_QUAD_STRIP)
   (for-each (lambda (angle)
         (define y (cos angle))
         (define z (sin angle))
         (define normal (normalize [
            dr
            (* y len)
            (* z len)]))
         (glNormal3fv normal)
         (glVertex3f -h (* radius1 y) (* radius1 z))
         (glVertex3f h (* radius2 y) (* radius2 z)))
      (iota (+ DIVISIONS 1) 0 (/ -6.2831 DIVISIONS)))
   (glEnd)

   ; bottom
   (glBegin GL_TRIANGLE_FAN)
      (glNormal3f -1 0 0)
      (glVertex3f -h 0 0)
      (for-each (lambda (angle)
            (define y (* radius1 (cos angle)))
            (define z (* radius1 (sin angle)))
            (glVertex3f -h y z))
         (iota (+ DIVISIONS 1) 0 (/ -6.2831 DIVISIONS)))
   (glEnd)

   (glBegin GL_TRIANGLE_FAN)
      (glNormal3f 1 0 0)
      (glVertex3f h 0 0)
      (for-each (lambda (angle)
            (define y (* radius2 (cos angle)))
            (define z (* radius2 (sin angle)))
            (glVertex3f h y z))
         (iota (+ DIVISIONS 1) 0 (/ 6.2831 DIVISIONS)))
   (glEnd)

   (glPopMatrix))
