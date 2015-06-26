(load "make-sxml.scm")
(load "lilysamples.scm")
(define sxml->xml 
	(lambda (obj) 
		(let 
			((port (open-output-file "sxml_final.scm"))
				(sxml (music->sxml obj)))
			(write sxml port)
			(close-output-port port)))) 
