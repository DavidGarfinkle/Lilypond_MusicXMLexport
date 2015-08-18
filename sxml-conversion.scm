#!(define (process-moments sxml)
					(let* ((moment 'la)
					(moment-left (regexp-substitute/global #f (string-match "<" moment) 'pre "(" 'post))
					(moment-both (regexp-substitute/global #f (string-match ">" moment-left) 'pre ")" 'post))
					(vector->list moment-both))))!#

(define (lily-octave->musicxml-octave oct)
	(+ oct 4))
; 0-6 note-names fixed do
(define (lily-note-name->musicxml-step note)
	(match note
		[0 "C"]
		[1 "D"]
		[2 "E"]
		[3 "F"]
		[4 "G"]
		[5 "A"]
		[6 "B"]))
(define (lily-alteration->musicxml-alter alt)
	(* alt 2))

(define (lily-clef-glyph->musicxml-clef-sign clef) 
	(match clef
		["clefs.G" "G"]
		["clefs.F" "F"]
		["clefs.C" "C"]
		[,otherwise "NOT SUPPORTED"]))
; musicxml doesn't do clefs on spaces? only lines? each line is worth 1
(define (lily-clef-position->musicxml-clef-line clef)
	(- 3 (/ clef 2)))
; not sure this is correct 
(define (lily-clef-transposition->musicxml-clef-octave-change clef)
	(/ clef 2))

;maybe eventually you should support global scale changes
(define (global-scale note) lily-note-name->musicxml-step note)

(define (lily-pitch->musicxml-fifths note) '())
	
	

; Returns 2 + 4 + 8 + ... 2^power for dot-count division calculation
; tail-recursion exercise
(define (dot-count-series-tailrecursive arg power)
	(let sum ((arg arg) (power power) (acc 0))
		(if (< power 1) 
			acc
			(sum arg (- power 1) (+ acc (expt arg power))))))
; Geometric series (1-r^n)/(1-r)
(define (dot-count-series dot)
	(+ (- (expt 1/2 dot) 1) (* 2 (- 1 (expt 1/2 dot)))))
			

(define num-divisions 24)

; Given log and dot-count, return the number of divisions per quarternote which represents this duration
(define (log-duration->musicxml-duration-calc log dot-count)
	(let ((without-dots (* num-divisions (expt 2 (- 2 log))))) ; # divisions w/o dots
		(* without-dots (+ 1 (dot-count-series dot-count))))) ; add on dots

(define (log-duration->musicxml-duration-names dur)
	(match dur
		[8 "256th"]
		[7 "128th"]
		[6 "64th"]
		[5 "32nd"]
		[4 "16th"]
		[3 "eighth"]
		[2 "quarter"]
		[1 "half"]
		[0 "whole"]
		[-1 "breve"]
		[-2 "longa"]))

; Measures record
(define-record-type <measures>
 (make-measures num)
	measures?
	(num measures-num set-measures-num!))

; Time Signature record
(define-record-type <timesig>
	(make-timesig numerator denominator beat-structure)
	timesig?
	(numerator timesig-numerator set-timesig-numerator!)
	(denominator timesig-denominator set-timesig-denominator!)
	(beat-structure timesig-beat-structure set-timesig-beat-structure!))

; Clef record
(define-record-type <clef>
	(make-clef glyph position transposition)
	clef?
	(glyph clef-glyph set-clef-glyph!)
	(position clef-position set-clef-position!)
	(transposition clef-transposition set-clef-transposition!))

(define current-timesig (make-timesig '4 '4 '()))
(define current-clef (make-clef "clefs.G" -2 0))

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
				[(music (@ (name ,attribute)) . ,rest) 
					(cond 
						( ; Time Signatures
							(equal? attribute 'TimeSignatureMusic) 
							(time-signature-music rest))
						( ; Note Events 
							(equal? attribute 'NoteEvent)
							(note-event rest))
						( ; Key Change Event
							(equal? attribute 'KeyChangeEvent)
							(key-change-event rest))
						( ; PropertySet
							(equal? attribute 'PropertySet)
							(property-set rest))
						( ; ApplyContext
							(equal? attribute 'ApplyContext)
							(apply-context rest))
						(else 
							(map search- rest)))]
				[(element . ,rest) (map search- rest)]
				[(elements . ,rest) (map search- rest)]
				[,otherwise 'notmached]))

; does not support key signatures with mixed sharps and flats. minor/major only.
	(define (key-change-event sblock)
		(sxml-match sblock
			[(list 
				(tonic (@ (octave ,oct) (note-name ,note) (alteration ,alt)))
				(pitch-alist ,lst))
				(display lst)
				; pitch-alist looks like ((cons 0 0) (cons 1 0) (cons 2 0) ... (cons 6 0))
				; fold iterates through the list, cdr cdr isolates the third elt of each pair
				; (car (cdr (cdr (cons 0 0)))) => (car (0)) => 0
				(let ((fifths (fold (lambda (scale-deg sum) (+ sum (* 2 (caddr scale-deg)))) 0 lst))) 
					`(key
						(fifths ,fifths)))]))

	(define (apply-context sblock) 
		(sxml-match sblock
			[(list (procedure ,proc) ...)
				(cond
					( ; set-middle-C!
						(equal? proc 'ly:set-middle-C!)
						`(clef 
							(sign ,(lily-clef-glyph->musicxml-clef-sign (clef-glyph current-clef)))
							(line ,(lily-clef-position->musicxml-clef-line (clef-position current-clef)))
							(octave-change ,(lily-clef-transposition->musicxml-clef-octave-change (clef-transposition current-clef))))))]))
			
	(define (property-set sblock) (sxml-match sblock
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

	(define (time-signature-music sblock) 
		(sxml-match sblock
			[(list (numerator ,num) (denominator ,denom) (beat-structure ,beat-structure))
				(set-timesig-numerator! current-timesig num)
				(set-timesig-denominator! current-timesig denom)
				(set-timesig-beat-structure! current-timesig beat-structure)
				`(time
					(beats ,num)
					(beat-type ,denom))])) ;maybe recurse on ... rest?

	(define (note-event sblock)
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


	(define mtree (make-measures 1))
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


