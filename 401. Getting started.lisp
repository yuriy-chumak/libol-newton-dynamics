(import (lib newton-dynamics-4))

(define world (or
   (NewtonWorldCreate)
   (runtime-error "Can't create newton world" #f)))

(let ((ver (NewtonWorldGetEngineVersion world)))
   (display "newton-dynamics version ")
   (display (div ver 100))
   (display ".")
   (display (mod ver 100)))
(newline)

(NewtonWorldDestroy world)
