.PHONY: all

all: libnewton-dynamics.so \
     libnewton-dynamics-4.so

install: libnewton-dynamics.so
	@echo Installing .so binary...
	install -d $(DESTDIR)$(PREFIX)/lib
	install libnewton-dynamics.so $(DESTDIR)$(PREFIX)/lib/libnewton-dynamics.so
	@echo Installing ol library...
	install -d $(DESTDIR)$(PREFIX)/lib/ol/lib
	install -m 644 lib/newton-dynamics.scm $(DESTDIR)$(PREFIX)/lib/ol/lib/newton-dynamics.scm
	@echo Ok


# ******************************************************
#
# dg low level library
#
# ******************************************************
DG_INCLUDED_PATH =newton-dynamics/newton-3.14/sdk/dgCore

DG_PATH          =$(DG_INCLUDED_PATH)/
DG_SRCS = \
	$(DG_PATH)dg.cpp \
	$(DG_PATH)dgAABBPolygonSoup.cpp \
	$(DG_PATH)dgCRC.cpp \
	$(DG_PATH)dgConvexHull3d.cpp \
	$(DG_PATH)dgConvexHull4d.cpp \
	$(DG_PATH)dgDebug.cpp \
	$(DG_PATH)dgDelaunayTetrahedralization.cpp \
	$(DG_PATH)dgGeneralMatrix.cpp \
	$(DG_PATH)dgGeneralVector.cpp \
	$(DG_PATH)dgGoogol.cpp \
	$(DG_PATH)dgIntersections.cpp \
	$(DG_PATH)dgMatrix.cpp \
	$(DG_PATH)dgMemory.cpp \
	$(DG_PATH)dgMutexThread.cpp \
	$(DG_PATH)dgNode.cpp \
	$(DG_PATH)dgObb.cpp \
	$(DG_PATH)dgPolygonSoupBuilder.cpp \
	$(DG_PATH)dgPolygonSoupDatabase.cpp \
	$(DG_PATH)dgPolyhedra.cpp \
	$(DG_PATH)dgPolyhedraMassProperties.cpp \
	$(DG_PATH)dgProfiler.cpp \
	$(DG_PATH)dgQuaternion.cpp \
	$(DG_PATH)dgRandom.cpp \
	$(DG_PATH)dgRef.cpp \
	$(DG_PATH)dgRefCounter.cpp \
	$(DG_PATH)dgSmallDeterminant.cpp \
	$(DG_PATH)dgThread.cpp \
	$(DG_PATH)dgThreadHive.cpp \
	$(DG_PATH)dgTree.cpp \
	$(DG_PATH)dgTypes.cpp


# *****************************************************************
#
# Physics engine files
#
# *****************************************************************
DG_INCLUDED_PHYSICS_PATH =newton-dynamics/newton-3.14/sdk/dgPhysics
DG_PHYSICS_PATH = $(DG_INCLUDED_PHYSICS_PATH)/

