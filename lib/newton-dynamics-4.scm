(define-library (lib newton-dynamics-4)
   (version 4.00)
   (import
      (otus lisp)
      (otus ffi))
   (export
      ;; Bodies in the "kinematic" state (instead of the default, "dynamic" state)
      ;;  are "unstoppable" bodies, that behave as if they had infinite mass.
      ;; This means they don't react to any force (gravity, constraints or user-supplied);
      ;;  they simply follow velocity to reach the next position.
      ;; Their purpose is to animate objects that don't react to other bodies,
      ;;  but act upon them through joints (any joint, not just contact joints).

      ;; NewtonWorldFloatSize

      Newton:CreateWorld
      Newton:DestroyWorld
      NewtonWorld:GetEngineVersion
      NewtonWorld:Sync
      NewtonWorld:Update

      NewtonWorld:SetSubSteps

      ;; ...
      NewtonWorld:SetSolverIterations

      NewtonWorld:AddBody

      ;; ----------------------------------------------
      ;; convex collision primitives creation functions
      ;; ----------------------------------------------

      ; Null
      Newton:CreateBox
      Newton:CreateCone
      ; Point
      Newton:CreateSphere
      Newton:CreateStatic ; Static_bvh
      Newton:CreateCapsule
      Newton:CreateCylinder
      Newton:CreateConvexHull
      ; Compound
      ; StaticBVH
      ; StaticMesh
      ; Heightfield
      ; ConvexPolygon
      ; ChamferCylinder
      ; StaticProceduralMesh

      Newton:CreatePolygonSoupBuilder
      Newton:DestroyPolygonSoupBuilder
      PolygonSoupBuilder:Begin
      PolygonSoupBuilder:AddFace
      PolygonSoupBuilder:End


      Newton:CreateDynamicBody
      Newton:CreateKinematicBody

      NewtonBody:SetCollisionShape
      NewtonBody:SetMatrix
      NewtonBody:GetMatrix
      NewtonBody:SetMass
      NewtonBody:SetMassMatrix
      NewtonBody:SetMassShape

      NewtonBody:SetForce
      NewtonBody:SetVelocity

      ApplyExternalForceCallback
      NewtonBody:SetApplyExternalForceCallback

)

(begin
   (define SO (or
      (load-dynamic-library "libnewton-dynamics-4.so")
      (runtime-error "Can't load newton library" #n)))

   ; basic types
   (define void fft-void)
   (define ndInt32 fft-int32)
   (define bool fft-bool)
   ;; (define void* fft-void*)

   (define ndFloat32 fft-float)
   (define ndFloat32* (fft* ndFloat32))

   (define ndMatrix* (fft* ndFloat32))
   (define ndMatrix& (fft& ndFloat32))
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
   (define NewtonShape* type-vptr)
   (define NewtonBody* type-vptr)
   (define PolygonSoupBuilder* type-vptr)
   ;; (define NewtonMaterial* type-vptr)
   ;; (define NewtonMesh* type-vptr)
   ;; (define NewtonJoint* type-vptr)
   ;; (define NewtonUserContactPoint* type-vptr)
   ;; (define NewtonContact* type-vptr)

   ;; (define NewtonFracturedCompoundMeshPart* type-vptr)

   ; -----------------------
   ; NewtonWorld

   ;; (define NewtonGetMemoryUsed (SO int "NewtonGetMemoryUsed"))

   (define Newton:CreateWorld (SO NewtonWorld* "NewtonCreateWorld"))
   (define Newton:DestroyWorld (SO void "NewtonDestroyWorld" NewtonWorld*))
   (define NewtonWorld:GetEngineVersion (SO ndInt32 "NewtonWorldGetEngineVersion" NewtonWorld*))
   (define NewtonWorld:Sync (SO void "NewtonWorldSync" NewtonWorld*))
   (define NewtonWorld:Update (SO void "NewtonWorldUpdate" NewtonWorld* ndFloat32))

   (define NewtonWorld:SetSubSteps (SO void "NewtonWorldSetSubSteps" NewtonWorld* ndInt32))
   (define NewtonWorld:SetSolverIterations (SO void "NewtonWorldSetSolverIterations" NewtonWorld* ndInt32))

   (define NewtonWorld:AddBody (SO void "NewtonWorldAddBody" NewtonWorld* NewtonBody*))

   ; ---------
   ; mesh builder
   (define Newton:CreatePolygonSoupBuilder (SO PolygonSoupBuilder* "NewtonCreatePolygonSoupBuilder"))
   (define Newton:DestroyPolygonSoupBuilder (SO void "NewtonDestroyPolygonSoupBuilder" PolygonSoupBuilder*))
   (define PolygonSoupBuilder:Begin (SO void "PolygonSoupBuilderBegin" PolygonSoupBuilder*))
   (define PolygonSoupBuilder:AddFace (SO void "PolygonSoupBuilderAddFace" PolygonSoupBuilder* ndFloat32* ndInt32 ndInt32 ndInt32))
   (define PolygonSoupBuilder:End (SO void "PolygonSoupBuilderEnd" PolygonSoupBuilder* bool))

   ; ----------------------
   ; collisions (shapes)
   ; Null
   (define Newton:CreateBox (SO NewtonShape* "NewtonCreateBox" ndFloat32 ndFloat32 ndFloat32))
   (define Newton:CreateCone (SO NewtonShape* "NewtonCreateCone" ndFloat32 ndFloat32))
   ; Point
   (define Newton:CreateSphere (SO NewtonShape* "NewtonCreateSphere" ndFloat32))
   (define Newton:CreateCapsule (SO NewtonShape* "NewtonCreateCapsule" ndFloat32 ndFloat32 ndFloat32))
   (define Newton:CreateCylinder (SO NewtonShape* "NewtonCreateCylinder" ndFloat32 ndFloat32 ndFloat32))
   ; ChamferCylinder
   ; Compound
   (define Newton:CreateConvexHull (SO NewtonShape* "NewtonCreateConvexHull" ndInt32 ndInt32 ndFloat32 ndFloat32*))
   ; ConvexPolygon
   (define Newton:CreateStatic (SO NewtonShape* "NewtonCreateStatic" PolygonSoupBuilder*))
   ; StaticMesh
   ; Heightfield
   ; UserDefinedImplicit
   ; StaticProceduralMesh

   ; ----------------------
   (define Newton:CreateDynamicBody (SO NewtonBody* "NewtonCreateDynamicBody" NewtonShape* ndFloat32))
   (define Newton:CreateKinematicBody (SO NewtonBody* "NewtonCreateKinematicBody" NewtonShape*))

   (define NewtonBody:SetCollisionShape (SO void "NewtonBodySetCollisionShape" NewtonBody* NewtonShape*))
   (define NewtonBody:SetMatrix (SO void "NewtonBodySetMatrix" NewtonBody* ndMatrix*))
   (define NewtonBody:GetMatrix (SO void "NewtonBodyGetMatrix" NewtonBody* ndMatrix&))
   (define NewtonBody:SetMass (SO void "NewtonBodySetMass" NewtonBody* ndFloat32))
   (define NewtonBody:SetMassMatrix (SO void "NewtonBodySetMassMatrix" NewtonBody* ndFloat32 ndMatrix*))
   (define NewtonBody:SetMassShape (SO void "NewtonBodySetMassShape" NewtonBody* ndFloat32 NewtonShape* fft-bool))

   (define NewtonBody:SetForce (SO void "NewtonBodySetForce" NewtonBody* ndFloat32*))
   (define NewtonBody:SetVelocity (SO void "NewtonBodySetVelocity" NewtonBody* ndFloat32*))

   (define *ApplyExternalForceCallback type-callable)
   (define (ApplyExternalForceCallback f)
      (make-callback (vm:pin (cons
         (cons void (list
         ;  body        timestep  threadIndex
            NewtonBody* ndFloat32 ndInt32))
         f))))

   (define NewtonBody:SetApplyExternalForceCallback (SO void "NewtonBodySetApplyExternalForceCallback" NewtonBody* *ApplyExternalForceCallback))
))
