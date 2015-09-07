;;; All of these samples are the result of feeding music expressions into \displayMusic{ } 
;; (define foo (hw))
;; (run-translator foo) -- adds measure information to foo
;; (music->sxml foo) -- returns sxml of foo

(define (obj) #{\displayMusic
	{
		c
	}
 #})

(define (obj2) #{\displayMusic
	{
		c d
	}
#})	

;hello world taken from musicxml website, converted with musicxml2ly 
(define (hw) #{\displayMusic
	{
		\relative c' {
			\clef "treble" \key c \major \numericTimeSignature\time 4/4 c1 }
	}
#})

; articulations example taken from <http://www.lilypond.org/doc/v2.19/Documentation/learning/articulation-and-dynamics>
(define (articulations) #{\displayMusic
	{
		\relative {
			c''4-^ c-+ c-- c-!
			c4-> c-. c2-_ }
	}
#})

; a chords example taken from lilypond.org
(define (chords) #{\displayMusic
	{
		< a c e >1
		< a c e >2
		< f a c e >4
		< a c >8.
		< g c e >16
	}
#})

;;;; MUSIC-XML EXAMPLES TAKEN FROM TEST SUITE
(define (21b) #{\displayMusic
	{
    \clef "treble" \numericTimeSignature\time 4/4 <a f>4 <a f>4 <a f>4
    <a f>4 | % 2
    <a f>4 <a f>4 <a f>4 <a f>4
	}
#})



;; not supported yet
(define (obj3)  #{\displayMusic
	{
		e2 \grace { f16 } e2 
	}
#})

;; not supported yet
(define (obj4) #{\displayMusic
	{
		<< { d1^\trill_( } { s2 s4. \grace { c16 d } } >> c1)
	}
#})

;; not supported yet
; 46d-PickupMeasure-ImplicitMeasures.ly taken from musicxml test suite
(define (46d) #{\displayMusic
	{
		\relative e' {
				\clef "treble" \key c \major \time 4/4 \partial 4. e4 e8 | % 1
				f4 g4 \bar ""
				a4 b4 | % 2
				c4 d4 r4 \bar "|." }
	}
#})