DG_PHYSICS_SRCS = \
	$(DG_PHYSICS_PATH)dgBallConstraint.cpp \
	$(DG_PHYSICS_PATH)dgBilateralConstraint.cpp \
	$(DG_PHYSICS_PATH)dgBody.cpp \
	$(DG_PHYSICS_PATH)dgBodyMasterList.cpp \
	$(DG_PHYSICS_PATH)dgBroadPhase.cpp \
	$(DG_PHYSICS_PATH)dgBroadPhaseAggregate.cpp \
	$(DG_PHYSICS_PATH)dgBroadPhaseMixed.cpp \
	$(DG_PHYSICS_PATH)dgBroadPhaseSegregated.cpp \
	$(DG_PHYSICS_PATH)dgCollision.cpp \
	$(DG_PHYSICS_PATH)dgCollisionBVH.cpp \
	$(DG_PHYSICS_PATH)dgCollisionBox.cpp \
	$(DG_PHYSICS_PATH)dgCollisionCapsule.cpp \
	$(DG_PHYSICS_PATH)dgCollisionChamferCylinder.cpp \
	$(DG_PHYSICS_PATH)dgCollisionCompound.cpp \
	$(DG_PHYSICS_PATH)dgCollisionCompoundFractured.cpp \
	$(DG_PHYSICS_PATH)dgCollisionCone.cpp \
	$(DG_PHYSICS_PATH)dgCollisionConvex.cpp \
	$(DG_PHYSICS_PATH)dgCollisionConvexHull.cpp \
	$(DG_PHYSICS_PATH)dgCollisionConvexPolygon.cpp \
	$(DG_PHYSICS_PATH)dgCollisionCylinder.cpp \
	$(DG_PHYSICS_PATH)dgCollisionDeformableMesh.cpp \
	$(DG_PHYSICS_PATH)dgCollisionDeformableSolidMesh.cpp \
	$(DG_PHYSICS_PATH)dgCollisionHeightField.cpp \
	$(DG_PHYSICS_PATH)dgCollisionIncompressibleParticles.cpp \
	$(DG_PHYSICS_PATH)dgCollisionInstance.cpp \
	$(DG_PHYSICS_PATH)dgCollisionLumpedMassParticles.cpp \
	$(DG_PHYSICS_PATH)dgCollisionMassSpringDamperSystem.cpp \
	$(DG_PHYSICS_PATH)dgCollisionMesh.cpp \
	$(DG_PHYSICS_PATH)dgCollisionNull.cpp \
	$(DG_PHYSICS_PATH)dgCollisionScene.cpp \
	$(DG_PHYSICS_PATH)dgCollisionSphere.cpp \
	$(DG_PHYSICS_PATH)dgCollisionUserMesh.cpp \
	$(DG_PHYSICS_PATH)dgConstraint.cpp \
	$(DG_PHYSICS_PATH)dgContact.cpp \
	$(DG_PHYSICS_PATH)dgContactSolver.cpp \
	$(DG_PHYSICS_PATH)dgCorkscrewConstraint.cpp \
	$(DG_PHYSICS_PATH)dgDynamicBody.cpp \
	$(DG_PHYSICS_PATH)dgHingeConstraint.cpp \
	$(DG_PHYSICS_PATH)dgKinematicBody.cpp \
	$(DG_PHYSICS_PATH)dgNarrowPhaseCollision.cpp \
	$(DG_PHYSICS_PATH)dgSkeletonContainer.cpp \
	$(DG_PHYSICS_PATH)dgSlidingConstraint.cpp \
	$(DG_PHYSICS_PATH)dgUniversalConstraint.cpp \
	$(DG_PHYSICS_PATH)dgUpVectorConstraint.cpp \
	$(DG_PHYSICS_PATH)dgUserConstraint.cpp \
	$(DG_PHYSICS_PATH)dgWorld.cpp \
	$(DG_PHYSICS_PATH)dgWorldDynamicUpdate.cpp \
	$(DG_PHYSICS_PATH)dgWorldDynamicsParallelSolver.cpp \
	$(DG_PHYSICS_PATH)dgWorldDynamicsSimpleSolver.cpp \
	$(DG_PHYSICS_PATH)dgWorldPlugins.cpp


# ****************************************************************
#
# mesh gemotry 
#
# ****************************************************************
DG_INCLUDED_MESH_PATH = newton-dynamics/newton-3.14/sdk/dgMeshUtil
DG_MESH_PATH = $(DG_INCLUDED_MESH_PATH)/
DG_MESH_SRCS = \
	$(DG_MESH_PATH)dgMeshEffect1.cpp \
	$(DG_MESH_PATH)dgMeshEffect2.cpp \
	$(DG_MESH_PATH)dgMeshEffect3.cpp \
	$(DG_MESH_PATH)dgMeshEffect4.cpp \
	$(DG_MESH_PATH)dgMeshEffect5.cpp \
	$(DG_MESH_PATH)dgMeshEffect6.cpp 


# ****************************************************************
#
# Newton engine files
#
# ****************************************************************
DG_INCLUDED_NEWTON_PATH = newton-dynamics/newton-3.14/sdk/dgNewton
DG_NEWTON_PATH = $(DG_INCLUDED_NEWTON_PATH)/

DG_NEWTON_SRCS = \
	$(DG_NEWTON_PATH)Newton.cpp \
	$(DG_NEWTON_PATH)NewtonClass.cpp


SRC_FILES = $(DG_SRCS) $(DG_PHYSICS_SRCS) $(DG_NEWTON_SRCS) $(DG_MESH_SRCS) #$(DG_OPENCL_SRCS)
#OBJ_FILES = $(SRC_FILES:.cpp=.o)

CPU_FLAGS = -fPIC -msse -msse3 -msse4 -mfpmath=sse -ffloat-store -ffast-math -freciprocal-math -funsafe-math-optimizations -fsingle-precision-constant
FLAGS += -Wall -Wno-strict-aliasing -D_POSIX_VER $(CPU_FLAGS) -I$(DG_INCLUDED_PATH) -I$(DG_INCLUDED_PHYSICS_PATH) -I$(DG_INCLUDED_NEWTON_PATH) -I$(DG_INCLUDED_MESH_PATH)
FLAGS += -Os -g0
FLAGS += -DDG_DISABLE_ASSERT

