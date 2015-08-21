(define time_marks (make-object-property))

(define time_collector 
 	(make-engraver
   (listeners ((music-event engraver e)
	       (let ((m (ly:event-property e 'music-cause)))
		(if (ly:music? m)
		 (let ((c (ly:translator-context engraver)))
		  (set! (time_marks m)
		   (ly:context-property c 'internalBarNumber)))))))))

;(ly:context-property c 'measurePosition)

(define (run-translator obj) (ly:run-translator obj
  #{
     \layout {
        \context {
          \Score
          \consists \time_collector
        }
     }
  #}))
