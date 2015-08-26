(define sxml (quote (music (@ (name SequentialMusic) (measure #f)) (elements (music (@ (name RelativeOctaveMusic) (measure #f)) (element (music (@ (name SequentialMusic) (measure #f)) (elements ((music (@ (name ContextSpeccedMusic) (measure #f)) (context-type Staff) (element (music (@ (name SequentialMusic) (measure #f)) (elements ((music (@ (name PropertySet) (measure #f)) (value "clefs.G") (symbol clefGlyph)) (music (@ (name PropertySet) (measure #f)) (value -6) (symbol middleCClefPosition)) (music (@ (name PropertySet) (measure #f)) (value -2) (symbol clefPosition)) (music (@ (name PropertySet) (measure #f)) (value 0) (symbol clefTransposition)) (music (@ (name ApplyContext) (measure #f)) (procedure ly:set-middle-C!))))))) (music (@ (name KeyChangeEvent) (measure 1)) (pitch-alist ((cons 0 0) (cons 1 0) (cons 2 0) (cons 3 0) (cons 4 0) (cons 5 0) (cons 6 0))) (tonic (@ (octave -1) (note-name 0) (alteration 0)))) (music (@ (name ContextSpeccedMusic) (measure #f)) (context-type Staff) (element (music (@ (name OverrideProperty) (measure #f)) (pop-first #t) (grob-property-path style) (grob-value numbered) (symbol TimeSignature)))) (music (@ (name TimeSignatureMusic) (measure #f)) (beat-structure (quote ())) (denominator 4) (numerator 4)) (music (@ (name NoteEvent) (measure 1)) (duration (@ (log 0) (dot-count 0) (scale 1))) (pitch (@ (octave 0) (note-name 0) (alteration 0)))))))))))))