#.SUFFIXES : .o .cpp
#.cpp.o :
#	$(CC) -c $(FLAGS) -o $@ $<

libnewton-dynamics.so: $(SRC_FILES)
	$(CC) $(FLAGS) $(SRC_FILES) \
	-lstdc++ -lm -pthread \
	-shared -o libnewton-dynamics.so

libnewton-dynamics.dll: CC:=x86_64-w64-mingw32-g++-posix
libnewton-dynamics.dll: $(SRC_FILES)
	$(CC) $(FLAGS) $(SRC_FILES) \
	-shared -o libnewton-dynamics.dll

# *********************************************************************************************************
# newton-dynamics 4.00
#
SRC4_FILES = \
	newton-dynamics/newton-4.00/sdk/dCollision/ndBody.cpp \
	newton-dynamics/newton-4.00/sdk/dCollision/ndBodyKinematic.cpp \
	newton-dynamics/newton-4.00/sdk/dCollision/ndBodyKinematicBase.cpp \
	newton-dynamics/newton-4.00/sdk/dCollision/ndBodyListView.cpp \
	newton-dynamics/newton-4.00/sdk/dCollision/ndBodyNotify.cpp \
	newton-dynamics/newton-4.00/sdk/dCollision/ndBodyPlayerCapsule.cpp \
	newton-dynamics/newton-4.00/sdk/dCollision/ndBodyTriggerVolume.cpp \
	newton-dynamics/newton-4.00/sdk/dCollision/ndBvhNode.cpp \
	newton-dynamics/newton-4.00/sdk/dCollision/ndCollisionStdafx.cpp \
	newton-dynamics/newton-4.00/sdk/dCollision/ndConstraint.cpp \
	newton-dynamics/newton-4.00/sdk/dCollision/ndContact.cpp \
	newton-dynamics/newton-4.00/sdk/dCollision/ndContactArray.cpp \
	newton-dynamics/newton-4.00/sdk/dCollision/ndContactSolver.cpp \
	newton-dynamics/newton-4.00/sdk/dCollision/ndConvexCastNotify.cpp \
	newton-dynamics/newton-4.00/sdk/dCollision/ndJointBilateralConstraint.cpp \
	newton-dynamics/newton-4.00/sdk/dCollision/ndMeshEffect1.cpp \
	newton-dynamics/newton-4.00/sdk/dCollision/ndMeshEffect2.cpp \
	newton-dynamics/newton-4.00/sdk/dCollision/ndMeshEffect3.cpp \
	newton-dynamics/newton-4.00/sdk/dCollision/ndMeshEffect4.cpp \
	newton-dynamics/newton-4.00/sdk/dCollision/ndMeshEffect5.cpp \
	newton-dynamics/newton-4.00/sdk/dCollision/ndMeshEffect6.cpp \
	newton-dynamics/newton-4.00/sdk/dCollision/ndMeshEffectNode.cpp \
	newton-dynamics/newton-4.00/sdk/dCollision/ndPolygonMeshDesc.cpp \
	newton-dynamics/newton-4.00/sdk/dCollision/ndRayCastNotify.cpp \
	newton-dynamics/newton-4.00/sdk/dCollision/ndScene.cpp \
	newton-dynamics/newton-4.00/sdk/dCollision/ndShape.cpp \
	newton-dynamics/newton-4.00/sdk/dCollision/ndShapeBox.cpp \
	newton-dynamics/newton-4.00/sdk/dCollision/ndShapeCapsule.cpp \
	newton-dynamics/newton-4.00/sdk/dCollision/ndShapeChamferCylinder.cpp \
	newton-dynamics/newton-4.00/sdk/dCollision/ndShapeCompound.cpp \
	newton-dynamics/newton-4.00/sdk/dCollision/ndShapeCone.cpp \
	newton-dynamics/newton-4.00/sdk/dCollision/ndShapeConvex.cpp \
	newton-dynamics/newton-4.00/sdk/dCollision/ndShapeConvexHull.cpp \
	newton-dynamics/newton-4.00/sdk/dCollision/ndShapeConvexPolygon.cpp \
	newton-dynamics/newton-4.00/sdk/dCollision/ndShapeCylinder.cpp \
	newton-dynamics/newton-4.00/sdk/dCollision/ndShapeHeightfield.cpp \
	newton-dynamics/newton-4.00/sdk/dCollision/ndShapeInstance.cpp \
	newton-dynamics/newton-4.00/sdk/dCollision/ndShapeNull.cpp \
	newton-dynamics/newton-4.00/sdk/dCollision/ndShapePoint.cpp \
	newton-dynamics/newton-4.00/sdk/dCollision/ndShapeSphere.cpp \
	newton-dynamics/newton-4.00/sdk/dCollision/ndShapeStaticMesh.cpp \
	newton-dynamics/newton-4.00/sdk/dCollision/ndShapeStaticProceduralMesh.cpp \
	newton-dynamics/newton-4.00/sdk/dCollision/ndShapeStatic_bvh.cpp \
	newton-dynamics/newton-4.00/sdk/dCore/ndAabbPolygonSoup.cpp \
	newton-dynamics/newton-4.00/sdk/dCore/ndBezierSpline.cpp \
	newton-dynamics/newton-4.00/sdk/dCore/ndCRC.cpp \
	newton-dynamics/newton-4.00/sdk/dCore/ndClassAlloc.cpp \
	newton-dynamics/newton-4.00/sdk/dCore/ndContainersAlloc.cpp \
	newton-dynamics/newton-4.00/sdk/dCore/ndConvexHull2d.cpp \
	newton-dynamics/newton-4.00/sdk/dCore/ndConvexHull3d.cpp \
	newton-dynamics/newton-4.00/sdk/dCore/ndConvexHull4d.cpp \
	newton-dynamics/newton-4.00/sdk/dCore/ndCoreStdafx.cpp \
	newton-dynamics/newton-4.00/sdk/dCore/ndDebug.cpp \
	newton-dynamics/newton-4.00/sdk/dCore/ndDelaunayTetrahedralization.cpp \
	newton-dynamics/newton-4.00/sdk/dCore/ndFastAabb.cpp \
	newton-dynamics/newton-4.00/sdk/dCore/ndFastRay.cpp \
	newton-dynamics/newton-4.00/sdk/dCore/ndGoogol.cpp \
	newton-dynamics/newton-4.00/sdk/dCore/ndIntersections.cpp \
	newton-dynamics/newton-4.00/sdk/dCore/ndIsoSurface.cpp \
	newton-dynamics/newton-4.00/sdk/dCore/ndMatrix.cpp \
	newton-dynamics/newton-4.00/sdk/dCore/ndMemory.cpp \
	newton-dynamics/newton-4.00/sdk/dCore/ndPerlinNoise.cpp \
	newton-dynamics/newton-4.00/sdk/dCore/ndPolygonSoupBuilder.cpp \
	newton-dynamics/newton-4.00/sdk/dCore/ndPolygonSoupDatabase.cpp \
	newton-dynamics/newton-4.00/sdk/dCore/ndPolyhedra.cpp \
	newton-dynamics/newton-4.00/sdk/dCore/ndPolyhedraMassProperties.cpp \
	newton-dynamics/newton-4.00/sdk/dCore/ndProfiler.cpp \
	newton-dynamics/newton-4.00/sdk/dCore/ndQuaternion.cpp \
	newton-dynamics/newton-4.00/sdk/dCore/ndRand.cpp \
	newton-dynamics/newton-4.00/sdk/dCore/ndSaveLoadSytem.cpp \
	newton-dynamics/newton-4.00/sdk/dCore/ndSemaphore.cpp \
	newton-dynamics/newton-4.00/sdk/dCore/ndSmallDeterminant.cpp \
	newton-dynamics/newton-4.00/sdk/dCore/ndSpatialMatrix.cpp \
	newton-dynamics/newton-4.00/sdk/dCore/ndString.cpp \
	newton-dynamics/newton-4.00/sdk/dCore/ndSyncMutex.cpp \
	newton-dynamics/newton-4.00/sdk/dCore/ndThread.cpp \
	newton-dynamics/newton-4.00/sdk/dCore/ndThreadBackgroundWorker.cpp \
	newton-dynamics/newton-4.00/sdk/dCore/ndThreadPool.cpp \
	newton-dynamics/newton-4.00/sdk/dCore/ndTinyXmlGlue.cpp \
	newton-dynamics/newton-4.00/sdk/dCore/ndTree.cpp \
	newton-dynamics/newton-4.00/sdk/dCore/ndTypes.cpp \
	newton-dynamics/newton-4.00/sdk/dCore/ndUtils.cpp \
	newton-dynamics/newton-4.00/sdk/dCore/ndVector.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/dIkSolver/ndIk6DofEffector.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/dIkSolver/ndIkJointDoubleHinge.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/dIkSolver/ndIkJointHinge.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/dIkSolver/ndIkJointSpherical.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/dIkSolver/ndIkSolver.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/dIkSolver/ndIkSwivelPositionEffector.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/dJoints/ndJointCylinder.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/dJoints/ndJointDoubleHinge.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/dJoints/ndJointDryRollingFriction.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/dJoints/ndJointFix6dof.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/dJoints/ndJointFixDistance.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/dJoints/ndJointFollowPath.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/dJoints/ndJointGear.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/dJoints/ndJointHinge.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/dJoints/ndJointKinematicController.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/dJoints/ndJointPlane.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/dJoints/ndJointPulley.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/dJoints/ndJointRoller.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/dJoints/ndJointSlider.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/dJoints/ndJointSpherical.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/dJoints/ndJointUpVector.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/dJoints/ndJointWheel.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/dModels/dCharacter/ndCharacter.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/dModels/dCharacter/ndCharacterForwardDynamicNode.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/dModels/dCharacter/ndCharacterInverseDynamicNode.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/dModels/dCharacter/ndCharacterNode.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/dModels/dCharacter/ndCharacterRootNode.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/dModels/dVehicle/ndMultiBodyVehicle.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/dModels/dVehicle/ndMultiBodyVehicleDifferential.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/dModels/dVehicle/ndMultiBodyVehicleDifferentialAxle.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/dModels/dVehicle/ndMultiBodyVehicleGearBox.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/dModels/dVehicle/ndMultiBodyVehicleMotor.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/dModels/dVehicle/ndMultiBodyVehicleTireJoint.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/dModels/dVehicle/ndMultiBodyVehicleTorsionBar.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/dModels/ndModel.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/dModels/ndModelList.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/dParticles/ndBodyParticleSet.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/dParticles/ndBodySphFluid.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/ndBodyDynamic.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/ndDynamicsUpdate.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/ndDynamicsUpdateSoa.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/ndLoadSave.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/ndNewtonStdafx.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/ndSkeletonContainer.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/ndWorld.cpp \
	newton-dynamics/newton-4.00/sdk/dNewton/ndWorldScene.cpp \
	newton-dynamics/newton-4.00/sdk/dTinyxml/tinystr.cpp \
	newton-dynamics/newton-4.00/sdk/dTinyxml/tinyxml.cpp \
	newton-dynamics/newton-4.00/sdk/dTinyxml/tinyxmlerror.cpp \
	newton-dynamics/newton-4.00/sdk/dTinyxml/tinyxmlparser.cpp \

