;;;;;
;; SXML-conversion.scm 
;; Purpose: given a lily-SXML-list, return a Music-SXML-list
;; This is achieved by changing program state and using (sxml-match). The given SXML-tree is traversed using (map f lst). 
;; Each node is matched by (sxml-match) which in turn writes to a global record of measures (changing the state)
;; The result of the recursive (map) is then disregarded 

;;; Records to store lily-music data
(define current-timesig (make-timesig '4 '4 '()))
(define current-clef (make-clef "clefs.G" -2 0))

;;; For a one-part example, we only have one group of measures
(define m1 (make-measure-list #()))

(define (music-sxml-partwise lily-sxml)
	; reset the measure record
	(define m1 (make-measure-list #()))
	`(score-partwise (@ (version "3.0"))
		(part-list
			(score-part (@ (id "P1"))
				(part-name Music)))
		(part (@ (id "P1"))
		,@(lily-sxml->music-sxml lily-sxml m1))))
		
;;;;; TEST recursive
;;; args: sxml-list ; record mlist
;;; output: .. some garbage
;;; side effects: populates mlist with lists of measures
;;;
(define (lily-sxml->music-sxml sxml-list mlist)
	(define (search x) 
			;(display x) (newline) (newline)
			(sxml-match x
				[,obj (guard (or 
					(symbol? obj)
					(null? obj))) obj]
				[(list (music (@ (name ,attribute) (measure (,measure-number #f))) . ,rest) ...)
					`(,(search `(music (@ (name ,attribute) (measure ,measure-number)) ,@rest)) ...)]
				[(music (@ (name ,attribute) (measure (,measure-number #f))) . ,rest) 
					(cond 
						( ; ArticulationEvent --- returns sxml
							(eqv? attribute 'ArticulationEvent)
							(articulation-event rest measure-number))
						( ; ApplyContext --- writes directly to mlist
							(eqv? attribute 'ApplyContext)
							(apply-context rest 1)) ; clefs don't have any measure information
						( ; EventChord --- writes directly to mlist
							(eqv? attribute 'EventChord)
							(event-chord rest measure-number))
						( ; Key Change Event --- writes directly to mlist
							(eqv? attribute 'KeyChangeEvent)
							(key-change-event rest measure-number))
						( ; Note Events --- writes directly to mlist
							(eqv? attribute 'NoteEvent)
							(note-event-write rest measure-number))
						( ; PropertySet --- modifies the records without printing sxml
							(eqv? attribute 'PropertySet)
							(property-set rest measure-number))
						( ; Time Signatures --- modifies the record AND writes directly to mlist
							(eqv? attribute 'TimeSignatureMusic) 
							(time-signature-music rest 1)) ; timesigs lack measure information
						(else 
							(map search rest)))]
				[(element . ,rest) (map search rest)]
				[(elements . ,rest) (map search rest)]
				[,otherwise otherwise]))


;;;;;;;;;; The following functions expect an SXML list "sblock" and a measure-number.
;; They convert sblock to Music-SXML and write it to the corresponding measure list
;; ** except for clefs, which are read and written separately

;;; KeyChangeEvent (key signatures)
; does not support key signatures with mixed sharps and flats. minor/major only.
	(define (key-change-event sblock measure-number)
		(define (key-change-event-helper oct note alt lst)
			(let* (
				; Isolate and sum the cdr of each pair in the pitch-alist 
				(fifths (fold (lambda (scale-deg sum) (+ sum (* 2 (caddr scale-deg)))) 0 lst))
				(sxml 
					`(key
						(fifths ,fifths))))
				(measure-list-extend mlist measure-number sxml 'attributes)))
		(sxml-match sblock
			[(list 
					(tonic (@ (octave ,oct) (note-name ,note) (alteration ,alt)))
					(pitch-alist ,lst))
				(key-change-event-helper oct note alt lst)]	
			[(list 
					(pitch-alist ,lst)
					(tonic (@ (octave ,oct) (note-name ,note) (alteration ,alt))))
				(key-change-event-helper oct note alt lst)]))
				
;;; ApplyContext (so far just prints musicXML clefs)
;; Expects a lily procedure name as its first element
	(define (apply-context sblock measure-number) 
		(sxml-match sblock
			[(list (procedure ,proc) ...)
				(let ((sxml 
					(cond
						( ; set-middle-C!
							(eqv? (car proc) 'ly:set-middle-C!) ; proc gets wrapped in quotes :S
							`(clef 
								(sign ,(lily-clef-glyph->musicxml-clef-sign (clef-glyph current-clef)))
								(line ,(lily-clef-position->musicxml-clef-line (clef-position current-clef)))
								(octave-change ,(lily-clef-transposition->musicxml-clef-octave-change (clef-transposition current-clef)))))
						(else 'ApplyContextNotSupported))))
					 (measure-list-extend mlist measure-number sxml 'attributes))]))
			
;;; PropertySet does not write to the measure list. It just updates the clef record
	(define (property-set sblock measure-number) 
		(define (property-set-helper symbol val)
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
				(else	'PropertySetNotSupported)))
		(sxml-match sblock
			[(list (value ,val) (symbol ,symbol))
				(property-set-helper symbol val)]
			[(list (symbol ,symbol) (value ,val))
				(property-set-helper symbol val)]))

;;; TimeSignatureMusic records the current timesig and also writes it to mlist
	(define (time-signature-music sblock measure-number) 
		(define (time-signature-music-helper num denom beat-structure)
			(set-timesig-numerator! current-timesig num)
			(set-timesig-denominator! current-timesig denom)
			(set-timesig-beat-structure! current-timesig beat-structure)
			(let ((sxml 
				`(time
					(beats ,num)
					(beat-type ,denom))))
			(measure-list-extend mlist measure-number sxml 'attributes)))
		(sxml-match sblock
			[(list (numerator ,num) (denominator ,denom) (beat-structure ,beat-structure))
				(time-signature-music-helper num denom beat-structure)]
			[(list (beat-structure ,beat-structure) (denominator ,denom) (numerator ,num))
				(time-signature-music-helper num denom beat-structure)]))


;;; NoteEvent
;; Returns the musicSXML equivalent of a lilypond SXML NoteEvent
;; todo add <dot/> for each dot value
;; todo return (duration ...) and (type ...) s.t. they are not nested in a list
	(define (note-event-sxml sblock)
		(let* (
			(matcher (lambda (lst) (sxml-match lst
				[(pitch (@ (octave ,oct) (note-name ,note) (alteration ,alt) . ,pitch-rest))
					`(pitch
						(step ,(lily-note-name->musicxml-step note))
						(alter ,(lily-alteration->musicxml-alter alt))
						(octave ,(lily-octave->musicxml-octave oct)))]
				[(duration (@ (log ,log) (dot-count ,dot) (scale ,scale) . ,dur-rest))
					`( 
						(duration ,(lily-log&dot->musicxml-duration log dot))
						(type ,(lily-log->musicxml-type log)))]
				[(articulations . ,articulations-rest) (search articulations-rest)])))
			(sxml (append '(note) (map matcher sblock))))
		sxml))

; if measure-number is false when it should be set (note events, etc..) then program will crash in sxml-matching of (measure-list-extend)
	(define (note-event-write sblock measure-number)
		 (measure-list-extend mlist measure-number (note-event-sxml sblock) 'root))

;;; ArticulationEvent
;; input: expects a list of lists, where the first element is lily-sxml articulation
;; output: a music-sxml articulation list 
	(define (articulation-event sblock measure-number)
		(sxml-match sblock
			[(list (articulation-type ,articulation) ...)
				`(notations
					(articulations ,(lily-articulation-type->musicxml-articulations articulation)))]))


;;; EventChord
;; This is a litle bit of a mess. It expects exactly this input of sxml block:
;; (elements ((music (@ (name NoteEvent)) ...) ...)) i.e. a list of NoteEvents
	(define (event-chord sblock measure-number)
		;;wrapper function for matching a lily-sxml NoteEvent
		(define (lily-note-event->musicxml-note-event sblock)
			(sxml-match sblock
				[(music (@ (name ,attribute)) . ,rest) (note-event-sxml rest)]))
		(let ((note-list (unwrap (cdr (unwrap sblock)))))
			(sxml-match (car note-list)
				[(music (@ (name ,attribute) (measure ,measure-number)) . ,rest);get measure#
				(begin
					(note-event-write rest measure-number) ;write the first note to the measure
					(measure-list-extend mlist measure-number (map (lambda (lst) (append (lily-note-event->musicxml-note-event lst) '((chord)))) (cdr note-list)) 'root))]))) ;for the rest of the notes in the chord, add (chord) as specified in MusicXML



	(search sxml-list)	
	(vector->list (measure-list mlist)) 
)

; Removes a reduntant list wrapping e.g. (unwrap '((2 4))) => (2 4)
(define (unwrap lst)
	(if (null? (cdr lst))
		(car lst)
		lst))
		

