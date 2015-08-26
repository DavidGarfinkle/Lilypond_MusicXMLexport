;;; Modelled off of (music->make-music ...) from the \displayMusic machinery
;; music->sxml takes a music expression and returns the lily-SXML equivalent
;;
;; todo: take away list containers, since they have no purpose in SXML and only complicate the matching process (would also need to modify the matching process after)
;; 	ex. (elements ((music ...) (music ...) ...) => (elements (music ...) (music ...) ...)
(define (music->sxml obj)
	(cond
		(;; music expression
			(ly:music? obj)
			`(music (@ (name ,(ly:music-property obj 'name)) (measure ,(time_marks obj)))
			,@(append-map 
				(lambda (prop) `((,(car prop) ,(music->sxml (cdr prop)))))
				(remove (lambda (prop) (eqv? (car prop) 'origin)) (ly:music-mutable-properties obj)))))
		(;; moment
			(ly:moment? obj)
			`(@ (main-numerator ,(ly:moment-main-numerator obj))
									(main-denominator ,(ly:moment-main-denominator obj))
									(grace-numerator ,(ly:moment-grace-numerator obj))
									(grace-denominator ,(ly:moment-grace-denominator obj))))
		(;; note duration
			(ly:duration? obj)
			`(@ 
				(log ,(ly:duration-log obj))
				(dot-count ,(ly:duration-dot-count obj))
				(scale ,(ly:duration-scale obj))))
		(;; note pitch
			(ly:pitch? obj)
			`(@  
				(octave ,(ly:pitch-octave obj))
				(note-name ,(ly:pitch-notename obj))
			 	(alteration ,(ly:pitch-alteration obj))))
		(;; scheme procedure
			(procedure? obj)
			(or (procedure-name obj) obj))
		(;; a symbol (avoid having an unquoted symbol)
		 (symbol? obj)
		 `,obj)
		(;; an empty list (avoid having an unquoted empty list)
		 (null? obj)
		 `'())
		(;; a proper list
		 (list? obj)
			(let (
				(cont `(,@(map music->sxml obj)))
				(list-of-lists? (lambda (lst) (fold (lambda (x y) (and x y)) #t (map list? lst)))))
				(cond 
					( ; a single element list ex. '(style)
						; returns 'style
						(null? (cdr cont)) 
						(car cont))
					  ; a list with a list of lists ex. (elements ((music ...) (music ...) ...))
						; returns a list of lists ex. (elements (music ...) (music ...) ...)
					(else 
						cont))))
		(;; a pair
		 (pair? obj)
		 `(cons ,(music->sxml (car obj))
						,(music->sxml (cdr obj))))
		(else 
			obj)))

