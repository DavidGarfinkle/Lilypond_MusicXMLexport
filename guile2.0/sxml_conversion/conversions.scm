;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CONVERSION PROCEDURES
;; naming convention is lily-<lily property>->musicxml-<musicxml property>

;;; PITCH
(define (lily-octave->musicxml-octave oct)
	(+ oct 4))

; assuming fixed do
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


;;; DURATION
; Given log and dot-count, return the number of divisions per quarternote which represents this duration
(define (lily-log&dot->musicxml-duration log dot-count)
	(let* (
		(dot-count-series (lambda (dot) (+ (- (expt 1/2 dot) 1) (* 2 (- 1 (expt 1/2 dot)))))) ; Geometric series (1-r^n)/(1-r)
		(without-dots (* num-divisions (expt 2 (- 2 log))))) ; the # divisions w/o dots
		(* without-dots (+ 1 (dot-count-series dot-count))))) ; then we add on the dots

(define (lily-log->musicxml-type dur)
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


;;; CLEFS
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


;;; ARTICULATIONS
;; in musicxml, articulations are NOT wrapped in quotes; they make up their own tag
;; Most articulations carry the same name in lilypond as they do in MusicXML, so we only need to list the exceptions. 
(define (lily-articulation-type->musicxml-articulations articulation)
	(match (car articulation)
		["portato" `(detatched-legato)]
		["staccatissimo" `(spiccato)] ;actually i'm not too sure about this one. the images are kind of small on the lilypond website
		["marcato" `(strong-accent (@ (type "up")))]
		[otherwise `(,(string->symbol otherwise))]))
