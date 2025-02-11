#!/usr/bin/env ol

(import (lib newton-dynamics))

(define world (or
   (NewtonCreate)
   (runtime-error "Can't create newton world")))

(define threads (NewtonGetThreadsCount world))
(print "threads allowed: " threads)

(NewtonDestroy world)
