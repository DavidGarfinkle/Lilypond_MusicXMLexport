(define hw1 '(music (@ (name SequentialMusic)) (elements ((music (@ (name RelativeOctaveMusic)) (element (music (@ (name SequentialMusic)) (elements ((music (@ (name ContextSpeccedMusic)) (element (music (@ (name SequentialMusic)) (elements ((music (@ (name PropertySet)) (symbol clefGlyph) (value "clefs.G")) (music (@ (name PropertySet)) (symbol middleCClefPosition) (value -6)) (music (@ (name PropertySet)) (symbol clefPosition) (value -2)) (music (@ (name PropertySet)) (symbol clefTransposition) (value 0)) (music (@ (name ApplyContext)) (procedure ly:set-middle-C!)))))) (context-type Staff)) (music (@ (name KeyChangeEvent)) (tonic (@ (octave -1) (note-name 0) (alteration 0))) (pitch-alist ((cons 0 0) (cons 1 0) (cons 2 0) (cons 3 0) (cons 4 0) (cons 5 0) (cons 6 0)))) (music (@ (name ContextSpeccedMusic)) (element (music (@ (name OverrideProperty)) (symbol TimeSignature) (grob-value numbered) (grob-property-path (style)) (pop-first #t))) (context-type Staff)) (music (@ (name TimeSignatureMusic)) (numerator 4) (denominator 4) (beat-structure (quote ()))) (music (@ (name NoteEvent)) (pitch (@ (octave 0) (note-name 0) (alteration 0))) (duration (@ (log 0) (dot-count 0) (scale 1)))))))))))))


(define note
	'(music (@ (name SequentialMusic))
		(elements
			(music (@ (name NoteEvent))
				(duration (@
					(log 2)
					(dot-count 0)
					(scale 1)))
				(pitch (@
					(octave -1)
					(note-name 0)))))))

(define hw2 
	'(music (@ (name SequentialMusic)) (elements (music (@ (name RelativeOctaveMusic)) (element (music (@ (name SequentialMusic)) 
		(elements 
			(music (@ (name ContextSpeccedMusic)) 
				(element 
					(music (@ (name SequentialMusic)) 
						(elements 
							(music (@ (name PropertySet)) (symbol clefGlyph) (value "clefs.G")) 
							(music (@ (name PropertySet)) (symbol middleCClefPosition) (value -6)) 
							(music (@ (name PropertySet)) (symbol clefPosition) (value -2)) 
							(music (@ (name PropertySet)) (symbol clefTransposition) (value 0)) 
							(music (@ (name ApplyContext)) (procedure ly:set-middle-C!))))) 
				(context-type Staff)) 
			(music (@ (name KeyChangeEvent)) (tonic (@ (octave -1) (note-name 0) (alteration 0))) (pitch-alist ((cons 0 0) (cons 1 0) (cons 2 0) (cons 3 0) (cons 4 0) (cons 5 0) (cons 6 0)))) 
			(music (@ (name ContextSpeccedMusic)) (element (music (@ (name OverrideProperty)) (symbol TimeSignature) (grob-value numbered) (grob-property-path style) (pop-first #t))) (context-type Staff)) 
			(music (@ (name TimeSignatureMusic)) (numerator 4) (denominator 4) (beat-structure (quote ()))) 
			(music (@ (name NoteEvent)) (pitch (@ (octave 0) (note-name 0) (alteration 0))) (duration (@ (log 0) (dot-count 0) (scale 1)))))))))))


