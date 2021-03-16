(message "bye")

(message "hello"

(flymake--diag-text (overlay-get (lazyflymake-overlay-at-point) 'flymake-diagnostic))
idefun hello ()
  "hello world."
  (message "hello"))

(provide 'hello)
