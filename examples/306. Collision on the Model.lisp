#!/usr/bin/env ol

; temporary, we need NVidia card
(syscall 1014 (c-string "__NV_PRIME_RENDER_OFFLOAD") (c-string "1") #true)
(syscall 1014 (c-string "__GLX_VENDOR_LIBRARY_NAME") (c-string "nvidia") #true)

; the program
(import
   (lib newton-dynamics)
   (lib gl-2) (lib GLU))
(import (file glTF)
   (OpenGL glTF))

(gl:set-window-title "305. Cube Collision on the Floor")

; create the "world"
(define world (or
   (NewtonCreate)
   (runtime-error "Can't create newton world")))
(NewtonSetSolverIterations world 1)

; opengl init
(glShadeModel GL_SMOOTH)
(glClearColor 0.11 0.11 0.11 1)
(glEnable GL_DEPTH_TEST)

(define sun [3 10 10 0])

,load "cube-shader.lisp"
,load "models/box.lisp"

(define collision (NewtonCreateBox world       1 1 1      0 #f))
; 2. create a dynamic body (body than can move)
(define cube (NewtonCreateDynamicBody world collision
      ; column-major body matrix: "all-in-one" location and rotation
      `( 1 0 0 0
         0 1 0 0
         0 0 1 0
         0 10 0 1; x y z w
      )))

; 3. set body mass
(NewtonBodySetMassProperties cube 1.0 collision)

; 4. set "apply-gravity" callback to body
;    (Oy is "up")
(define ApplyGravityCallback (NewtonApplyForceAndTorque
   (lambda (body timestep threadIndex)
      (NewtonBodySetForce body '(0 -9.8 0 0)))))

(NewtonBodySetForceAndTorqueCallback cube ApplyGravityCallback)

; 5. delete collision, we don't need it anymore
(NewtonDestroyCollision collision)


; -- floor as model --
(define model (read-glTF-file "models/Torus.glb"))
(define torus (compile model))

,load "models/gltf.lisp"

(define newtonmesh (NewtonMeshCreate world))
(NewtonMeshBeginBuild newtonmesh)
   (define nodes (model 'nodes))
   (define meshes (model 'meshes))
   (define buffers (model 'buffers))
   (define bufferViews (model 'bufferViews))
   (define accessors (model 'accessors))

   ; render scene tree
   (let walk ((i 0))
      (define node (vref nodes i))
      (print "node: " node)
   ;;    ;; (glPushMatrix) ; !!!
   ;;    ;; (when (node 'matrix #f)
   ;;    ;;    (glMultMatrixf (node 'matrix)))

      (when (node 'mesh #f)
         (define mesh (vref meshes (node 'mesh)))
         (print "  mesh: " mesh)
         (vector-for-each (lambda (primitive)
               ;(glBindVertexArray (primitive 'vao))

               (define indices (primitive 'indices #f))
               (define attributes (primitive 'attributes #f))
               (when indices
                  (define accessor (vref accessors indices))
                  (define indexView (vref bufferViews (accessor 'bufferView)))
                  (define indexBuffer ((vref buffers (indexView 'buffer)) 'buffer))
                  (print "indexBuffer: " (bytevector-copy indexBuffer (indexView 'byteOffset) (+ (indexView 'byteOffset) 1000)))

                  (define position (vref accessors (attributes 'POSITION)))
                  (print "position: " position)
                  (define positionView (vref bufferViews (position 'bufferView)))
                  (print "positionView: " positionView)
                  (define positionBuffer ((vref buffers (positionView 'buffer)) 'buffer))
                  (print "typename " (typename (type positionBuffer)))
                  (define offset (positionView 'byteOffset))

                  (print "offset: " offset)

                  ; assert (= (accessor 'componentType) GL_UNSIGNED_SHORT)
                  (for-each (lambda (a)
                        (define i (+ (<< (ref indexBuffer (+ a 1)) 8) (ref indexBuffer (+ a 0))))
                        (define j (+ (<< (ref indexBuffer (+ a 3)) 8) (ref indexBuffer (+ a 2))))
                        (define k (+ (<< (ref indexBuffer (+ a 5)) 8) (ref indexBuffer (+ a 4))))
                        ; assert (= (position 'type) 'VEC3)
                        (NewtonMeshBeginFace newtonmesh)
                        (for-each (lambda (v)
                              (apply NewtonMeshAddPoint (cons* newtonmesh (map (lambda (p)
                                    (bytevector->float positionBuffer p))
                                 (iota 3 (+ offset (* v 4)) 4))))) ; 4 for (sizeof float)
                           (list (* i 3) (* j 3) (* k 3)))
                        (NewtonMeshEndFace newtonmesh))
                     (iota (/ (accessor 'count) 3) (indexView 'byteOffset) (* 2 3)))
                  #f)
               #f)
            (mesh 'primitives [])))
      ; visit children
      (vector-for-each walk (node 'children []))
      ;; (glPopMatrix)
      )
(NewtonMeshEndBuild newtonmesh)


(print "x")
(define collision (NewtonCreateCompoundCollisionFromMesh world newtonmesh 0 0 #f))
(define torusbody (NewtonCreateDynamicBody world collision
      `( 1 0 0 0
         0 1 0 0
         0 0 1 0
         0 0 0 1; x y z w
      )))
(NewtonBodySetMassProperties torusbody 10000.0 collision)
(NewtonDestroyCollision collision)

;; ; temp
;; (define ApplyRotationCallback (NewtonApplyForceAndTorque
;;    (lambda (body timestep threadIndex)
;;       ;; (NewtonBodySetOmega body '(-1.8 0 0 0))
;;       #f
;;       )))

;; ;; (NewtonBodySetForceAndTorqueCallback torusbody ApplyRotationCallback)

;; todo


; keyboard handler
(import (lib keyboard))
(gl:set-keyboard-handler (lambda (key)
   (case key
      (KEY_ESC
         (NewtonBodySetVelocity cube [0 0 0]) ; stop moving
         (NewtonBodySetMatrix cube            ; move to start location
               ; column-major body matrix: location and rotation
               `( 1 0 0 0
                  0 1 0 0
                  0 0 1 0
                  0 10 0 1; x y z w
               ))
         )
   )))

; draw
(define old (inexact 0.0))

(gl:set-renderer (lambda (mouse)
   ; rotate torus before
   (NewtonBodySetOmega torusbody '(-1.1 0 0 0))

   ; let's calculate newtonian world
   (define now (/ (time-ms) #i1000))
   (NewtonUpdate world (min (- now old) 0.05))
   (vm:set! old now)

   ; get body matrix
   (define matrix [
      #i0 #i0 #i0 #i0
      #i0 #i0 #i0 #i0
      #i0 #i0 #i0 #i0
      #i0 #i0 #i0 #i0 ])
   (NewtonBodyGetMatrix cube matrix)

   ; --- depth support -----
   (prepare-shadows (lambda ()
      (glPushMatrix)
      (glMultMatrixf matrix)
      (draw-Box 1 1 1)
      (glPopMatrix)
   ))

   ;; ---------------------------------
   ;; scene rendering
   (glViewport 0 0 (gl:get-window-width) (gl:get-window-height))
   (glClear (vm:ior GL_COLOR_BUFFER_BIT GL_DEPTH_BUFFER_BIT))
   ;; (glEnable GL_CULL_FACE)

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

   ;; ; apply matrix to the opengl cube
   (glUseProgram lighting-program)
   (glUniform4fv lightPosition 1 sun)

   (glPushMatrix)
   (glMultMatrixf matrix)
   (draw-Box 1 1 1)
   (glPopMatrix)

   ; draw the "floor" cube
   (glColor3f 0.2 0.2 0.2)
   (glUseProgram shading-program)
   (apply-shadowmap)
   (NewtonBodyGetMatrix torusbody matrix)

   ; don't move the torus!
   (vm:set! (ref matrix 13) #i0)
   (vm:set! (ref matrix 14) #i0)
   (vm:set! (ref matrix 15) #i0)
   (NewtonBodySetMatrix torusbody matrix)

   (glUniformMatrix4fv modelMatrix 1 #false matrix)
   ;; (glUniformMatrix4fv modelMatrix 1 #false [
   ;;    1  0  0  0
   ;;    0  1  0  0
   ;;    0  0  1  0
   ;;    0  0  0  1 ])

   (render-model torus)

   ; draw xyz axis
   (glUseProgram 0)
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
