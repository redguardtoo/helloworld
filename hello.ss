#!/usr/local/bin/guile -s
!#

(define hello-world
   (lambda ()
         (begin
	(write ‘Hello-World)
            (newline)
	(hello-world))))
(display (format #t "helllo=~S" "hello")) (newline)