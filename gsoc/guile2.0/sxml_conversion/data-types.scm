;;; some constants
(define num-divisions 24)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; RECORDS
;;

;;; Measures record
;; Measures are stored as a vector of lists; each list is one measure, each record is a part. One vector per record.
(define-record-type <measure-list>
 (make-measure-list list-of-measures)
	measure-list?
	(list-of-measures measure-list set-measure-list!))

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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MEASURES
;;

;;; measure-list-extend
;; args: <measure-list>, int, sxml-list
;; Side-effect: Appends sxml-list to the nth measure within <measure-list> 
;; if nth measure does not exist, then create it
(define (measure-list-extend list-of-measures measure-number music-sxml) 
	;; create nth measure
	(define extend 
		(let (
			(current-extended (append (vector->list (measure-list list-of-measures)) 
				`((measure (@ (number ,(number->string measure-number)))
						(attributes (divisions ,num-divisions)))))))
		(delay (set-measure-list! list-of-measures (list->vector current-extended)))))
	;; update nth measure
	(define update
		(delay (vector-set! 
			(measure-list list-of-measures) 
			(measure-get-index list-of-measures measure-number) 
			(append (vector-ref (measure-list list-of-measures) (measure-get-index list-of-measures measure-number)) (list music-sxml)))))
	(if (measure-exists? list-of-measures measure-number)
		(force update)
		(begin (force extend) (force update))))

;; Given a measure list inside record <measure-list>, return the measure number
(define (measure-get-number m)
	(sxml-match m [(measure (@ (number ,num)) . ,rest) (string->number num)]))

;; Given a measure list inside record <measure-list>, return a list of measure #s
(define (list-of-measures->list-of-measure-numbers list-of-measures)
		(map measure-get-number (vector->list (measure-list list-of-measures))))

;; Check if measure # exists within record <measure-list>
(define (measure-exists? list-of-measures measure-number)
	(fold (lambda (x y) (or x y)) #f (map (lambda (m) (= m measure-number)) (list-of-measures->list-of-measure-numbers list-of-measures))))

;; Given measure #, return the index of measure list within the list of measures
(define (measure-get-index list-of-measures measure-number)
	(define (index-of-elt elt lst) (- (length lst) (length (memv elt lst))))
	(if (measure-exists? list-of-measures measure-number)
		(index-of-elt measure-number (list-of-measures->list-of-measure-numbers list-of-measures))
		#f))

;; TODO: sort measures according to increasing order
#!
		(letrec* (
			(new-measure `((measure (@ (number ,(number->string measure-number))))))
			(mlist (vector->list (measure-list list-of-measures)))
			(new-measure-list (lambda (mlist) 
				(cond 
					( ; null list
						(null? mlist)
						new-measure)
					( ; if we've reached the end of the list
						(null? (cdr mlist))
						(append mlist new-measure))
					(else
						(if (< (measure-get-number (car mlist)) measure-number)
							(begin 
(display "begin") 
(display (car mlist)) (newline) 
(display (cdr mlist)) 
							(append  (car mlist) (new-measure-list `(,(cdr mlist)))))
							(append new-measure mlist)))))))
			(delay (set-measure-list! list-of-measures (list->vector (new-measure-list mlist))))))
!#	
							


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
; Geometric series (1-r^n)/(1-r)
(define (dot-count-series dot)
	(+ (- (expt 1/2 dot) 1) (* 2 (- 1 (expt 1/2 dot)))))
			
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


;;;;;;;;;; MISCELLANEOUS

; Removes a reduntant list wrapping e.g. (unwrap '((2 4))) => (2 4)
(define (unwrap lst)
	(if (null? (cdr lst))
		(car lst)
		lst))
		


;;;;;;;;;;;; TRASHYARD
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

;; to fix the #<Mom 0> issue?
#!(define (process-moments sxml)
					(let* ((moment 'la)
					(moment-left (regexp-substitute/global #f (string-match "<" moment) 'pre "(" 'post))
					(moment-both (regexp-substitute/global #f (string-match ">" moment-left) 'pre ")" 'post))
					(vector->list moment-both))))!#
