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

(define hw2 '(music (@ (name SequentialMusic)) (elements (music (@ (name RelativeOctaveMusic)) (element (music (@ (name SequentialMusic)) (elements ((music (@ (name ContextSpeccedMusic)) (element (music (@ (name SequentialMusic)) (elements ((music (@ (name PropertySet)) (symbol clefGlyph) (value "clefs.G")) (music (@ (name PropertySet)) (symbol middleCClefPosition) (value -6)) (music (@ (name PropertySet)) (symbol clefPosition) (value -2)) (music (@ (name PropertySet)) (symbol clefTransposition) (value 0)) (music (@ (name ApplyContext)) (procedure ly:set-middle-C!)))))) (context-type Staff)) (music (@ (name KeyChangeEvent)) (tonic (@ (octave -1) (note-name 0) (alteration 0))) (pitch-alist ((cons 0 0) (cons 1 0) (cons 2 0) (cons 3 0) (cons 4 0) (cons 5 0) (cons 6 0)))) (music (@ (name ContextSpeccedMusic)) (element (music (@ (name OverrideProperty)) (symbol TimeSignature) (grob-value numbered) (grob-property-path (style)) (pop-first #t))) (context-type Staff)) (music (@ (name TimeSignatureMusic)) (numerator 4) (denominator 4) (beat-structure (quote ()))) (music (@ (name NoteEvent)) (pitch (@ (octave 0) (note-name 0) (alteration 0))) (duration (@ (log 0) (dot-count 0) (scale 1))))))))))))
