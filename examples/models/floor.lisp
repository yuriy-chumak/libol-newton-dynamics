; reed floor model from the OBJ file
(import (owl parse))
(import (file wavefront obj))
(define floor-obj-model (parse wavefront-obj-parser (file->list "models/floor.obj") #empty))

; 1. build static collision
(define collision (NewtonCreateTreeCollision world 0))
(NewtonTreeCollisionBeginBuild collision)

;; use this for manual faces (these can be either triangles or multiangles)
;; (NewtonTreeCollisionAddFace collision 4 '(
;;    -19 0.1  19
;;     19 0.1  19
;;     19 0.1 -19
;;    -19 0.1 -19) (* 3 4) 0) ; (* 3 4) is stride, where 4 is sizeof(float)

(define vertices (list->vector (floor-obj-model 'v)))
(define normals (list->vector (floor-obj-model 'vn)))

; get triangles from the OBJ model file
(for-each (lambda (object)
      (for-each (lambda (facegroup)
            (for-each (lambda (face)
                  (define triangle (vector-map (lambda (v) (ref vertices (ref v 1))) face))
                  (define flat (foldr (lambda (tri a) (append (vector->list tri) a))
                        #null (vector->list triangle)))
                  (NewtonTreeCollisionAddFace collision 3 flat (* 3 4) 0))
               (cdr facegroup)))
         (object 'facegroups)))
   (floor-obj-model 'o))

(NewtonTreeCollisionEndBuild collision 1)
(NewtonCreateKinematicBody world collision '(1 0 0 0  0 1 0 0  0 0 1 0  0 0 0 1))
(NewtonDestroyCollision collision)
