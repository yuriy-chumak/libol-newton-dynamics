#include "ndTypes.h"
#include "ndWorld.h"
#include "ndBodyDynamic.h"
#include "ndPolygonSoupBuilder.h"
#include "ndShapeStatic_bvh.h"

// naming rules:
//  NewtonCreate === new
//  NewtonDestroy === delete
//  TypenameMethodname === Typename->Methodname

// notes:
//  we'r skipping "Shape" in constructors (to be more 3.14-like)


#ifdef _NEWTON_BUILD_DLL
	#if (defined (__MINGW32__) || defined (__MINGW64__))
		int main(int argc, char* argv[])
		{
			return 0;
		}
	#endif

	#ifdef _MSC_VER
		BOOL APIENTRY DllMain( HMODULE hModule,	DWORD  ul_reason_for_call, LPVOID lpReserved)
		{
			switch (ul_reason_for_call)
			{
				case DLL_THREAD_ATTACH:
				case DLL_PROCESS_ATTACH:
					// check for memory leaks
					#ifdef _DEBUG
						// Track all memory leaks at the operating system level.
						// make sure no Newton tool or utility leaves leaks behind.
						_CrtSetDbgFlag(_CRTDBG_LEAK_CHECK_DF | _CRTDBG_REPORT_FLAG);
					#endif

				case DLL_THREAD_DETACH:
				case DLL_PROCESS_DETACH:
				break;
			}
			return TRUE;
		}
	#endif
#endif

//===========================================================================

typedef ndWorld NewtonWorld;
typedef ndBodyKinematic NewtonBody;

#ifdef D_LIBRARY_EXPORT 
#undef D_LIBRARY_EXPORT
#endif

#if defined(_MSC_VER)
	#define D_LIBRARY_EXPORT extern "C" __declspec(dllexport)
#else
	#define D_LIBRARY_EXPORT extern "C" __attribute__((visibility("default")))
#endif


D_LIBRARY_EXPORT
NewtonWorld* NewtonCreateWorld() {
	return new NewtonWorld();
}

D_LIBRARY_EXPORT
void NewtonDestroyWorld(NewtonWorld* world)
{
	delete world;
}

// CleanUp

D_LIBRARY_EXPORT
ndInt32 NewtonWorldGetEngineVersion(NewtonWorld* world)
{
	return world->GetEngineVersion();
}

D_LIBRARY_EXPORT
void NewtonWorldSync(NewtonWorld* world)
{
	(void) world->Sync();
}

D_LIBRARY_EXPORT
void NewtonWorldUpdate(NewtonWorld* world, ndFloat32 timestep)
{
	(void) world->Update(timestep);
}

// CollisionUpdate

// OnPostUpdate
// GetThreadCount
// SetThreadCount

// GetSubSteps
// SetSubSteps
D_LIBRARY_EXPORT
void NewtonWorldSetSubSteps(NewtonWorld* world, ndInt32 subSteps) {
    (void) world->SetSubSteps(subSteps);
}

// ...

// GetSolverIterations
D_LIBRARY_EXPORT
void NewtonWorldSetSolverIterations(NewtonWorld* world, ndInt32 iterations)
{
    (void) world->SetSolverIterations(iterations);
}

D_LIBRARY_EXPORT
void NewtonWorldAddBody(NewtonWorld* world, ndBody* body)
{
    (void) world->AddBody(body);
}



// ---------------------------------------
// collision primitives creation functions
// ---------------------------------------

// ----------------------------
#include "ndShapeBox.h"

D_LIBRARY_EXPORT
ndShapeBox* NewtonCreateBox (ndFloat32 size_x, ndFloat32 size_y, ndFloat32 size_z)
{
    return new ndShapeBox(size_x, size_y, size_z);
}

// ----------------------------
#include "ndShapeCone.h"

D_LIBRARY_EXPORT
ndShapeCone* NewtonCreateCone (ndFloat32 radio, ndFloat32 height)
{
    return new ndShapeCone(radio, height);
}
// TODO: Null

// ----------------------------
#include "ndShapeSphere.h"

D_LIBRARY_EXPORT
ndShapeSphere* NewtonCreateSphere (ndFloat32 radius)
{
    return new ndShapeSphere(radius);
}

// ----------------------------
#include "ndShapeCapsule.h"

D_LIBRARY_EXPORT
ndShapeCapsule* NewtonCreateCapsule (ndFloat32 radius0, ndFloat32 radius1, ndFloat32 height)
{
    return new ndShapeCapsule(radius0, radius1, height);
}

// ----------------------------
#include "ndShapeCylinder.h"

D_LIBRARY_EXPORT
ndShapeCylinder* NewtonCreateCylinder (ndFloat32 radius0, ndFloat32 radius1, ndFloat32 height)
{
    return new ndShapeCylinder(radius0, radius1, height);
}

// ----------------------------
#include "ndShapeConvexHull.h"

