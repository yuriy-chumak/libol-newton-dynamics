#!/usr/bin/env ol

(import (lib newton-dynamics-4))

(define world (or
   (Newton:CreateWorld)
   (runtime-error "Can't create newtonian world.")))

(let ((version (NewtonWorld:GetEngineVersion world)))
   (print-to stderr "newton-dynamics version " (div version 100) "." (mod version 100)))

(Newton:DestroyWorld world)