(define hw3 
	'(music (@ (name SequentialMusic) (measure #f)) 
		(elements 
			(music (@ (name RelativeOctaveMusic) (measure #f)) 
				(element 
					(music (@ (name SequentialMusic) (measure #f)) 
						(elements 
							(music (@ (name ContextSpeccedMusic) (measure #f)) 
								(element 
									(music (@ (name SequentialMusic) (measure #f)) 
										(elements 
											(music (@ (name PropertySet) (measure #f)) (symbol clefGlyph) (value "clefs.G")) 
											(music (@ (name PropertySet) (measure #f)) (symbol middleCClefPosition) (value -6)) 
											(music (@ (name PropertySet) (measure #f)) (symbol clefPosition) (value -2)) 
											(music (@ (name PropertySet) (measure #f)) (symbol clefTransposition) (value 0)) 
											(music (@ (name ApplyContext) (measure #f)) (procedure ly:set-middle-C!))))) 
									(context-type Staff)) 
							(music (@ (name KeyChangeEvent) (measure 1)) (tonic (@ (octave -1) (note-name 0) (alteration 0))) (pitch-alist ((cons 0 0) (cons 1 0) (cons 2 0) (cons 3 0) (cons 4 0) (cons 5 0) (cons 6 0)))) 
							(music (@ (name ContextSpeccedMusic) (measure #f)) (element (music (@ (name OverrideProperty) (measure #f)) (symbol TimeSignature) (grob-value numbered) (grob-property-path (style)) (pop-first #t))) (context-type Staff)) 
							(music (@ (name TimeSignatureMusic) (measure #f)) (numerator 4) (denominator 4) (beat-structure (quote ()))) 
							(music (@ (name NoteEvent) (measure 1)) (pitch (@ (octave 0) (note-name 0) (alteration 0))) (duration (@ (log 0) (dot-count 0) (scale 1)))))))))))

(define obj '(music (@ (name SequentialMusic)) (elements (music (@ (name NoteEvent)) (pitch (@ (octave -1) (note-name 0) (alteration 0))) (duration (@ (log 2) (dot-count 0) (scale 1)))))))


(define 46d 
	'(music (@ (name SequentialMusic)) (elements ((music (@ (name RelativeOctaveMusic)) (element (music (@ (name SequentialMusic)) 
		(elements (
			(music (@ (name ContextSpeccedMusic)) (element (music (@ (name SequentialMusic)) (elements ((music (@ (name PropertySet)) (symbol clefGlyph) (value "clefs.G")) (music (@ (name PropertySet)) (symbol middleCClefPosition) (value -6)) (music (@ (name PropertySet)) (symbol clefPosition) (value -2)) (music (@ (name PropertySet)) (symbol clefTransposition) (value 0)) (music (@ (name ApplyContext)) (procedure ly:set-middle-C!)))))) (context-type Staff)) 
			(music (@ (name KeyChangeEvent)) (tonic (@ (octave -1) (note-name 0) (alteration 0))) (pitch-alist ((cons 0 0) (cons 1 0) (cons 2 0) (cons 3 0) (cons 4 0) (cons 5 0) (cons 6 0)))) 
			(music (@ (name TimeSignatureMusic)) (numerator 4) (denominator 4) (beat-structure (quote ()))) 
			(music (@ (name ContextSpeccedMusic)) (element (music (@ (name ContextSpeccedMusic)) (element (music (@ (name PartialSet)) (duration (@ (log 2) (dot-count 1) (scale 1))))) (context-type Timing))) (context-type Score) (descend-only #t)) 
			(music (@ (name NoteEvent)) (pitch (@ (octave 0) (note-name 2) (alteration 0))) (duration (@ (log 2) (dot-count 0) (scale 1)))) 
			(music (@ (name NoteEvent)) (pitch (@ (octave 0) (note-name 2) (alteration 0))) (duration (@ (log 3) (dot-count 0) (scale 1)))) 
			(music (@ (name BarCheck))) 
			(music (@ (name NoteEvent)) (pitch (@ (octave 0) (note-name 3) (alteration 0))) (duration (@ (log 2) (dot-count 0) (scale 1)))) 
			(music (@ (name NoteEvent)) (pitch (@ (octave 0) (note-name 4) (alteration 0))) (duration (@ (log 2) (dot-count 0) (scale 1)))) 
			(music (@ (name ContextSpeccedMusic)) (element (music (@ (name PropertySet)) (symbol whichBar) (value ""))) (context-type Timing)) 
			(music (@ (name NoteEvent)) (pitch (@ (octave 0) (note-name 5) (alteration 0))) (duration (@ (log 2) (dot-count 0) (scale 1)))) 
			(music (@ (name NoteEvent)) (pitch (@ (octave 0) (note-name 6) (alteration 0))) (duration (@ (log 2) (dot-count 0) (scale 1)))) 
			(music (@ (name BarCheck))) 
			(music (@ (name NoteEvent)) (pitch (@ (octave 1) (note-name 0) (alteration 0))) (duration (@ (log 2) (dot-count 0) (scale 1)))) 
			(music (@ (name NoteEvent)) (pitch (@ (octave 1) (note-name 1) (alteration 0))) (duration (@ (log 2) (dot-count 0) (scale 1)))) 
			(music (@ (name RestEvent)) (duration (@ (log 2) (dot-count 0) (scale 1)))) 
			(music (@ (name ContextSpeccedMusic)) (element (music (@ (name PropertySet)) (symbol whichBar) (value "|."))) (context-type Timing)))))))))))

