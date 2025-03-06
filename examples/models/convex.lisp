; convex hull

(import (owl parse))
(import (file wavefront obj))
(define monkey (parse wavefront-obj-parser (file->list "models/monkey.obj") #empty))

(define (draw-Convex)
   (glPushMatrix)

   (define vertices (list->vector (monkey 'v)))
   (define normals (list->vector (monkey 'vn)))

   (glColor3f 1 1 0)

   (glBegin GL_TRIANGLES)
   (for-each (lambda (object)
         (for-each (lambda (facegroup)
               (for-each (lambda (face)
                     (vector-for-each glNormal3fv (vector-map (lambda (v) (ref normals (ref v 3))) face))
                     (vector-for-each glVertex3fv (vector-map (lambda (v) (ref vertices (ref v 1))) face)))
                  (cdr facegroup)))
            (object 'facegroups)))
      (monkey 'o))

   (glEnd)
   (glPopMatrix))
