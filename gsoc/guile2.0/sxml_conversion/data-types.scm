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
;; MEASURE FUNCTIONS
;;

; well, we could compute the optimal one, or we can choose 24
(define num-divisions 24)

;;; measure-list-extend
;; args: <measure-list>, int, sxml-list
;; Side-effect: Appends sxml-list to the nth measure within <measure-list> 
;; if nth measure does not exist, then create it
(define (measure-list-extend list-of-measures measure-number music-sxml node) 
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
			(cond
				( ; Add it to the root 
					(eqv? node 'root)
					(append (vector-ref (measure-list list-of-measures) (measure-get-index list-of-measures measure-number)) (list music-sxml)))
				( ; Attributes node
					(eqv? node 'attributes)
					(sxml-match (vector-ref (measure-list list-of-measures) (measure-get-index list-of-measures measure-number))
						[(measure (@ (number ,num)) (attributes ,attribute-list) ...)
							`(measure (@ (number ,num)) (attributes ,@(append attribute-list (list music-sxml))))]))))))
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


;; TODO: insert measures according to increasing order
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