D_LIBRARY_EXPORT
ndShapeConvexHull* NewtonCreateConvexHull (ndInt32 count, ndInt32 strideInBytes, ndFloat32 tolerance, const ndFloat32* const vertexArray)
{
    return new ndShapeConvexHull(count, strideInBytes, tolerance, vertexArray);
}

// --------
// PolygonSoupBuilder

D_LIBRARY_EXPORT
ndPolygonSoupBuilder* NewtonCreatePolygonSoupBuilder()
{
    return new ndPolygonSoupBuilder();
}
D_LIBRARY_EXPORT
ndPolygonSoupBuilder* NewtonCreatePolygonSoupBuilder1(const ndPolygonSoupBuilder& other)
{
    return new ndPolygonSoupBuilder(other);
}
D_LIBRARY_EXPORT
void NewtonDestroyPolygonSoupBuilder(ndPolygonSoupBuilder* self)
{
    delete self;
}

D_LIBRARY_EXPORT
void PolygonSoupBuilderBegin(ndPolygonSoupBuilder* self)
{
    (void)self->Begin();
}

D_LIBRARY_EXPORT
void PolygonSoupBuilderAddFace(ndPolygonSoupBuilder* self, const ndFloat32* const vertex, ndInt32 strideInBytes, ndInt32 vertexCount, const ndInt32 faceId)
{
    (void)self->AddFace(vertex, strideInBytes, vertexCount, faceId);
}

D_LIBRARY_EXPORT
void PolygonSoupBuilderEnd(ndPolygonSoupBuilder* self, bool optimize)
{
    (void)self->End(optimize);
}

// --------
// ndShapeStatic_bvh
D_LIBRARY_EXPORT
ndShapeStatic_bvh* NewtonCreateStatic (ndPolygonSoupBuilder& builder)
{
    return new ndShapeStatic_bvh(builder);
}

// ----------------------------------------------
// D_LIBRARY_EXPORT
// void NewtonShapeGetMassMatrix(ndShape* shape, ndMatrix* matrix, )
// {

// }


D_LIBRARY_EXPORT
NewtonBody* NewtonCreateDynamicBody(ndShape* shape, ndFloat32 mass)
{
    ndBodyDynamic *body = new ndBodyDynamic();
    if (shape) {
        body->SetCollisionShape(shape);
        body->SetMassMatrix(mass, shape);
    }

    return body;
}

D_LIBRARY_EXPORT
NewtonBody* NewtonCreateKinematicBody(ndShape* shape)
{
    ndBodyKinematic *body = new ndBodyKinematic();
    if (shape) {
        body->SetCollisionShape(shape);
    }

    return body;
}

D_LIBRARY_EXPORT
void NewtonBodySetCollisionShape(NewtonBody *body, ndShape* shape) {
    body->SetCollisionShape(shape);
}

D_LIBRARY_EXPORT
void NewtonBodyGetMatrix(NewtonBody *body, ndFloat32 matrix[16]) {
    ndMemCpy(matrix, &body->GetMatrix().m_front[0], 16);
}

D_LIBRARY_EXPORT
void NewtonBodySetMatrix(NewtonBody *body, ndFloat32 matrix[16]) {
    body->SetMatrix(matrix);
}

D_LIBRARY_EXPORT
void NewtonBodySetMass(NewtonBody *body, ndFloat32 mass) {
    body->SetMassMatrix(mass, body->GetCollisionShape());
}


D_LIBRARY_EXPORT
void NewtonBodySetMassMatrix(NewtonBody *body, ndFloat32 mass, ndFloat32 inertia[16]) {
    body->SetMassMatrix(mass, inertia);
}

D_LIBRARY_EXPORT
void NewtonBodySetMassShape(NewtonBody *body, ndFloat32 mass, ndShape* shape, bool fullInertia) {
    body->SetMassMatrix(mass, shape, fullInertia);
}

D_LIBRARY_EXPORT
void NewtonBodySetForce(NewtonBody *body, ndFloat32 force[4]) {
    body->SetForce(force);
}

D_LIBRARY_EXPORT
void NewtonBodySetVelocity(NewtonBody *body, ndFloat32 velocity[4]) {
    body->SetVelocity(velocity);
}


typedef void (*ApplyExternalForceCallback) (const NewtonBody* const body, ndFloat32 timestep, ndInt32 threadIndex);

class BodyNotify: public ndBodyNotify
{
public:
  BodyNotify(ApplyExternalForceCallback cb)
  : ndBodyNotify(ndVector(0.0f, 0.0f, 0.0f, 0.0f))
  , callback(cb) {}

  virtual void OnApplyExternalForce(ndInt32 threadIdx, ndFloat32 timestep) override
  {
    NewtonBody* body = GetBody()->GetAsBodyKinematic();
    if (body && callback)
      callback(body, timestep, threadIdx);
  }
protected:
  ApplyExternalForceCallback callback;
};

D_LIBRARY_EXPORT
void NewtonBodySetApplyExternalForceCallback(NewtonBody *body, ApplyExternalForceCallback callback)
{
    body->SetNotifyCallback(new BodyNotify(callback));
}