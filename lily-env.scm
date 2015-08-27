(use-modules (ice-9 popen))
(load "lily/lily-time.scm") 
(load "lily/make-sxml.scm")
(load "samples/lily-objects.scm")

;; Given music expression mus, return a lily-SXML representation which includes measure and moment information
(define (music->lily-sxml obj)
	(run-translator obj) (newline)
	(music->sxml obj))

(define music->xml
	(lambda (obj) 
		(let 
			((port (open-output-file "guile2.0/sxml-transfer.scm"))
				(sxml (music->lily-sxml obj)))
			(write `(define sxml ',sxml) port)
			(close-output-port port)
			(let ((port (open-output-pipe "guile2.0/sxml-to-xml.guile sxml-transfer.scm"))) (close-pipe port))
			(display "Conversion Successful!") (newline)
)))

