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
# notes: no dFileFormat/, 
#	$(wildcard newton-dynamics/newton-4.00/sdk/dBrain/*.cpp)
SRC4_FILES += \
	$(wildcard newton-dynamics/newton-4.00/sdk/dCollision/*.cpp) \
	$(wildcard newton-dynamics/newton-4.00/sdk/dCore/*.cpp) \
	$(wildcard newton-dynamics/newton-4.00/sdk/dCore/tinyxml/*.cpp) \
	$(wildcard newton-dynamics/newton-4.00/sdk/dNewton/*.cpp) \
	$(wildcard newton-dynamics/newton-4.00/sdk/dNewton/dIkSolver/*.cpp) \
	$(wildcard newton-dynamics/newton-4.00/sdk/dNewton/dJoints/*.cpp) \
	$(wildcard newton-dynamics/newton-4.00/sdk/dNewton/dModels/dCharacter/*.cpp) \
	$(wildcard newton-dynamics/newton-4.00/sdk/dNewton/dModels/dVehicle/*.cpp) \
	$(wildcard newton-dynamics/newton-4.00/sdk/dNewton/dModels/*.cpp) \
	$(wildcard newton-dynamics/newton-4.00/sdk/dNewton/*.cpp)

FLAGS4     += \
  -Inewton-dynamics/newton-4.00/sdk/dCollision \
  -Inewton-dynamics/newton-4.00/sdk/dCore \
  -Inewton-dynamics/newton-4.00/sdk/dNewton \
  -Inewton-dynamics/newton-4.00/sdk/dNewton/dIkSolver \
  -Inewton-dynamics/newton-4.00/sdk/dNewton/dJoints \
  -Inewton-dynamics/newton-4.00/sdk/dNewton/dModels \
  -Inewton-dynamics/newton-4.00/sdk/dNewton/dModels/dCharacter \
  -Inewton-dynamics/newton-4.00/sdk/dNewton/dModels/dVehicle \
  -Inewton-dynamics/newton-4.00/thirdParty/tinyxml

FLAGS4     += -fPIC -msse3

# if avx2
SRC4_FILES += $(wildcard newton-dynamics/newton-4.00/sdk/dNewton/dExtensions/dAvx2/*.cpp)
FLAGS4     += -march=haswell -D_D_USE_AVX2_SOLVER \
              -Inewton-dynamics/newton-4.00/sdk/dNewton/dExtensions/dAvx2

# todo: cuda, opencl

FLAGS4 += -Wall -Wno-strict-aliasing -D_POSIX_VER $(CPU_FLAGS)
FLAGS4 += -Os -g0
#FLAGS4 += -DDG_DISABLE_ASSERT

O4_FILES := $(notdir $(SRC4_FILES:.cpp=.o))

libnewton-dynamics-4.a: $(SRC4_FILES)
	$(CC) $(FLAGS4) -c $^
	ar -cr $@ $(O4_FILES)
	ranlib $@
	rm -rf    $(O4_FILES)

# include C interface
libnewton-dynamics-4.so: newton-4.00.cpp libnewton-dynamics-4.a
	$(CC) $(FLAGS4) $^ \
	-lstdc++ -lm -pthread \
	-shared -o $@
