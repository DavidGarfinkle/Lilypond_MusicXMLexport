(define obj '(make-music
  'SequentialMusic
  'elements
  (list (make-music
          'NoteEvent
          'duration
          (ly:make-duration 2 0 1)
          'pitch
          (ly:make-pitch -1 0 0)))))

(define obj2 '(make-music
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

(define stest
	(lambda (mus)
		((load "make-sxml.scm")
		(music->sxml mus))))
