(use-modules (ice-9 popen))
(load "lily-time.scm")
(load "make-sxml.scm")
(load "lilysamples.scm")

(define music->xml
	(lambda (obj) 
		(run-translator obj)
		(let 
			((port (open-output-file "sxml_final.scm"))
				(sxml (music->sxml obj)))
			(write `(define sxml ',sxml ) port)
			(close-output-port port)
			(let ((port (open-input-pipe "./sxml-to-xml.guile sxml_final.scm"))) (close-pipe port)))))
#!
;; my attempt at changing this to a function rather than two nested lets
(define output-file "sxml_final.scm")
(define f-music->xml
	((lambda (sxml port pipe obj)
		(write `(define sxml ',sxml ) port)
		(close-output-port port)
		(pipe ()))
	((music->sxml obj)
	 (open-output-file output-file) 	
	 (lambda (sus) (open-input-pipe ("./sxml_to_xml.guile"))))))	
!#
