(load "conversion-records.scm")

(define current-timesig (make-timesig '4 '4 '()))
(define current-clef (make-clef "clefs.G" -2 0))
(define mlist (make-measure-list #()))

(define search 
	(lambda (x)
		(display x) (newline) (newline)
		(sxml-match x
			[,obj (guard (or 
				(symbol? obj)
				(null? obj))) obj]
;			  (procedure? (procedure-name obj))	
			[(music (@ (name ,attribute)) . ,rest) 
				(if (equal? attribute 'TimeSignatureMusic) 
					(map search rest)
					(map search rest))]
			[(element . ,rest) (map search rest)]
			[(elements . ,rest) (map search rest)]
			[,otherwise `(nomatch ,otherwise)])))

(define search-cont 
	(lambda (x cont)
		(display x) (newline) (newline)
		(sxml-match x
			[,obj (guard (or
				(symbol? obj)
				(null? obj))) obj]
			[(music (@ (name ,attribute)) . ,rest) 
				(if (equal? attribute 'TimeSignatureMusic) 
					(map search rest)
					(search-cont (cdr x) (lambda head (cons head 0 ))))]
			[(element . ,rest) (map search rest)]
			[(elements . ,rest) (map search rest)])))

; you want to (let ((t (timesignature))) search ..) so that the time signature var is bound inside your nested recursions, and it has some sort of temporal vibe, and it gets replaces now and then, and anytime you call time sig it should be the most recent time sig available, since each new one is sequentially rebound, yeah? so use continuations to do that, more control. i think..
; options: map, continuations, exceptions



(define (test sxml)
	(define (search- x) 
			(display x) (newline) (newline)
			(sxml-match x
				[,obj (guard (or 
					(symbol? obj)
					(null? obj))) obj]
				[(list (music (@ (name ,attribute)) . ,rest) ...)
					`(,(search- `(music (@ (name ,attribute)) ,@rest)) ...)]
				[(music (@ (name ,attribute) (measure ,measure-number)) . ,rest) 
					(cond 
						( ; Time Signatures
							(equal? attribute 'TimeSignatureMusic) 
							(time-signature-music rest measure-number))
						( ; Note Events 
							(equal? attribute 'NoteEvent)
							(note-event rest measure-number))
						( ; Key Change Event
							(equal? attribute 'KeyChangeEvent)
							(key-change-event rest measure-number))
						( ; PropertySet
							(equal? attribute 'PropertySet)
							(property-set rest measure-number))
						( ; ApplyContext
							(equal? attribute 'ApplyContext)
							(apply-context rest measure-number))
						(else 
							(map search- rest)))]
				[(element . ,rest) (map search- rest)]
				[(elements . ,rest) (map search- rest)]
				[,otherwise 'notmached]))

; does not support key signatures with mixed sharps and flats. minor/major only.
	(define (key-change-event sblock measure-number)
		(sxml-match sblock
			[(list 
				(tonic (@ (octave ,oct) (note-name ,note) (alteration ,alt)))
				(pitch-alist ,lst))
				(display lst)
				; pitch-alist looks like ((cons 0 0) (cons 1 0) (cons 2 0) ... (cons 6 0))
				; fold iterates through the list, cdr cdr isolates the third elt of each pair
				; (car (cdr (cdr (cons 0 0)))) => (car (0)) => 0
				(let (
					(fifths (fold (lambda (scale-deg sum) (+ sum (* 2 (caddr scale-deg)))) 0 lst)))
					(sxml 
						`(key
							(fifths ,fifths)))
					sxml)
						
					]))

	(define (apply-context sblock measure-number) 
		(sxml-match sblock
			[(list (procedure ,proc) ...)
				(cond
					( ; set-middle-C!
						(equal? proc 'ly:set-middle-C!)
						`(clef 
							(sign ,(lily-clef-glyph->musicxml-clef-sign (clef-glyph current-clef)))
							(line ,(lily-clef-position->musicxml-clef-line (clef-position current-clef)))
							(octave-change ,(lily-clef-transposition->musicxml-clef-octave-change (clef-transposition current-clef))))))]))
			
	(define (property-set sblock measure-number) 
		(sxml-match sblock
			[(list (symbol ,symbol) (value ,val))
				(cond
					( ; clefGlyph
						(equal? symbol 'clefGlyph) 
						(set-clef-glyph! current-clef val))
					( ; clefPosition
						(equal? symbol 'clefPosition)
						(set-clef-position! current-clef val))
					( ; clefTransposition
						(equal? symbol 'clefTransposition)
						(set-clef-transposition! current-clef val))
					(else 
						(display "ELSE PROPERTY")))]))

	(define (time-signature-music sblock measure-number) 
		(sxml-match sblock
			[(list (numerator ,num) (denominator ,denom) (beat-structure ,beat-structure))
				(set-timesig-numerator! current-timesig num)
				(set-timesig-denominator! current-timesig denom)
				(set-timesig-beat-structure! current-timesig beat-structure)
				`(time
					(beats ,num)
					(beat-type ,denom))])) ;maybe recurse on ... rest?

	(define (note-event sblock measure-number)
		(sxml-match sblock
			[(list 
				(pitch (@ (octave ,oct) (note-name ,note) (alteration ,alt) . ,pitch-rest))	
				(duration (@ (log ,log) (dot-count ,dot) (scale ,scale) . ,dur-rest)))
				(let (
					;; duration
					[musicxml-duration (log-duration->musicxml-duration-calc log dot)] 
					[musicxml-type (log-duration->musicxml-duration-names log)]
					;; pitch
					[musicxml-octave (lily-octave->musicxml-octave oct)]
					[musicxml-step (lily-note-name->musicxml-step note)]
					[musicxml-alt (lily-alteration->musicxml-alter alt)])
					`(note 
							(pitch 
								(step ,musicxml-step);need to output a value wrapped in double quotes?
								(alter ,musicxml-alt)
								(octave ,musicxml-octave))
						(duration ,musicxml-duration)
						(type ,musicxml-type)))]))



; you should wrap the sxml printing in a new object which can filter out unnecessary tags, such as alt when it's 0
;	,(if (not (= 0 musicxml-alt)) 
;		(`alter musicxml-alt)
;		(void))

	(sxml-match sxml
		[(music ,[search- -> x])
			`(part (@ (id "P1"))
				(measure (@ (number "1"))
					(attributes (divisions ,num-divisions))
						,x ))]))


