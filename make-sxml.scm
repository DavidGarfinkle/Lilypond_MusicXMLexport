

(define (append-fix lst1 lst2)
	(letrec ((append-help (lambda (chain tail cont)
		(if (null? (cdr chain))
			(cont)
			(append-help (cdr chain) tail (cons (car chain) (cont tail))))))
		(append-help lst1 lst2 (lambda x (cons '() x)))))); get rid of (style) and '() append errors. write the function yourself..? ugh.. useless time spent.. 	

(define (unnest lst) (cond ((null? lst) '()) ((not (list? lst)) (list lst)) (else (append (unnest (car lst)) (unnest (cdr lst))))))

(define (remove-redundant-list lst)
	(letrec ((loop (lambda (l cont) 
		(if (list? ic (@ (name SequentialMusic) (measure #f)) (elements ((music (@ (name EventChord) (measure #f)) (elements ((music (@ (name NoteEvent) (measure 1)) (pitch (@ (octave -1) (note-name 5) (alteration 0))) (duration (@ (log 0) (dot-count 0) (scale 1)))) (music (@ (name NoteEvent) (measure 1)) (pitch (@ (octave -1) (note-name 0) (alteration 0))) (duration (@ (log 0) (dot-count 0) (scale 1)))) (music (@ (name NoteEvent) (measure 1)) (pitch (@ (octave -1) (note-name 2) (alteration 0))) (duration (@ (log 0) (dot-count 0) (scale 1))))))) (music (@ (name EventChord) (measure #f)) (elements ((music (@ (name NoteEvent) (measure 2)) (pitch (@ (octave -1) (note-name 5) (alteration 0))) (duration (@ (log 1) (dot-count 0) (scale 1)))) (music (@ (name NoteEvent) (measure 2)) (pitch (@ (octave -1) (note-name 0) (alteration 0))) (duration (@ (log 1) (dot-count 0) (scale 1)))) (music (@ (name NoteEvent) (measure 2)) (pitch (@ (octave -1) (note-name 2) (alteration 0))) (duration (@ (log 1) (dot-count 0) (scale 1))))))) (music (@ (name EventChord) (measure #f)) (elements ((music (@ (name NoteEvent) (measure 2)) (pitch (@ (octave -1) (note-name 3) (alteration 0))) (duration (@ (log 2) (dot-count 0) (scale 1)))) (music (@ (name NoteEvent) (measure 2)) (pitch (@ (octave -1) (note-name 5) (alteration 0))) (duration (@ (log 2) (dot-count 0) (scale 1)))) (music (@ (name NoteEvent) (measure 2)) (pitch (@ (octave -1) (note-name 0) (alteration 0))) (duration (@ (log 2) (dot-count 0) (scale 1)))) (music (@ (name NoteEvent) (measure 2)) (pitch (@ (octave -1) (note-name 2) (alteration 0))) (duration (@ (log 2) (dot-count 0) (scale 1))))))) (music (@ (name EventChord) (measure #f)) (elements ((music (@ (name NoteEvent) (measure 2)) (pitch (@ (octave -1) (note-name 5) (alteration 0))) (duration (@ (log 3) (dot-count 1) (scale 1)))) (music (@ (name NoteEvent) (measure 2)) (pitch (@ (octave -1) (note-name 0) (alteration 0))) (duration (@ (log 3) (dot-count 1) (scale 1))))))) (music (@ (name EventChord) (measure #f)) (elements ((music (@ (name NoteEvent) (measure 2)) (pitch (@ (octave -1) (note-name 4) (alteration 0))) (duration (@ (log 4) (dot-count 0) (scale 1)))) (music (@ (name NoteEvent) (measure 2)) (pitch (@ (octave -1) (note-name 0) (alteration 0))) (duration (@ (log 4) (dot-count 0) (scale 1)))) (music (@ (name NoteEvent) (measure 2)) (pitch (@ (octave -1) (note-name 2) (alteration 0))) (duration (@ (log 4) (dot-count 0) (scale 1))))))))))
car l))
			(loop (cdr l) (append (car l) (cont))) 
			lst))))
		(loop lst '())))

(define (music->sxml obj)
	(cond
		(;; markup expression
			(markup? obj)
			(markup-expression->make-markup obj))
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


(define (flatten x)
(display x) (newline) (newline)
  (cond ((null? x) '())
        ((pair? x) (car x))
        (else (list x))))

					;(if (null? (car cont)) '() (car flatten cont))

(define (markup-expression->make-markup markup-expression)
  "Transform `markup-expression' into an equivalent, hopefuly readable, scheme expression.
For instance,
  \\markup \\bold \\italic hello
==>
  (markup #:line (#:bold (#:italic (#:simple \"hello\"))))"
  (define (proc->command-keyword proc)
    "Return a keyword, eg. `#:bold', from the `proc' function, eg. #<procedure bold-markup (layout props arg)>"
    (let ((cmd-markup (symbol->string (procedure-name proc))))
      (symbol->keyword (string->symbol (substring cmd-markup 0 (- (string-length cmd-markup)
                                                                  (string-length "-markup")))))))
  (define (transform-arg arg)
    (cond ((and (pair? arg) (markup? (car arg))) ;; a markup list
           (append-map inner-markup->make-markup arg))
          ((and (not (string? arg)) (markup? arg)) ;; a markup
           (inner-markup->make-markup arg))
          (else                                  ;; scheme arg
           (music->make-music arg))))
  (define (inner-markup->make-markup mrkup)
    (if (string? mrkup)
        `(#:simple ,mrkup)
        (let ((cmd (proc->command-keyword (car mrkup)))
              (args (map transform-arg (cdr mrkup))))
          `(,cmd ,@args))))
  ;; body:
  (if (string? markup-expression)
      markup-expression
      `(markup ,@(inner-markup->make-markup markup-expression))))

(define-public (music->make-music obj)
  "Generate an expression that, once evaluated, may return an object
equivalent to @var{obj}, that is, for a music expression, a
@code{(make-music ...)} form."
  (cond (;; markup expression
         (markup? obj)
         (markup-expression->make-markup obj))
        (;; music expression
         (ly:music? obj)
         `(make-music
           ',(ly:music-property obj 'name)
           ,@(append-map (lambda (prop) 
                           `(',(car prop)
                             ,(music->make-music (cdr prop))))
                         (remove (lambda (prop)
                                   (eqv? (car prop) 'origin))
                                 (ly:music-mutable-properties obj)))))

        (;; moment
         (ly:moment? obj)
         `(ly:make-moment ,(ly:moment-main-numerator obj)
                          ,(ly:moment-main-denominator obj)
                          ,(ly:moment-grace-numerator obj)
                          ,(ly:moment-grace-denominator obj)))
        (;; note duration
         (ly:duration? obj)
         `(ly:make-duration ,(ly:duration-log obj)
                            ,(ly:duration-dot-count obj)
                            ,(ly:duration-scale obj)))
        (;; note pitch
         (ly:pitch? obj)
         `(ly:make-pitch ,(ly:pitch-octave obj)
                         ,(ly:pitch-notename obj)
                         ,(ly:pitch-alteration obj)))
        (;; scheme procedure
         (procedure? obj)
         (or (procedure-name obj) obj))
        (;; a symbol (avoid having an unquoted symbol)
         (symbol? obj)
         `',obj)
        (;; an empty list (avoid having an unquoted empty list)
         (null? obj)
         `'())
        (;; a proper list
         (list? obj)
         `(list ,@(map music->make-music obj)))
        (;; a pair
         (pair? obj)
         `(cons ,(music->make-music (car obj))
                ,(music->make-music (cdr obj))))))

