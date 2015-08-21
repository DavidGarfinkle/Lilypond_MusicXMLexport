(use-modules (ice-9 popen))
(load "lily/lily-time.scm") 
(load "lily/make-sxml.scm")
(load "samples/lilysamples.scm")

(define music->xml
	(lambda (obj) 
		(run-translator obj)
		(let 
			((port (open-output-file "sxml_transfer.scm"))
				(sxml (music->sxml obj)))
			(write `(define sxml ',sxml ) port)
			(close-output-port port)
			(let ((port (open-input-pipe "guile2.0/sxml-to-xml.guile sxml_transfer.scm"))) (close-pipe port)))))
