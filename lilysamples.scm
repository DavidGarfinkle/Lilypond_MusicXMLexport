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
