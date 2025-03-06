; capsule
,load "models/sphere.lisp"
,load "models/cylinder.lisp"

(define (draw-Capsule radius1 radius2 height)
   (glPushMatrix)

   ; capsule head
   (glTranslatef (/ height -2) 0 0)
   (glPushMatrix)
   (glScalef radius1 radius1 radius1)
   (glColor3f 1 0 0)
   (sphere)
   (glPopMatrix)

   ; capsule tail
   (glTranslatef (+ height) 0 0)
   (glPushMatrix)
   (glScalef radius2 radius2 radius2)
   (glColor3f 0 1 0)
   (sphere)
   (glPopMatrix)

   (glTranslatef (/ height -2) 0 0)

   ; cylinder
   (draw-Cylinder radius1 radius2 height)

   (glPopMatrix))
