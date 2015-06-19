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

(load "markup.scm")

(define stest
	(lambda (mus)
		((load "markup.scm")
		(music->sxml mus))))
