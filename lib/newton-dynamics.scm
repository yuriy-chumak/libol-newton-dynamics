; About Newton Dynamics
; =====
;
; Newton Dynamics is a cross-platform life-like physics simulation library.
; It can easily be integrated into game engines and other applications and
; provides top of it's class performance and simulation stability. Ongoing
; developement and a permissive license makes Newton Dynamics a top choice
; for all kinds of projects from scientific projects to game engines.
;
; Newton Dynamics implements a deterministic solver, which is not based on
; traditional LCP or iterative methods, but possesses the stability and
; speed of both respectively. This feature makes Newton Dynamics a tool
; not only for games, but also for any real-time physics simulation.
;
; Links to demos, tutorial, FAQ, etc: github.com/newton-dynamics/wiki
; Main project page: http://newtondynamics.com
; Forums and public discussion: http://newtondynamics.com/forum
;
; Authors
; Newton Dynamics is a project of Julio Jerez and Alain Suero and various other contributors.
; See the AUTHORS page on github for a full list of all contributors.
;
; Notes:
; Newton serialization/deserialization removed from library.

(define-library (lib newton-dynamics)
   (version 3.14)
   (license zlib)
   (import
      (otus lisp)
      (otus ffi))
   (export
      NewtonWorld*
      NewtonCollision*
      NewtonBody*
      NewtonMaterial*
      NewtonMesh*
      NewtonJoint*
      NewtonUserContactPoint*
      NewtonContact*

      NewtonFracturedCompoundMeshPart*

      NEWTON_DYNAMIC_BODY
      ; Bodies in the "kinematic" state (instead of the default, "dynamic" state)
      ;  are "unstoppable" bodies, that behave as if they had infinite mass.
      ; This means they don't react to any force (gravity, constraints or user-supplied);
      ;  they simply follow velocity to reach the next position.
      ; Their purpose is to animate objects that don't react to other bodies,
      ;  but act upon them through joints (any joint, not just contact joints).
      NEWTON_KINEMATIC_BODY
      NEWTON_DYNAMIC_ASYMETRIC_BODY

      NewtonWorldGetVersion
      NewtonWorldFloatSize

      ;; ---------
      ;; callbacks
      ;; ---------
      
      ;NewtonAllocMemory
      ;NewtonFreeMemory
      ;NewtonWorldDestructorCallback
      ;NewtonPostUpdateCallback
      ;NewtonCreateContactCallback
      ;NewtonDestroyContactCallback
      ;NewtonWorldListenerDebugCallback
      ;NewtonWorldListenerBodyDestroyCallback
      ;NewtonWorldUpdateListenerCallback
      ;NewtonWorldDestroyListenerCallback
      ;NewtonGetTimeInMicrosencondsCallback
      ;NewtonUserMeshCollisionDestroyCallback
      ;NewtonUserMeshCollisionRayHitCallback
      ;NewtonUserMeshCollisionGetCollisionInfo
      ;NewtonUserMeshCollisionAABBTest
      ;NewtonUserMeshCollisionGetFacesInAABB
      ;NewtonUserMeshCollisionCollideCallback
      ;NewtonTreeCollisionFaceCallback
      ;NewtonCollisionTreeRayCastCallback
      ;NewtonHeightFieldRayCastCallback
      ;NewtonCollisionCopyConstructionCallback
      ;NewtonCollisionDestructorCallback
      ;NewtonTreeCollisionCallback ; obsoleted
      ;NewtonBodyDestructor
      NewtonApplyForceAndTorque
      ;NewtonSetTransform
      ;NewtonIslandUpdate
      ;NewtonFractureCompoundCollisionOnEmitCompoundFractured
      ;NewtonFractureCompoundCollisionOnEmitChunk
      ;NewtonFractureCompoundCollisionReconstructMainMeshCallBack
      NewtonWorldRayPrefilterCallback
      NewtonWorldRayFilterCallback
      NewtonOnAABBOverlap
      NewtonContactsProcess
      NewtonOnCompoundSubCollisionAABBOverlap
      NewtonOnContactGeneration
      ;NewtonBodyIterator
      ;NewtonJointIterator
      ;NewtonCollisionIterator
      ;NewtonBallCallback
      ;NewtonHingeCallback
      ;NewtonSliderCallback
      ;NewtonUniversalCallback
      ;NewtonCorkscrewCallback
      ;NewtonUserBilateralCallback
      ;NewtonUserBilateralGetInfoCallback
      ;NewtonConstraintDestructor
      ;NewtonJobTask
      ;NewtonReportProgress

      ;; -----------------------
      ;; world control functions
      ;; -----------------------

      NewtonGetMemoryUsed
      ;NewtonSetMemorySystem

      NewtonCreate
      NewtonDestroy
      NewtonDestroyAllBodies

      ;NewtonGetPostUpdateCallback
      ;NewtonSetPostUpdateCallback

      NewtonAlloc
      NewtonFree

      ;... plugins ...

      ;NewtonGetContactMergeTolerance
      ;NewtonSetContactMergeTolerance

      NewtonInvalidateCache

      NewtonSetSolverIterations
      NewtonGetSolverIterations
      ;NewtonSetParallelSolverOnLargeIsland
      ;NewtonGetParallelSolverOnLargeIsland
      ;NewtonGetBroadphaseAlgorithm
      ;NewtonSelectBroadphaseAlgorithm
      ;NewtonResetBroadphase

      NewtonUpdate
      ;NewtonUpdateAsync
      ;NewtonWaitForUpdateToFinish

      ;NewtonGetNumberOfSubsteps
      ;NewtonSetNumberOfSubsteps
      NewtonGetLastUpdateTime

      ;; multi threading interface
      ;NewtonWorldCriticalSectionLock
      ;NewtonWorldCriticalSectionUnlock
      NewtonSetThreadsCount
      NewtonGetThreadsCount
      ;NewtonGetMaxThreadsCount
      ;NewtonDispachThreadJob
      ;NewtonSyncThreadJobs

      ;; atomic operations
      ;NewtonAtomicAdd
      ;NewtonAtomicSwap
      ;NewtonYield

      ;NewtonSetIslandUpdateEvent
      ;NewtonWorldForEachJointDo
      ;NewtonWorldForEachBodyInAABBDo

      NewtonWorldSetUserData
      NewtonWorldGetUserData

      ;NewtonWorldAddListener
      ;NewtonWorldGetListener

      ;NewtonWorldListenerSetDebugCallback
      ;NewtonWorldListenerSetPostStepCallback
      ;NewtonWorldListenerSetPreUpdateCallback
      ;NewtonWorldListenerSetPostUpdateCallback
      ;NewtonWorldListenerSetDestructorCallback
      ;NewtonWorldListenerSetBodyDestroyCallback
      ;NewtonWorldListenerDebug
      ;NewtonWorldGetListenerUserData

      ;NewtonWorldListenerGetBodyDestroyCallback
      ;NewtonWorldGetDestructorCallback
      ;NewtonWorldSetCollisionConstructorDestructorCallback

      ;NewtonWorldSetCreateDestroyContactCallback

      ; The ray cast function will trigger the callback for every intersection between
      ;  the line segment (from p0 to p1) and a body in the world.
      NewtonWorldRayFilterCallback
      NewtonWorldRayPrefilterCallback
      NewtonWorldRayCast

      ;NewtonWorldConvexCast
      ;NewtonWorldCollide

      ;; world utility functions
      ;NewtonWorldGetBodyCount
      ;NewtonWorldGetConstraintCount
      ;NewtonWorldFindJoint

      ;; ------------------
      ;; Simulation islands
      ;; ------------------

      ;NewtonIslandGetBody
      ;NewtonIslandGetBodyAABB

      ;; ------------------------
      ;; Physics Material Section
      ;; ------------------------

      ;NewtonMaterialCreateGroupID
      NewtonMaterialGetDefaultGroupID
      ;NewtonMaterialDestroyAllGroupID
      ;NewtonMaterialGetUserData
      ;NewtonMaterialSetSurfaceThickness
      ;NewtonMaterialSetCallbackUserData
      NewtonMaterialSetContactGenerationCallback
      NewtonMaterialSetCompoundCollisionCallback
      NewtonMaterialSetCollisionCallback
      ;NewtonMaterialSetDefaultSoftness
      ;NewtonMaterialSetDefaultElasticity
      ;NewtonMaterialSetDefaultCollidable
      ;NewtonMaterialSetDefaultFriction
      ;NewtonMaterialJointResetIntraJointCollision
      ;NewtonMaterialJointResetSelftJointCollision

      ;NewtonWorldGetFirstMaterial
      ;NewtonWorldGetNextMaterial

      NewtonWorldGetFirstBody
      NewtonWorldGetNextBody


      ;; ---------------------------------
      ;; Physics Contact control functions
      ;; ---------------------------------

      ;NewtonMaterialGetMaterialPairUserData
      ;NewtonMaterialGetContactFaceAttribute
      ;NewtonMaterialGetBodyCollidingShape
      ;NewtonMaterialGetContactNormalSpeed
      ;NewtonMaterialGetContactForce
      ;NewtonMaterialGetContactPositionAndNormal
      ;NewtonMaterialGetContactTangentDirections
      ;NewtonMaterialGetContactTangentSpeed
      ;NewtonMaterialGetContactMaxNormalImpact
      ;NewtonMaterialGetContactMaxTangentImpact
      ;NewtonMaterialGetContactPenetration

      ;NewtonMaterialSetAsSoftContact
      ;NewtonMaterialSetContactSoftness
      ;NewtonMaterialSetContactThickness
      ;NewtonMaterialSetContactElasticity
      ;NewtonMaterialSetContactFrictionState
      ;NewtonMaterialSetContactFrictionCoef

      ;NewtonMaterialSetContactNormalAcceleration
      ;NewtonMaterialSetContactNormalDirection
      ;NewtonMaterialSetContactPosition

      ;NewtonMaterialSetContactTangentFriction
      ;NewtonMaterialSetContactTangentAcceleration
      ;NewtonMaterialContactRotateTangentDirections

      ;NewtonMaterialGetContactPruningTolerance
      ;NewtonMaterialSetContactPruningTolerance

      ;; ----------------------------------------------
      ;; convex collision primitives creation functions
      ;; ----------------------------------------------

      NewtonCreateNull
      NewtonCreateSphere
      NewtonCreateBox
      NewtonCreateCone ; world  radius height  shapeID offsetMatrix
      NewtonCreateCapsule
      NewtonCreateCylinder ; world  radio0 radio1 height  shapeID offsetMatrix
      NewtonCreateChamferCylinder
      NewtonCreateConvexHull
      NewtonCreateConvexHullFromMesh

      ;NewtonCollisionGetMode
      ;NewtonCollisionSetMode
      ;NewtonConvexHullGetFaceIndices
      ;NewtonConvexHullGetVertexData
      ;NewtonConvexCollisionCalculateVolume
      ;NewtonConvexCollisionCalculateInertialMatrix
      ;NewtonConvexCollisionCalculateBuoyancyVolume
      ;NewtonCollisionDataPointer

      ;; ------------------------------------------------
      ;; compound collision primitives creation functions
      ;; ------------------------------------------------

      NewtonCreateCompoundCollision
      NewtonCreateCompoundCollisionFromMesh

      NewtonCompoundCollisionBeginAddRemove
      NewtonCompoundCollisionAddSubCollision
      ;NewtonCompoundCollisionRemoveSubCollision
      ;NewtonCompoundCollisionRemoveSubCollisionByIndex
      ;NewtonCompoundCollisionSetSubCollisionMatrix
      NewtonCompoundCollisionEndAddRemove

      ;NewtonCompoundCollisionGetFirstNode
      ;NewtonCompoundCollisionGetNextNode
      ;NewtonCompoundCollisionGetNodeByIndex
      ;NewtonCompoundCollisionGetNodeIndex
      ;NewtonCompoundCollisionGetCollisionFromNode

      ;; -------------------------------------------------
      ;; fractured compound collision primitives interface
      ;; -------------------------------------------------

      ;NewtonCreateFracturedCompoundCollision
      ;NewtonFracturedCompoundPlaneClip
      ;NewtonFracturedCompoundSetCallbacks
      ;NewtonFracturedCompoundIsNodeFreeToDetach
      ;NewtonFracturedCompoundNeighborNodeList
      ;NewtonFracturedCompoundGetMainMesh
      ;NewtonFracturedCompoundGetFirstSubMesh
      ;NewtonFracturedCompoundGetNextSubMesh
      ;NewtonFracturedCompoundCollisionGetVertexCount
      ;NewtonFracturedCompoundCollisionGetVertexPositions
      ;NewtonFracturedCompoundCollisionGetVertexNormals
      ;NewtonFracturedCompoundCollisionGetVertexUVs
      ;NewtonFracturedCompoundMeshPartGetIndexStream
      ;NewtonFracturedCompoundMeshPartGetFirstSegment
      ;NewtonFracturedCompoundMeshPartGetNextSegment
      ;NewtonFracturedCompoundMeshPartGetMaterial
      ;NewtonFracturedCompoundMeshPartGetIndexCount

      ;; ---------------------------------------------------------------------------------------
      ;; scene collision are static compound collision that can take polygonal static collisions
      ;; ---------------------------------------------------------------------------------------

      ;NewtonCreateSceneCollision
      ;NewtonSceneCollisionBeginAddRemove
      ;NewtonSceneCollisionAddSubCollision
      ;NewtonSceneCollisionRemoveSubCollision
      ;NewtonSceneCollisionRemoveSubCollisionByIndex
      ;NewtonSceneCollisionSetSubCollisionMatrix
      ;NewtonSceneCollisionEndAddRemove
      ;NewtonSceneCollisionGetFirstNode
      ;NewtonSceneCollisionGetNextNode
      ;NewtonSceneCollisionGetNodeByIndex
      ;NewtonSceneCollisionGetNodeIndex
      ;NewtonSceneCollisionGetCollisionFromNode

      ;; ------------------------------------
      ;; user static mesh collision interface
      ;; ------------------------------------

      ;NewtonCreateUserMeshCollision
      ;NewtonUserMeshCollisionContinuousOverlapTest

      ;; ---------------------------------
      ;; static collision shapes functions
      ;; ---------------------------------

      ;NewtonCreateHeightFieldCollision
      ;NewtonHeightFieldSetUserRayCastCallback

      NewtonCreateTreeCollision
      ;NewtonCreateTreeCollisionFromMesh
      ;NewtonTreeCollisionSetUserRayCastCallback
      NewtonTreeCollisionBeginBuild
      NewtonTreeCollisionAddFace
      NewtonTreeCollisionEndBuild
      ;NewtonTreeCollisionGetFaceAttribute
      ;NewtonTreeCollisionSetFaceAttribute
      ;NewtonTreeCollisionForEachFace
      ;NewtonTreeCollisionGetVertexListTriangleListInAABB
      ;NewtonStaticCollisionSetDebugCallback

      ;; -------------------------------------------
      ;; general purpose collision library functions
      ;; -------------------------------------------

      NewtonCollisionCreateInstance
      NewtonDestroyCollision

      NewtonCollisionGetType
      NewtonCollisionIsConvexShape
      NewtonCollisionIsStaticShape

      NewtonCollisionSetUserData
      NewtonCollisionGetUserData
      NewtonCollisionSetUserID
      NewtonCollisionGetUserID
      ;NewtonCollisionGetMaterial
      ;NewtonCollisionSetMaterial
      ;NewtonCollisionGetSubCollisionHandle
      ;NewtonCollisionGetParentInstance

      ;NewtonCollisionSetMatrix
      ;NewtonCollisionGetMatrix
      ;NewtonCollisionSetScale
      ;NewtonCollisionGetScale
      ;NewtonCollisionGetSkinThickness
      ;NewtonCollisionSetSkinThickness
      
      NewtonCollisionIntersectionTest
      NewtonCollisionPointDistance
      NewtonCollisionClosestPoint
      ;NewtonCollisionCollide
      ;NewtonCollisionCollideContinue
      ;NewtonCollisionSupportVertex
      NewtonCollisionRayCast
      ;NewtonCollisionCalculateAABB
      ;NewtonCollisionForEachPolygonDo

      ;; --------------------
      ;; collision aggregates
      ;; --------------------

      ;NewtonCollisionAggregateCreate
      ;NewtonCollisionAggregateDestroy
      ;NewtonCollisionAggregateAddBody
      ;NewtonCollisionAggregateRemoveBody
      ;NewtonCollisionAggregateGetSelfCollision
      ;NewtonCollisionAggregateSetSelfCollision

      ;; ----------------------------
      ;; transforms utility functions
      ;; ----------------------------

      ;NewtonSetEulerAngle
      ;NewtonGetEulerAngle
      ;NewtonCalculateSpringDamperAcceleration

      ;; ---------------------------
      ;; body manipulation functions
      ;; ---------------------------

      NewtonCreateDynamicBody
      NewtonCreateKinematicBody
      NewtonCreateAsymetricDynamicBody
      NewtonDestroyBody

      NewtonBodyGetSimulationState
      NewtonBodySetSimulationState

      NewtonBodyGetType
      NewtonBodyGetCollidable
      NewtonBodySetCollidable

      NewtonBodyAddForce
      NewtonBodyAddTorque

      ;NewtonBodySetCentreOfMass
      ;NewtonBodySetMassMatrix
      ;NewtonBodySetFullMassMatrix

      NewtonBodySetMassProperties
      NewtonBodySetMatrix
      NewtonBodySetMatrixNoSleep
      ;NewtonBodySetMatrixRecursive

      ;NewtonBodySetMaterialGroupID
      ;NewtonBodySetContinuousCollisionMode
      ;NewtonBodySetJointRecursiveCollision
      NewtonBodySetOmega
      NewtonBodySetOmegaNoSleep
      NewtonBodySetVelocity
      NewtonBodySetVelocityNoSleep
      NewtonBodySetForce
      NewtonBodySetTorque

      NewtonBodySetLinearDamping
      NewtonBodySetAngularDamping
      NewtonBodySetCollision
      ;NewtonBodySetCollisionScale

      NewtonBodyGetSleepState
      ;NewtonBodySetSleepState
      ;NewtonBodyGetAutoSleep
      ;NewtonBodySetAutoSleep
      NewtonBodyGetFreezeState
      NewtonBodySetFreezeState
      ;NewtonBodyGetGyroscopicTorque
      ;NewtonBodySetGyroscopicTorque

      ;NewtonBodySetDestructorCallback
      ;NewtonBodyGetDestructorCallback
      ;NewtonBodySetTransformCallback
      ;NewtonBodyGetTransformCallback
      NewtonBodySetForceAndTorqueCallback
      ;NewtonBodyGetForceAndTorqueCallback

      ;NewtonBodyGetID
      NewtonBodySetUserData
      NewtonBodyGetUserData
      NewtonBodyGetWorld
      NewtonBodyGetCollision
      ;NewtonBodyGetMaterialGroupID
      ;NewtonBodyGetSerializedID
      ;NewtonBodyGetContinuousCollisionMode
      ;NewtonBodyGetJointRecursiveCollision

      NewtonBodyGetPosition
      NewtonBodyGetMatrix
      NewtonBodyGetRotation
      ;NewtonBodyGetMass
      ;NewtonBodyGetInvMass
      ;NewtonBodyGetInertiaMatrix
      ;NewtonBodyGetInvInetiaMatrix
      NewtonBodyGetOmega
      NewtonBodyGetVelocity
      ;NewtonBodyGetAlpha
      ;NewtonBodyGetAcceleration
      ;NewtonBodyGetForce
      ;NewtonBodyGetTorque
      ;NewtonBodyGetCentreOfMass
      ;NewtonBodyGetPointVelocity

      ;NewtonBodyApplyImpulsePair
      ;NewtonBodyAddImpulse
      ;NewtonBodyApplyImpulseArray
      ;NewtonBodyIntegrateVelocity

      ;NewtonBodyGetLinearDamping
      ;NewtonBodyGetAngularDamping
      NewtonBodyGetAABB

      ;NewtonBodyGetFirstJoint
      ;NewtonBodyGetNextJoint
      ;NewtonBodyGetFirstContactJoint
      ;NewtonBodyGetNextContactJoint
      ;NewtonBodyFindContact

      ;; ------------------------
      ;; contact joints interface
      ;; ------------------------

      NewtonContactJointGetFirstContact
      NewtonContactJointGetNextContact
      NewtonContactJointGetContactCount
      NewtonContactJointRemoveContact
      NewtonContactJointGetClosestDistance
      ;NewtonContactJointResetSelftJointCollision
      ;NewtonContactJointResetIntraJointCollision
      ;NewtonContactGetMaterial
      NewtonContactGetCollision0
      NewtonContactGetCollision1
      NewtonContactGetCollisionID0
      NewtonContactGetCollisionID1

      ;; ----------------------
      ;; common joint functions
      ;; ----------------------

      ;NewtonJointGetUserData
      ;NewtonJointSetUserData
      NewtonJointGetBody0
      NewtonJointGetBody1
      ;NewtonJointGetInfo
      ;NewtonJointGetCollisionState
      ;NewtonJointSetCollisionState
      ;NewtonJointGetStiffness
      ;NewtonJointSetStiffness
      ;NewtonDestroyJoint
      ;NewtonJointSetDestructor
      ;NewtonJointIsActive

      ;; -------------------------
      ;; particle system interface
      ;; -------------------------

      ;NewtonCreateMassSpringDamperSystem
      ;NewtonCreateDeformableSolid
      ;NewtonDeformableMeshGetParticleCount
      ;NewtonDeformableMeshGetParticleStrideInBytes
      ;NewtonDeformableMeshGetParticleArray

      ;; -------------------------------
      ;; ball and socket joint functions
      ;; -------------------------------

      ;NewtonConstraintCreateBall
      ;NewtonBallSetUserCallback
      ;NewtonBallGetJointAngle
      ;NewtonBallGetJointOmega
      ;NewtonBallGetJointForce
      ;NewtonBallSetConeLimits

      ;; ---------------------
      ;; hinge joint functions
      ;; ---------------------

      ;NewtonConstraintCreateHinge
      ;NewtonHingeSetUserCallback
      ;NewtonHingeGetJointAngle
      ;NewtonHingeGetJointOmega
      ;NewtonHingeGetJointForce
      ;NewtonHingeCalculateStopAlpha

      ;; ----------------------
      ;; slider joint functions
      ;; ----------------------

      ;NewtonConstraintCreateSlider
      ;NewtonSliderSetUserCallback
      ;NewtonSliderGetJointPosit
      ;NewtonSliderGetJointVeloc
      ;NewtonSliderGetJointForce
      ;NewtonSliderCalculateStopAccel

      ;; -------------------------
      ;; corkscrew joint functions
      ;; -------------------------

      ;NewtonConstraintCreateCorkscrew
      ;NewtonCorkscrewSetUserCallback
      ;NewtonCorkscrewGetJointPosit
      ;NewtonCorkscrewGetJointAngle
      ;NewtonCorkscrewGetJointVeloc
      ;NewtonCorkscrewGetJointOmega
      ;NewtonCorkscrewGetJointForce
      ;NewtonCorkscrewCalculateStopAlpha
      ;NewtonCorkscrewCalculateStopAccel

      ;; -------------------------
      ;; universal joint functions
      ;; -------------------------

      ;NewtonConstraintCreateUniversal
      ;NewtonUniversalSetUserCallback
      ;NewtonUniversalGetJointAngle0
      ;NewtonUniversalGetJointAngle1
      ;NewtonUniversalGetJointOmega0
      ;NewtonUniversalGetJointOmega1
      ;NewtonUniversalGetJointForce
      ;NewtonUniversalCalculateStopAlpha0
      ;NewtonUniversalCalculateStopAlpha1

      ;; -------------------------
      ;; up vector joint functions
      ;; -------------------------

      ;NewtonConstraintCreateUpVector
      ;NewtonUpVectorGetPin
      ;NewtonUpVectorSetPin

      ;; ----------------------------
      ;; user defined bilateral joint
      ;; ----------------------------

      ;NewtonConstraintCreateUserJoint
      ;NewtonUserJointGetSolverModel
      ;NewtonUserJointSetSolverModel
      ;NewtonUserJointMassScale
      ;NewtonUserJointSetFeedbackCollectorCallback
      ;NewtonUserJointAddLinearRow
      ;NewtonUserJointAddAngularRow
      ;NewtonUserJointAddGeneralRow
      ;NewtonUserJointSetRowMinimumFriction
      ;NewtonUserJointSetRowMaximumFriction
      ;NewtonUserJointCalculateRowZeroAcceleration
      ;NewtonUserJointGetRowAcceleration
      ;NewtonUserJointGetRowJacobian
      ;NewtonUserJointSetRowAcceleration
      ;NewtonUserJointSetRowMassDependentSpringDamperAcceleration
      ;NewtonUserJointSetRowMassIndependentSpringDamperAcceleration
      ;NewtonUserJointSetRowStiffness
      ;NewtonUserJoinRowsCount
      ;NewtonUserJointGetGeneralRow
      ;NewtonUserJointGetRowForce

      ;; --------------------
      ;; mesh joint functions
      ;; --------------------

      NewtonMeshCreate
      ;NewtonMeshCreateFromMesh
      ;NewtonMeshCreateFromCollision
      ;NewtonMeshCreateTetrahedraIsoSurface
      ;NewtonMeshCreateConvexHull
      ;NewtonMeshCreateVoronoiConvexDecomposition
      NewtonMeshDestroy

      ;NewtonMeshFlipWinding
      ;NewtonMeshApplyTransform
      ;NewtonMeshCalculateOOBB
      ;NewtonMeshCalculateVertexNormals
      ;NewtonMeshApplySphericalMapping
      ;NewtonMeshApplyCylindricalMapping
      ;NewtonMeshApplyBoxMapping
      ;NewtonMeshApplyAngleBasedMapping
      ;NewtonCreateTetrahedraLinearBlendSkinWeightsChannel
      ;NewtonMeshOptimize
      ;NewtonMeshOptimizePoints
      ;NewtonMeshOptimizeVertex
      ;NewtonMeshIsOpenMesh
      ;NewtonMeshFixTJoints
      ;NewtonMeshPolygonize
      ;NewtonMeshTriangulate
      ;NewtonMeshUnion
      ;NewtonMeshDifference
      ;NewtonMeshIntersection
      ;NewtonMeshClip
      ;NewtonMeshConvexMeshIntersection
      ;NewtonMeshSimplify
      ;NewtonMeshApproximateConvexDecomposition
      ;NewtonRemoveUnusedVertices

      NewtonMeshBeginBuild
      NewtonMeshBeginFace
      NewtonMeshAddPoint
      ;NewtonMeshAddLayer
      NewtonMeshAddMaterial
      NewtonMeshAddNormal
      ;NewtonMeshAddBinormal
      ;NewtonMeshAddUV0
      ;NewtonMeshAddUV1
      ;NewtonMeshAddVertexColor
      NewtonMeshEndFace
      NewtonMeshEndBuild

      ;NewtonMeshClearVertexFormat
      ;NewtonMeshBuildFromVertexListIndexList

      ;NewtonMeshGetPointCount
      ;NewtonMeshGetIndexToVertexMap
      ;NewtonMeshGetVertexDoubleChannel
      ;NewtonMeshGetVertexChannel
      ;NewtonMeshGetNormalChannel
      ;NewtonMeshGetBinormalChannel
      ;NewtonMeshGetUV0Channel
      ;NewtonMeshGetUV1Channel
      ;NewtonMeshGetVertexColorChannel

      ;NewtonMeshHasNormalChannel
      ;NewtonMeshHasBinormalChannel
      ;NewtonMeshHasUV0Channel
      ;NewtonMeshHasUV1Channel
      ;NewtonMeshHasVertexColorChannel

      ;NewtonMeshBeginHandle
      ;NewtonMeshEndHandle
      ;NewtonMeshFirstMaterial
      ;NewtonMeshNextMaterial
      ;NewtonMeshMaterialGetMaterial
      ;NewtonMeshMaterialGetIndexCount
      ;NewtonMeshMaterialGetIndexStream
      ;NewtonMeshMaterialGetIndexStreamShort

      ;NewtonMeshCreateFirstSingleSegment
      ;NewtonMeshCreateNextSingleSegment
      ;NewtonMeshCreateFirstLayer
      ;NewtonMeshCreateNextLayer

      ;NewtonMeshGetTotalFaceCount
      ;NewtonMeshGetTotalIndexCount
      ;NewtonMeshGetFaces
      ;NewtonMeshGetVertexCount
      ;NewtonMeshGetVertexStrideInByte
      ;NewtonMeshGetVertexArray
      ;NewtonMeshGetVertexBaseCount
      ;NewtonMeshSetVertexBaseCount
      ;NewtonMeshGetFirstVertex
      ;NewtonMeshGetNextVertex
      ;NewtonMeshGetVertexIndex
      ;NewtonMeshGetFirstPoint
      ;NewtonMeshGetNextPoint
      ;NewtonMeshGetPointIndex
      ;NewtonMeshGetVertexIndexFromPoint
      ;NewtonMeshGetFirstEdge
      ;NewtonMeshGetNextEdge
      ;NewtonMeshGetEdgeIndices
      ;NewtonMeshGetFirstFace
      ;NewtonMeshGetNextFace
      ;NewtonMeshIsFaceOpen
      ;NewtonMeshGetFaceMaterial
      ;NewtonMeshGetFaceIndexCount
      ;NewtonMeshGetFaceIndices
      ;NewtonMeshGetFacePointIndices
      ;NewtonMeshCalculateFaceNormal
      ;NewtonMeshSetFaceMaterial

)
(begin

   (define SO (or
      (load-dynamic-library "libnewton-dynamics.so")
      (load-dynamic-library "libnewton-dynamics.dll")
      (runtime-error "Can't load newton library" #null)))
   (define newton SO) ; legacy name

   ; basic types
   (define int fft-int)
   (define void fft-void)
   (define void* fft-void*)

   ; 
   (define NewtonWorldGetVersion (SO int "NewtonWorldGetVersion"))
   (define NewtonWorldFloatSize  (SO int "NewtonWorldFloatSize"))

   (define _NEWTON_USE_DOUBLE (eq? (NewtonWorldFloatSize) 8))
   (define dFloat32 fft-float)
   (define dFloat64 fft-double)
   (define dLong fft-long-long)

   ; advanced types

   (define dFloat (if _NEWTON_USE_DOUBLE fft-double fft-float))
   (define dFloat* (fft* dFloat))
   (define dFloat& (fft& dFloat))
   (define dLong* (fft* dLong))
   (define dLong& (fft& dLong))

   (define NEWTON_DYNAMIC_BODY           1)
   (define NEWTON_KINEMATIC_BODY         2)
   (define NEWTON_DYNAMIC_ASYMETRIC_BODY 3)

   ; newton types
   (define NewtonWorld* type-vptr)
   (define NewtonCollision* type-vptr)
   (define NewtonBody* type-vptr)
   (define NewtonMaterial* type-vptr)
   (define NewtonMesh* type-vptr)
   (define NewtonJoint* type-vptr)
   (define NewtonUserContactPoint* type-vptr)
   (define NewtonContact* type-vptr)

   (define NewtonFracturedCompoundMeshPart* type-vptr)

   ; -----------------------
   ; world control functions
   ; -----------------------

   (define NewtonGetMemoryUsed (SO int "NewtonGetMemoryUsed"))

   (define NewtonCreate (SO NewtonWorld* "NewtonCreate"))
   (define NewtonDestroy (SO void "NewtonDestroy" NewtonWorld*))
   (define NewtonDestroyAllBodies (SO void "NewtonDestroyAllBodies" NewtonWorld*))

   (define NewtonAlloc (SO void* "NewtonAlloc" int))
   (define NewtonFree (SO void "NewtonFree" void*))

   (define NewtonInvalidateCache (SO void "NewtonInvalidateCache" NewtonWorld*))

   (define NewtonSetSolverIterations (SO void "NewtonSetSolverIterations" NewtonWorld* int)) ; model of operation n = number of iteration default value is 4.
   (define NewtonGetSolverIterations (SO int "NewtonGetSolverIterations" NewtonWorld*))

   (define NewtonUpdate (SO void "NewtonUpdate" NewtonWorld* dFloat))
   (define NewtonGetLastUpdateTime (SO dFloat "NewtonGetLastUpdateTime" NewtonWorld*))

   (define NewtonSetThreadsCount (SO void "NewtonSetThreadsCount" NewtonWorld* int))
   (define NewtonGetThreadsCount (SO int "NewtonGetThreadsCount" NewtonWorld*))

   (define NewtonWorldSetUserData (SO void "NewtonWorldSetUserData" NewtonWorld* void*))
   (define NewtonWorldGetUserData (SO void* "NewtonWorldGetUserData" NewtonWorld*))

   ; --------------------
   ; NewtonWorldRayCast

   (define *NewtonWorldRayFilterCallback type-callable)
   (define (NewtonWorldRayFilterCallback f)
      (make-callback (vm:pin (cons
         (cons dFloat (list
         ;  body        shapeHit         hitContact hitNormal collisionID userData intersectParam
         ;                               dFloat*    dFloat*               void*
            NewtonBody* NewtonCollision* void*      void*     dLong       int      dFloat))
         f))))

   (define *NewtonWorldRayPrefilterCallback type-callable)
   (define (NewtonWorldRayPrefilterCallback f)
      (make-callback (vm:pin (cons
         (cons fft-unsigned-int (list
         ;  body        collision        userData
            NewtonBody* NewtonCollision* void*))
         f))))

   (define NewtonWorldRayCast (SO void "NewtonWorldRayCast" NewtonWorld* dFloat* dFloat* *NewtonWorldRayFilterCallback int *NewtonWorldRayPrefilterCallback int))

   ;; ------------------------
   ;; Physics Material Section
   ;; ------------------------
   
   (define NewtonMaterialGetDefaultGroupID (SO int "NewtonMaterialGetDefaultGroupID" NewtonWorld*))

   (define *NewtonOnAABBOverlap type-callable)
   (define (NewtonOnAABBOverlap f)
      (make-callback (vm:pin (cons
         (cons int (list
         ;  contact      timestep threadIndex
            NewtonJoint* dFloat   int))
         f))))

   (define *NewtonContactsProcess type-callable)
   (define (NewtonContactsProcess f)
      (make-callback (vm:pin (cons
         (cons void (list
         ;  joint        timestep threadIndex
            NewtonJoint* dFloat   int))
         f))))

   (define NewtonMaterialSetCollisionCallback (newton void "NewtonMaterialSetCollisionCallback" NewtonWorld* int int *NewtonOnAABBOverlap *NewtonContactsProcess))

   (define *NewtonOnContactGeneration type-callable)
   (define (NewtonOnContactGeneration f)
      (make-callback (vm:pin (cons
         (cons int (list
         ;  material        body0       collision0       body1       collision1       contactBuffer           maxCount threadIndex
            NewtonMaterial* NewtonBody* NewtonCollision* NewtonBody* NewtonCollision* NewtonUserContactPoint* int      int))
         f))))

   (define NewtonMaterialSetContactGenerationCallback (newton void "NewtonMaterialSetContactGenerationCallback" NewtonWorld* int int *NewtonOnContactGeneration))


   (define *NewtonOnCompoundSubCollisionAABBOverlap type-callable)
   (define (NewtonOnCompoundSubCollisionAABBOverlap f)
      (make-callback (vm:pin (cons
         (cons int (list
         ;  contact      timestep body0       collisionNode0 body1       collisionNode1 threadIndex
            NewtonJoint* dFloat   NewtonBody* void*          NewtonBody* void*          int))
         f))))

   (define NewtonMaterialSetCompoundCollisionCallback (newton void "NewtonMaterialSetCompoundCollisionCallback" NewtonWorld* int int *NewtonOnCompoundSubCollisionAABBOverlap))

   (define NewtonWorldGetFirstBody (newton NewtonBody* "NewtonWorldGetFirstBody" NewtonWorld*))
   (define NewtonWorldGetNextBody (newton NewtonBody* "NewtonWorldGetNextBody" NewtonWorld* NewtonBody*))

   ;; ----------------------------------------------
   ;; convex collision primitives creation functions
   ;; ----------------------------------------------

   (define NewtonCreateNull (SO NewtonCollision* "NewtonCreateNull" NewtonWorld*))
   (define NewtonCreateSphere (SO NewtonCollision* "NewtonCreateSphere" NewtonWorld* dFloat int dFloat*))
   (define NewtonCreateBox (SO NewtonCollision* "NewtonCreateBox" NewtonWorld* dFloat dFloat dFloat int dFloat*))
   (define NewtonCreateCone (SO NewtonCollision* "NewtonCreateCone" NewtonWorld* dFloat dFloat int dFloat*))
   (define NewtonCreateCapsule (SO NewtonCollision* "NewtonCreateCapsule" NewtonWorld* dFloat dFloat dFloat int dFloat*))
   (define NewtonCreateCylinder (SO NewtonCollision* "NewtonCreateCylinder" NewtonWorld* dFloat dFloat dFloat int dFloat*))
   (define NewtonCreateChamferCylinder (SO NewtonCollision* "NewtonCreateChamferCylinder" NewtonWorld* dFloat dFloat int dFloat*))
   (define NewtonCreateConvexHull (SO NewtonCollision* "NewtonCreateConvexHull" NewtonWorld* int dFloat* int dFloat int dFloat*))
   (define NewtonCreateConvexHullFromMesh (SO NewtonCollision* "NewtonCreateConvexHullFromMesh" NewtonWorld* NewtonMesh* dFloat int))

   ;; ------------------------------------------------
   ;; compound collision primitives creation functions
   ;; ------------------------------------------------

   (define NewtonCreateCompoundCollision (SO NewtonCollision* "NewtonCreateCompoundCollision" NewtonWorld* int))
   (define NewtonCreateCompoundCollisionFromMesh (SO NewtonCollision* "NewtonCreateCompoundCollisionFromMesh" NewtonWorld* NewtonMesh* dFloat int int))
   (define NewtonCompoundCollisionBeginAddRemove (SO void "NewtonCompoundCollisionBeginAddRemove" NewtonCollision*))
   (define NewtonCompoundCollisionAddSubCollision (SO void* "NewtonCompoundCollisionAddSubCollision" NewtonCollision* NewtonCollision*))
   (define NewtonCompoundCollisionEndAddRemove (SO void "NewtonCompoundCollisionEndAddRemove" NewtonCollision*))

   ;; ---------------------------------
   ;; static collision shapes functions
   ;; ---------------------------------

   (define NewtonCreateTreeCollision (SO NewtonCollision* "NewtonCreateTreeCollision" NewtonWorld* int))
   (define NewtonTreeCollisionBeginBuild (SO void "NewtonTreeCollisionBeginBuild" NewtonCollision*))
   (define NewtonTreeCollisionAddFace (SO void "NewtonTreeCollisionAddFace" NewtonCollision* int dFloat* int int))
   (define NewtonTreeCollisionEndBuild (SO void "NewtonTreeCollisionEndBuild" NewtonCollision* int))

   ;; -------------------------------------------
   ;; general purpose collision library functions
   ;; -------------------------------------------

   (define NewtonCollisionCreateInstance (SO NewtonCollision* "NewtonCollisionCreateInstance" NewtonCollision*))
   (define NewtonDestroyCollision (SO fft-void "NewtonDestroyCollision" NewtonCollision*))

   (define NewtonCollisionGetType (SO int "NewtonCollisionGetType" NewtonCollision*))
   (define NewtonCollisionIsConvexShape (SO int "NewtonCollisionIsConvexShape" NewtonCollision*))
   (define NewtonCollisionIsStaticShape (SO int "NewtonCollisionIsStaticShape" NewtonCollision*))

   (define NewtonCollisionSetUserData (SO void "NewtonCollisionSetUserData" NewtonCollision* int)) ; todo: long long
   (define NewtonCollisionGetUserData (SO int "NewtonCollisionGetUserData" NewtonCollision*))
   (define NewtonCollisionSetUserID (SO void "NewtonCollisionSetUserID" NewtonCollision* int))
   (define NewtonCollisionGetUserID (SO int "NewtonCollisionGetUserID" NewtonCollision*))


   (define NewtonCollisionIntersectionTest (SO int "NewtonCollisionIntersectionTest" NewtonWorld* NewtonCollision* dFloat* NewtonCollision* dFloat* int))
   (define NewtonCollisionPointDistance (SO int "NewtonCollisionPointDistance" NewtonWorld* dFloat* NewtonCollision* dFloat* dFloat& dFloat& int))
   (define NewtonCollisionClosestPoint (SO int "NewtonCollisionClosestPoint" NewtonWorld* NewtonCollision* dFloat* NewtonCollision* dFloat* dFloat& dFloat& dFloat& int))
   (define NewtonCollisionRayCast (SO dFloat "NewtonCollisionRayCast" NewtonCollision* dFloat* dFloat* dFloat& dLong&))

   ;; ---------------------------
   ;; body manipulation functions
   ;; ---------------------------

   (define NewtonCreateDynamicBody (SO NewtonBody* "NewtonCreateDynamicBody" NewtonWorld* NewtonCollision* dFloat*))
   (define NewtonCreateKinematicBody (SO NewtonBody* "NewtonCreateKinematicBody" NewtonWorld* NewtonCollision* dFloat*))
   (define NewtonCreateAsymetricDynamicBody (SO NewtonBody* "NewtonCreateAsymetricDynamicBody" NewtonWorld* NewtonCollision* dFloat*))
   (define NewtonDestroyBody (SO fft-void "NewtonDestroyBody" NewtonBody*))

   (define NewtonBodyGetSimulationState (SO int "NewtonBodyGetSimulationState" NewtonBody*))
   (define NewtonBodySetSimulationState (SO void "NewtonBodySetSimulationState" NewtonBody* int))

   (define NewtonBodyGetType (SO int "NewtonBodyGetType" NewtonBody*))
   (define NewtonBodyGetCollidable (SO int "NewtonBodyGetCollidable" NewtonBody*))
   (define NewtonBodySetCollidable (SO void "NewtonBodySetCollidable" NewtonBody* int))

   (define NewtonBodyAddForce (SO void "NewtonBodyAddForce" NewtonBody* dFloat*))
   (define NewtonBodyAddTorque (SO void "NewtonBodyAddTorque" NewtonBody* dFloat*))

   (define NewtonBodySetMassProperties (SO void "NewtonBodySetMassProperties" NewtonBody* dFloat NewtonCollision*))
   (define NewtonBodySetMatrix (SO void "NewtonBodySetMatrix" NewtonBody* dFloat*))
   (define NewtonBodySetMatrixNoSleep (SO void "NewtonBodySetMatrixNoSleep" NewtonBody* dFloat*))

   (define NewtonBodySetOmega (SO void "NewtonBodySetOmega" NewtonBody* dFloat*))
   (define NewtonBodySetOmegaNoSleep (SO void "NewtonBodySetOmegaNoSleep" NewtonBody* dFloat*))
   (define NewtonBodySetVelocity (SO void "NewtonBodySetVelocity" NewtonBody* dFloat*))
   (define NewtonBodySetVelocityNoSleep (SO void "NewtonBodySetVelocityNoSleep" NewtonBody* dFloat*))
   (define NewtonBodySetForce (SO void "NewtonBodySetForce" NewtonBody* dFloat*))
   (define NewtonBodySetTorque (SO void "NewtonBodySetTorque" NewtonBody* dFloat*))

   (define NewtonBodySetLinearDamping (SO void "NewtonBodySetLinearDamping" NewtonBody* dFloat))
   (define NewtonBodySetAngularDamping (SO void "NewtonBodySetAngularDamping" NewtonBody* dFloat*))
   (define NewtonBodySetCollision (SO fft-void "NewtonBodySetCollision" NewtonBody* NewtonCollision*))

   (define NewtonBodyGetSleepState (SO int "NewtonBodyGetSleepState" NewtonBody*))

   (define NewtonBodyGetFreezeState (SO int "NewtonBodyGetFreezeState" NewtonBody*))
   (define NewtonBodySetFreezeState (SO void "NewtonBodySetFreezeState" NewtonBody* int))

   (define *NewtonApplyForceAndTorque type-callable)
   (define (NewtonApplyForceAndTorque f)
      (make-callback (vm:pin (cons
         (cons void (list
         ;  body        timestep threadIndex
            NewtonBody* dFloat   int))
         f))))
   (define NewtonBodySetForceAndTorqueCallback (SO void "NewtonBodySetForceAndTorqueCallback" NewtonBody* *NewtonApplyForceAndTorque))

   (define NewtonBodySetUserData (SO void "NewtonBodySetUserData" NewtonBody* int))
   (define NewtonBodyGetUserData (SO int "NewtonBodyGetUserData" NewtonBody*))

   (define NewtonBodyGetWorld (SO NewtonWorld* "NewtonBodyGetWorld" NewtonBody*))
   (define NewtonBodyGetCollision (SO NewtonCollision* "NewtonBodyGetCollision" NewtonBody*))

   (define NewtonBodyGetPosition (SO void "NewtonBodyGetPosition" NewtonBody* dFloat&))
   (define NewtonBodyGetMatrix (SO void "NewtonBodyGetMatrix" NewtonBody* dFloat&))
   (define NewtonBodyGetRotation (SO void "NewtonBodyGetRotation" NewtonBody* dFloat&))
   (define NewtonBodyGetOmega (SO void "NewtonBodyGetOmega" NewtonBody* dFloat&))
   (define NewtonBodyGetVelocity (SO void "NewtonBodyGetVelocity" NewtonBody* dFloat&))
   (define NewtonBodyGetAABB (SO void "NewtonBodyGetAABB" NewtonBody* dFloat& dFloat&))

   (define NewtonContactJointGetFirstContact (SO NewtonContact* "NewtonContactJointGetFirstContact" NewtonJoint*))
   (define NewtonContactJointGetNextContact (SO NewtonContact* "NewtonContactJointGetNextContact" NewtonJoint* NewtonContact*))
   (define NewtonContactJointGetContactCount #f)
   (define NewtonContactJointRemoveContact (SO void "NewtonContactJointRemoveContact" NewtonJoint* NewtonContact*))
   (define NewtonContactJointGetClosestDistance #f)
      ;NewtonContactGetMaterial
   (define NewtonContactGetCollision0 (SO NewtonCollision* "NewtonContactGetCollision0" NewtonContact*))
   (define NewtonContactGetCollision1 (SO NewtonCollision* "NewtonContactGetCollision1" NewtonContact*))
   (define NewtonContactGetCollisionID0 (SO int "NewtonContactGetCollisionID0" NewtonContact*))
   (define NewtonContactGetCollisionID1 (SO int "NewtonContactGetCollisionID1" NewtonContact*))

   (define NewtonJointGetBody0 (SO NewtonBody* "NewtonJointGetBody0" NewtonJoint*))
   (define NewtonJointGetBody1 (SO NewtonBody* "NewtonJointGetBody1" NewtonJoint*))

   (define NewtonMeshCreate (SO NewtonMesh* "NewtonMeshCreate" NewtonWorld*))
   (define NewtonMeshDestroy (SO void "NewtonMeshDestroy" NewtonMesh*))

   (define NewtonMeshBeginBuild (SO void "NewtonMeshBeginBuild" NewtonMesh*))
   (define NewtonMeshBeginFace (SO void "NewtonMeshBeginFace" NewtonMesh*))
   (define NewtonMeshAddPoint (SO void "NewtonMeshAddPoint" NewtonMesh* dFloat64 dFloat64 dFloat64))
   (define NewtonMeshAddMaterial (SO void "NewtonMeshAddMaterial" NewtonMesh* int))
   (define NewtonMeshAddNormal (SO void "NewtonMeshAddNormal" NewtonMesh* dFloat dFloat dFloat))
   (define NewtonMeshEndFace (SO void "NewtonMeshEndFace" NewtonMesh*))
   (define NewtonMeshEndBuild (SO void "NewtonMeshEndBuild" NewtonMesh*))

   (let ((version (NewtonWorldGetVersion)))
      (print-to stderr "newton-dynamics version " (div version 100) "." (mod version 100)))

))
