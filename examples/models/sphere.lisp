; sphere

(define (vertex v)
   (vector-apply v (lambda (x y z)
      (glNormal3d x y z)
      (glVertex3d x y z) )))

(define (normalize a)
   (define lv (/ #i1 (sqrt (vector-fold + 0 (vector-map * a a)))))
   (vector-map (lambda (x) (* x lv)) a))

(define (side a b c n)
   (vector-apply a (lambda (ax ay az)
   (vector-apply b (lambda (bx by bz)
   (vector-apply c (lambda (cx cy cz)
      (if (> n 0)
      then
         (define d (normalize [(/ (+ ax bx) 2) (/ (+ ay by) 2) (/ (+ az bz) 2)]))
         (define e (normalize [(/ (+ bx cx) 2) (/ (+ by cy) 2) (/ (+ bz cz) 2)]))
         (define f (normalize [(/ (+ cx ax) 2) (/ (+ cy ay) 2) (/ (+ cz az) 2)]))

         (side a d f (-- n))
         (side d b e (-- n))
         (side e c f (-- n))
         (side d e f (-- n))
      else
         (vertex a)
         (vertex b)
         (vertex c) ))))))))

(define (sphere)
   (define DIVISIONS 3)

   ; "нулевой" тетраэдр
   (define r (/ (sqrt 6) 4))
   (define m (negate r))
   (define vertices [
      [m m m] [r m r] [m r r] [r r m] ])

   (glBegin GL_TRIANGLES)
   (for-each (lambda (a b c color)
         (glColor3fv color)
         (side (normalize (ref vertices a))
               (normalize (ref vertices b))
               (normalize (ref vertices c)) DIVISIONS))
      '(1 4 3 2)
      '(2 3 4 1)
      '(3 2 1 4)
      ; colors
      '((1 0 0) (0 1 0) (0 0 1) (1 1 0)))
   (glEnd) )


(define (draw-Sphere radius)
   (glPushMatrix)
   (glScalef radius radius radius)

   (sphere)

   (glPopMatrix))
