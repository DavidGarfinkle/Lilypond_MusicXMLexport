(define obj (make-music
  'SequentialMusic
  'elements
  (list (make-music
          'NoteEvent
          'duration
          (ly:make-duration 2 0 1)
          'pitch
          (ly:make-pitch -1 0 0)))))

(define obj2 (make-music
  'SequentialMusic
  'elements
  (list (make-music
          'NoteEvent
          'duration
          (ly:make-duration 2 0 1)
          'pitch
          (ly:make-pitch -1 0 0))
        (make-music
          'NoteEvent
          'pitch
          (ly:make-pitch -1 1 0)
          'duration
          (ly:make-duration 2 0 1)))))

(define obj3 (make-music
  'SequentialMusic
  'elements
  (list (make-music
          'NoteEvent
          'duration
          (ly:make-duration 1 0 1)
          'pitch
          (ly:make-pitch -1 2 0))
        (make-music
          'GraceMusic
          'element
          (make-music
            'SequentialMusic
            'elements
            (list (make-music
                    'SequentialMusic
                    'elements
                    '())
                  (make-music
                    'SequentialMusic
                    'elements
                    (list (make-music
                            'NoteEvent
                            'duration
                            (ly:make-duration 4 0 1)
                            'pitch
                            (ly:make-pitch -1 3 0))))
                  (make-music
                    'SequentialMusic
                    'elements
                    '()))))
        (make-music
          'NoteEvent
          'duration
          (ly:make-duration 1 0 1)
          'pitch
          (ly:make-pitch -1 2 0)))))

#! 
  <<
    { d1^\trill_( }
    { s2 s4. \grace { c16 d } }
  >>
  c1)
!#
(define obj4 
(make-music
  'SequentialMusic
  'elements
  (list (make-music
          'SimultaneousMusic
          'elements
          (list (make-music
                  'SequentialMusic
                  'elements
                  (list (make-music
                          'NoteEvent
                          'articulations
                          (list (make-music
                                  'ArticulationEvent
                                  'direction
                                  1
                                  'articulation-type
                                  "trill")
                                (make-music
                                  'SlurEvent
                                  'direction
                                  -1
                                  'span-direction
                                  -1))
                          'duration
                          (ly:make-duration 0 0 1)
                          'pitch
                          (ly:make-pitch -1 1 0))))
                (make-music
                  'SequentialMusic
                  'elements
                  (list (make-music
                          'SkipEvent
                          'duration
                          (ly:make-duration 1 0 1))
                        (make-music
                          'SkipEvent
                          'duration
                          (ly:make-duration 2 1 1))
                        (make-music
                          'GraceMusic
                          'element
                          (make-music
                            'SequentialMusic
                            'elements
                            (list (make-music
                                    'SequentialMusic
                                    'elements
                                    '())
                                  (make-music
                                    'SequentialMusic
                                    'elements
                                    (list (make-music
                                            'NoteEvent
                                            'duration
                                            (ly:make-duration 4 0 1)
                                            'pitch
                                            (ly:make-pitch -1 0 0))
                                          (make-music
                                            'NoteEvent
                                            'pitch
                                            (ly:make-pitch -1 1 0)
                                            'duration
                                            (ly:make-duration 4 0 1))))
                                  (make-music
                                    'SequentialMusic
                                    'elements
                                    '()))))))))
        (make-music
          'NoteEvent
          'articulations
          (list (make-music
                  'SlurEvent
                  'span-direction
                  1))
          'duration
          (ly:make-duration 0 0 1)
          'pitch
          (ly:make-pitch -1 0 0)))))

(define sxml-obj1
	'(music (@ (name SequentialMusic))
		(elements
			(music (@ (name NoteEvent))
				(duration (@
					(log 2)
					(dot-count 0)
					(scale 1)))
				(pitch (@
					(octave -1)
					(note-name 0)
					(alteration 0)))))))


;suspend these objects otherwise displayMusic will verbose everytime you load "env.scm"
(define lily-obj 
	(lambda () (
		#{\void \displayMusic {
			\relative e' {
			\clef "treble" \key c \major \time 4/4 \partial 4. e4 e8 | % 1
			f4 g4 \bar ""
			a4 b4 | % 2
			c4 d4 r4 \bar "|."
    	}
		}#}
))) 

;hello world taken from musicxml website, converted with musicxml2ly and then \displayMusic
;\relative c' {
;    \clef "treble" \key c \major \numericTimeSignature\time 4/4 c1 }
(define obj-hw
	(make-music
		'SequentialMusic
		'elements
		(list (make-music
						'RelativeOctaveMusic
						'element
						(make-music
							'SequentialMusic
							'elements
							(list (make-music
											'ContextSpeccedMusic
											'context-type
											'Staff
											'element
											(make-music
												'SequentialMusic
												'elements
												(list (make-music
																'PropertySet
																'value
																"clefs.G"
																'symbol
																'clefGlyph)
															(make-music
																'PropertySet
																'value
																-6
																'symbol
																'middleCClefPosition)
															(make-music
																'PropertySet
																'value
																-2
																'symbol
																'clefPosition)
															(make-music
																'PropertySet
																'value
																0
																'symbol
																'clefTransposition)
															(make-music
																'ApplyContext
																'procedure
																ly:set-middle-C!))))
										(make-music
											'KeyChangeEvent
											'pitch-alist
											(list (cons 0 0)
														(cons 1 0)
														(cons 2 0)
														(cons 3 0)
														(cons 4 0)
														(cons 5 0)
														(cons 6 0))
											'tonic
											(ly:make-pitch -1 0 0))
										(make-music
											'ContextSpeccedMusic
											'context-type
											'Staff
											'element
											(make-music
												'OverrideProperty
												'pop-first
												#t
												'grob-property-path
												(list (quote style))
												'grob-value
												'numbered
												'symbol
												'TimeSignature))
										(make-music
											'TimeSignatureMusic
											'beat-structure
											'()
											'denominator
											4
											'numerator
											4)
										(make-music
											'NoteEvent
											'duration
											(ly:make-duration 0 0 1)
											'pitch
											(ly:make-pitch 0 0 0))))))))