FLAGS4 = -fPIC -msse3 

# if avx2
SRC4_FILES += newton-dynamics/newton-4.00/sdk/dNewton/dExtensions/dAvx2/ndDynamicsUpdateAvx2.cpp
FLAGS4     += -march=haswell -D_D_USE_AVX2_SOLVER \
            -Inewton-dynamics/newton-4.00/sdk/dNewton/dExtensions/dAvx2
# todo: cuda, opencl

# NEWTON_BUILD_SHARED_LIBS
#               dNewton                dCollision                dCore                dTinyXml
#FLAGS4     += -D_D_NEWTON_EXPORT_DLL -D_D_COLLISION_EXPORT_DLL -D_D_CORE_EXPORT_DLL -D_D_TINYXML_EXPORT_DLL
FLAGS4     += \
  -Inewton-dynamics/newton-4.00/sdk/dCollision \
  -Inewton-dynamics/newton-4.00/sdk/dCore \
  -Inewton-dynamics/newton-4.00/sdk/dNewton \
  -Inewton-dynamics/newton-4.00/sdk/dNewton/dIkSolver \
  -Inewton-dynamics/newton-4.00/sdk/dNewton/dJoints \
  -Inewton-dynamics/newton-4.00/sdk/dNewton/dModels \
  -Inewton-dynamics/newton-4.00/sdk/dNewton/dModels/dCharacter \
  -Inewton-dynamics/newton-4.00/sdk/dNewton/dModels/dVehicle \
  -Inewton-dynamics/newton-4.00/sdk/dNewton/dParticles \
  -Inewton-dynamics/newton-4.00/sdk/dTinyxml

FLAGS4 += -Wall -Wno-strict-aliasing -D_POSIX_VER $(CPU_FLAGS)
FLAGS4 += -Os -g0
#FLAGS4 += -DDG_DISABLE_ASSERT

O4_FILES := $(notdir $(SRC4_FILES:.cpp=.o))

libnewton-dynamics-4.a: $(SRC4_FILES)
	$(CC) $(FLAGS4) -c $^
	ar -cr $@ $(O4_FILES)
	ranlib $@
	rm -rf    $(O4_FILES)

libnewton-dynamics-4.so: newton-dynamics/newton-4.00/sdk/Newton.cpp \
                         libnewton-dynamics-4.a
	$(CC) $(FLAGS4) $^ \
	-lstdc++ -lm -pthread \
	-shared -o $@
