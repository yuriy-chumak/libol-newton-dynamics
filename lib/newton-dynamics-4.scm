(define-library (lib newton-dynamics-4)
   (version 4.00)
   (import
      (otus lisp)
      (otus ffi))
   (export
      NewtonWorld*
      ;; NewtonCollision*
      ;; NewtonBody*
      ;; NewtonMaterial*
      ;; NewtonMesh*
      ;; NewtonJoint*
      ;; NewtonUserContactPoint*
      ;; NewtonContact*

      ;; NewtonFracturedCompoundMeshPart*

      ;; NEWTON_DYNAMIC_BODY
      ;; ; Bodies in the "kinematic" state (instead of the default, "dynamic" state)
      ;; ;  are "unstoppable" bodies, that behave as if they had infinite mass.
      ;; ; This means they don't react to any force (gravity, constraints or user-supplied);
      ;; ;  they simply follow velocity to reach the next position.
      ;; ; Their purpose is to animate objects that don't react to other bodies,
      ;; ;  but act upon them through joints (any joint, not just contact joints).
      ;; NEWTON_KINEMATIC_BODY
      ;; NEWTON_DYNAMIC_ASYMETRIC_BODY

      ;; NewtonWorldFloatSize

      NewtonWorldCreate
      NewtonWorldDestroy
      NewtonWorldGetEngineVersion
      NewtonWorldUpdate

)
(begin

   (define SO (or
      (load-dynamic-library "libnewton-dynamics-4.so")
      (runtime-error "Can't load newton library" #n)))

   ; basic types
   (define ndInt32 fft-int32)
   (define void fft-void)
   ;; (define void* fft-void*)

   (define ndFloat32 fft-float)
   ;; (define dFloat64 fft-double)
   ;; (define dLong fft-long-long)

   ;; ; 
   ;; (define NewtonWorldFloatSize  (SO int "NewtonWorldFloatSize"))

   ;; ; advanced types
   ;; (define _NEWTON_USE_DOUBLE (eq? (NewtonWorldFloatSize) 8))

   ;; (define dFloat (if _NEWTON_USE_DOUBLE fft-double fft-float))
   ;; (define dFloat* (fft* dFloat))
   ;; (define dFloat& (fft& dFloat))
   ;; (define dLong* (fft* dLong))
   ;; (define dLong& (fft& dLong))

   ;; (define NEWTON_DYNAMIC_BODY           1)
   ;; (define NEWTON_KINEMATIC_BODY         2)
   ;; (define NEWTON_DYNAMIC_ASYMETRIC_BODY 3)

   ; newton types
   (define NewtonWorld* type-vptr)
   ;; (define NewtonCollision* type-vptr)
   ;; (define NewtonBody* type-vptr)
   ;; (define NewtonMaterial* type-vptr)
   ;; (define NewtonMesh* type-vptr)
   ;; (define NewtonJoint* type-vptr)
   ;; (define NewtonUserContactPoint* type-vptr)
   ;; (define NewtonContact* type-vptr)

   ;; (define NewtonFracturedCompoundMeshPart* type-vptr)

   ;; ; -----------------------
   ;; ; world control functions
   ;; ; -----------------------

   ;; (define NewtonGetMemoryUsed (SO int "NewtonGetMemoryUsed"))

   (define NewtonWorldCreate (SO NewtonWorld* "NewtonWorldCreate"))
   (define NewtonWorldDestroy (SO void "NewtonWorldDestroy" NewtonWorld*))
   (define NewtonWorldGetEngineVersion (SO ndInt32 "NewtonWorldGetEngineVersion" NewtonWorld*))
   (define NewtonWorldUpdate (SO void "NewtonWorldUpdate" NewtonWorld* ndFloat32))

))
