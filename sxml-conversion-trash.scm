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

#!
;; A cleaner EventChord, if the sxml would ever match correctly :(
			[(list (music (@ (name ,attribute) (measure ,measure)) . ,note-rest) . ,music-rest) music-rest
				(let ((chord-sxml
					(map (lambda (lst) (append (lily-note-event->musicxml-note-event lst) '(chord))) music-rest)))
				(if (eqv? attribute 'NoteEvent)

					(begin (note-event-write note-rest measure)
					(measure-list-extend mlist measure chord-sxml))
					;; else
					'ChordEventERROR))]))
!#	


#!
;;; NoteEvent 
	(define (note-event sblock measure-number)
		(sxml-match sblock
			[(list 
				(pitch (@ (octave ,oct) (note-name ,note) (alteration ,alt) . ,pitch-rest))	
				(duration (@ (log ,log) (dot-count ,dot) (scale ,scale) . ,dur-rest))
				(articulations . ,articulations-rest))
				(let* (
					[articulations (search articulations-rest)]
					;; duration
					[musicxml-duration (log-duration->musicxml-duration-calc log dot)] 
					[musicxml-type (log-duration->musicxml-duration-names log)]
					;; pitch
					[musicxml-octave (lily-octave->musicxml-octave oct)]
					[musicxml-step (lily-note-name->musicxml-step note)]
					[musicxml-alt (lily-alteration->musicxml-alter alt)]
					[sxml 
						`(note 
							(pitch 
								(step ,musicxml-step)
								(alter ,musicxml-alt)
								(octave ,musicxml-octave))
							(duration ,musicxml-duration)
							(type ,musicxml-type))]
					[sxml (append sxml articulations)])
				(measure-list-extend mlist measure-number sxml))]))
!#

#!
	(sxml-match sxml-list
		[(music ,[search -> x])
			`(part (@ (id "P1"))
				(measure (@ (number "1"))
					(attributes (divisions ,num-divisions))
						,x ))])
!#
