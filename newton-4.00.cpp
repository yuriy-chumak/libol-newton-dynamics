#include "ndTypes.h"
#include "ndWorld.h"
#include "ndBodyDynamic.h"

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



// ----------------------------------------------
// convex collision primitives creation functions
// ----------------------------------------------

D_LIBRARY_EXPORT
ndShapeBox* NewtonCreateBox (ndFloat32 size_x, ndFloat32 size_y, ndFloat32 size_z)
{
    return new ndShapeBox(size_x, size_y, size_z);
}

// Null

D_LIBRARY_EXPORT
ndShapeSphere* NewtonCreateSphere (ndFloat32 radius)
{
    return new ndShapeSphere(radius);
}

// ...

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
void NewtonBodySetMatrix(NewtonBody *body, const ndMatrix& matrix) {
    body->SetMatrix(matrix);
}

D_LIBRARY_EXPORT
void NewtonBodySetMass(NewtonBody *body, ndFloat32 mass) {
    body->SetMassMatrix(mass, body->GetCollisionShape());
}


D_LIBRARY_EXPORT
void NewtonBodySetMassMatrix(NewtonBody *body, ndFloat32 mass, const ndMatrix& inertia) {
    body->SetMassMatrix(mass, inertia);
}

D_LIBRARY_EXPORT
void NewtonBodySetMassShape(NewtonBody *body, ndFloat32 mass, ndShape* shape, bool fullInertia) {
    body->SetMassMatrix(mass, shape, fullInertia);
}

D_LIBRARY_EXPORT
void NewtonBodySetForce(NewtonBody *body, ndFloat32* force) {
    body->SetForce(force);
}

D_LIBRARY_EXPORT
void NewtonBodySetVelocity(NewtonBody *body, ndFloat32* velocity) {
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